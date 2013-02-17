//
//  ProfileViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "User.h"

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIImageView *avatar;
@property (nonatomic, weak) IBOutlet UITableView *profileTable;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *loginLabel;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic) Boolean hideBackButton;

- (void)performHouseKeepingTasks;
- (void)prepareProfileTable;
- (void)getUserInfo;
- (void)displayUsernameAndAvatar;
- (void)adjustFrameHeight;

@end