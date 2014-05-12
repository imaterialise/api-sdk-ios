//
//  UploadModelViewController.m
//  imat-sdk-ios
//
//  Created by imat on 5/12/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import "UploadModelViewController.h"
#import "ApiManager.h"
#import "IMModelRequest.h"
#import "IMFile.h"
#import "UploadModelResultViewController.h"
#import "MBProgressHUD.h"

@interface UploadModelViewController ()
{
    ApiManager* apiManager;
    MBProgressHUD* hud;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *fileUnitSegmentedControl;


@end

@implementation UploadModelViewController


- (IBAction)uploadButtonTouched:(id)sender
{
    ((UIButton*)sender).enabled = false;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSString *filePath = [[[NSBundle mainBundle] resourcePath]
                          stringByAppendingPathComponent:@"10x10x10.stl"];
    
    IMFile* file = [[IMFile alloc] init];
    file.name = @"10x10x10.stl";
    file.mimeType = @"application/octet-stream";
    file.data = [NSData dataWithContentsOfFile:filePath];
    
    IMModelRequest* modelRequest = [[IMModelRequest alloc] init];
    modelRequest.file = file;
    modelRequest.fileUnits = [self.fileUnitSegmentedControl titleForSegmentAtIndex:self.fileUnitSegmentedControl.selectedSegmentIndex];
    
    apiManager = [[ApiManager alloc] initWitSiteUrl:@"https://imatsandbox.materialise.net" toolId: @"[TOOL ID HERE]" apiCode:nil];
    
    [apiManager uploadModel:modelRequest success: ^(IMModelResponse* response)
     {
        UploadModelResultViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier: @"UploadModelResultViewController"];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
}


@end
