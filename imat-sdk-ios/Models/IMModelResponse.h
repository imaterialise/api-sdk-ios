//
//  IMModelResponse.h
//  api-sdk-ios
//
//  Created by imat on 5/8/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMModelResponse : NSObject

@property NSString* fileUnits;

@property NSString* modelFileName;

@property NSString* modelID;

@property NSString* modelStatus;

@property float surfaceCm2;

@property float volumeCm3;

@property NSString* toolID;

@property NSDate* validUntil;

@property float xDimMm;

@property float yDimMm;

@property float zDimMm;

@end
