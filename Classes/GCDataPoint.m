//
//  GCDataPoint.m
//  GeoCompass
//
//  Created by Daniel Staudigel on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GCDataPoint.h"


@implementation GCDataPoint

@dynamic date;
@dynamic dip;
@dynamic dipDir;
@dynamic latitude;
@dynamic longitude;

+ (GCDataPoint *)newDataPointInDefaultContext {
  return [NSEntityDescription insertNewObjectForEntityForName:@"compassDataPoint"
				       inManagedObjectContext:[[[UIApplication sharedApplication] delegate] managedObjectContext]];
}

- (NSString *)encodedString {
  NSDateFormatter * df = [[NSDateFormatter alloc] init];
  
  [df setTimeStyle:NSDateFormatterShortStyle];
  [df setDateStyle:NSDateFormatterShortStyle];
  
  NSLog(@"index: %i",self.index);
  Log(@"Date: %@",self.date);
  
  return [NSString stringWithFormat:@"%.4i : %3.0f/%2.0f @ (%2.4fN,%3.4fE) - %@",
	  [self.dipDir floatValue],
	  [self.dip floatValue],
	  [self.latitude floatValue],
	  [self.longitude floatValue],
	  [df stringFromDate:self.date]];
}

@end

