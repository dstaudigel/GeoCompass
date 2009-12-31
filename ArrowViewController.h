//
//  ArrowViewController.h
//
//  Created by Daniel Staudigel on 12/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#include "vector3.h"

@interface ArrowViewController : UIViewController <CLLocationManagerDelegate,UIAccelerometerDelegate>
{
	UIAccelerometer * accelerometer;
	CLLocationManager * locationManager;
	
	float latitude;
	float longitude;
	 
	float downX,downY,downZ;
	float northX,northY,northZ;
	
	IBOutlet UIImageView * arrow;
	IBOutlet UILabel * latLabel;
	IBOutlet UILabel * lonLabel;
	IBOutlet UILabel * dipLabel;
	IBOutlet UILabel * azimuthLabel;
}
- (void)updateView;
@end
