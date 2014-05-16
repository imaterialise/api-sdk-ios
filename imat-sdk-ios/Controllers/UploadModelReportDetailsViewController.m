//
//  UploadModelReportDetailsViewController.m
//  imat-sdk-ios
//
//  Created by imat on 5/16/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import "UploadModelReportDetailsViewController.h"

@interface UploadModelReportDetailsViewController ()

@end

@implementation UploadModelReportDetailsViewController

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
    self.title = self.model.modelFileName;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ModelCell"];
    
    UILabel* fieldNameLabel = (UILabel*)[cell viewWithTag:100];
    UILabel* fieldValueLabel = (UILabel*)[cell viewWithTag:101];
    
    
    if(indexPath.row == 0)
    {
        fieldNameLabel.text = @"modelId";
        fieldValueLabel.text = self.model.modelId;
    } else if(indexPath.row == 1)
    {
        fieldNameLabel.text = @"fileName";
        fieldValueLabel.text = self.model.modelFileName;
    } else if(indexPath.row == 2)
    {
        fieldNameLabel.text = @"processingResult";
        fieldValueLabel.text = self.model.processingResult;
    } else if(indexPath.row == 3)
    {
        fieldNameLabel.text = @"surfaceCm2";
        fieldValueLabel.text = [NSString stringWithFormat:@"%f", self.model.surfaceCm2];
    } else if(indexPath.row == 4)
    {
        fieldNameLabel.text = @"volumeCm3";
        fieldValueLabel.text = [NSString stringWithFormat:@"%f", self.model.volumeCm3];
    } else if(indexPath.row == 5)
    {
        fieldNameLabel.text = @"toolId";
        fieldValueLabel.text = self.model.toolId;
    } else if(indexPath.row == 6)
    {
        fieldNameLabel.text = @"uploadDate";
        fieldValueLabel.text = [self.model.uploadDate description];
    } else if(indexPath.row == 7)
    {
        fieldNameLabel.text = @"wasCanceled";
        fieldValueLabel.text = [NSString stringWithFormat:@"%d", self.model.wasCanceled];
    } else if(indexPath.row == 8)
    {
        fieldNameLabel.text = @"wasDeleted";
        fieldValueLabel.text = [NSString stringWithFormat:@"%d", self.model.wasDeleted];
    } else if(indexPath.row == 9)
    {
        fieldNameLabel.text = @"wasOrdered";
        fieldValueLabel.text = [NSString stringWithFormat:@"%d", self.model.wasOrdered];
    } else if(indexPath.row == 10)
    {
        fieldNameLabel.text = @"xDimMm";
        fieldValueLabel.text = [NSString stringWithFormat:@"%f", self.model.xDimMm];
    } else if(indexPath.row == 11)
    {
        fieldNameLabel.text = @"yDimMm";
        fieldValueLabel.text = [NSString stringWithFormat:@"%f", self.model.yDimMm];
    } else if(indexPath.row == 12)
    {
        fieldNameLabel.text = @"yDimMm";
        fieldValueLabel.text = [NSString stringWithFormat:@"%f", self.model.yDimMm];
    }

    
    return cell;
}


@end
