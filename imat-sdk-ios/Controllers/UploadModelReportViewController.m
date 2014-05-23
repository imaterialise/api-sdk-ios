//
//  UploadModelReportViewController.m
//  imat-sdk-ios
//
//  Created by imat on 5/16/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import "UploadModelReportViewController.h"
#import "MBProgressHUD.h"
#import "IMUploadModelReportRequest.h"
#import "IMUploadModelReportResponse.h"
#import "ApiManager.h"
#import "UploadModelReportResultViewController.h"

@interface UploadModelReportViewController ()
{
    MBProgressHUD* hud;
}

@property (weak, nonatomic) IBOutlet UITextField *dateFromTextField;

@property (weak, nonatomic) IBOutlet UITextField *dateToTextField;

@end

@implementation UploadModelReportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)showReportTouched:(id)sender
{
    ((UIButton*)sender).enabled = false;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *dateFrom = [dateFormatter dateFromString: self.dateFromTextField.text];
    NSDate *dateTo = [dateFormatter dateFromString: self.dateToTextField.text];
    
    
    IMUploadModelReportRequest* request = [[IMUploadModelReportRequest alloc] init];
    request.dateFrom =  dateFrom;
    request.dateTo = dateTo;
    request.toolId = @"";
    request.modelId = @"";
    
    ApiManager* apiManager = [ApiManager instance];
    [apiManager getModelsReport:request success: ^(IMUploadModelReportResponse* response)
     {
         
         UploadModelReportResultViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier: @"UploadModelReportResultViewController"];
         controller.response = response;
         
         [self.navigationController pushViewController:controller animated:true];
         
         ((UIButton*)sender).enabled = true;
         [hud hide:true];
         
     } failure: ^(IMError* error)
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

-(void)dismissKeyboard
{
    [self.dateFromTextField resignFirstResponder];
    [self.dateToTextField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Uploaded Models Report";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                  initWithTarget:self
                                  action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

@end
