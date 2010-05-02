//
//  GCDataPoint.h
//  GeoCompass
//
//  Created by Daniel Staudigel on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDataPoint : NSObject {
  unsigned int mIndex;
  NSDate * mDate;
  
  float mDipDir;
  float mDip;
  float mLatitude;
  float mLongitude;
  
  NSString * mIdentifier;
}
@property(readonly) unsigned int index;
@property(readonly) NSDate * date;

@property(assign) float dipDir;
@property(assign) float dip;
@property(assign) float latitude;
@property(assign) float longitude;

@property(retain) NSString * identifier;

+ (GCDataPoint*)createDataPoint;

- (NSString *)encodedString;


@end
