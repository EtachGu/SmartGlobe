//
//  MyLocationButton.h
//  SmartGlobe
//
//  Created by G on 3/28/14.
//  Copyright (c) 2014 G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface MyLocationButton : UIButton <CLLocationManagerDelegate>
{
    
    CLLocationManager       *locationManager;
    
    CLLocationCoordinate2D  currentLocation;
    CLLocationDirection     currentHeading;
    
    CLLocationCoordinate2D  _oldLocation;
    CLLocationDirection     _oldHeading;

}
@property(nonatomic)BOOL pressed;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic) CLLocationDirection currentHeading;
@property(nonatomic,readonly) float longitude;
@property(nonatomic,readonly) float latitude;
@property(nonatomic,readonly) bool  changed ;

@end
