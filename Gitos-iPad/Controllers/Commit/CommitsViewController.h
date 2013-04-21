//
//  CommitsViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/13/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Branch.h"

@interface CommitsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) Repo *repo;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) Branch *branch;
@property (nonatomic, strong) NSMutableArray *commits;

@property (nonatomic, weak) IBOutlet UITableView *commitsTable;

- (void)performHouseKeepingTasks;
- (void)registerNib;
- (void)registerEvents;
- (void)fetchCommits;
- (void)displayCommits:(NSNotification *)notification;

@end
