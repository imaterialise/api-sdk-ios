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

@interface ApiManager : NSObject

+ (void) setup: (NSString*) siteUrl toolId: (NSString*) toolId apiCode: (NSString*) apiCode;

+ (ApiManager*) instance;

- (void) uploadModel: (IMModelRequest*) model
             success: (void(^)(IMModelResponse* modelReponse)) success
             failure: (void(^)(NSError* error)) failure;

- (void) getModelsReport: (IMUploadModelReportRequest*) request
                 success: (void(^)(IMUploadModelReportResponse* reponse)) success
                 failure: (void(^)(NSError* error)) failure;


@end
