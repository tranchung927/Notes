//
//  DetailViewController.h
//  Notes
//
//  Created by Chung Tran on 8/28/17.
//  Copyright © 2017 Chung Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Notes+CoreDataModel.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface DetailViewController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dateCurrent;
@property (weak, nonatomic) IBOutlet UITextView *textViewInputNote;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cpmpleteButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) NSString *urlImage;
@property (strong, nonatomic) Note *detailItem;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end
