//
//  LayersTree.h
//  SmartGlobe
//
//  Created by G on 5/20/14.
//  Copyright (c) 2014 G. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IContainer.h"

@interface LayersTree : NSObject  <NSXMLParserDelegate>
{
//    NSData *xmlData;
//    NSXMLParser *parserXML;
//    NSData          *dataToParse;
//    NSMutableArray  *workingArray;
//    NSMutableString *workingPropertyString;
//    NSArray         *elementsToParse;
    BOOL            storingCharacterData;
}
@property (nonatomic,retain) NSXMLParser *parserXML;
@property (nonatomic,retain) NSData *xmlData;
@property (nonatomic,retain) NSData          *dataToParse;
@property (nonatomic,retain) NSMutableArray  *workingArray;
@property (nonatomic,retain) NSMutableString *workingPropertyString;
@property (nonatomic,retain) NSArray         *elementsToParse;
@property(retain,nonatomic) IContainer * workingEntry;

-(id)init:(NSString*) filepath;


@end
