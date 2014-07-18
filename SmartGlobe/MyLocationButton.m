//
//  MyLocationButton.m
//  SmartGlobe
//
//  Created by G on 3/28/14.
//  Copyright (c) 2014 G. All rights reserved.
//

#import "MyLocationButton.h"

@implementation MyLocationButton
@synthesize pressed =_pressed;
@synthesize locationManager;
@synthesize longitude=_longitude;
@synthesize latitude = _latitude;
@synthesize changed  = _changed ;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
         [self setBackgroundImage:[self MyLocationButtonForStyle:NO] forState:UIButtonTypeCustom];
        _pressed =NO;
        // 判断定位操作是否被允许
        _changed = false;
        if([CLLocationManager locationServicesEnabled])
        {
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
        }
        else
        {
            //提示用户无法进行定位操作
        }

    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _pressed =NO;
        _changed = false;
        UIImage* image = [self MyLocationButtonForStyle:_pressed];
        [self setImage:image forState:UIButtonTypeCustom];
        [self addTarget:self action:@selector(TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        // 判断定位操作是否被允许
        if([CLLocationManager locationServicesEnabled])
        {
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
        }
        else
        {
            //提示用户无法进行定位操作
        }
    }
    return  self;
}
- (UIImage *) MyLocationButtonForStyle:(BOOL)isChecked
{
//    NSString *imageName = isChecked ? @"mylocation-ipad_on@2x.png" : @"mylocation-ipad@2x.png";
       NSString *imageName = isChecked ? @"mylocation-ipad_on.png" : @"mylocation-ipad.png";
//    imageName = [NSString stringWithFormat:@"%@", imageName];
    return [UIImage imageNamed:imageName];
}
-(void)TouchUpInside:(id)sender
{
    _pressed =!_pressed;
    [self updateImage];
       // 开始定位
    if (locationManager)
    {
        if (_pressed)
        {
           [locationManager startUpdatingLocation];
        }
        else
        {
            [locationManager stopUpdatingLocation];
            _changed =false;
        }
    }
}
- (void) updateImage
{
    UIImage* image = [self MyLocationButtonForStyle:_pressed];
     [self setImage:image forState:UIButtonTypeCustom];
}
// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    //latitude和lontitude均为NSString型变量
    if (oldLocation &&
        abs(oldLocation.coordinate.latitude - newLocation.coordinate.latitude) <1e-07 &&
        abs(oldLocation.coordinate.longitude - newLocation.coordinate.longitude) < 1e-07){
        _changed = false;
        return ;
    }
    //纬度
    _latitude =   newLocation.coordinate.latitude;
    //经度
   _longitude = newLocation.coordinate.longitude;
    
    _oldLocation = newLocation.coordinate;
    _changed = true;
    
    
    // for 6.0 and later
//    NSLog(@"latitude %+.6f, longitude %+.6f\n",
//          newLocation.coordinate.latitude,
//          newLocation.coordinate.longitude);
//    currentLocation = newLocation.coordinate;
//    [self updateHeadingDisplays];
    // else skip the event and process the next one.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    if (newHeading.headingAccuracy < 0)
        return;
    
    // Use the true heading if it is valid.
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ?
                                       newHeading.trueHeading : newHeading.magneticHeading);
    
    self.currentHeading = theHeading;
//    [self updateHeadingDisplays];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        _changed = false;
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
