//
//  LayerContainer.h
//  SmartGlobe
//
//  Created by G on 5/20/14.
//  Copyright (c) 2014 G. All rights reserved.
//

#import "IContainer.h"

@interface LayerContainer : IContainer
@property(nonatomic) bool isUse32Bit;
@property(nonatomic) bool isUseJingWei;
@property(nonatomic) bool isEnableLight;
@property(nonatomic) float  xScale;
@property(nonatomic) float  yScale;
@property(nonatomic) float  radius;
@property(nonatomic) int  visualMode;
@property(nonatomic) unsigned int  tilePixelSize;
@property(nonatomic) unsigned int  tileMaxPixelSize;

@end
