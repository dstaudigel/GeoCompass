//
//  ArrowViewController.h
//
//  Created by Daniel Staudigel on 12/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ArrowViewController : UIViewController <CLLocationManagerDelegate,UIAccelerometerDelegate>
{
	UIAccelerometer * accelerometer;
	CLLocationManager * locationManager;
	
	IBOutlet UIImageView * arrow;
	IBOutlet UILabel * latLabel;
	IBOutlet UILabel * lonLabel;
	IBOutlet UILabel * dipLabel;
	IBOutlet UILabel * azimuthLabel;
}

@end
