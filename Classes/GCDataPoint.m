//
//  GCDataPoint.m
//  GeoCompass
//
//  Created by Daniel Staudigel on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GCDataPoint.h"


@implementation GCDataPoint
@synthesize index=mIndex;
@synthesize date=mDate;
@synthesize dipDir=mDipDir;
@synthesize dip=mDip;
@synthesize latitude=mLatitude;
@synthesize longitude=mLognitude;
@synthesize identifier=mIdentifier;

+ (GCDataPoint*)createDataPoint {
  GCDataPoint * ret = [[self alloc] init];
  
  
  
  return [ret autorelease];
}

- (id)init {
  if(self = [super init]) {
    mDate = [NSDate date];
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    
    mIndex = [ud integerForKey:@"index"]+1;
    [ud setInteger:mIndex
	    forKey:@"index"];
  }
  return self;
}

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
