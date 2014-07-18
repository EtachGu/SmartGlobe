//
//  SetUpView.h
//  SmartGlobe
//
//  Created by G on 5/4/14.
//  Copyright (c) 2014 G. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SetUpView : UIView<UITextViewDelegate>
{
@public
    UITextView* textview;
    NSString*     _ipTest;
    UIViewController*    _mainViewController;
}
-(void)addFinishedButton;
@end
