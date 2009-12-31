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
	
	averaging_time = 0.5;
	
	accelerometer = [UIAccelerometer sharedAccelerometer];
	accelerometer.delegate = self;
	accelerometer.updateInterval = 0.1;
	
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	
	locationManager.headingFilter = kCLHeadingFilterNone;
	
	[locationManager startUpdatingHeading];
	[locationManager startUpdatingLocation];
	
	updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateView) userInfo:nil repeats:YES];
}

- (void)accelerometer:(UIAccelerometer *)acc didAccelerate:(UIAcceleration *)acceleration
{
	Vector3f d(acceleration.x,acceleration.y,acceleration.z);
	
	downV_unscaled += d;
	downVA.push(d);
	
	int targetN = averaging_time/accelerometer.updateInterval;
	while(downVA.size() > targetN)
	{
		downV_unscaled -= downVA.front();
		downVA.pop();
	}

	downV = downV_unscaled / downVA.size();
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)heading
{
	northV = Vector3f(heading.x,heading.y,heading.z);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	latitude = newLocation.coordinate.latitude;
	longitude = newLocation.coordinate.longitude;
}

- (IBAction)hold:(id)sender
{
	holdButton.selected = !holdButton.selected;
}

- (void)updateView
{
	if(holdButton.selected) return;
	
	const Vector3f dipV = Vector3f(downV.x,downV.y,0); // just remove Z component from 'down' to project into plane of phone
	
	// the angle (w.r.t. phone) of 'down', i.e. the angle for the arrow
	float angle = -atan2(dipV.y,dipV.x) + M_PI/2.;
	arrow.transform = CGAffineTransformMakeRotation(angle);

	dipLabel.text = [NSString stringWithFormat:@"%.1f",atan2(downV.z,dipV.length())*180./M_PI+90.];
	
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
		dipDirection += 2*M_PI;
	float strikeDirection = dipDirection*(180/M_PI) - 90.0;
	if(strikeDirection < 0)
		strikeDirection += 360;
	
	dipDirLabel.text = [NSString stringWithFormat:@"%.1f",dipDirection*(180/M_PI)];
	strikeLabel.text = [NSString stringWithFormat:@"%.1f",(strikeDirection)];
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
