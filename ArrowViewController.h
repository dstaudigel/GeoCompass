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
#include <queue>

using namespace vmml;

@interface ArrowViewController : UIViewController <CLLocationManagerDelegate,UIAccelerometerDelegate>
{
	UIAccelerometer * accelerometer;
	CLLocationManager * locationManager;
	
	float averaging_time;
	
	float latitude;
	float longitude;
	
	std::queue<Vector3f> downVA;
	Vector3f downV,northV;
	
	IBOutlet UIImageView * arrow;
	IBOutlet UILabel * latLabel;
	IBOutlet UILabel * lonLabel;
	IBOutlet UILabel * dipLabel;
	IBOutlet UILabel * azimuthLabel;
}
- (void)updateView;
@end
