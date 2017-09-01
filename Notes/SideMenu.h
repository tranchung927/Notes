//
//  SideMenu.h
//  Notes
//
//  Created by Chung Tran on 9/1/17.
//  Copyright © 2017 Chung Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenu : UITableViewController

@property (nonatomic)NSMutableArray *sections;
@property (nonatomic)NSMutableArray *cells;

@property (weak, nonatomic) IBOutlet UITableViewCell *setFont;


@end
