//
//  SideMenu.m
//  Notes
//
//  Created by Chung Tran on 9/1/17.
//  Copyright © 2017 Chung Tran. All rights reserved.
//

#import "SideMenu.h"
#import "OverlayViewController.h"

@interface SideMenu ()

@end

@implementation SideMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNotificationSetTimeAlarm];
    [self.isOnAlarm setSelectedSegmentIndex:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"index: %ld",(long)indexPath.row);
    switch (indexPath.row) {
        case 1:
            
            break;
        case 2:
            
            break;
        case 4:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SetTimeAlarmOpen" object:nil];
            break;
        default:
            break;
    }
}
- (IBAction)repeatAlarm:(id)sender {
    if (self.repeatAlarm.isOn) {
        NSLog(@"True");
    } else {
        NSLog(@"False");
    }
}
- (IBAction)turnOnOffAlarm:(id)sender {
    if (self.isOnAlarm.selectedSegmentIndex == 0) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = self.time;
        localNotification.alertAction = @"Alarm";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Alarm On %@",self.time);
    } else {
        NSLog(@"Alarm Off");
    }
}

- (void)registerNotificationSetTimeAlarm {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTimeLabel:) name:@"SetTimeAlarmClose" object:nil];
}

- (void)setTimeLabel: (NSNotification*)notification {
    self.time = notification.object;
    NSDateFormatter *dateForMatter = [[NSDateFormatter alloc] init];
    [dateForMatter setDateFormat:@"HH:mm"];
    self.timeAlarm.text = [NSString stringWithFormat:@"Time   %@",[dateForMatter stringFromDate:notification.object]];
    NSLog(@"time %@",notification.object);
    
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
