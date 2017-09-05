//
//  ContainerVC.m
//  Notes
//
//  Created by Chung Tran on 8/29/17.
//  Copyright © 2017 Chung Tran. All rights reserved.
//

#import "ContainerVC.h"

@interface ContainerVC ()

@end

@implementation ContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.leftOverlayView.constant = - self.view.bounds.size.width;
    self.isSideMenuOpen = false;
    self.isOverlayOpen = false;
    [self setStageOverlayClose];
    [self setStageSideMenu:self.isSideMenuOpen];
    [self registerNotification];
    [self registerNotificationSetTimeAlarmOpen];
    [self registerNotificationSetTimeAlarmClose];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onClickCorverButton:) name:@"ClickSideMenu" object:nil];
}
- (void)registerNotificationSetTimeAlarmClose {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setStageOverlayClose) name:@"SetTimeAlarmClose" object:nil];
}

- (void)registerNotificationSetTimeAlarmOpen {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setStageOverlayOpen) name:@"SetTimeAlarmOpen" object:nil];
}

- (void)setStageOverlayOpen {
    self.overlayView.clipsToBounds = NO;
    self.bottomOverlayView.constant = 0;
   [self setAnimation];
}

- (void)setStageOverlayClose {
    self.bottomOverlayView.constant = - self.view.bounds.size.height;
    self.overlayView.clipsToBounds = YES;
    [self setAnimation];
}

- (void)setStageSideMenu: (BOOL)isSideMenuOpen {
    if (isSideMenuOpen) {
        self.sideMenuViewContainer.clipsToBounds = NO;
        self.leftSideMenuConstraint.constant = 0;
        self.coverButton.alpha = 0.5;
    } else {
        self.leftSideMenuConstraint.constant = - self.sideMenuViewContainer.bounds.size.width;
        self.coverButton.alpha = 0;
        self.sideMenuViewContainer.clipsToBounds = YES;
    }
    [self setAnimation];
}
- (void)setAnimation {
    [UIView animateWithDuration:0.35 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (IBAction)onClickCorverButton:(id)sender {
    self.isSideMenuOpen = !self.isSideMenuOpen;
    [self setStageSideMenu:self.isSideMenuOpen];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
