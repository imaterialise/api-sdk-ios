//
//  UploadModelReportRequest.h
//  imat-sdk-ios
//
//  Created by imat on 5/16/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMUploadModelReportRequest : NSObject

@property NSDate* dateFrom;

@property NSDate* dateTo;

@property NSString* modelId;

@property NSString* toolId;

@end
