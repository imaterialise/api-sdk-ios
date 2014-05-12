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

@interface ApiManager : NSObject

- (id) initWitSiteUrl: (NSString*) siteUrl toolId: (NSString*) toolId apiCode: (NSString*) apiCode;

- (void) uploadModel: (IMModelRequest*) model
             success: (void(^)(IMModelResponse* modelReponse)) success
             failure: (void(^)(NSError* error)) failure;

@end
