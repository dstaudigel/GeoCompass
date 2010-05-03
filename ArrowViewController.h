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
  NSManagedObjectContext * managedObjectContext;
  
  UIAccelerometer * accelerometer;
  CLLocationManager * locationManager;
  
  float averaging_time;
  
  float latitude;
  float longitude;
  
  NSTimer * updateTimer;
  
  std::queue<Vector3f,std::deque<Vector3f> > downVA;
  Vector3f downV_unscaled;
  Vector3f downV,northV;
  
  float dip,dipDir;
  
  IBOutlet UIImageView * arrow;
  IBOutlet UILabel * latLabel;
  IBOutlet UILabel * lonLabel;
  IBOutlet UILabel * dipLabel;
  IBOutlet UILabel * dipDirLabel;
  IBOutlet UILabel * strikeLabel;
  
  IBOutlet UIButton * holdButton;
}

@property(readonly) float dip;
@property(readonly) float dipDir;

@property(assign) NSManagedObjectContext * managedObjectContext;
- (void)updateView;
- (IBAction)hold:(id)sender;
- (IBAction)save:(id)sender;
@end
