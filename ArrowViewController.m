//
//  ArrowViewController.m
//
//  Created by Daniel Staudigel on 12/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ArrowViewController.h"

@implementation ArrowViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSLog(@"View did load!");
	
	accelerometer = [UIAccelerometer sharedAccelerometer];
	accelerometer.delegate = self;
	accelerometer.updateInterval = 0.1;
	
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	
	[locationManager startUpdatingHeading];
	[locationManager startUpdatingLocation];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	downX = acceleration.x;
	downY = acceleration.y;
	downZ = acceleration.z;
	
	[self updateView];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
	
	northX = newHeading.x;
	northY = newHeading.y;
	northZ = newHeading.z;
	
	[self updateView];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	latitude = newLocation.coordinate.latitude;
	longitude = newLocation.coordinate.longitude;
	
	[self updateView];
}


- (void)updateView
{
	// get the angle in the plane of the phone
	float angle = atan2(downY,downX);
	
	float downLen = sqrt(downX*downX+downY*downY);
	float nDownX = downX/downLen;
	float nDownY = downY/downLen;
	
	float gLen = sqrt(downX*downX+downY*downY+downZ*downZ);
	float nGX = downX / gLen;
	float nGY = downY / gLen;
	
	dipLabel.text = [NSString stringWithFormat:@"%f",atan2(downZ,downLen)];
	
	arrow.transform = CGAffineTransformMakeRotation(angle);	
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}
@end
