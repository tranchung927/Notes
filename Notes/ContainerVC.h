//
//  ContainerVC.h
//  Notes
//
//  Created by Chung Tran on 8/29/17.
//  Copyright © 2017 Chung Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContainerVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *sideMenuViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *coverButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSideMenuConstraint;
@property (nonatomic) BOOL isSideMenuOpen;
@end
