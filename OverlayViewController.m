//
//  OverlayViewController.m
//  Notes
//
//  Created by Chung Tran on 9/1/17.
//  Copyright © 2017 Chung Tran. All rights reserved.
//

#import "OverlayViewController.h"

@interface OverlayViewController ()

@end

@implementation OverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.coverButtonOverlay.alpha = 0.5;
    self.viewContainerPicker.layer.cornerRadius = 10;
    self.viewContainerPicker.layer.borderWidth = 3;
    self.viewContainerPicker.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor grayColor]);
    self.viewContainerPicker.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickCoverButtonOverlay:(id)sender {
    // Get the current date
    NSDate *pickerDate = [self.datePicker date];
    NSLog(@"Time: %@",pickerDate);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetTimeAlarmClose" object:pickerDate];
}

@end
