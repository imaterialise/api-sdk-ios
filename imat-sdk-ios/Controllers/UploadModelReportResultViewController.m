//
//  UploadModelReportResultViewConroller.m
//  imat-sdk-ios
//
//  Created by imat on 5/16/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import "UploadModelReportResultViewController.h"
#import "IMUploadModel.h"
#import "UploadModelReportDetailsViewController.h"

@interface UploadModelReportResultViewController ()
@property (weak, nonatomic) IBOutlet UILabel *numberOfModelsLabel;

@end

@implementation UploadModelReportResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.numberOfModelsLabel.text = [NSString stringWithFormat:@"%d", self.response.models.count];
    self.title = @"Result";
}


- (void) tableView: (UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMUploadModel* model = [self.response.models objectAtIndex:indexPath.row];
    UploadModelReportDetailsViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier: @"UploadModelReportDetailsViewController"];
    controller.model = model;
    
    [self.navigationController pushViewController:controller animated:true];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.response.models.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMUploadModel* model = [self.response.models objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ModelCell"];
    
    UILabel* modelIdLabel = (UILabel*)[cell viewWithTag:100];
    modelIdLabel.text = model.modelId;

    return cell;
}

@end
