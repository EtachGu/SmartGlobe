//
//  IContainer.h
//  SmartGlobe
//
//  Created by G on 5/20/14.
//  Copyright (c) 2014 G. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IContainer : NSObject
@property(retain,nonatomic) NSString* name;
@property(retain,nonatomic) NSString* dispName;
@property(retain,nonatomic) NSString* type;
@property(nonatomic) bool    isVisible;
@property(nonatomic) bool isSelected;



@end
