//
//  IMCartItemModelRequest.h
//  imat-sdk-ios
//
//  Created by imat on 5/22/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMFile.h"

@interface IMCartItemModelRequest : NSObject

@property NSString* toolId;

@property NSString* myCartItemReference;

@property NSString* modelID;

@property float fileScaleFactor;

@property NSString* fileUnits;

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

@property IMFile* file;

@end
