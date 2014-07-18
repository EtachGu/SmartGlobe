//
//  StartUpView.m
//  SmartGlobe
//
//  Created by G on 3/18/14.
//  Copyright (c) 2014 G. All rights reserved.
//

#import "StartUpView.h"

@implementation StartUpView

@synthesize ImageView =_ImageView;
@synthesize spinner = _spinner;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *defaultImage = [UIImage imageNamed:@"default2.png"];
        _ImageView = [[UIImageView alloc] initWithImage:defaultImage];
        [_ImageView setFrame:frame];
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_spinner setCenter:self.center];
        [_spinner startAnimating];
        [self addSubview:_ImageView];
        [self addSubview: _spinner];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self =[super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        UIImage *defaultImage = [UIImage imageNamed:@"default2.png"];
        _ImageView = [[UIImageView alloc] initWithImage:defaultImage];
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_spinner setCenter:self.center];
        [_spinner startAnimating];
        [self addSubview:_ImageView];
        [self addSubview: _spinner];
    }
    return self;
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
