//
//  IMUploadModel.h
//  imat-sdk-ios
//
//  Created by imat on 5/16/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMUploadModel : NSObject

@property NSString* modelFileName;

@property NSString* modelId;

@property NSString* processingResult;

@property float surfaceCm2;

@property float volumeCm3;

@property NSString* toolId;

@property NSDate* uploadDate;

@property BOOL wasOrdered;

@property BOOL wasCanceled;

@property BOOL wasDeleted;

@property float xDimMm;

@property float yDimMm;

@property float zDimMm;


@end
