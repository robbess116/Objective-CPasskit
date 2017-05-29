//
//  PlaceMark.m
//  iTransitBuddy
//
//  Created by Blue Technology Solutions LLC 09/09/2008.
//  Copyright 2010 Blue Technology Solutions LLC. All rights reserved.
//

#import "PlaceMark.h"


@implementation PlaceMark

@synthesize coordinate;
@synthesize place;

-(id) initWithPlace: (Place*) p
{
	self = [super init];
	if (self != nil) {
		coordinate.latitude = p.latitude;
		coordinate.longitude = p.longitude;
		self.place = p;
        self.isMain = p.isMain;
        self.ratingValue = p.ratingValue;
	}
	return self;
}

- (NSString *)subtitle
{
	return self.place.resDistance;
}
- (NSString *)title
{
	return self.place.resTitle;
}


@end
