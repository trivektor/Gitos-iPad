//
//  RepoTreeViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Branch.h"
#import "RepoTreeNode.h"
#import "RepoTreeCell.h"

@interface RepoTreeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *treeTable;
@property (nonatomic, retain) NSMutableArray *treeNodes;
@property (nonatomic, strong) NSString *branchUrl;
@property (nonatomic, strong) Branch *branch;
@property (nonatomic, strong) Repo *repo;
@property (nonatomic, strong) RepoTreeNode *node;
@property (nonatomic, strong) MBProgressHUD *hud;

- (void)performHouseKeepingTasks;
- (void)registerEvents;
- (void)fetchData;
- (void)displayTree:(NSNotification *)notification;
- (void)fetchBlob;
- (void)showCommitForBranch;

@end
