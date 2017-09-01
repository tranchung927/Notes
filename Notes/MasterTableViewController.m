//
//  MasterTableViewController.m
//  Notes
//
//  Created by Chung Tran on 8/28/17.
//  Copyright © 2017 Chung Tran. All rights reserved.
//

#import "MasterTableViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "NoteTableViewCell.h"

@interface MasterTableViewController ()

@end

@implementation MasterTableViewController

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    context = [AppDelegate shared].persistentContainer.viewContext;
    return context;
}
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.cancelButton setTitle:@"Edit"];
    self.arrayDeleteIndexPath = [[NSMutableArray alloc]init];
    self.isEditTableView = false;
    self.titleToolBar.tintColor = [UIColor blackColor];
    [self.barRightButton setImage:[UIImage imageNamed:@"create_new"]];
    [self loadNoteFromData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadNoteFromData];
    [self hasNoData];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load data from CoreData

- (void)hasNoData {
    if (self.notes.count == 0) {
        self.tableView.tableFooterView = self.noData;
        [self.tableView setScrollEnabled:NO];
        [self.cancelButton setEnabled:NO];
    } else {
        self.tableView.tableFooterView = self.footer;
        [self.tableView setScrollEnabled:YES];
        [self.cancelButton setEnabled:YES];
    }
    if ([self.tableView isEditing]) {
        [self editTableView:self.cancelButton];
    }
}

- (void)loadNoteFromData {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (!results) {
        NSLog(@"Error fetching Note objects: %@\n%@", [error localizedDescription], [error userInfo]);
        //        abort();
    }
    self.notes = [(NSArray *)results mutableCopy];
    NSLog(@"loaddate notes %ld",(unsigned long)results.count);
}
#pragma mark - Delete data

- (void)deleteData {
    if (self.arrayDeleteIndexPath.count != 0) {
        [self.tableView beginUpdates];
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
        NSError *error = nil;
        NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (!results) {
            NSLog(@"Error fetching Note objects: %@\n%@", [error localizedDescription], [error userInfo]);
            abort();
        }
        for (NSIndexPath *indexPath in self.arrayDeleteIndexPath) {
            NSManagedObject *object = [results objectAtIndex:indexPath.row];
            [[self managedObjectContext] deleteObject:object];
            NSError *error = nil;
            if (![[AppDelegate shared].persistentContainer.viewContext save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                abort();
            }
        }
        [self.tableView deleteRowsAtIndexPaths:self.arrayDeleteIndexPath withRowAnimation:UITableViewRowAnimationFade];
        [self loadNoteFromData];
        [self hasNoData];
        [self.tableView endUpdates];
    }
}

#pragma mark - Action Delete TableView
- (IBAction)editTableView:(UIBarButtonItem *)sender {
    self.isEditTableView = !self.isEditTableView;
    if (self.isEditTableView) {
        [self.cancelButton setTitle:@"Cancel"];
        [self.tableView setEditing:YES animated:YES];
        [self.titleToolBar setEnabled:NO];
        self.titleToolBar.tintColor = [UIColor clearColor];
        [self.barRightButton setImage:nil];
        [self.barRightButton setTitle:@"Delete All"];
        
    } else {
        [self.tableView setEditing:NO animated:YES];
        [self.cancelButton setTitle:@"Edit"];
        [self.navigationItem setTitle:@"Notes"];
        [self.arrayDeleteIndexPath removeAllObjects];
        [self.titleToolBar setEnabled:YES];
        self.titleToolBar.tintColor = [UIColor blackColor];
        [self.barRightButton setImage:[UIImage imageNamed:@"create_new"]];
    }
}
- (IBAction)deleteButton:(id)sender {
    if (self.tableView.isEditing == false) {
        DetailViewController *vc = (DetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        [self.navigationController pushViewController:vc animated:true];
    } else {
        if ([self.barRightButton.title isEqualToString:@"Delete"]) {
            [self deleteData];
            [self.arrayDeleteIndexPath removeAllObjects];
            [self setTitle];
        } else {
            NSLog(@"Delete All");
        }
        [self noData];
    }
}

// Set title
- (void)setTitle {
    if (self.arrayDeleteIndexPath.count == 0) {
        [self.navigationItem setTitle:@"Notes"];
    } else {
        NSString *titleNavigation = [NSString stringWithFormat:@"%lu Selected",(unsigned long)self.arrayDeleteIndexPath.count];
        [self.navigationItem setTitle:titleNavigation];
    }
}
#pragma mark - Date Fomat

- (NSString*)outPutDate: (NSDate*)date {
    NSDate *now = [NSDate date];
    NSDateFormatter *dateForMatter = [[NSDateFormatter alloc] init];
    NSDateComponents *componentsNow = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:now];
    NSDateComponents *componentsDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    if (componentsDate.day == componentsNow.day) {
        [dateForMatter setDateFormat:@"HH:mm"];
        NSString *dateString = [dateForMatter stringFromDate:date];
        return dateString;
    } else {
        [dateForMatter setDateFormat:@"EEE MMM dd"];
        NSString *dateStringFull = [dateForMatter stringFromDate:date];
        return dateStringFull;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.notes.count > 0) {
        self.titleToolBar.title =[NSString stringWithFormat:@"%lu Notes",(unsigned long)self.notes.count];
        return self.notes.count;
    } else {
        self.titleToolBar.title =[NSString stringWithFormat:@"No Notes"];
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    Note *note = self.notes[indexPath.row];
    [self configureCell:cell withNote:note];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Configure Cell
- (void)configureCell:(NoteTableViewCell*)cell withNote:(Note *)note{
    if (note.imageURL != nil) {
        cell.contextImage.text = @"Attachments";
    } else {
        cell.contextImage.text = @"No additional text";
    }
    cell.nameNote.text = note.name;
    cell.timeNote.text = [self outPutDate:note.timestamp];
}

#pragma mark - Table view delegate
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
    return 3;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing == YES) {
        [self.arrayDeleteIndexPath addObject:indexPath];
        [self.barRightButton setTitle:@"Delete"];
        [self setTitle];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.arrayDeleteIndexPath.count != 0) {
        [self.arrayDeleteIndexPath removeObject:indexPath];
        if (self.arrayDeleteIndexPath.count == 0) {
            [self.barRightButton setTitle:@"Delete All"];
        }
        [self setTitle];
    }
}

#pragma mark - Click SideMenu
- (IBAction)clickSideMenu:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickSideMenu" object:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (!self.tableView.editing) {
        if ([[segue identifier] isEqualToString:@"showDetail"]) {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            DetailViewController *controller = [segue destinationViewController];
            controller.detailItem = self.notes[indexPath.row];
            
        }
    } else {
        [self shouldPerformSegueWithIdentifier:@"showDetail" sender:sender];
    }
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (self.tableView.editing) {
        return NO;
    } else {
        return YES;
    }
}

@end
