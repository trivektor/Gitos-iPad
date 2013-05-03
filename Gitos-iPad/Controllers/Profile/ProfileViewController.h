//
//  ProfileViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "User.h"

@interface ProfileViewController : GitosViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIImageView *avatar;
@property (nonatomic, weak) IBOutlet UITableView *profileTable;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *loginLabel;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIActionSheet *optionsActionSheet;
@property (nonatomic) BOOL hideOptionsButton;
@property (nonatomic) BOOL isFollowing;

- (void)performHouseKeepingTasks;
- (void)registerEvents;
- (void)addOptionsButton;
- (void)showProfileOptions;
- (void)prepareProfileOptions:(NSNotification *)notification;
- (void)prepareProfileTable;
- (void)displayUsernameAndAvatar;
- (void)adjustFrameHeight;
- (void)viewProfileOnGithub;
- (void)mailProfileToEmail:(NSString *)email WithSubject:(NSString *)subject;
- (void)loadWebsiteWithUrl:(NSString *)url;
- (void)showEditButtonIfEditable;
- (void)editProfile;
- (void)respondToFollowingEvents:(NSNotification *)notification;

@end