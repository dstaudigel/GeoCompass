//
//  ArrowViewController.m
//
//  Created by Daniel Staudigel on 12/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ArrowViewController.h"
#include "vmmlib.h"
#include "vector3.h"

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
	
	locationManager.headingFilter = kCLHeadingFilterNone;
	
	[locationManager startUpdatingHeading];
	[locationManager startUpdatingLocation];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	Vector3f d(acceleration.x,acceleration.y,acceleration.z);
	downVA.push_back(d);
	
	while(downVA.length() > averaging_time/accelerometer.updateInterval)
	{
		downVA.pop_front();
	}
	
	Vector3f down(0,0,0);
	
	queue<Vector3f>::const_iterator cii;
	for(cii=downVA.begin() ; cii!=downVA.end() ; cii++)
	{
		down += cii;
	}
	
	downV = down;
	
	[self updateView];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
	Vector3f n(northX,northY,northZ);
	
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
	
	const Vector3f dipV = Vector3f(downX,downY,0); // just remove Z component from 'down' to project into plane of phone
	
	// the angle (w.r.t. phone) of 'down', i.e. the angle for the arrow
	float angle = -atan2(dipV.y,dipV.x) + M_PI/2.;
	arrow.transform = CGAffineTransformMakeRotation(angle);

	dipLabel.text = [NSString stringWithFormat:@"%.1f",atan2(downZ,dipV.length())*180./M_PI+90.];
	
	// We must project both northV (north vector in phone coordinate system)
	// and dipV (dip vector in phone coordinate system) onto the plane of the earth,
	// by subtracting out their projections onto a normalized 'down' vector.
	
	const Vector3f n_downV = downV.getNormalized();
	
	//                     [ vector ] - [ projection of vector onto 'down' ]
	Vector3f hplane_dipV   = dipV     -   n_downV * ( n_downV.dot(dipV  ) );
	Vector3f hplane_northV = northV   -   n_downV * ( n_downV.dot(northV) );
	
	// normalize them
	
	hplane_dipV.normalize();
	hplane_northV.normalize();
	
	// Now that we have these two, take their cross product, whose magnitude is proportional to sin(theta), the angle between them
	
	Vector3f cp = hplane_dipV.cross(hplane_northV);
	float dp = hplane_dipV.dot(hplane_northV);
	
	float len = cp.length(); // get length of vector
	cp /= len; // normalize
	
	float dipDirection = acos(dp); // now we have the angle
	
	// now we want whether or not the cross product is in the same direction or the opposite of g, telling us the sign of the angle!
	
	dipDirection *= -(n_downV.dot(cp)); // since it'll be -1 or +1, this works out perfectly.
	
	if(dipDirection < 0)
		dipDirection += 360;
	
	azimuthLabel.text = [NSString stringWithFormat:@"%.1f",dipDirection*(180/M_PI)];
	
	latLabel.text = [NSString stringWithFormat:@"%3.5f",latitude];
	lonLabel.text= [NSString stringWithFormat:@"%3.5f",longitude];
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
