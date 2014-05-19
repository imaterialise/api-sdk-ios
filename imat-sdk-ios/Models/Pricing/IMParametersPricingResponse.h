//
//  IMParametersPricingResponse.h
//  imat-sdk-ios
//
//  Created by imat on 5/19/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMPricingShipmentService.h"
#import "IMPricingShipmentCost.h"
#import "IMError.h"

@interface IMParametersPricingResponse : NSObject

@property NSArray* models;

@property NSString* disclaimer;

@property NSString* currency;

@property IMPricingShipmentCost* shipmentCost;

@property IMError* error;

@end
