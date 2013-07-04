//
//  RepoMiscViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 7/4/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDSemiModalViewController.h"

@interface RepoMiscViewController : TDSemiModalViewController

@property (weak, nonatomic) IBOutlet UIView *halfModal;

@property (weak, nonatomic) IBOutlet UIButton *contributorsBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitsActivityBtn;
@property (weak, nonatomic) IBOutlet UIButton *punchCardBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeModalBtn;

- (IBAction)showContributors:(id)sender;
- (IBAction)showCommitsActivity:(id)sender;
- (IBAction)showPunchCard:(id)sender;
- (void)postCloseMiscModalNotification;

@end
