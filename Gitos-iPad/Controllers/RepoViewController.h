//
//  RepoViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repo.h"
#import "MBProgressHUD.h"

@interface RepoViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *detailsTable;
@property (nonatomic, weak) IBOutlet UITableView *branchesTable;
@property (nonatomic, weak) IBOutlet UIScrollView *repoScrollView;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) Repo *repo;
@property (nonatomic, strong) NSMutableArray *repoBranches;
@property (nonatomic, strong) MBProgressHUD *hud;

- (void)performHouseKeepingTasks;
- (void)registerNib;
- (UITableViewCell *)cellForDetailsTableAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)cellForBranchesTableAtIndexPath:(NSIndexPath *)indexPath;
- (void)getRepoBranches;
- (void)adjustFrameHeight;

@end
