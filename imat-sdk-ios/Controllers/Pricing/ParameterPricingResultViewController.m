//
//  ParameterPricingResultViewController.m
//  imat-sdk-ios
//
//  Created by imat on 5/19/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import "ParameterPricingResultViewController.h"
#import "IMPricingResponseModel.h"

@interface ParameterPricingResultViewController ()

@property IMPricingResponseModel* model;

@end

@implementation ParameterPricingResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Price result";
    
    
    //For demo we show only first model
    self.model = self.response.models[0];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ModelCell"];
    
    UILabel* fieldNameLabel = (UILabel*)[cell viewWithTag:100];
    UILabel* fieldValueLabel = (UILabel*)[cell viewWithTag:101];
    
    
    if(indexPath.row == 0)
    {
        fieldNameLabel.text = @"materialName";
        fieldValueLabel.text = self.model.materialName;
    } else if(indexPath.row == 1)
    {
        fieldNameLabel.text = @"finishingName";
        fieldValueLabel.text = self.model.finishingName;
    } else if(indexPath.row == 2)
    {
        fieldNameLabel.text = @"modelReference";
        fieldValueLabel.text = self.model.modelReference;
    } else if(indexPath.row == 3)
    {
        fieldNameLabel.text = @"quantity";
        fieldValueLabel.text = [NSString stringWithFormat:@"%d", self.model.quantity];
    } else if(indexPath.row == 4)
    {
        fieldNameLabel.text = @"totalPrice";
        fieldValueLabel.text = [NSString stringWithFormat:@"%f", self.model.totalPrice];
    } else if(indexPath.row == 5)
    {
        fieldNameLabel.text = @"xDimMm";
        fieldValueLabel.text = [NSString stringWithFormat:@"%f", self.model.xDimMm];
    } else if(indexPath.row == 6)
    {
        fieldNameLabel.text = @"yDimMm";
        fieldValueLabel.text = [NSString stringWithFormat:@"%f", self.model.yDimMm];
    } else if(indexPath.row == 7)
    {
        fieldNameLabel.text = @"yDimMm";
        fieldValueLabel.text = [NSString stringWithFormat:@"%f", self.model.yDimMm];
    } else if(indexPath.row == 8)
    {
        fieldNameLabel.text = @"currency";
        fieldValueLabel.text = self.response.currency;
    }
    
    
    
    return cell;
}


@end
