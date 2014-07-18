//
//  SetUpView.m
//  SmartGlobe
//
//  Created by G on 5/4/14.
//  Copyright (c) 2014 G. All rights reserved.
//

#import "SetUpView.hpp"
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation SetUpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 70, 30)];
        label.text = @"服务器:";
        label.backgroundColor =[UIColor clearColor];
        textview = [[UITextView alloc] initWithFrame:CGRectMake(90,7, 125, 30)];
        textview.delegate = self;
        textview.text = @"192.168.1.120:8079";
        textview.textAlignment = UITextAlignmentCenter;
        textview.backgroundColor =[UIColor clearColor];
        textview.layer.borderColor =[UIColor grayColor].CGColor;
        textview.layer.borderWidth =1.0;
        textview.layer.cornerRadius =5.0;
        
        [self addSubview:label];
        [self addSubview:textview];
        
//        UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(20, 65, frame.size.width-20, 5)];
//        line.text = @"............";
//        [self addSubview: line];
        
    
        
        

        
    }
    return self;
}
-(void)addFinishedButton
{
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        //initWithFrame:CGRectMake(245,7, 55, 30)];
    button.frame = CGRectMake(220,7, 79, 30);
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ChangeIPServer:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

#pragma mark- UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
//    UIPickerView*  pickerveiw =[[UIPickerView alloc] initWithFrame:CGRectMake(20, 130, 200, 200)];
//    [self addSubview:pickerveiw];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    _ipTest = textview.text;
}
-(void)ChangeIPServer:(id)sender
{
    [textview endEditing:YES];
    [(ViewController*)_mainViewController ChangeIPServer:sender];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
