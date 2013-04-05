//
//  ProfileViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "User.h"

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIImageView *avatar;
@property (nonatomic, weak) IBOutlet UITableView *profileTable;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *loginLabel;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSMutableDictionary *accessTokenParams;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIActionSheet *optionsActionSheet;
@property (nonatomic) Boolean hideBackButton;
@property (nonatomic) BOOL hideOptionsButton;
@property (nonatomic) BOOL isFollowing;

- (void)performHouseKeepingTasks;
- (void)addOptionsButton;
- (void)showProfileOptions;
- (void)prepareProfileTable;
- (void)getUserInfo;
- (void)displayUserInfo:(NSNotification *)notification;
- (void)displayUsernameAndAvatar;
- (void)adjustFrameHeight;
- (void)displayFollowOptions;
- (void)follow;
- (void)unfollow;
- (void)viewProfileOnGithub;
- (void)mailProfile;
- (void)copyProfile;
- (void)mailProfileToEmail:(NSString *)email WithSubject:(NSString *)subject;
- (void)loadWebsiteWithUrl:(NSString *)url;

@end