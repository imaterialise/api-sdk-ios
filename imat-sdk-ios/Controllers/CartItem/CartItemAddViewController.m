//
//  CartItemAddViewController.m
//  imat-sdk-ios
//
//  Created by imat on 5/22/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import "CartItemAddViewController.h"
#import "MBProgressHUD.h"
#import "IMCartItemRequest.h"
#import "IMCartItemModelRequest.h"
#import "IMCartItemModelResponse.h"
#import "IMCartItemResponse.h"
#import "ApiManager.h"
#import "CartItemAddResultViewController.h"



@interface CartItemAddViewController ()
{
    MBProgressHUD* hud;
}

@property (weak, nonatomic) IBOutlet UITextField *xDimTextField;
@property (weak, nonatomic) IBOutlet UITextField *yDimTextField;
@property (weak, nonatomic) IBOutlet UITextField *zDimTextField;
@property (weak, nonatomic) IBOutlet UITextField *surfaceTextField;
@property (weak, nonatomic) IBOutlet UITextField *volumeTextField;

@end

@implementation CartItemAddViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Add cart item";    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard
{
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

    
    IMCartItemRequest* request = [[IMCartItemRequest alloc] init];
    //API allows you to create a few cart items at once
    NSMutableArray* cartItems = [[NSMutableArray alloc] init];
    request.currency = @"EUR";
    
    NSString *filePath = [[[NSBundle mainBundle] resourcePath]
                          stringByAppendingPathComponent:@"10x10x10.stl"];
    IMFile* file = [[IMFile alloc] init];
    file.name = @"10x10x10.stl";
    file.mimeType = @"application/octet-stream";
    file.data = [NSData dataWithContentsOfFile:filePath];
    
    
    
    IMCartItemModelRequest* cartModel = [[IMCartItemModelRequest alloc] init];
    cartModel.materialId = @"035f4772-da8a-400b-8be4-2dd344b28ddb"; // get it from materials API
    cartModel.finishId = @"bba2bebb-8895-4049-aeb0-ab651cee2597"; // get it from materials API

    cartModel.modelID = @""; //fill if you don't want to upload file
    cartModel.quantity = 1;
    cartModel.myCartItemReference = @"My reference";
    cartModel.fileUnits = @"mm"; //or inch
    cartModel.fileScaleFactor = 1;
    cartModel.xDimMm = [self.xDimTextField.text floatValue];
    cartModel.yDimMm = [self.yDimTextField.text floatValue];
    cartModel.zDimMm = [self.zDimTextField.text floatValue];
    cartModel.iMatAPIPrice = 12.5;
    cartModel.mySalesPrice = 123.5;
    cartModel.surfaceCm2 = [self.surfaceTextField.text floatValue];
    cartModel.volumeCm3 = [self.volumeTextField.text floatValue];
    cartModel.toolId = [ApiManager toolId];
    cartModel.file = file;
    
    [cartItems addObject: cartModel];
    request.cartItems = cartItems;
    
    ApiManager* apiManager = [ApiManager instance];
    [apiManager registerCartItem: request success: ^(IMCartItemResponse* response)
    {
        ((UIButton*)sender).enabled = true;
        [hud hide:true];
         CartItemAddResultViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier: @"CartItemAddResultViewController"];
         controller.response = response;
         
         [self.navigationController pushViewController:controller animated:true];
         
     } failure: ^(IMError* error)
     {
         ((UIButton*)sender).enabled = true;
         [hud hide:true];
         
         UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Erorr"
                                                           message: error.description
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
         
         [message show];
         
     }];
}

@end
