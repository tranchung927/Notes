//
//  NoteTableViewCell.h
//  Notes
//
//  Created by Chung Tran on 8/30/17.
//  Copyright © 2017 Chung Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameNote;
@property (weak, nonatomic) IBOutlet UILabel *timeNote;
@property (weak, nonatomic) IBOutlet UILabel *contextImage;
@end
