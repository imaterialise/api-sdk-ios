//
//  UploadModelResultViewController.m
//  imat-sdk-ios
//
//  Created by imat on 5/12/14.
//  Copyright (c) 2014 i.materialise. All rights reserved.
//

#import "UploadModelResultViewController.h"

@interface UploadModelResultViewController ()


@property (weak, nonatomic) IBOutlet UILabel *fileUnitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelFileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *surfaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *toolIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *validUntilLabel;
@property (weak, nonatomic) IBOutlet UILabel *xDimLabel;
@property (weak, nonatomic) IBOutlet UILabel *yDimLabel;
@property (weak, nonatomic) IBOutlet UILabel *zDimLabel;

@end

@implementation UploadModelResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fileUnitsLabel.text = self.response.fileUnits;
    self.modelFileNameLabel.text = self.response.modelFileName;
    self.modelIdLabel.text = self.response.modelID;
    self.modelStatusLabel.text = self.response.modelStatus;
    self.surfaceLabel.text = [NSString stringWithFormat:@"%f", self.response.surfaceCm2];
    self.volumeLabel.text = [NSString stringWithFormat:@"%f", self.response.volumeCm3];
    self.toolIdLabel.text = self.response.toolID;
    self.validUntilLabel.text = [self.response.validUntil description];
    self.xDimLabel.text = [NSString stringWithFormat:@"%f", self.response.xDimMm];
    self.yDimLabel.text = [NSString stringWithFormat:@"%f", self.response.yDimMm];
    self.zDimLabel.text = [NSString stringWithFormat:@"%f", self.response.zDimMm];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
