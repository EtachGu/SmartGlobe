//
//  TQViewController.h
//  TQMultistageTableViewDemo
//
//  Created by fuqiang on 13-9-3.
//  Copyright (c) 2013年 fuqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQMultistageTableView.h"
#import "SSCheckBoxView.h"
#import "LayerSet.hpp"
#import "Layer.hpp"
#import "SetUpView.hpp"

@interface TQViewController : UIViewController <TQTableViewDataSource, TQTableViewDelegate>
{
    @public
    NSMutableArray*    _checkBoxes;
    UIViewController*    _mainViewController;
    NSMutableArray*       _labelsPOIs;
    SetUpView*              _setupView;
}


@property (nonatomic, strong) TQMultistageTableView *mTableView;




@end
