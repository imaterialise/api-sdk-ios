//
//  MasterViewController.m
//  api-sdk-ios
//
//  Created by imat on 5/8/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import "MasterViewController.h"
#import "UploadModelViewController.h"
#import "UploadModelReportViewController.h"
#import "ParameterPricingViewController.h"
#import "CartItemAddViewController.h"

@interface MasterViewController () {
    NSMutableArray *objects;
}
@end

@implementation MasterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    objects = [[NSMutableArray alloc] init];
    [objects addObject:@"Upload model"];
    [objects addObject:@"Uploaded models reporting"];
    [objects addObject:@"Price calculation by parameters"];
    [objects addObject:@"Cart item/ Cart registration"];    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSString *item = objects[indexPath.row];
    cell.textLabel.text = item;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        UploadModelViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier: @"UploadModelViewController"];

        [self.navigationController pushViewController:controller animated: true];
    }
    else if(indexPath.row == 1)
    {
        UploadModelReportViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier: @"UploadModelReportViewController"];

        [self.navigationController pushViewController:controller animated: true];
    }
    else if(indexPath.row == 2)
    {
        ParameterPricingViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier: @"ParameterPricingViewController"];
        
        [self.navigationController pushViewController:controller animated: true];
    }
    else if(indexPath.row == 3)
    {
        CartItemAddViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier: @"CartItemAddViewController"];
        
        [self.navigationController pushViewController:controller animated: true];
    }
    
    
}

@end
