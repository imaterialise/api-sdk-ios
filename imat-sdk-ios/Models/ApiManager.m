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
#import "IMUploadModel.h"
#import "IMPricingResponseModel.h"
#import "IMError.h"

@interface ApiManager()



@end

@implementation ApiManager


static NSString* toolId;
static NSString* apiCode;
static NSString* siteUrl;

+ (NSString*) siteUrl
{
    @synchronized(self) { return siteUrl; }
}

+ (void) setSiteUrl:(NSString*)val
{
    @synchronized(self) { siteUrl = val; }
}


+ (NSString*) apiCode
{
    @synchronized(self) { return apiCode; }
}

+ (void) setApiCode:(NSString*)val
{
    @synchronized(self) { apiCode = val; }
}

+ (NSString*) toolId
{
    @synchronized(self) { return toolId; }
}

+ (void) setToolId:(NSString*)val
{
    @synchronized(self) { toolId = val; }
}


+ (ApiManager*) instance
{
    return [[ApiManager alloc] init];
}

+ (void) setup: (NSString*) siteUrl toolId: (NSString*) toolId apiCode: (NSString*) apiCode
{
    [ApiManager setSiteUrl: siteUrl];
    [ApiManager setToolId: toolId];
    [ApiManager setApiCode:apiCode];
}

- (void) uploadModel: (IMModelRequest*) model
             success: (void(^)(IMModelResponse* modelReponse)) success
             failure: (void(^)(IMError* error)) failure
{
    NSString* url = [NSString stringWithFormat:@"%@/web-api/tool/%@/model", [ApiManager siteUrl], [ApiManager toolId]];
    
    
    AFHTTPRequestOperationManager* m = [AFHTTPRequestOperationManager manager];
    m.securityPolicy.allowInvalidCertificates = true;
    
    NSMutableURLRequest *request = [m.requestSerializer multipartFormRequestWithMethod:@"POST" URLString: url parameters:nil constructingBodyWithBlock:^(id < AFMultipartFormData > formData) {

       
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
        response.validUntil = [self convertToNSDateUtc: ((NSString*)responseObject[@"validUntil"])];
        response.xDimMm = ((NSNumber*)responseObject[@"xDimMm"]).floatValue;
        response.yDimMm = ((NSNumber*)responseObject[@"yDimMm"]).floatValue;
        response.zDimMm = ((NSNumber*)responseObject[@"zDimMm"]).floatValue;

        success(response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        IMError* e = [[IMError alloc] init];
        e.code = error.code;
        e.message = [error description];
        failure(e);
    }];
 
    [m.operationQueue addOperation:operation];
}



- (void) getModelsReport: (IMUploadModelReportRequest*) request
             success: (void(^)(IMUploadModelReportResponse* reponse)) success
             failure: (void(^)(IMError* error)) failure
{
    NSString* url = [NSString stringWithFormat:@"%@/web-api/reporting/models/uploaded", [ApiManager siteUrl]];
    
    AFHTTPRequestOperationManager* m = [AFHTTPRequestOperationManager manager];
    m.securityPolicy.allowInvalidCertificates = true;
    m.requestSerializer = [AFJSONRequestSerializer serializer];
    m.responseSerializer = [AFJSONResponseSerializer serializer];
    [m.requestSerializer setValue: [ApiManager apiCode] forHTTPHeaderField: @"ApiCode"];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSString* dateFrom = [dateFormatter stringFromDate: request.dateFrom];
    NSString* dateTo = [dateFormatter stringFromDate: request.dateTo];

    [m POST: url parameters: @{ @"dateFrom":    dateFrom,
                                         @"dateTo":   dateTo,
                                         @"toolId": request.toolId,
                                         @"ModelId":    request.modelId }
     
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {

                       IMUploadModelReportResponse* response = [[IMUploadModelReportResponse alloc] init];
                       
                       response.toolId = responseObject[@"toolId"];
                       response.modelId = responseObject[@"modelId"];
                       response.dateFrom = [self convertToNSDateShort: ((NSString*)responseObject[@"dateFrom"])];
                       response.dateTo = [self convertToNSDateShort: ((NSString*)responseObject[@"dateTo"])];
                       
                       
                       NSMutableArray* models = [[NSMutableArray alloc]init];
                       
                       for (NSDictionary* json in responseObject[@"models"])
                       {
                           IMUploadModel* model = [[IMUploadModel alloc] init];
                           model.modelFileName = json[@"modelFileName"];
                           model.modelId = json[@"modelId"];
                           model.processingResult = json[@"processingResult"];
                           model.surfaceCm2 = ((NSNumber*)json[@"surfaceCm2"]).floatValue;
                           model.volumeCm3 = ((NSNumber*)json[@"volumeCm3"]).floatValue;
                           model.toolId = json[@"toolId"];
                           model.uploadDate = [self convertToNSDate: ((NSString*)json[@"uploadDate"])];

                           model.wasCanceled = ((NSNumber*)json[@"wasCanceled"]).boolValue;
                           model.wasDeleted = ((NSNumber*)json[@"wasDeleted"]).boolValue;
                           model.wasOrdered = ((NSNumber*)json[@"wasOrdered"]).boolValue;
                           
                           model.xDimMm = ((NSNumber*)json[@"xDimMm"]).floatValue;
                           model.yDimMm = ((NSNumber*)json[@"yDimMm"]).floatValue;
                           model.zDimMm = ((NSNumber*)json[@"zDimMm"]).floatValue;
                           
                           [models addObject:model];
                       }
                       
                       response.models = models;
                       
                       success(response);
                   }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       IMError* e = [[IMError alloc] init];
                       e.code = error.code;
                       e.message = [error description];
                       failure(e);
                   }
    ];
}


- (void) getPrice: (IMParametersPricingRequest*) request
          success: (void(^)(IMParametersPricingResponse* reponse)) success
          failure: (void(^)(IMError* error)) failure
{
    NSString* url = [NSString stringWithFormat:@"%@/web-api/pricing", [ApiManager siteUrl]];
    
    AFHTTPRequestOperationManager* m = [AFHTTPRequestOperationManager manager];
    m.securityPolicy.allowInvalidCertificates = true;
    m.requestSerializer = [AFJSONRequestSerializer serializer];
    m.responseSerializer = [AFJSONResponseSerializer serializer];
    [m.requestSerializer setValue: [ApiManager apiCode] forHTTPHeaderField: @"ApiCode"];

    NSMutableDictionary* pricingRequestJson = [[NSMutableDictionary alloc] init];

    NSMutableDictionary* shippingJson = [[NSMutableDictionary alloc] init];
    [shippingJson setValue:request.shipment.countryCode forKey:@"countryCode"];
    [shippingJson setValue:request.shipment.stateCode forKey:@"stateCode"];
    [shippingJson setValue:request.shipment.city forKey:@"city"];
    [shippingJson setValue:request.shipment.zipCode forKey:@"zipCode"];
    
    NSMutableArray* models = [[NSMutableArray alloc] init];
    for (IMPricingModel* model in request.models)
    {
        NSMutableDictionary* modelJson = [[NSMutableDictionary alloc] init];
        [modelJson setValue:model.toolId forKey:@"toolID"];
        [modelJson setValue:model.modelReference forKey:@"modelReference"];
        [modelJson setValue:model.materialId forKey:@"materialID"];
        [modelJson setValue:model.finishId forKey:@"finishID"];
        [modelJson setValue: [NSNumber numberWithInt: model.quantity] forKey:@"quantity"];
        
        [modelJson setValue: [NSNumber numberWithFloat: model.xDimMm] forKey:@"xDimMm"];
        [modelJson setValue: [NSNumber numberWithFloat: model.yDimMm] forKey:@"yDimMm"];
        [modelJson setValue: [NSNumber numberWithFloat: model.zDimMm] forKey:@"zDimMm"];
        
        [modelJson setValue: [NSNumber numberWithFloat: model.volumeCm3] forKey:@"volumeCm3"];
        [modelJson setValue: [NSNumber numberWithFloat: model.surfaceCm2] forKey:@"surfaceCm2"];
        
        [models addObject:modelJson];
    }
    
    [pricingRequestJson setValue:models forKey:@"models"];
    [pricingRequestJson setValue:shippingJson forKey:@"shipmentInfo"];
    [pricingRequestJson setValue:request.currency forKey:@"currency"];
 
    
    
    
    [m POST: url parameters: pricingRequestJson success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        IMParametersPricingResponse * response = [[IMParametersPricingResponse alloc] init];
        
        NSDictionary* errorJson = [responseObject objectForKey:@"error"];
        if(errorJson != nil)
        {
            IMError* error = [[IMError alloc] init];
            error.code = ((NSNumber*)errorJson[@"code"]).intValue;
            error.message = errorJson[@"message"];
            response.error = error;
            
            failure(error);
            return;
        }

        
        response.disclaimer = responseObject[@"disclaimer"];
        response.currency = responseObject[@"currency"];
        
        NSMutableArray* models = [[NSMutableArray alloc]init];
        
        for (NSDictionary* json in responseObject[@"models"])
        {
            IMPricingResponseModel* model = [[IMPricingResponseModel alloc] init];
            model.toolId = json[@"toolID"];
            model.modelReference = json[@"modelReference"];
            model.materialId = json[@"materialID"];
            model.materialName = json[@"materialName"];
            model.finishId = json[@"finishID"];
            model.finishingName = json[@"finishingName"];
            model.surfaceCm2 = ((NSNumber*)json[@"surfaceCm2"]).floatValue;
            model.volumeCm3 = ((NSNumber*)json[@"volumeCm3"]).floatValue;
            
            model.quantity = ((NSNumber*)json[@"quantity"]).intValue;
            model.totalPrice = ((NSNumber*)json[@"totalPrice"]).floatValue;
            
            model.xDimMm = ((NSNumber*)json[@"xDimMm"]).floatValue;
            model.yDimMm = ((NSNumber*)json[@"yDimMm"]).floatValue;
            model.zDimMm = ((NSNumber*)json[@"zDimMm"]).floatValue;
            
            [models addObject:model];
        }
        
        response.models = models;
        
        IMPricingShipmentCost* shipmentCost = [[IMPricingShipmentCost alloc] init];
        
        NSMutableArray* shipmentServices = [[NSMutableArray alloc] init];

        NSString* shipmentError = [[responseObject objectForKey:@"shipmentCost"] objectForKey:@"shipmentError"];
        
        if(shipmentError != nil)
        {
            shipmentCost.shipmentError = shipmentError;
        }
        else
        {
            for (NSDictionary* json in responseObject[@"shipmentCost"][@"services"])
            {
                IMPricingShipmentService* shipmentService = [[IMPricingShipmentService alloc] init];
                shipmentService.daysInTransit = ((NSNumber*)json[@"daysInTransit"]).intValue;
                shipmentService.name = json[@"name"];
                shipmentService.value = ((NSNumber*)json[@"value"]).floatValue;
            
                [shipmentServices addObject: shipmentService];
            }
            shipmentCost.services = shipmentServices;
        }
        
        response.shipmentCost = shipmentCost;
        
        success(response);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        IMError* e = [[IMError alloc] init];
        e.code = error.code;
        e.message = [error description];
        failure(e);
    }];
}



- (void) registerCartItem: (IMCartItemRequest*) request
                  success: (void(^)(IMCartItemResponse* reponse)) success
                  failure: (void(^)(IMError* error)) failure
{
    NSString* url = [NSString stringWithFormat:@"%@/web-api/cartitems/register", [ApiManager siteUrl]];
    
    AFHTTPRequestOperationManager* m = [AFHTTPRequestOperationManager manager];
    m.securityPolicy.allowInvalidCertificates = true;
    m.requestSerializer = [AFJSONRequestSerializer serializer];
    m.responseSerializer = [AFJSONResponseSerializer serializer];
    [m.requestSerializer setValue: [ApiManager apiCode] forHTTPHeaderField: @"ApiCode"];
    
    NSMutableURLRequest *urlRequest = [m.requestSerializer multipartFormRequestWithMethod:@"POST" URLString: url parameters:nil constructingBodyWithBlock:^(id < AFMultipartFormData > formData) {
        
        NSMutableDictionary* cartItemRequestJson = [[NSMutableDictionary alloc] init];
        NSMutableArray* cartItems = [[NSMutableArray alloc] init];

        int fileNumber = 0;
        for (IMCartItemModelRequest* cartItem in request.cartItems)
        {
                NSMutableDictionary* modelJson = [[NSMutableDictionary alloc] init];
                [modelJson setValue: cartItem.toolId forKey:@"toolID"];
                [modelJson setValue: cartItem.myCartItemReference forKey:@"myCartItemReference"];
                [modelJson setValue: cartItem.modelID forKey:@"modelID"];
                [modelJson setValue: [NSNumber numberWithFloat: cartItem.fileScaleFactor] forKey:@"fileScaleFactor"];
                [modelJson setValue: cartItem.fileUnits forKey:@"fileUnits"];
                [modelJson setValue: cartItem.materialId forKey:@"materialID"];
                [modelJson setValue: cartItem.finishId forKey:@"finishID"];
                [modelJson setValue: [NSNumber numberWithInt: cartItem.quantity] forKey:@"quantity"];
                [modelJson setValue: [NSNumber numberWithFloat: cartItem.xDimMm] forKey:@"xDimMm"];
                [modelJson setValue: [NSNumber numberWithFloat: cartItem.yDimMm] forKey:@"yDimMm"];
                [modelJson setValue: [NSNumber numberWithFloat: cartItem.zDimMm] forKey:@"zDimMm"];
                [modelJson setValue: [NSNumber numberWithFloat: cartItem.volumeCm3] forKey:@"volumeCm3"];
                [modelJson setValue: [NSNumber numberWithFloat: cartItem.surfaceCm2] forKey:@"surfaceCm2"];
                [modelJson setValue: [NSNumber numberWithFloat: cartItem.iMatAPIPrice] forKey:@"iMatAPIPrice"];
                [modelJson setValue: [NSNumber numberWithFloat: cartItem.mySalesPrice] forKey:@"mySalesPrice"];
            
            if(cartItem.file != NULL)
            {
                [modelJson setValue: cartItem.file.name forKey:@"modelFileName"];
                [formData appendPartWithFileData: cartItem.file.data name: [NSString stringWithFormat:@"file[%d]", fileNumber] fileName: cartItem.file.name mimeType: cartItem.file.mimeType];
                fileNumber++;
            }
            
            [cartItems addObject:modelJson];
        }
        
        [cartItemRequestJson setValue:cartItems forKey:@"cartItems"];
        [cartItemRequestJson setValue:request.currency forKey:@"currency"];
        
        [formData appendPartWithFormData:[[self serializeDictionary: cartItemRequestJson] dataUsingEncoding: NSUTF16StringEncoding] name:@"request" contentType: @"application/json"];
        
    } error: nil];
    
    AFHTTPRequestOperation *operation = [m HTTPRequestOperationWithRequest:urlRequest success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        IMCartItemResponse * response = [[IMCartItemResponse alloc] init];
        
        NSDictionary* errorJson = [responseObject objectForKey:@"error"];
        if(errorJson != nil)
        {
            IMError* error = [[IMError alloc] init];
            error.code = ((NSNumber*)errorJson[@"code"]).intValue;
            error.message = errorJson[@"message"];
            response.error = error;
            
            return failure(error);
        }
        
        response.currency = responseObject[@"currency"];
        
        NSMutableArray* cartItems = [[NSMutableArray alloc]init];
        
        for (NSDictionary* json in responseObject[@"cartItems"])
        {
            IMCartItemModelResponse* carItem = [[IMCartItemModelResponse alloc] init];
            carItem.cartItemId = json[@"cartItemID"];
            carItem.toolId = json[@"toolID"];
            carItem.modelId = json[@"modelID"];
            carItem.modelFileName = json[@"modelFileName"];
            carItem.myCartItemReference = json[@"myCartItemReference"];
            carItem.materialId = json[@"materialID"];
            carItem.finishId = json[@"finishID"];
            carItem.surfaceCm2 = ((NSNumber*)json[@"surfaceCm2"]).floatValue;
            carItem.volumeCm3 = ((NSNumber*)json[@"volumeCm3"]).floatValue;
            
            carItem.fileUnits = json[@"fileUnits"];
            carItem.fileScaleFactor = ((NSNumber*)json[@"fileScaleFactor"]).floatValue;
            
            carItem.quantity = ((NSNumber*)json[@"quantity"]).intValue;
            carItem.iMatAPIPrice = ((NSNumber*)json[@"iMatAPIPrice"]).floatValue;
            carItem.iMatPrice = ((NSNumber*)json[@"iMatPrice"]).floatValue;
            carItem.mySalesPrice = ((NSNumber*)json[@"mySalesPrice"]).floatValue;
            carItem.mySalesUnitPrice = ((NSNumber*)json[@"mySalesUnitPrice"]).floatValue;
            
            carItem.xDimMm = ((NSNumber*)json[@"xDimMm"]).floatValue;
            carItem.yDimMm = ((NSNumber*)json[@"yDimMm"]).floatValue;
            carItem.zDimMm = ((NSNumber*)json[@"zDimMm"]).floatValue;
            
            carItem.validUntil = [self convertToNSDate: ((NSString*)json[@"validUntil"])];
            
            [cartItems addObject:carItem];
        }
        
        response.cartItems = cartItems;
        
        success(response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        IMError* e = [[IMError alloc] init];
        e.code = error.code;
        e.message = [error description];
        failure(e);
    }];
    
    [m.operationQueue addOperation:operation];
}


- (void) registerCart: (IMCartRequest*) request
              success: (void(^)(IMCartResponse* reponse)) success
              failure: (void(^)(IMError* error)) failure
{
    NSString* url = [NSString stringWithFormat:@"%@/web-api/cart/post", [ApiManager siteUrl]];
    
    AFHTTPRequestOperationManager* m = [AFHTTPRequestOperationManager manager];
    m.securityPolicy.allowInvalidCertificates = true;
    m.requestSerializer = [AFJSONRequestSerializer serializer];
    m.responseSerializer = [AFJSONResponseSerializer serializer];
    [m.requestSerializer setValue: [ApiManager apiCode] forHTTPHeaderField: @"ApiCode"];
    

    
    NSMutableDictionary* cartRequestJson = [[NSMutableDictionary alloc] init];
    NSMutableArray* cartItems = [[NSMutableArray alloc] init];
    
    for (IMCartItemCartRequest* cartItem in request.cartItems)
    {
        NSMutableDictionary* modelJson = [[NSMutableDictionary alloc] init];
        [modelJson setValue: cartItem.cartItemId forKey:@"cartItemID"];
        [cartItems addObject:modelJson];
    }
    
    [cartRequestJson setValue:cartItems forKey:@"cartItems"];
    [cartRequestJson setValue:request.currency forKey:@"myCartReference"];
    [cartRequestJson setValue:request.currency forKey:@"currency"];
    [cartRequestJson setValue:request.currency forKey:@"iframeTheme"];
    [cartRequestJson setValue:request.currency forKey:@"returnUrl"];
    [cartRequestJson setValue:request.currency forKey:@"orderConfirmationUrl"];
    [cartRequestJson setValue:request.currency forKey:@"failureUrl"];
    [cartRequestJson setValue:request.currency forKey:@"promoCode"];
    
    NSMutableDictionary* shippingInfoRequestJson = [[NSMutableDictionary alloc] init];
    [shippingInfoRequestJson setValue: request.shippingInfo.firstName forKey:@"firstName"];
    [shippingInfoRequestJson setValue: request.shippingInfo.lastName forKey:@"lastName"];
    [shippingInfoRequestJson setValue: request.shippingInfo.email forKey:@"email"];
    [shippingInfoRequestJson setValue: request.shippingInfo.phone forKey:@"phone"];
    [shippingInfoRequestJson setValue: request.shippingInfo.company forKey:@"company"];
    [shippingInfoRequestJson setValue: request.shippingInfo.line1 forKey:@"line1"];
    [shippingInfoRequestJson setValue: request.shippingInfo.line2 forKey:@"line2"];
    [shippingInfoRequestJson setValue: request.shippingInfo.countryCode forKey:@"countryCode"];
    [shippingInfoRequestJson setValue: request.shippingInfo.stateCode forKey:@"stateCode"];
    [shippingInfoRequestJson setValue: request.shippingInfo.zipCode forKey:@"zipCode"];
    [shippingInfoRequestJson setValue: request.shippingInfo.city forKey:@"city"];
    
    [cartRequestJson setValue: shippingInfoRequestJson forKey:@"shippingInfo"];
    
    NSMutableDictionary* billingInfoRequestJson = [[NSMutableDictionary alloc] init];
    [billingInfoRequestJson setValue: request.shippingInfo.firstName forKey:@"firstName"];
    [billingInfoRequestJson setValue: request.shippingInfo.lastName forKey:@"lastName"];
    [billingInfoRequestJson setValue: request.shippingInfo.email forKey:@"email"];
    [billingInfoRequestJson setValue: request.shippingInfo.phone forKey:@"phone"];
    [billingInfoRequestJson setValue: request.shippingInfo.company forKey:@"company"];
    [billingInfoRequestJson setValue: request.shippingInfo.line1 forKey:@"line1"];
    [billingInfoRequestJson setValue: request.shippingInfo.line2 forKey:@"line2"];
    [billingInfoRequestJson setValue: request.shippingInfo.countryCode forKey:@"countryCode"];
    [billingInfoRequestJson setValue: request.shippingInfo.stateCode forKey:@"stateCode"];
    [billingInfoRequestJson setValue: request.shippingInfo.zipCode forKey:@"zipCode"];
    [billingInfoRequestJson setValue: request.shippingInfo.city forKey:@"city"];
    [billingInfoRequestJson setValue: request.shippingInfo.vatNumber forKey:@"vatNumber"];
    
    [cartRequestJson setValue: billingInfoRequestJson forKey:@"billingInfo"];
    
    
    [m POST: url parameters: cartRequestJson success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        success(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        IMError* e = [[IMError alloc] init];
        e.code = error.code;
        e.message = [error description];
        failure(e);
    }];
}









- (NSDate*) convertToNSDateShort: (NSString*) strDate
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:strDate];
    
    return date;
}

- (NSDate*) convertToNSDate: (NSString*) strDate
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate *date = [dateFormatter dateFromString:strDate];
    
    return date;
}

- (NSDate*) convertToNSDateUtc: (NSString*) strDate
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSDate *date = [dateFormatter dateFromString:strDate];
    
    return date;
}

-(NSString*) serializeDictionary:(id)object
{
    NSError *writeError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&writeError];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    return jsonString;
}

@end
