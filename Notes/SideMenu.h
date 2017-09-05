//
//  SideMenu.h
//  Notes
//
//  Created by Chung Tran on 9/1/17.
//  Copyright © 2017 Chung Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenu : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *timeAlarm;
@property (weak, nonatomic) IBOutlet UISwitch *repeatAlarm;
@property (weak, nonatomic) IBOutlet UISegmentedControl *isOnAlarm;
@property (nonatomic) NSDate *time;

@end
