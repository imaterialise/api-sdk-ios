//
//  IMParametersPricingRequest.h
//  imat-sdk-ios
//
//  Created by imat on 5/19/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMPricingModel.h"
#import "IMPricingShipment.h"

@interface IMParametersPricingRequest : NSObject

@property NSArray* models;

@property IMPricingShipment* shipment;

@property NSString* currency;


@end
