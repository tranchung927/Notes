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
    [self registerNotificationSetting];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    [self settingDatePicker];
}

- (void)registerNotificationSetting {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingDatePicker:) name:@"SetTimeAlarmOpen" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)clickCoverButtonOverlay:(id)sender {
    if (self.numberSetting == 4) {
        // Get the current date
        NSDate *pickerDate = [self.datePicker date];
        NSLog(@"Time: %@",pickerDate);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SetTimeAlarmClose" object:pickerDate];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SetTimeAlarmClose" object:nil];
    }
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = @"sample title";
    NSAttributedString *attString =
    [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
}

- (void)settingDatePicker: (NSNotification *)notification {
    //    self.datePicker.backgroundColor = [UIColor redColor];
    NSNumber *index = notification.object;
    int numberSetting = [index intValue];
    self.numberSetting = numberSetting;
    [self.datePicker removeFromSuperview];
    [self.settingPickerView removeFromSuperview];
    if (numberSetting == 4) {
        [self.datePicker setFrame:CGRectMake(0, 0, self.viewContainerPicker.frame.size.width, self.viewContainerPicker.frame.size.height)];
        [self.viewContainerPicker addSubview:self.datePicker];
    } else {
        [self.viewContainerPicker clearsContextBeforeDrawing];
        [self.settingPickerView setFrame:CGRectMake(0, 0, self.viewContainerPicker.frame.size.width, self.viewContainerPicker.frame.size.height)];
        [self.viewContainerPicker addSubview:self.settingPickerView];
    }
    
}
@end
