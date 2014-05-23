//
//  IMCartItemResponse.h
//  imat-sdk-ios
//
//  Created by imat on 5/22/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMError.h"


@interface IMCartItemResponse : NSObject

@property NSString* currency;

@property float uploadTimeMs;

@property float processingTimeMs;

@property float responseSentUnixTimestampUtcMs;

@property NSArray* cartItems;

@property IMError* error;

@end
