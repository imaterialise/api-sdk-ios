//
//  IMPricingModel.h
//  imat-sdk-ios
//
//  Created by imat on 5/19/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMPricingModel : NSObject

@property NSString* toolId;

@property NSString* modelReference;

@property NSString* materialId;

@property NSString* finishId;

@property int quantity;


@property float xDimMm;

@property float yDimMm;

@property float zDimMm;


@property float surfaceCm2;

@property float volumeCm3;

@end
