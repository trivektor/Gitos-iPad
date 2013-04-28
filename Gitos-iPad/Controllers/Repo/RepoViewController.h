//
//  RepoViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Repo.h"

@interface RepoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet UITableView *detailsTable;
@property (nonatomic, weak) IBOutlet UITableView *branchesTable;
@property (nonatomic, weak) IBOutlet UIScrollView *repoScrollView;
@property (nonatomic, strong) Repo *repo;
@property (nonatomic, strong) NSMutableArray *repoBranches;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIActionSheet *actionOptions;
@property (nonatomic) BOOL *isWatching;

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

@end
