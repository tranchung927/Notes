//
//  OverlayViewController.h
//  Notes
//
//  Created by Chung Tran on 9/1/17.
//  Copyright © 2017 Chung Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverlayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *coverButtonOverlay;
@property (weak, nonatomic) IBOutlet UIView *viewContainerPicker;

@end
