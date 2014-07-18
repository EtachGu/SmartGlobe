//
//  LayersTree.m
//  SmartGlobe
//
//  Created by G on 5/20/14.
//  Copyright (c) 2014 G. All rights reserved.
//

#import "LayersTree.h"

@implementation LayersTree
@synthesize xmlData =_xmlData;
@synthesize parserXML= _parserXML;
@synthesize  dataToParse=_dataToParse
, workingArray=_workingArray,workingPropertyString =_workingPropertyString, elementsToParse=_elementsToParse;

//定义需要从xml中解析的元素
static NSString *kIDStr     = @"id";
static NSString *kNameStr   = @"name";
static NSString *kImageStr  = @"image";
static NSString *kArtistStr = @"artist";

-(id)init:(NSString*) fileName
{
    self = [super init];
    if (self)
    {
        //初始化用来临时存储从xml中读取到的字符串
        self.workingPropertyString = [NSMutableString string];
        
        //初始化用来存储解析后的xml文件
        self.workingArray = [NSMutableArray array];
        
//        //从资源文件中获取images.xml文件
//        NSString *strPathXml = [[NSBundle mainBundle] pathForResource:@"images" ofType:@"xml"];
        NSArray* resourcePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
         NSString* documentPath = [resourcePath objectAtIndex:0];
        NSString* fileFullName = [documentPath stringByAppendingPathComponent:@"Default01.xml"];
        
        NSFileManager* fileManager = [NSFileManager defaultManager];
        BOOL existed = [fileManager fileExistsAtPath:fileFullName];
        if (existed == NO)
        {
//            UIAlertView* alertView =[[UIAlertView alloc] initWithTitle:@"错误" message:@"文件不存在!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alertView show];
            return nil;
        }
        //将xml文件转换成data类型
        self.xmlData = [[NSData alloc] initWithContentsOfFile:fileFullName];
        
        //初始化待解析的xml
        self.parserXML = [[NSXMLParser alloc] initWithData:_xmlData];
        
        //初始化需要从xml中解析的元素
        self.elementsToParse = [NSArray arrayWithObjects:kIDStr, kNameStr, kImageStr, kArtistStr, nil];
        
        //设置xml解析代理为self
        [_parserXML setDelegate:self];
        
        //开始解析
        [_parserXML parse];//调用解析的代理方法
        
        return  self;
    }
    return nil;
}
#pragma mark- xmlparserdelegate method
//遍例xml的节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict
{
    // entry: { id (link), im:name (app name), im:image (variable height) }
    //判断elementName与images是否相等
    if ([elementName isEqualToString:@"Container"])
	{
        //相等的话,重新初始化workingEntry
//		self.workingEntry = [[[AppRecord alloc] init] autorelease];
        NSString *nameAttribute = [attributeDict valueForKey:@"Name"];
        if ([nameAttribute isEqualToString:@""])
        {
            NSString *USGSWebLink = [attributeDict valueForKey:@"href"];
        }
    }
	//查询指定对象是否存在，我们需要保存的那四个对象，开头定义的四个static
    storingCharacterData = [_elementsToParse containsObject:elementName];
}

//节点有值则调用此方法
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (storingCharacterData)
    {
		//string添加到workingPropertyString中
        [_workingPropertyString appendString:string];
    }
}
//当遇到结束标记时，进入此句
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
	//判断workingEntry是否为空
	if (self.workingEntry)
	{
        if (storingCharacterData)
        {
			//NSString的方法，去掉字符串前后的空格
			NSString *trimmedString = [_workingPropertyString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            //将字符串置空
			[_workingPropertyString setString:@""];
			//根据元素名，进行相应的存储
					
		}
	}
	//遇到images时，将本次解析的数据存入数组workingArray中，AppRecord对象置空
    if ([elementName isEqualToString:@"images"])
	{
		[self.workingArray addObject:self.workingEntry];
		self.workingEntry = nil;
		//用于检测数组中是否已保存，实际使用时可去掉，保存的是AppRecord的地址
		NSLog(@"%@",_workingArray);
	}
}


@end
