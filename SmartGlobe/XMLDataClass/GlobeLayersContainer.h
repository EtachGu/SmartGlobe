//
//  GlobeLayersContainer.h
//  SmartGlobe
//
//  Created by G on 5/20/14.
//  Copyright (c) 2014 G. All rights reserved.
//

#import "IContainer.h"

@interface GlobeLayersContainer : IContainer
@property(nonatomic) int globe_ColNum;
@property(nonatomic) int globe_LayerHeight;
@property(nonatomic) bool globe_PassHorizon;
@property(nonatomic) double globe_Range_Bottom;
@property(nonatomic) double globe_Range_Left;
@property(nonatomic) double globe_Range_Right;
@property(nonatomic) double globe_Range_Top;
@property(nonatomic) bool globe_RenderSkirts;
@property(nonatomic) int globe_RowNum;
@property(nonatomic) int globe_TileGridNum;


@property(nonatomic) int plat_ColNum;
@property(nonatomic) int plat_LayerHeight;
@property(nonatomic) int plat_LodCount;
@property(nonatomic) bool plat_PassHorizon;
@property(nonatomic) double plat_Range_Bottom;
@property(nonatomic) double plat_Range_Left;
@property(nonatomic) double plat_Range_Right;
@property(nonatomic) double plat_Range_Top;
@property(nonatomic) bool plat_RenderSkirts;
@property(nonatomic) int plat_RowNum;
@property(nonatomic) int plat_TileGridNum;

@property(retain,nonatomic)NSString* terrainOpenString;
@property(retain,nonatomic)NSString* terrainType;



@end
