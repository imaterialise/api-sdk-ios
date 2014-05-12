//
//  ApiManager.m
//  api-sdk-ios
//
//  Created by imat on 5/8/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import "ApiManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLRequestSerialization.h"

@interface ApiManager()

@property NSString* siteUrl;

@property NSString* toolId;

@property NSString* apiCode;

@end

@implementation ApiManager

@synthesize siteUrl = _siteUrl;

@synthesize apiCode = _apiCode;

@synthesize toolId = _toolId;



- (id) initWitSiteUrl: (NSString*) siteUrl toolId: (NSString*) toolId apiCode: (NSString*) apiCode
{
    self = [super init];
    if (self) {
        _siteUrl = siteUrl;
        _toolId = toolId;
        _apiCode = apiCode;
    }
    return self;
}

- (void) uploadModel: (IMModelRequest*) model
             success: (void(^)(IMModelResponse* modelReponse)) success
             failure: (void(^)(NSError* error)) failure
{
    NSString* uploadDroddleUrl = [NSString stringWithFormat:@"%@/web-api/tool/%@/model", self.siteUrl, self.toolId];
    
    
    AFHTTPRequestOperationManager* m = [AFHTTPRequestOperationManager manager];
    m.securityPolicy.allowInvalidCertificates = true;
    
    NSMutableURLRequest *request = [m.requestSerializer multipartFormRequestWithMethod:@"POST" URLString: uploadDroddleUrl parameters:nil constructingBodyWithBlock:^(id < AFMultipartFormData > formData) {

       
        [formData appendPartWithFileData:model.file.data name:@"file" fileName: model.file.name mimeType:model.file.mimeType];
        
        [formData appendPartWithFormData:[model.fileUnits dataUsingEncoding: NSUTF16StringEncoding] name:@"FileUnits"];
    } error: nil];
    
    AFHTTPRequestOperation *operation = [m HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject){

        IMModelResponse* response = [[IMModelResponse alloc] init];
        
        response.fileUnits = responseObject[@"fileUnits"];
        response.modelFileName = responseObject[@"modelFileName"];
        response.modelID = responseObject[@"modelID"];
        response.modelStatus = responseObject[@"modelStatus"];
        response.surfaceCm2 = ((NSNumber*)responseObject[@"surfaceCm2"]).floatValue;
        response.volumeCm3 = ((NSNumber*)responseObject[@"volumeCm3"]).floatValue;
        response.toolID = responseObject[@"toolID"];
        response.validUntil = [self convertToNSDate: ((NSString*)responseObject[@"validUntil"])];
        response.xDimMm = ((NSNumber*)responseObject[@"xDimMm"]).floatValue;
        response.yDimMm = ((NSNumber*)responseObject[@"yDimMm"]).floatValue;
        response.zDimMm = ((NSNumber*)responseObject[@"zDimMm"]).floatValue;

        success(response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error);
    }];
 
    [m.operationQueue addOperation:operation];
}

- (NSDate*) convertToNSDate: (NSString*) strDate
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSDate *date = [dateFormatter dateFromString:strDate];
    
    return date;
}

@end
