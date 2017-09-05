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


@end
