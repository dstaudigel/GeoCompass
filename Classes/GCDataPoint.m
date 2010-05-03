//
//  GCDataPoint.m
//  GeoCompass
//
//  Created by Daniel Staudigel on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GCDataPoint.h"


@implementation GCDataPoint

- (NSString *)encodedString {
  NSDateFormatter * df = [[NSDateFormatter alloc] init];
  
  [df setTimeStyle:NSDateFormatterShortStyle];
  [df setDateStyle:NSDateFormatterShortStyle];
  
  return [NSString stringWithFormat:@"%4i : %3.0f/%2.0f @ (%2.4fN,%3.4fE) - %@",
	  self.index,
	  self.dipDir,
	  self.dip,
	  self.latitude,
	  self.longitude,
	  [df stringFromDate:self.date]];
}

@end
