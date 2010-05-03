//
//  GCDataPoint.h
//  GeoCompass
//
//  Created by Daniel Staudigel on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDataPoint : NSManagedObject {

}

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * dip;
@property (nonatomic, retain) NSNumber * dipDir;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

+ (GCDataPoint *)newDataPointInDefaultContext;

- (NSString *)encodedString;

@end

  // coalesce these into one @interface GCDataPoint (CoreDataGeneratedAccessors) section
@interface GCDataPoint (CoreDataGeneratedAccessors)
@end