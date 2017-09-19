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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"index: %ld",(long)indexPath.row);
    NSNumber *index = [[NSNumber alloc]initWithInteger:indexPath.row];
    switch (indexPath.row) {
        case 1:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SetTimeAlarmOpen" object:index];
            break;
        case 2:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SetTimeAlarmOpen" object:index];
            break;
        case 4:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SetTimeAlarmOpen" object:index];
            break;
        default:
            break;
    }
}

- (IBAction)repeatAlarm:(id)sender {
    NSLog(@"%f and %f",[self.time timeIntervalSinceNow],[[NSDate date] timeIntervalSinceNow]);
}

- (void)notificationForTime:(BOOL)isOn withRepeat:(BOOL)isRepeat
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertAction = @"Alarm";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    if (isOn) {
        localNotification.userInfo = @{@"uid":@"Alarm"};
        if (isRepeat) {
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:self.time];
            NSInteger hour = [components hour];
            NSInteger minute = [components minute];
            [components setHour:hour];
            [components setMinute:minute];
            
            NSDate *nextTime = [calendar dateFromComponents:components];
            if ([nextTime timeIntervalSinceNow] < 0) {
                nextTime = [nextTime dateByAddingTimeInterval:60*60*24];
            }
            // Set a repeat interval to daily
            localNotification.repeatInterval = kCFCalendarUnitDay;
            localNotification.fireDate = nextTime;
            localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
            NSLog(@"Repeat");
        } else {
            if ([self.time timeIntervalSinceNow] < 0) {
                localNotification.fireDate = [self.time dateByAddingTimeInterval:60*60*24];
                localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
            } else {
                localNotification.fireDate = self.time;
                localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
            }
            NSLog(@"No Repeat");
        }
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Alarm On %@",self.time);
    } else {
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *eventArray = [app scheduledLocalNotifications];
        for (int i=0; i<[eventArray count]; i++)
        {
            UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
            NSDictionary *userInfoCurrent = oneEvent.userInfo;
            NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"uid"]];
            if ([uid isEqualToString:@"Alarm"])
            {
                //Cancelling local notification
                [app cancelLocalNotification:oneEvent];
                break;
            }
        }
    }
}

- (IBAction)turnOnOffAlarm:(id)sender {
    [self notificationForTime:(self.isOnAlarm.selectedSegmentIndex == 0) withRepeat:self.repeatAlarm.isOn];
}

- (void)registerNotificationSetTimeAlarm {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTimeLabel:) name:@"SetTimeAlarmClose" object:nil];
}

- (void)setTimeLabel: (NSNotification*)notification {
    self.time = notification.object;
    NSDateFormatter *dateForMatter = [[NSDateFormatter alloc] init];
    [dateForMatter setDateFormat:@"HH:mm"];
    self.timeAlarm.text = [NSString stringWithFormat:@"Time   %@",[dateForMatter stringFromDate:notification.object]];
    [self.isOnAlarm setSelectedSegmentIndex:1];
    NSLog(@"time %@",notification.object);
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
