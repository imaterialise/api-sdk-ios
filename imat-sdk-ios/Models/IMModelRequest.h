//
//  IMModel.h
//  api-sdk-ios
//
//  Created by imat on 5/8/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMFile.h"

@interface IMModelRequest : NSObject

@property IMFile* file;

@property NSString* fileUrl;

@property NSString* fileUnits;

@end
