//
//  MasterTableViewController.h
//  Notes
//
//  Created by Chung Tran on 8/28/17.
//  Copyright © 2017 Chung Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Notes+CoreDataModel.h"

@interface MasterTableViewController : UITableViewController 
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleToolBar;
@property (strong, nonatomic) NSFetchedResultsController<Note *> *fetchedResultController;
@property (nonatomic) NSMutableArray *arrayDeleteIndexPath;
@property (nonatomic) NSMutableArray *notes;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barRightButton;
@property (weak, nonatomic) IBOutlet UIView *noData;
@property (weak, nonatomic) IBOutlet UIView *footer;
@property (nonatomic)BOOL isEditTableView;
@end
