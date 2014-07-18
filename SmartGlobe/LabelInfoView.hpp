//
//  LabelInfoView.h
//  SmartGlobe
//
//  Created by G on 4/22/14.
//  Copyright (c) 2014 G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mark.hpp"
#import <MediaPlayer/MediaPlayer.h>

@interface LabelInfoView : UIView
{
    float _scale ;
    UILabel * _tile;
    UITextView* _contents;
    Mark*     _mark;
    int _index;
    UIView*   _realLabelView;
    MPMoviePlayerViewController*   _moviePlayerController;
}

-(void)initialContent:(Mark*) mark backgroundImage:(int) index;
-(void)initialImages:(Mark*) mark;
-(void)initialContents:(Mark*) mark;
-(void)animationStop:(id)sender;
@end
