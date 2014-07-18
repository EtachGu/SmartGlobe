//
//  ViewController.m
//  SmartGlobe
//
//  Created by G on 3/17/14.
//  Copyright (c) 2014 G. All rights reserved.
//

#import "ViewController.h"
#import "G3MBuilder_iOS.hpp"
#import "LayerSet.hpp"
#import "Layer.hpp"
#import "PlanetRendererBuilder.hpp"

#import "ZWMSLayer.hpp"
#import "ZWMSMarksLayer.hpp"
#import "WMSLayer.hpp"
#import "TerrainLayer.hpp"

#import "LevelTileCondition.hpp"
#import "Sector.hpp"
#import "TimeInterval.hpp"
#import "URL.hpp"
#import "LayerTilesRenderParameters.hpp"
#import "Color.hpp"
#import "G3MWidget.hpp"
#import "ZWMSBillElevationDataProvider.hpp"
#import "SQLiteStorage_iOS.hpp"
#import "SQDatabase.h"
#import "HUDQuadWidget.hpp"
#import "DownloaderImageBuilder.hpp"
#import "HUDRelativePosition.hpp"
#import "HUDRelativeSize.hpp"

#import "HUDRenderer.hpp"
#import "MarksRenderer.hpp"
#import "Mark.hpp"
#import "MarkTouchListener.hpp"
#import "LabelsTouchListener.hpp"
#import "LabelsData.h"

#import "LabelImageBuilder.hpp"
#import "HUDAbsolutePosition.hpp"
#import "HUDAbsoluteSize.hpp"

#import "PeriodicalTask.hpp"
#import "AnimateHUDWidgetsTask.h"
#import "MyLocationMarksTask.h"

#import "MeshRenderer.hpp"
#import "AbstractGeometryMesh.hpp"
#import "IndexedGeometryMesh.hpp"
#import "LeveledMesh.hpp"

#import "ShapesRenderer.hpp"
#import "EllipsoidShape.hpp"


#include "StarsRenderer.hpp"
#include "AtmosphereRenderer.hpp"

#include "SceneLighting.hpp"

#import <sqlite3.h>

#include "pugixml.hpp"


#define TextTimes   1000

@interface ViewController ()
{
    LayerSet*  _layerSet;
    MarksRenderer*  _marksRenderer;
   StarsRenderer*           _starsRenderer;
    AnimateHUDWidgetsTask*   _animateHUDtask;
    pugi::xml_document   _docXML;
}
-(LayerSet*) createLayerSet;
-(void)initWithDefaultBuilder;

@end


@implementation ViewController
@synthesize g3mWidget=_g3mWidget;
@synthesize actIndicatorView = _actIndicatorView;
@synthesize layersTableView = _layersTableView;
@synthesize layersBarButtonItem =_layersBarButtonItem;
@synthesize navigationBar = _navigationBar;
@synthesize myLocationButton =_mylocationButton;
@synthesize northButton =_northButton;
@synthesize resetButton = _resetButton;
@synthesize setupView =_setupView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)TextSQLiteReadTime
{
    NSString* databaseName = @"g3m.cache";
    NSArray*  paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDirectory stringByAppendingPathComponent:  databaseName];
    
    int counter=0;
    //    SQDatabase* readDB =[[SQDatabase alloc] initWithPath: dbPath];
    sqlite3*   readDB;
    int i =sqlite3_open([dbPath UTF8String], &readDB);
    
    NSData * data;
    NSString* name = @"http://192.168.1.120:8079/GMSS/rest/data/tile/map?name=%2FTdt%2FImage&id=9%3B1369%3B3351";
    char * errormassge;
    
    
    double  StartTime =    CACurrentMediaTime();
    while (counter <TextTimes) {
        NSString *select = @"SELECT contents, expiration FROM image2 WHERE (name = ?)";
        sqlite3_exec(readDB, [select UTF8String], NULL, NULL, &errormassge);
        sqlite3_stmt*  stmt;
        do
        {
            int rc=sqlite3_prepare_v2(readDB, [select UTF8String], -1, &stmt, NULL);
            if (rc == SQLITE_OK) {
                break;
            }
        }while (1);
        sqlite3_bind_text(stmt, 1, [[name description] UTF8String], -1, SQLITE_STATIC);
        do{
            int rc = sqlite3_step(stmt);
            if (rc == SQLITE_ROW) {
                break;
            }
        }while (YES);
        NSInteger blobLength = sqlite3_column_bytes(stmt, 0);
        data =  [NSData dataWithBytes: sqlite3_column_blob(stmt, 0)
                               length: (NSUInteger)blobLength];
        sqlite3_finalize(stmt);
        counter ++;
    }
    double  EndTime =CACurrentMediaTime();
    NSLog(@"SQLRead elapsed time : %.2f",EndTime-StartTime);

}
-(void)TextLocalizedFileReadTime
{
    NSString* dirFile = @"cache_imge";
    NSString* name =@"398";
    NSArray*  paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDirectory stringByAppendingPathComponent:  dirFile];
    dbPath =  [dbPath stringByAppendingPathComponent:name];
    
    int counter =0;
    double startTime = CACurrentMediaTime();
    NSError * error;
    while (counter<TextTimes) {
       NSData*  data =[NSData dataWithContentsOfFile:dbPath options:0 error:&error];
        counter++;
    }
    double endTime =CACurrentMediaTime();
    NSLog(@"FileRead elapsed time: %.2f",endTime -startTime);
    
    

    
}

- (void)viewDidLoad
{
       [super viewDidLoad];
    
    
      // download the XML  file  and praser it
    [self ParseXML];


    
	// Do any additional setup after loading the view.
//    [self initWithDefaultBuilder];
    [self initWithCustomBuilder];
    [[self g3mWidget] startAnimation];
    
    
    _layersView = [[TQViewController alloc] init];
    _layersView->_mainViewController = self;

    _layersTableView = [[TQMultistageTableView alloc] initWithFrame:CGRectMake(0,44, 320, 1024)];
    [_layersTableView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.7]];
    _layersTableView.delegate = _layersView;
    _layersTableView.dataSource = _layersView;
    _layersView.mTableView = _layersTableView;
    
    _layersView->_labelsPOIs = _labelsPOIs;
    
    
    [self.view addSubview:_layersTableView];
    [_layersTableView setHidden:YES];
    
    
    [self initLayerSetCheckBoxes:_layerSet];
    _layersView->_checkBoxes = checkBoxes;
    
    [[self northButton] addTarget:self action:@selector(ResetNorth:) forControlEvents:UIControlEventTouchUpInside];
    [[self resetButton] addTarget:self action:@selector(ResetPlanet:) forControlEvents:UIControlEventTouchUpInside];
//    _layersBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Layers" style:UIBarButtonItemStyleBordered target:self action:@selector(LayerBarButtonItemAction:)];
    

    
//    [self TextLocalizedFileReadTime];
//    [self TextSQLiteReadTime];
    
    

//    [self.startupView.spinner stopAnimating];
//    [self.startupView.spinner removeFromSuperview];
//    [self.startupView.ImageView removeFromSuperview];
}

#pragma mark -
-(void)initWithDefaultBuilder
{
    G3MBuilder_iOS builder([self g3mWidget]);
    LayerSet* layerSet = [self createLayerSet];
    builder.getPlanetRendererBuilder()->setLayerSet(layerSet);
    builder.initializeWidget();
}
-(void)initWithCustomBuilder
{
    G3MBuilder_iOS builder([self g3mWidget]);
    LayerSet* layerSet = [self createLayerSet];
    builder.getPlanetRendererBuilder()->setLayerSet(layerSet);
    Color* backgroundColor =Color::newFromRGBA(0.5,0.5,0.5,1);
    builder.setBackgroundColor(backgroundColor);
    builder.getPlanetRendererBuilder()->setElevationDataProvider(new ZWMSBillElevationDataProvider(URL("http://192.168.1.120:8079/zs/data/tile/dem?name=%2FTdt%2FDem&id="),"bmng200406",
                                        Sector::fullSphere(),
                                                                       0) );
    
//  test5
    HUDRenderer* hudRenderer = new HUDRenderer(false);
    builder.setHUDRenderer(hudRenderer);
    
    
    _marksRenderer = [self createMarksRenderer];
    //new MarksRenderer(false);
    builder.addRenderer(_marksRenderer);
//
//    
    _starsRenderer =  new StarsRenderer(new DownloaderImageBuilder(URL("file:///stars.png")));
    builder.setStarsRenderer(_starsRenderer);
//    builder.addRenderer(starsRenderer);
//
//
//    AtmosphereRenderer* atmosphereRenderer = new AtmosphereRenderer(20000.0,new DownloaderImageBuilder(URL("file:///atmosphere.png")));
//    builder.addRenderer(atmosphereRenderer);
    
   
    
   builder.getPlanetRendererBuilder()->setPlanetRendererParameters([self createPlanetRendererParameters]);
//    builder.setLogFPS(true);
    builder.initializeWidget();
    
    
    G3MWidget *widget = [builder.getNativeWidget() widget];
    const Planet *        planet  = builder.getPlanet();
    [self initHUDRender:hudRenderer G3MWidget:widget];
    
    widget->addPeriodicalTask(new PeriodicalTask(TimeInterval::fromSeconds(0.5),
                                         new MyLocationMarksTask(_mylocationButton,_marksRenderer,widget)));

    _layerSet = layerSet;
}

-(void)initLayerSetCheckBoxes: (LayerSet*) layer
{
    int capacity =_layerSet->size();
    checkBoxes = [[NSMutableArray alloc] initWithCapacity:capacity];
    CGRect frame = CGRectMake(20, 7, 240, 30);
    
    //add Stars
    SSCheckBoxViewStyle style = (SSCheckBoxViewStyle)(kSSCheckBoxViewStyleMonoBlue);
    BOOL checked =YES;
    SSCheckBoxView *cbv = [[SSCheckBoxView alloc] initWithFrame:frame
                                                          style:style
                                                        checked:checked];
    [cbv setStateChangedTarget:self selector:@selector(changeLayers:)];
    [cbv setText:@"星空"];
    [cbv   setIndex:0];
//    [self.layersTableView addSubview:cbv];
    [checkBoxes addObject:cbv];
//    frame.origin.y += 44;

    //add layers
    for (int i = 0; i < capacity; ++i) {
        Layer *   layer = _layerSet->getLayer(i);
        NSString * name =  [NSString stringWithCString: layer->getName().c_str()
                                                                encoding: NSUTF8StringEncoding];
        SSCheckBoxViewStyle style = (SSCheckBoxViewStyle)(kSSCheckBoxViewStyleMonoBlue);
        BOOL checked =YES;
        SSCheckBoxView *cbv = [[SSCheckBoxView alloc] initWithFrame:frame
                                              style:style
                                            checked:checked];
        [cbv setStateChangedTarget:self selector:@selector(changeLayers:)];
        [cbv setText:name];
        [cbv   setIndex:i+1];
//        [self.layersTableView addSubview:cbv];
        [checkBoxes addObject:cbv];
//        frame.origin.y += 44;
    }
    
    

}


#pragma  mark - The  methods of  SmartGlobe Render preperation

//
-(void)ParseXML
{
    NSArray*  paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDirectory stringByAppendingPathComponent:  @"Default.xml" ];
    // NSString* dbPath = [documentsDirectory stringByAppendingPathComponent:  @"utftest_utf8_bom.xml" ];
//     _docXML.load_file([dbPath cStringUsingEncoding:NSUTF8StringEncoding],pugi::encoding_utf8);
    _docXML.load_file([dbPath cStringUsingEncoding:NSUTF8StringEncoding],pugi::parse_default,pugi::encoding_utf8);
}
-(ZWMSLayer*)createLayer: (pugi::xml_node) node
{
    string ip = "192.168.1.120:8079";//[_setupView->_ipTest UTF8String];
    int tileResolution = 11;
    int layerRenderLevel = 20;
    Vector2I tileResolutionVec = Vector2I(tileResolution,tileResolution);
    const Vector2I TileTextureResolution =Vector2I(512,512);
    const std::string name = node.attribute("Name").value();
    string url;
    if (strcmp(name.c_str(), "Name:Map")==0)
    {
        url  = "http://"+ip+"/zs/data/tile/map?name=%2FTdt%2FMap";
    }
    else if(strcmp(name.c_str(), "Name:Image")==0)
    {
        url  = "http://"+ip+"/zs/data/tile/map?name=%2FTdt%2FImage";
    }
    else
    {
        return NULL;
    }
    const char* name1 = node.attribute("DispName").value();
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);      //重点
    //char*转换为NSString
    NSString *str = [[NSString alloc] initWithCString:name1 encoding:enc];
    ZWMSLayer* tdtMap = new ZWMSLayer([str cStringUsingEncoding:NSUTF8StringEncoding],
                                      URL(url.c_str(), false),
                                      WMS_1_1_0,
                                      Sector::fullSphere(),
                                      "image/png",
                                      "EPSG:4326",
                                      "",
                                      false,
                                      new LevelTileCondition(0, 30),     //download level range
                                      //NULL,
                                      TimeInterval::fromDays(30),
                                      true,
                                      new LayerTilesRenderParameters(Sector::fullSphere(),
                                                                     4, 8,
                                                                     0, layerRenderLevel,             //render level range
                                                                     TileTextureResolution,
                                                                     tileResolutionVec,
                                                                     false)
                                      );
    
       return tdtMap;
}

-(LayerSet*) createLayerSet
{
    string ip = "192.168.1.120:8079";//[_setupView->_ipTest UTF8String];
    int tileResolution = 11;
    int layerRenderLevel = 20;
    Vector2I tileResolutionVec = Vector2I(tileResolution,tileResolution);
    LayerSet* layerSet = new LayerSet();
    const Vector2I TileTextureResolution =Vector2I(512,512);
//    LayerTilesRenderParameters::defaultTileTextureResolution()
//    ZWMSLayer* blueMarble = new ZWMSLayer("卫星影像",
//                                          URL("http://192.168.1.120:8079/GMSS/rest/data/tile/map?name=%2FTdt%2FImage", false),
//                                          WMS_1_1_0,
//                                          Sector::fullSphere(),
//                                          "image/png",
//                                          "EPSG:4326",
//                                          "",
//                                          false,
//                                          new LevelTileCondition(0, 30),     //download level range
//                                          //NULL,
//                                          TimeInterval::fromDays(30),
//                                          true,
//                                          new LayerTilesRenderParameters(Sector::fullSphere(),
//                                                                         4, 8,
//                                                                         0, 20,             //render level range
//                                                                         LayerTilesRenderParameters::defaultTileTextureResolution(),
//                                                                        tileResolutionVec,
//                                                                         false)
//                                          );
//    layerSet->addLayer(blueMarble);
//    
//    ZWMSLayer*  marksOfCity =new ZWMSLayer("城市注记",
//                                           URL("http://192.168.1.120:8079/GMSS/rest/data/tile/map?name=%2FTdt%2FImageAnno",false),
//                                           WMS_1_1_0,
//                                           Sector::fullSphere(),
//                                           "image/png",
//                                           "EPSG:4326",
//                                           "",
//                                           true,       // isTransparent
//                                           new LevelTileCondition(0, 30),     //download level range
//                                           //NULL,
//                                           TimeInterval::fromDays(30),
//                                           true,
//                                           new LayerTilesRenderParameters(Sector::fullSphere(),
//                                                                          4, 8,
//                                                                          0, 20,             //render level range
//                                                                          LayerTilesRenderParameters::defaultTileTextureResolution(),
//                                                                          tileResolutionVec,
//                                                                          false));
//    layerSet ->addLayer(marksOfCity);
    
    pugi::xml_node rootNode =_docXML.child("RootContainer").child("Children").child("Container");
    pugi::xml_node terrainNode =  rootNode.child("Children").find_child_by_attribute("Type", "{6B3313A6-F0BF-4037-9781-F3414C4D3B1C}");
//    TerrainLayer terrainLayer(terrainNode.attribute("Globe_ColNum"),
    
   
    const char* type ="{AB8AAED1-58C2-4b01-AAA3-0D42C8AD1DE6}";
    pugi::xml_node node =    terrainNode.child("Children").find_child_by_attribute("Type",type );
  
   
    while (node)
    {
        if (strcmp(node.attribute("Type").value() , type ) ==0)
        {
             Layer* layer= [self createLayer:node];
             if(layer!=NULL)layerSet->addLayer(layer);
        }
        node=node.next_sibling();
    }
    
    return layerSet;
    
    /*
    
    //天地图Map
    ZWMSLayer* tdtMap = new ZWMSLayer("天地图地图",
                                          URL("http://"+ip+"/zs/data/tile/map?name=%2FTdt%2FMap", false),
                                          WMS_1_1_0,
                                          Sector::fullSphere(),
                                          "image/png",
                                          "EPSG:4326",
                                          "",
                                          false,
                                          new LevelTileCondition(0, 30),     //download level range
                                          //NULL,
                                          TimeInterval::fromDays(30),
                                          true,
                                          new LayerTilesRenderParameters(Sector::fullSphere(),
                                                                         4, 8,
                                                                         0, layerRenderLevel,             //render level range
                                                                         TileTextureResolution,
                                                                         tileResolutionVec,
                                                                         false)
                                          );
    layerSet->addLayer(tdtMap);
    
    //天地图影像图层
    ZWMSLayer* tdtImage = new ZWMSLayer("天地图影像",
                                      URL("http://"+ip+"/zs/data/tile/map?name=%2FTdt%2FImage", false),
                                      WMS_1_1_0,
                                      Sector::fullSphere(),
                                      "image/png",
                                      "EPSG:4326",
                                      "",
                                      false,
                                      new LevelTileCondition(0, 30),     //download level range
                                      //NULL,
                                      TimeInterval::fromDays(30),
                                      true,
                                      new LayerTilesRenderParameters(Sector::fullSphere(),
                                                                     4, 8,
                                                                     0, layerRenderLevel,             //render level range
                                                                     TileTextureResolution,
                                                                     tileResolutionVec,
                                                                     false)
                                      );
    layerSet->addLayer(tdtImage);

    
    //天地图注记
    ZWMSLayer* tdtLabel = new ZWMSLayer("天地图注记",
                                        URL("http://"+ip+"/zs/data/tile/map?name=%2FTdt%2FImageAnno", false),
                                        WMS_1_1_0,
                                        Sector::fullSphere(),
                                        "image/png",
                                        "EPSG:4326",
                                        "",
                                        true,
                                        new LevelTileCondition(0, 30),     //download level range
                                        //NULL,
                                        TimeInterval::fromDays(30),
                                        true,
                                        new LayerTilesRenderParameters(Sector::fullSphere(),
                                                                       4, 8,
                                                                       0, layerRenderLevel,             //render level range
                                                                       TileTextureResolution,
                                                                       tileResolutionVec,
                                                                       false)
                                        );
    layerSet->addLayer(tdtLabel);
    
    
    return layerSet;
     */
}
-(void)reCreateLayersSet
{
    string ip = [_setupView->textview.text UTF8String];
    int tileResolution = 11;
    int layerRenderLevel =20;
    Vector2I tileResolutionVec = Vector2I(tileResolution,tileResolution);
     const Vector2I TileTextureResolution =Vector2I(512,512);
    _layerSet->removeAllLayers(true);
    //天地图Map
    ZWMSLayer* tdtMap = new ZWMSLayer("天地图地图",
                                      URL("http://"+ip+"/zs/data/tile/map?name=%2FTdt%2FMap", false),
                                      WMS_1_1_0,
                                      Sector::fullSphere(),
                                      "image/png",
                                      "EPSG:4326",
                                      "",
                                      false,
                                      new LevelTileCondition(0, 30),     //download level range
                                      //NULL,
                                      TimeInterval::fromDays(30),
                                      true,
                                      new LayerTilesRenderParameters(Sector::fullSphere(),
                                                                     4, 8,
                                                                     0, layerRenderLevel,             //render level range
                                                                    TileTextureResolution,
                                                                     tileResolutionVec,
                                                                     false)
                                      );
    _layerSet->addLayer(tdtMap);
    
    //天地图影像图层
    ZWMSLayer* tdtImage = new ZWMSLayer("天地图影像",
                                        URL("http://"+ip+"/zs/data/tile/map?name=%2FTdt%2FImage", false),
                                        WMS_1_1_0,
                                        Sector::fullSphere(),
                                        "image/png",
                                        "EPSG:4326",
                                        "",
                                        false,
                                        new LevelTileCondition(0, 30),     //download level range
                                        //NULL,
                                        TimeInterval::fromDays(30),
                                        true,
                                        new LayerTilesRenderParameters(Sector::fullSphere(),
                                                                       4, 8,
                                                                       0, layerRenderLevel,             //render level range
                                                                      TileTextureResolution,
                                                                       tileResolutionVec,
                                                                       false)
                                        );
    _layerSet->addLayer(tdtImage);
    
    
    //天地图注记
    ZWMSLayer* tdtLabel = new ZWMSLayer("天地图注记",
                                        URL("http://"+ip+"/zs/data/tile/map?name=%2FTdt%2FImageAnno", false),
                                        WMS_1_1_0,
                                        Sector::fullSphere(),
                                        "image/png",
                                        "EPSG:4326",
                                        "",
                                        true,
                                        new LevelTileCondition(0, 30),     //download level range
                                        //NULL,
                                        TimeInterval::fromDays(30),
                                        true,
                                        new LayerTilesRenderParameters(Sector::fullSphere(),
                                                                       4, 8,
                                                                       0, layerRenderLevel,             //render level range
                                                                       TileTextureResolution,
                                                                       tileResolutionVec,
                                                                       false)
                                        );
    _layerSet->addLayer(tdtLabel);

    int count = [checkBoxes count];
    for (int i=1; i<count; i++)
    {
        SSCheckBoxView * view = (SSCheckBoxView*) [checkBoxes objectAtIndex:i];
        [view setChecked:YES];
    }
}
- (TilesRenderParameters*) createPlanetRendererParameters
{
    const bool renderDebug = false;
    const bool useTilesSplitBudget = false;
    const bool forceFirstLevelTilesRenderOnStart = false;
    const bool incrementalTileQuality = false;
    //const Quality quality = QUALITY_MEDIUM;
    const Quality quality = QUALITY_LOW;
    
    return new TilesRenderParameters(renderDebug,
                                     useTilesSplitBudget,
                                     forceFirstLevelTilesRenderOnStart,
                                     incrementalTileQuality,
                                     quality);
}
- (MarksRenderer*) createMarksRenderer
{
    // marks renderer
    const bool readyWhenMarksReady = false;
    MarksRenderer* marksRenderer = new MarksRenderer(readyWhenMarksReady);
    
    marksRenderer->setMarkTouchListener(new LabelsTouchListener(self.view), true);
    
    //                Mark* m1 = new Mark("M", URL("file:///begin.png"),
    //                                    g, RELATIVE_TO_GROUND, 4.0e+07,
    //                                    true);
    //                Mark* m1 = new Mark("M",
    //                                    g, RELATIVE_TO_GROUND);
    
    int capacity = 9;
    _labelsPOIs = [[NSMutableArray alloc] initWithCapacity:capacity];
    if (true) {
        Mark* m1=NULL;
        LabelsData*  labeldata;
           //北京
           Geodetic3D g(Angle::fromDegrees(39.9), Angle::fromDegrees(116.5), 10);
               m1  = new Mark("北京",URL("file:///label.png"),
                                    g, RELATIVE_TO_GROUND);
        labeldata = new LabelsData();
        labeldata->addImage("北京地标.jpg");
        labeldata->addImage("北京地标2.jpg");
        labeldata->addImage("北京地标3.jpg");
        labeldata->addImage("北京地标4.jpg");
        m1->setUserData(labeldata);
       marksRenderer->addMark(m1);
       [self addMarksCBV:@"北京" index:0];
        _marksSet.push_back(m1);

        //上海
        Geodetic3D g1(Angle::fromDegrees(34.5), Angle::fromDegrees(121.43), 10);
        m1 = new Mark("上海",URL("file:///label.png"),
                            g1, RELATIVE_TO_GROUND);
        labeldata = new LabelsData();
        labeldata->addImage("上海地标.jpg");
        m1->setUserData(labeldata);
        marksRenderer->addMark(m1);
        [self addMarksCBV:@"上海" index:1];
       _marksSet.push_back(m1);
        
        
        //天津
        Geodetic3D g2(Angle::fromDegrees(39.13), Angle::fromDegrees(117.2), 10);
        m1 = new Mark("天津",URL("file:///label.png"),
                      g2, RELATIVE_TO_GROUND);
        labeldata = new LabelsData();
        labeldata->addImage("天津地标.jpg");
        m1->setUserData(labeldata);
        marksRenderer->addMark(m1);
        [self addMarksCBV:@"天津" index:2];
        _marksSet.push_back(m1);
        
        //香港
        Geodetic3D g3(Angle::fromDegrees(22.2), Angle::fromDegrees(114.1), 10);
        m1 = new Mark("香港",URL("file:///label.png"),
                      g3, RELATIVE_TO_GROUND);
        labeldata = new LabelsData();
        labeldata->addImage("香港地标.jpg");
        m1->setUserData(labeldata);
        marksRenderer->addMark(m1);
        [self addMarksCBV:@"香港" index:3];
        _marksSet.push_back(m1);
        

        //武汉
        Geodetic3D g4(Angle::fromDegrees(30.516), Angle::fromDegrees(114.316), 10);
        m1 = new Mark("武汉",URL("file:///label.png"),
                      g4, RELATIVE_TO_GROUND);
        marksRenderer->addMark(m1);
        [self addMarksCBV:@"武汉" index:4];
        _marksSet.push_back(m1);
        

//        for (int i = 0; i < 10; i+=2) {
//            for (int j = 0; j < 10; j+=2) {
//                Geodetic3D g(Angle::fromDegrees(30.516 + i), Angle::fromDegrees(114.316 + j - 10), (i+j)*10);
//                Mark* m1 = new Mark("M",URL("file:///label.png"), g, RELATIVE_TO_GROUND);
//                marksRenderer->addMark(m1);
//                
//            }
//        }

        //地质大学
//        东区：（研究生院）北纬30度31分05.61秒，东经114度24分06.57秒
//        地大信工学院：北纬30度31分06.03秒，东经114度24分23.24秒
//        西区：北纬30度31分15.05秒，东经114度23分37.32秒
//        北区：北纬30度31分37.70秒，东经114度24分02.76秒
        const string content = "湖北省武汉市洪山区鲁磨路388号 \n邮编：430074";
       
        Geodetic3D g5(Angle::fromDegrees(30.51825), Angle::fromDegrees(114.401825), 10);
        m1 = new Mark("东区",URL("file:///label.png"),
                      g5, RELATIVE_TO_GROUND);
        labeldata = new LabelsData();
        labeldata->addImage("东区.png");
        labeldata->addImage("东区2.png");
        labeldata->addImage("东区3.png");
        labeldata->addImage("东区4.png");
        labeldata->setContent(content);
        m1->setUserData(labeldata);
        marksRenderer->addMark(m1);
        [self addMarksCBV:@"东区" index:5];
        _marksSet.push_back(m1);
        

        
        Geodetic3D g6(Angle::fromDegrees(30.5183416), Angle::fromDegrees(114.406389), 10);
        m1 = new Mark("地大信工学院",URL("file:///label.png"),
                      g6, RELATIVE_TO_GROUND);
        labeldata = new LabelsData();
        labeldata->addImage("东区校门.png");
         labeldata->addImage("东区2.png");
        labeldata->addImage("东区3.png");
        labeldata->addImage("东区4.png");
        labeldata->setContent(content);
        m1->setUserData(labeldata);
        marksRenderer->addMark(m1);
        [self addMarksCBV:@"地大信工学院" index:6];
        _marksSet.push_back(m1);
        

        
        Geodetic3D g7(Angle::fromDegrees(30.520847), Angle::fromDegrees(114.393699), 10);
        m1 = new Mark("西区",URL("file:///label.png"),
                      g7, RELATIVE_TO_GROUND);
        labeldata = new LabelsData();
        labeldata->addImage("西区.png");
        labeldata->addImage("东区3.png");
        labeldata->addImage("东区4.png");
        labeldata->addImage("地大雪景.png");
        labeldata->setContent(content);
        m1->setUserData(labeldata);
        marksRenderer->addMark(m1);
        [self addMarksCBV:@"西区" index:7];
        _marksSet.push_back(m1);
        

        Geodetic3D g8(Angle::fromDegrees(30.527138), Angle::fromDegrees(114.4007666), 10);
        m1 = new Mark("北区",URL("file:///label.png"),
                      g8, RELATIVE_TO_GROUND);
        labeldata = new LabelsData();
        labeldata->addImage("西区.png");
        labeldata->addImage("东区3.png");
        labeldata->addImage("东区4.png");
        labeldata->addImage("博物馆.png");
        labeldata->setContent(content);
        m1->setUserData(labeldata);
        marksRenderer->addMark(m1);
        [self addMarksCBV:@"北区" index:8];
        _marksSet.push_back(m1);
        

    }
    
    if (false) {
        for (int i = 0; i < 2000; i++) {
            const Angle latitude  = Angle::fromDegrees( (int) (arc4random() % 180) - 90 );
            const Angle longitude = Angle::fromDegrees( (int) (arc4random() % 360) - 180 );
            
            marksRenderer->addMark(new Mark("Random",
                                            URL("http://glob3m.glob3mobile.com/icons/markers/g3m.png", false),
                                            Geodetic3D(latitude, longitude, 0), RELATIVE_TO_GROUND));
        }
    }
    
    return marksRenderer;
    
}
-(void)initHUDRender :(HUDRenderer*) hudRenderer  G3MWidget: (G3MWidget* ) widget
{
    
    
//   labelBuidler = new LabelImageBuilder("camera info",               // text
//                                                            GFont::monospaced(38), // font
//                                                            6,                     // margin
//                                                            Color::yellow(),       // color
//                                                            Color::black(),        // shadowColor
//                                                            5,                     // shadowBlur
//                                                            2,                     // shadowOffsetX
//                                                            -2,                    // shadowOffsetY
//                                                            Color::red(),          // backgroundColor
//                                                            4,                     // cornerRadius
//                                                            true                   // mutable
//                                                            );
  LabelImageBuilder*   cameraInfo = new LabelImageBuilder("camera info",
                                                                                GFont::sansSerif(),
                                                                                                        0,
                                                                                      Color::white(),
                                                                            Color::transparent(),
                                                                                                      0,
                                                                                                      2,   //shadowOffsetY
                                                                                                     -2,
                                                                            Color::transparent(),
                                                                                                        0,
                                                                                                  true);        //mutable
    
#warning Diego at work!
  HUDQuadWidget* compass = new HUDQuadWidget(//new DownloaderImageBuilder(URL("file:///g3m-marker.png")),
                                               cameraInfo,
                                               //new DownloaderImageBuilder(URL("file:///Compass_rose_browns_00_transparent.png")),
                                               new HUDAbsolutePosition(10),
                                               new HUDAbsolutePosition(10),
                                               // new HUDRelativeSize(0.15, HUDRelativeSize::VIEWPORT_MIN_AXIS),
                                               // new HUDRelativeSize(0.15, HUDRelativeSize::VIEWPORT_MIN_AXIS)
                                               new HUDRelativeSize(1, HUDRelativeSize::BITMAP_WIDTH),
                                               new HUDRelativeSize(1, HUDRelativeSize::BITMAP_HEIGTH) );
    //    compass->setTexCoordsRotation(Angle::fromDegrees(45),
    //                                   0.5f, 0.5f);
    hudRenderer->addWidget(compass);
    
    
    
   HUDQuadWidget* compass2 = new HUDQuadWidget(//URL("file:///debug-texture.png"),
                                                new DownloaderImageBuilder(URL("file:///compass.png")),
                                                //URL("file:///debug-compass.png"),
                                                //                                                        new HUDAbsolutePosition(),
                                                //                                                        new HUDAbsolutePosition(150+10),
                                                new HUDRelativePosition(0.85,
                                                                        HUDRelativePosition::VIEWPORT_WIDTH,
                                                                        HUDRelativePosition::RIGHT),
                                                new HUDRelativePosition(0.8,
                                                                        HUDRelativePosition::VIEWPORT_HEIGTH,
                                                                        HUDRelativePosition::ABOVE),
                                                new HUDRelativeSize(0.12,
                                                                    HUDRelativeSize::VIEWPORT_MIN_AXIS),
                                                new HUDRelativeSize(0.12,
                                                                    HUDRelativeSize::VIEWPORT_MIN_AXIS));
    
    hudRenderer->addWidget(compass2);
    _animateHUDtask = new AnimateHUDWidgetsTask(compass,compass2,cameraInfo,widget,NULL);
    _animateHUDtask->setPrintMethod(false);
    widget->addPeriodicalTask(new PeriodicalTask(TimeInterval::fromSeconds(0.5),
                                                _animateHUDtask));
}

-(void)changeLayers :(id)sender
{
    SSCheckBoxView * view = (SSCheckBoxView*) sender;
    int index =  view.index;
    if (index==0) {
        _starsRenderer->setEnable(view.checked);
    }
    else
    {
        _layerSet->getLayer(index-1)->setEnable(view.checked);
    }
}
//定位到Label点
-(void)LocateToLabel:(id)sender
{
    SSCheckBoxView * view = (SSCheckBoxView*) sender;
    int index =  view.index;
    const Geodetic3D toPos =    _marksSet[index]->getPosition();
    G3MWidget*  widget =  [[self g3mWidget] widget];
    if (widget)
    {
        const Camera* curCamera =  widget->getCurrentCamera();
        const Geodetic3D pos     =  curCamera->getGeodeticPosition();
        widget ->setAnimatedCameraPosition(TimeInterval::fromSeconds(3.0),pos,
                                           Geodetic3D(toPos._latitude,toPos._longitude,toPos._height+12000.0), curCamera->getHeading(), Angle::fromDegrees(0), curCamera->getPitch(), Angle::fromDegrees(0));
    }
    
    
}
//向labelsPOI中添加 checkBoxView
-(void)addMarksCBV:(NSString*)name index:(NSUInteger) index
{
    if (_labelsPOIs==nil)
    {
        return;
    }
    CGRect frame = CGRectMake(20, 7, 240, 30);
    SSCheckBoxViewStyle style = (SSCheckBoxViewStyle)(kSSCheckBoxViewStyleBox);
    BOOL checked =YES;
    SSCheckBoxView *cbv = [[SSCheckBoxView alloc] initWithFrame:frame
                                                          style:style
                                                        checked:checked];
    [cbv setStateChangedTarget:self selector:@selector(LocateToLabel:)];
    [cbv setText:name];
    [cbv   setIndex:index];
    [_labelsPOIs addObject:cbv];
}
BOOL barButtonDown = NO;
#pragma mark -  Operation  methods
-(void)LayerBarButtonItemAction:(id) sender
{
//    if (!_layersTableView.setupView.hidden)
//    {
//        _layersTableView.setupView.hidden = YES;
//        [_layersTableView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.7]];
//        return ;
//    }
    [_layersTableView setHidden:NO];
    UIBarButtonItem* button = (UIBarButtonItem*)sender;
    barButtonDown = !barButtonDown;
    CGRect rect =  CGRectMake(0, 44, 320,0);
    CGRect rect1= CGRectMake(0, 44, 320,1024);
    if (!barButtonDown)
    {
       rect1 = CGRectMake(0, 44, 320,0);
       rect=CGRectMake(0, 44, 320,1024);
        [button setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [button setStyle:UIBarButtonItemStyleDone];
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"Curl" context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [_layersTableView setFrame:rect];
    [_layersTableView setFrame:rect1];
    [UIView commitAnimations];
}
-(void)ResetNorth:(id)sender
{
    G3MWidget*  widget =  [[self g3mWidget] widget];
    if (widget)
    {
        const Camera* curCamera =  widget->getCurrentCamera();
        const Geodetic3D toPos     =  curCamera->getGeodeticPosition();
        widget->setAnimatedCameraHeading(TimeInterval::fromSeconds(2.0), curCamera->getHeading(),Angle::fromDegrees(0));
        
    }
}
-(void)ResetPlanet:(id)sender
{
    G3MWidget*  widget =  [[self g3mWidget] widget];
    if (widget)
    {
        const Camera* curCamera =  widget->getCurrentCamera();
        const Geodetic3D pos = curCamera->getGeodeticPosition();
        const Geodetic3D toPos     =  Geodetic3D(pos._latitude,
                                                 pos._longitude,2.4e+07);
        widget ->setAnimatedCameraPosition(TimeInterval::fromSeconds(3.0),pos,toPos, curCamera->getHeading(), Angle::fromDegrees(0), curCamera->getPitch(), Angle::fromDegrees(0));
    }
}
//更改IP服务器
-(void)ChangeIPServer:(id)sender
{
    _setupView = _layersView->_setupView;
    [self reCreateLayersSet];
}
-(void)switchPrintDegree:(id)sender
{
    UISwitch* s= (UISwitch*)sender;
    _animateHUDtask->setPrintMethod(!s.on);
}
#pragma mark -
#pragma mark View  methods
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload
{
    g3mWidget = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [g3mWidget stopAnimation];
    [super viewDidDisappear:animated];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else
    {
        return YES;
    }
}
- (void)viewWillLayoutSubviews
{
       if(!barButtonDown)
       {
        [_layersTableView setFrame: CGRectMake(0, 44, 320,0)];
       }
}
@end
