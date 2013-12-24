//
//  RepoViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Repo.h"
#import "RepoMiscViewController.h"
#import <Social/Social.h>

@interface RepoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *detailsTable;
@property (nonatomic, weak) IBOutlet UITableView *branchesTable;
@property (nonatomic, weak) IBOutlet UIScrollView *repoScrollView;
@property (nonatomic, strong) Repo *repo;
@property (nonatomic, strong) NSMutableArray *repoBranches;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIActionSheet *actionOptions;
@property (nonatomic, strong) UIAlertView *deleteConfirmation;
@property (nonatomic) BOOL *isWatching;
@property (nonatomic) RepoMiscViewController *repoMiscController;
@property (nonatomic, strong) NSString *starOption;

- (void)performHouseKeepingTasks;
- (void)registerNib;
- (void)registerNotifications;
- (UITableViewCell *)cellForDetailsTableAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)cellForBranchesTableAtIndexPath:(NSIndexPath *)indexPath;
- (void)adjustFrameHeight;
- (void)populateBranches:(NSNotification *)notification;
- (void)prepareActionOptionsForStatus:(NSNotification *)notification;
- (void)showAvailableActions;
- (void)updateStarredStatus;
- (void)displayRepoInfo:(NSNotification *)notification;
- (void)showReadme:(NSNotification *)notification;
- (void)handlePostDestroyEvent:(NSNotification *)notification;
- (void)handlePostForkEvent:(NSNotification *)notification;
- (void)closeRepoMiscModal;
- (void)showRepoMiscInfo:(NSNotification *)notification;

@end
