//
//  Place.h
//  iTransitBuddy
//
//  Created by Blue Technology Solutions LLC 09/09/2008.
//  Copyright 2010 Blue Technology Solutions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Place : NSObject {

}

@property (nonatomic, retain) NSString* resTitle;
@property (nonatomic, retain) NSString* resDistance;
@property (nonatomic) int isMain;
@property (nonatomic) int ratingValue;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@end
