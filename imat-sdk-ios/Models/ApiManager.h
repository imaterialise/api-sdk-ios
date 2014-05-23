//
//  ApiManager.h
//  api-sdk-ios
//
//  Created by imat on 5/8/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMModelRequest.h"
#import "IMModelResponse.h"
#import "IMUploadModelReportRequest.h"
#import "IMUploadModelReportResponse.h"
#import "IMParametersPricingRequest.h"
#import "IMParametersPricingResponse.h"
#import "IMCartItemRequest.h"
#import "IMCartItemModelRequest.h"
#import "IMCartItemResponse.h"
#import "IMCartItemModelResponse.h"
#import "IMError.h"
#import "IMCartRequest.h"
#import "IMCartItemCartRequest.h"
#import "IMShippingInfoRequest.h"
#import "IMBillingInfoRequest.h"
#import "IMCartResponse.h"

@interface ApiManager : NSObject

+ (NSString*) toolId;

+ (void) setup: (NSString*) siteUrl toolId: (NSString*) toolId apiCode: (NSString*) apiCode;

+ (ApiManager*) instance;

- (void) uploadModel: (IMModelRequest*) model
             success: (void(^)(IMModelResponse* modelReponse)) success
             failure: (void(^)(IMError* error)) failure;

- (void) getModelsReport: (IMUploadModelReportRequest*) request
                 success: (void(^)(IMUploadModelReportResponse* reponse)) success
                 failure: (void(^)(IMError* error)) failure;

- (void) getPrice: (IMParametersPricingRequest*) request
                 success: (void(^)(IMParametersPricingResponse* reponse)) success
                 failure: (void(^)(IMError* error)) failure;

- (void) registerCartItem: (IMCartItemRequest*) request
          success: (void(^)(IMCartItemResponse* reponse)) success
          failure: (void(^)(IMError* error)) failure;

- (void) registerCart: (IMCartRequest*) request
                  success: (void(^)(IMCartResponse* reponse)) success
                  failure: (void(^)(IMError* error)) failure;



@end
