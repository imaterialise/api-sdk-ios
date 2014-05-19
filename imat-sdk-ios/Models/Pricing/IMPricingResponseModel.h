//
//  IMPricingResponseModel.h
//  imat-sdk-ios
//
//  Created by imat on 5/19/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMPricingResponseModel : NSObject

@property NSString* toolId;

@property NSString* modelReference;

@property NSString* materialId;

@property NSString* materialName;

@property NSString* finishId;

@property NSString* finishingName;

@property int quantity;

@property float totalPrice;


@property float xDimMm;

@property float yDimMm;

@property float zDimMm;


@property float surfaceCm2;

@property float volumeCm3;


@end
