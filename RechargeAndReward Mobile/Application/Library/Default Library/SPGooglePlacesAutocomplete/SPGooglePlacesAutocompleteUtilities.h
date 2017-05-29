//
//  SPGooglePlacesAutocompleteUtilities.h
//  SPGooglePlacesAutocomplete
//
//  Created by Stephen Poletto on 7/18/12.
//  Copyright (c) 2012 Stephen Poletto. All rights reserved.
//

#define kGoogleAPIKey @"AIzaSyDXpe-cekg11fYFcEBHze1hfZ0JyUsV5h0"

#define kGoogleAPINSErrorCode 42

@class CLPlacemark;

typedef enum {
    SPPlaceTypeInvalid = -1,
    SPPlaceTypeGeocode = 0,
    SPPlaceTypeEstablishment
} SPGooglePlacesAutocompletePlaceType;

typedef void (^SPGooglePlacesPlacemarkResultBlock)(CLPlacemark *placemark, NSString *addressString, NSError *error);
typedef void (^SPGooglePlacesAutocompleteResultBlock)(NSArray *places, NSError *error);
typedef void (^SPGooglePlacesPlaceDetailResultBlock)(NSDictionary *placeDictionary, NSError *error);

extern SPGooglePlacesAutocompletePlaceType SPPlaceTypeFromDictionary(NSDictionary *placeDictionary);
extern NSString *SPBooleanStringForBool(BOOL boolean);
extern NSString *SPPlaceTypeStringForPlaceType(SPGooglePlacesAutocompletePlaceType type);
extern BOOL SPIsEmptyString(NSString *string);

@interface NSArray(SPFoundationAdditions)
- (id)onlyObject;
@end