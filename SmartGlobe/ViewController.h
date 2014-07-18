//
//  ViewController.h
//  SmartGlobe
//
//  Created by G on 3/17/14.
//  Copyright (c) 2014 G. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "G3MWidget_iOS.h"
//#import "StartUpView.h"
//#import "G3MWidget_iOS.h"

#import "SSCheckBoxView.h"
#import "MyLocationButton.h"
#import "TQMultistageTableView.h"
#import "TQViewController.hpp"
#import "SetUpView.hpp"



//other temp class
//#import "TestVisibleSectorListener.h"
//#import "MoveCameraInitializationTask.h"
//#import "SampleMapBooApplicationChangeListener.h"
//#import "SampleSymbolizer.h"
//#import "SampleInitializationTask.h"
//#import "TestTrailTask.h"
//#import "RadarParser_BufferDownloadListener.h"


class Sector;
class Mesh;
class Mark;

Mesh* createSectorMesh(const Planet* planet,
                       const int resolution,
                       const Sector& sector,
                       const Color& color,
                       const int lineWidth);

@interface ViewController : UIViewController {
    IBOutlet G3MWidget_iOS* g3mWidget;
    NSMutableArray*    checkBoxes;                           // 图层 内容
    MyLocationButton*     _mylocationButton;
    TQViewController*      _layersView;
    NSMutableArray*     _labelsPOIs;
    std::vector<Mark*>  _marksSet;
    
}

@property (retain, nonatomic) G3MWidget_iOS* g3mWidget;
@property(retain,nonatomic) UIActivityIndicatorView * actIndicatorView;
@property(retain,nonatomic) IBOutlet TQMultistageTableView*   layersTableView;
@property(retain,nonatomic) IBOutlet UIBarButtonItem* layersBarButtonItem;
@property(retain,nonatomic) IBOutlet UINavigationBar*    navigationBar;
@property(retain,nonatomic) IBOutlet MyLocationButton*    myLocationButton;
@property(retain,nonatomic) IBOutlet UIButton *  northButton;
@property(retain,nonatomic) IBOutlet UIButton *  resetButton;   // reset the planet
@property(nonatomic,retain)SetUpView*      setupView;



-(void)LayerBarButtonItemAction:(id) sender;
-(void)ResetNorth:(id)sender;
-(void)ResetPlanet:(id)sender;
-(void)ChangeIPServer:(id)sender;
@end



