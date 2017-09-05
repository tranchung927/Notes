//
//  DetailViewController.m
//  Notes
//
//  Created by Chung Tran on 8/28/17.
//  Copyright © 2017 Chung Tran. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "Database.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Load item

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    // Check version
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if (ver_float > 5.0 && ver_float < 10.0) {
        context = [Database.shared managedObjectContext];
    } else if (ver_float > 10.0) {
        context = [AppDelegate shared].persistentContainer.viewContext;
    }
    return context;
}
- (void)loadImage: (NSString*)path {
    NSURL *url = [NSURL URLWithString:path];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:url resultBlock:^(ALAsset *asset) {
        UIImage *returnValue = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageView setImage:returnValue];
            [self.imageView setNeedsDisplay];
        });
    } failureBlock:^(NSError *error) {
        NSLog(@"error : %@", error);
    }];
}

- (NSString*)outPutDate: (NSDate*)date {
    NSDateFormatter *dateForMatter = [[NSDateFormatter alloc] init];
    [dateForMatter setDateFormat:@"EEE MMM dd HH:mm:ss"];
    NSString *dateString = [dateForMatter stringFromDate:date];
    return dateString;
}

- (void)configureView {
    self.dateCurrent.text = [self outPutDate:self.detailItem.timestamp];
    self.textViewInputNote.text = self.detailItem.name;
    if (self.detailItem.imageURL != nil) {
        [self loadImage:self.detailItem.imageURL];
    }
    [self.shareButton setEnabled:true];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.textFieldInputNote.delegate = self;
    if (self.detailItem != NULL) {
        [self configureView];
    } else {
        [self.shareButton setEnabled:false];
        [self.cpmpleteButton setEnabled:false];
        NSDate *now = [NSDate date];
        self.dateCurrent.text = [self outPutDate:now];;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Create new Note and save note
- (void)createNewNote {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newNote = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
    [newNote setValue:self.textViewInputNote.text forKey:@"name"];
    NSDateFormatter *dateForMatter = [[NSDateFormatter alloc] init];
    [dateForMatter setDateFormat:@"EEE MMM dd HH:mm:ss"];
    NSDate *date = [dateForMatter dateFromString:self.dateCurrent.text];
    [newNote setValue:date forKey:@"timestamp"];
    [newNote setValue:self.urlImage forKey:@"imageURL"];
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

- (void) saveNote {
    NSManagedObjectContext *context = [self managedObjectContext];
    self.detailItem.name = self.textViewInputNote.text;
    self.detailItem.imageURL = self.urlImage;
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

#pragma mark - UITextFieldDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.cpmpleteButton setEnabled:true];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSUInteger length = textView.text.length;
    if (length > 0) {
        if (self.detailItem == nil) {
            [self createNewNote];
        } else {
            [self saveNote];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    // Dismiss the picker if the user canceled.
    [self dismissViewControllerAnimated:true completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    
    // Set photoImageView to display the selected image.
    self.imageView.image = selectedImage;
    // Get the image url from AssetsLibrary
    NSURL *path = info[UIImagePickerControllerReferenceURL];
    self.urlImage = path.absoluteString;
    NSLog(@"%@",path);
    
    // Dismiss the picker.
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Action
- (IBAction)saveNote:(id)sender {
    if (self.detailItem != NULL) {
        [self saveNote];
    }
    
    [self.navigationController popViewControllerAnimated:true];
}
- (IBAction)share:(id)sender {
    
    NSString *textToShare = self.textViewInputNote.text;
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[textToShare] applicationActivities:nil];
    
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //Exclude whichever aren't relevant
    
    // Present the controller
    [self presentViewController:activityVC animated:YES completion:nil];
    
}
- (IBAction)camera:(id)sender {
    
    // Hide the keyboard.
    [self.textViewInputNote resignFirstResponder];
    
    // UIImagePickerController is a view controller that lets a user pick media from their photo library.
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    // Make sure ViewController is notified when the user picks an image.
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}
- (IBAction)delete:(id)sender {
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

@end
