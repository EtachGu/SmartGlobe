//
//  LabelsTouchListener.cpp
//  SmartGlobe
//
//  Created by G on 4/22/14.
//  Copyright (c) 2014 G. All rights reserved.
//

#include "LabelsTouchListener.hpp"
bool  LabelsTouchListener::createDiagramView(Mark* mark ,const Vector2F pixels)
{
    if (_rootView) {
        if(_markView)
        {
            [_markView removeFromSuperview];
        }
        
        CGRect rect = getCGRect(pixels);
        CGRect  rect0 = CGRectMake(pixels._x, pixels._y, 33, 45);
        
        _mark =mark;
        _markView = [[LabelInfoView alloc] initWithFrame:rect0];
        LabelInfoView* markInfoView = (LabelInfoView*)_markView;
        [markInfoView initialContent:mark backgroundImage:_backgroundImageIndex];
       

        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:@"Curl" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:_markView];
        [UIView setAnimationDidStopSelector:@selector(animationStop:)];
        CGAffineTransform transform1 = CGAffineTransformMakeScale(10, 10);
        CGAffineTransform transform2 = CGAffineTransformMakeTranslation(rect.origin.x-rect0.origin.x + 165 - 16.5,rect.origin.y-rect0.origin.y + 225-22.5);
        _markView.transform =CGAffineTransformConcat(transform1, transform2);
        [UIView commitAnimations];
    
        [_rootView addSubview:_markView];
        [_rootView bringSubviewToFront:_markView];
        
    }
    return 1;
}
CGRect LabelsTouchListener:: getCGRect(const Vector2F pixels)
{
    CGSize size =  [_rootView bounds].size;
    const float width  =  size.width;
    const float height =  size.height;
    CGRect rect = CGRectMake(0, 0, 330, 450);
    int  index = 0;
    if (pixels._x > width - 330)
    {
        //right
        rect.origin.x = pixels._x - 330;
        index = 1;
    }
    else
    {
        //left
        rect.origin.x = pixels._x;
        index = 0;
    }
    if (pixels._y < 225)
    {
        // top
        rect.origin.y = pixels._y;
        index += 0;
    }
    else if(pixels._y > height-225)
    {
        // bottom
        rect.origin.y = pixels._y - 450;
        index += 4;
    }
    else
    {
        //middle
        rect.origin.y = pixels._y - 225;
        index +=2;
    }
    _backgroundImageIndex = index;
    return  rect;
}
