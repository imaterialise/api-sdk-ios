//
//  IMCartRequest.h
//  imat-sdk-ios
//
//  Created by imat on 5/23/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMShippingInfoRequest.h"
#import "IMBillingInfoRequest.h"

@interface IMCartRequest : NSObject

@property NSString* myCartReference;

@property NSString* currency;

@property NSString* iframeTheme;

@property NSString* returnUrl;

@property NSString* orderConfirmationUrl;

@property NSString* failureUrl;

@property NSString* promoCode;

@property NSArray* cartItems;

@property IMShippingInfoRequest* shippingInfo;

@property IMBillingInfoRequest* billingInfo;

@end
