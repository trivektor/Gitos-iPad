//
//  RepoTreeViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Branch.h"
#import "Repo.h"
#import "RepoTreeNode.h"

@interface RepoTreeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *treeTable;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSMutableDictionary *accessTokenParams;
@property (nonatomic, strong) NSMutableArray *treeNodes;
@property (nonatomic, strong) NSString *branchUrl;
@property (nonatomic, strong) Branch *branch;
@property (nonatomic, strong) Repo *repo;
@property (nonatomic, strong) RepoTreeNode *node;
@property (nonatomic, strong) MBProgressHUD *hud;

- (void)performHouseKeepingTasks;
- (void)fetchData;
- (void)fetchTopLayer;
- (void)fetchTree;
- (void)fetchBlob;
- (void)showCommitForBranch;

@end
