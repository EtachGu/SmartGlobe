//
//  LabelInfoView.m
//  SmartGlobe
//
//  Created by G on 4/22/14.
//  Copyright (c) 2014 G. All rights reserved.
//

#import "LabelInfoView.hpp"
#import "LabelsData.h"
@interface LabelInfoView (MPMoviePlayerViewController)

- (void)presentMoviePlayerViewControllerAnimated:(MPMoviePlayerViewController *)moviePlayerViewController;
- (void)dismissMoviePlayerViewControllerAnimated;

@end
@implementation LabelInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       _scale   = frame.size.width / 330.0 ;
    }
    return self;
}
-(void)initialContent:(Mark*) mark backgroundImage:(int) index
{
    _index = index;
    UIImage* background = [self getBackgroundImage:index];
    UIImageView* back = [[UIImageView alloc] initWithFrame:[self bounds]];
    back.image = background;
    [self addSubview:back];
    [self sendSubviewToBack:back];
    
    _mark = mark;
    //添加图片
    [self initialImages:mark];
//    [self initialContents:mark];
}
//添加视频按钮
-(void)initialMoive:(Mark*)mark
{
    UIButton* mvbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    mvbutton.frame = CGRectMake(250, 12, 30 , 30);
    UIImage* image = [UIImage imageNamed:@"video1.png"];
    [mvbutton setBackgroundImage:image forState:UIControlStateNormal];
    [mvbutton addTarget:self  action:@selector(DisplayMV:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mvbutton];
}
-(void)initialContents:(Mark*) mark
{
   _tile = [[UILabel alloc] initWithFrame:CGRectMake(15*_scale, 10*_scale, 300*_scale , 30*_scale)];
    UILabel* tile = _tile;
    tile.text = [NSString stringWithUTF8String:mark->getLabel().c_str()];
    tile.textColor = [UIColor whiteColor];
    tile.adjustsFontSizeToFitWidth = YES;
    tile.backgroundColor = [UIColor clearColor];
    tile.textAlignment = UITextAlignmentCenter;
//    tile.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin |
//    UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin ;
    [self addSubview:tile];
    
    Geodetic3D pos =  mark->getPosition();
   _contents   = [[UITextView alloc] initWithFrame:CGRectMake(39*_scale, 305*_scale, 250*_scale , 80*_scale)];
    UITextView*  content =_contents;
    content.text =[NSString stringWithFormat:@"%@ 位于：\n  纬度 %0.1f ° \n  经度 %0.1f °  \n" , tile.text ,pos._latitude._degrees,pos._longitude._degrees];
    content.textColor = [UIColor blackColor];
    content.backgroundColor = [UIColor clearColor];
    LabelsData* labelData = (LabelsData*)mark->getUserData();
    if (labelData!=NULL)
    {
        if (labelData->_content != "\0")
        {
            NSString* contents = [NSString stringWithUTF8String:labelData ->_content.c_str()];
            content.text = [content.text stringByAppendingString:contents];
        }
    }
//    [content setFont:[UIFont systemFontOfSize:12]];
    content.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin ;
    [self addSubview:content];
}
-(void)initialImages:(Mark*) mark
{
    LabelsData* labelData = (LabelsData*)mark->getUserData();
    float scale   = _scale;
    if (labelData == NULL)
    {
        UIImage* image =[UIImage imageNamed:@"武汉.jpg"];
        //总框（330，450）内部左上角 为（35，45） 宽为258 高位383  左下角（35，428）
        CGRect rect =    CGRectMake(39*scale, 49*scale, 250*scale, 250*scale);
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.image = image;
        [self addSubview:imageView];
    }
    else
    {
        //最多四块图片
        int numImages = labelData->getImagesCount();
        CGRect rect =    CGRectMake(39*scale, 49*scale, 250*scale, 250*scale);
        if (numImages<=2) {
//            rect = CGRectMake(39, 49, 250/numImages, 250);
            rect.size.width /=numImages;
        }
        else
        {
            rect.size.width  /=2;
            rect.size.height /= 2;
        }
        for(int i=0;i<numImages;i++)
        {
            string name_st = labelData->_images[i];
            NSString* name = [NSString stringWithUTF8String:name_st.c_str()];
            UIImage* image =[UIImage imageNamed:name];
            CGRect rectImages = CGRectMake(rect.origin.x + rect.size.width *(i%2) ,rect.origin.y + rect.size.height * (i/2), rect.size.width, rect.size.height);
            if (numImages==3 && i ==2)
            {
                rectImages.size.width *= 2;
            }
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:rectImages];
            imageView.image = image;
            [self addSubview:imageView];
        }
    }
}
-(UIImage*) getBackgroundImage:(int) index
{
    NSString* name =[NSString stringWithFormat:@"labelInfoBackground_%d.png", index] ;
    UIImage* backGroundImage = [UIImage imageNamed:name];
    return backGroundImage;
}
-(void)layoutSubviews
{
    _scale  = self.frame.size.width / 330;
//    _scale  *=0.01;
    CGRect r = self.frame;
    CGRect r0 = _tile .frame;
    CGRect r1 = _contents.frame;
//    _tile.text = [NSString stringWithUTF8String:_mark->getLabel().c_str()];
//    [self initialContents:_mark];
//    _tile.frame = CGRectMake(15*_scale, 10*_scale, 300*_scale , 30*_scale);
//    _contents.frame = CGRectMake(39*_scale, 305*_scale, 250*_scale , 80*_scale);
//    
//    
//    UILabel* tile = [[UILabel alloc] initWithFrame:CGRectMake(15*_scale, 10*_scale, 300*_scale , 30*_scale)];
//    tile.text = @"hh ";
//    tile.textColor = [UIColor whiteColor];
//    tile.backgroundColor = [UIColor clearColor];
//    tile.textAlignment = UITextAlignmentCenter;
//    [self addSubview:tile];
//    [self initialContents:_mark];
//    if (_content)
//    {
//        [_content removeFromSuperview];
//    }
//    if (_tile)
//    {
//        [_tile removeFromSuperview];
//    }
//    [self initialContents:_mark];
}
-(void)animationStop:(id)sender
{
    CGRect rect = self.frame;
   UIView* superview =  [self superview];
    [self removeFromSuperview];
    LabelInfoView* labelview = [[LabelInfoView alloc] initWithFrame:rect];
    [labelview                  initialContent:_mark backgroundImage:_index];
    [labelview initialMoive:_mark];
    [labelview initialContents:_mark];
    [superview addSubview:labelview];
    _realLabelView = labelview;
}
-(void)removeFromSuperview
{
    [super removeFromSuperview];
    if (_realLabelView)
    {
        [_realLabelView removeFromSuperview];
    }
}
- (void)presentMoviePlayerViewControllerAnimated:(MPMoviePlayerViewController *)moviePlayerViewController
{
    [self.superview addSubview:moviePlayerViewController.view];
}
- (void)dismissMoviePlayerViewControllerAnimated
{
    [_moviePlayerController.view removeFromSuperview];
}
#pragma mark - operation
-(void)DisplayMV:(id)sender
{
//    NSString *path=[[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"];
    
    NSArray* resourcePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = [resourcePath objectAtIndex:0];
    NSString* movieDir  = [documentPath stringByAppendingPathComponent:@"视频"];
    NSString* name   = [_tile.text stringByAppendingString:@".mp4"];
    NSString* path = [movieDir stringByAppendingPathComponent:name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:path];
    if (existed == NO)
    {
        UIAlertView* alertView =[[UIAlertView alloc] initWithTitle:@"错误" message:@"视频文件不存在!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    NSURL *URL = [[NSURL alloc] initFileURLWithPath:path];
     _moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:URL];
    [self presentMoviePlayerViewControllerAnimated:_moviePlayerController];
    _moviePlayerController.moviePlayer.movieSourceType=MPMovieSourceTypeFile;
    [_moviePlayerController.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    [_moviePlayerController.moviePlayer play];
    [_moviePlayerController.view setBackgroundColor:[UIColor clearColor]];
    
    [_moviePlayerController.view setFrame:CGRectMake(0, -20, self.superview.bounds.size.width, self.superview.bounds.size.height+20)];
//    CGRect rect = _moviePlayerController.view.frame;
//    [_moviePlayerController.moviePlayer.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(playbackDidFinsh:)
     
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
     
                                               object:_moviePlayerController.moviePlayer];
}
-(void)playbackDidFinsh:(NSNotification*) aNotification
{
        MPMoviePlayerController *player = [aNotification object];
        
        
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
         
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
         
                                                      object:player];
        
        if (_moviePlayerController)
        {
            
            [self dismissMoviePlayerViewControllerAnimated];
            
//            [self->_moviePlayerController.moviePlayer stop];
//            
//            _moviePlayerController.moviePlayer.initialPlaybackTime = -1.0;
//            
//            _moviePlayerController= nil;
            
        }
        
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
