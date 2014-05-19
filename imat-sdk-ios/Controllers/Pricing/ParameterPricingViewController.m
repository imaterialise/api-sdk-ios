//
//  ParameterPricingViewController.m
//  imat-sdk-ios
//
//  Created by imat on 5/19/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import "ParameterPricingViewController.h"
#import "ApiManager.h"
#import "IMParametersPricingRequest.h"
#import "IMParametersPricingResponse.h"
#import "MBProgressHUD.h"
#import "IMPricingModel.h"
#import "IMPricingShipment.h"
#import "ParameterPricingResultViewController.h"

@interface ParameterPricingViewController ()
{
    MBProgressHUD* hud;
}

@property (weak, nonatomic) IBOutlet UITextField *quantityTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *referenceTextField;
@property (weak, nonatomic) IBOutlet UITextField *xDimTextField;
@property (weak, nonatomic) IBOutlet UITextField *yDimTextField;
@property (weak, nonatomic) IBOutlet UITextField *zDimTextField;
@property (weak, nonatomic) IBOutlet UITextField *surfaceTextField;
@property (weak, nonatomic) IBOutlet UITextField *volumeTextField;
@end

@implementation ParameterPricingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Calculate price";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard
{
    [self.quantityTextFeild resignFirstResponder];
    [self.referenceTextField resignFirstResponder];
    [self.xDimTextField resignFirstResponder];
    [self.yDimTextField resignFirstResponder];
    [self.zDimTextField resignFirstResponder];
    [self.surfaceTextField resignFirstResponder];
    [self.volumeTextField resignFirstResponder];
}

- (IBAction)sendButtonTouched:(id)sender
{
    ((UIButton*)sender).enabled = false;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    IMParametersPricingRequest* request = [[IMParametersPricingRequest alloc] init];
    NSMutableArray* models = [[NSMutableArray alloc] init];
    request.currency = @"EUR";
    
    IMPricingModel* pricingModel = [[IMPricingModel alloc] init];
    pricingModel.materialId = @"035f4772-da8a-400b-8be4-2dd344b28ddb"; // get it from materials API
    pricingModel.finishId = @"bba2bebb-8895-4049-aeb0-ab651cee2597"; // get it from materials API
    pricingModel.quantity = [self.quantityTextFeild.text intValue];
    pricingModel.modelReference = self.referenceTextField.text;
    pricingModel.xDimMm = [self.xDimTextField.text floatValue];
    pricingModel.yDimMm = [self.yDimTextField.text floatValue];
    pricingModel.zDimMm = [self.zDimTextField.text floatValue];
    pricingModel.surfaceCm2 = [self.surfaceTextField.text floatValue];
    pricingModel.volumeCm3 = [self.volumeTextField.text floatValue];
    pricingModel.toolId = [ApiManager toolId];
    [models addObject: pricingModel];
    request.models = models;
    
    IMPricingShipment* shipment = [[IMPricingShipment alloc] init];
    shipment.countryCode = @"BE";
    shipment.stateCode = @"";
    shipment.city = @"Leuven";
    shipment.zipCode = @"3001";
    request.shipment = shipment;
    
    
    ApiManager* apiManager = [ApiManager instance];
    [apiManager getPrice:request success: ^(IMParametersPricingResponse* response)
     {
         //TODO: check for errors
         //response.error
         //response.shipmentCost.shipmentError
         
         
         ParameterPricingResultViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier: @"ParameterPricingResultViewController"];
         controller.response = response;
         
         [self.navigationController pushViewController:controller animated:true];
         
         ((UIButton*)sender).enabled = true;
         [hud hide:true];
         
         
     } failure: ^(NSError* error)
     {
         ((UIButton*)sender).enabled = true;
         [hud hide:true];
         
         UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Erorr"
                                                           message: [error description]
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
         
         [message show];
         
     }];
}

@end
