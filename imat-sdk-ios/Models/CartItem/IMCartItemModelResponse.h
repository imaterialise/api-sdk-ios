//
//  IMCartItemModelResponse.h
//  imat-sdk-ios
//
//  Created by imat on 5/22/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMError.h"

@interface IMCartItemModelResponse : NSObject

@property NSString* toolId;

@property NSString* cartItemId;

@property IMError* cartItemError;

@property NSString* myCartItemReference;

@property NSString* modelId;

@property NSString* modelFileName;

@property float fileScaleFactor;

@property NSString* fileUnits;

@property NSString* uploadStatus;

@property NSString* materialId;

@property NSString* finishId;

@property int quantity;

@property float xDimMm;

@property float yDimMm;

@property float zDimMm;

@property float surfaceCm2;

@property float volumeCm3;

@property float iMatAPIPrice;

@property float mySalesPrice;

@property float mySalesUnitPrice;

@property float iMatPrice;

@property NSDate* validUntil;

@end
