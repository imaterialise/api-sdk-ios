//
//  CartItemAddResultViewController.m
//  imat-sdk-ios
//
//  Created by imat on 5/23/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import "CartItemAddResultViewController.h"
#import "IMCartItemModelResponse.h"
#import "CartRegistrationViewController.h"

#import "IMCartRequest.h"
#import "IMCartItemCartRequest.h"
#import "IMShippingInfoRequest.h"
#import "IMBillingInfoRequest.h"
#import "IMCartResponse.h"

#import "MBProgressHUD.h"
#import "ApiManager.h"

@interface CartItemAddResultViewController ()
{
    MBProgressHUD* hud;
}

@property (weak, nonatomic) IBOutlet UILabel *cartItemIdLabel;

@end

@implementation CartItemAddResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    IMCartItemModelResponse* cartItem = self.response.cartItems[0];
    self.cartItemIdLabel.text = cartItem.cartItemId;
    
    self.title = @"Create cart"; 
}


- (IBAction)createCarButtonTouched:(id)sender
{
    ((UIButton*)sender).enabled = false;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;

    
    IMCartRequest* cartRequest = [[IMCartRequest alloc] init];
    cartRequest.myCartReference = @"my cart reference";
    cartRequest.currency = @"EUR";
    
    NSMutableArray* cartItems = [[NSMutableArray alloc] init];
    for (IMCartItemModelResponse* item in self.response.cartItems)
    {
        IMCartItemCartRequest* cartItem = [[IMCartItemCartRequest alloc] init];
        cartItem.cartItemId = item.cartItemId;
        [cartItems addObject: cartItem];
    }
    cartRequest.cartItems = cartItems;
    
    
    IMShippingInfoRequest* shippingInfo = [[IMShippingInfoRequest alloc ] init];
    shippingInfo.firstName = @"John";
    shippingInfo.lastName = @"Smith";
    shippingInfo.email = @"test@test.com";
    shippingInfo.phone = @"1234567";
    shippingInfo.company = @"ABC";
    shippingInfo.line1 = @"North Street";
    shippingInfo.line2 = @"";
    shippingInfo.countryCode = @"US";
    shippingInfo.stateCode = @"NY";
    shippingInfo.zipCode = @"10001";
    shippingInfo.city = @"New York";
    
    IMBillingInfoRequest* billingInfo = [[IMBillingInfoRequest alloc ] init];
    billingInfo.firstName = @"John";
    billingInfo.lastName = @"Smith";
    billingInfo.email = @"test@test.com";
    billingInfo.phone = @"1234567";
    billingInfo.company = @"ABC";
    billingInfo.line1 = @"North Street";
    billingInfo.line2 = @"";
    billingInfo.countryCode = @"US";
    billingInfo.stateCode = @"NY";
    billingInfo.zipCode = @"10001";
    billingInfo.city = @"New York";
    
    cartRequest.shippingInfo = shippingInfo;
    cartRequest.billingInfo = billingInfo;
    
    [[ApiManager instance] registerCart: cartRequest success: ^(IMCartResponse* response)
     {
         
         ((UIButton*)sender).enabled = true;
         [hud hide:true];
         
         CartRegistrationViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier: @"CartRegistrationViewController"];
         //controller.response = response;
         
         [self.navigationController pushViewController:controller animated:true];
         
     }
                     failure: ^(IMError* error)
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
