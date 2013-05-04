//
//  IssuesViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/10/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repo.h"
#import "User.h"

@interface IssuesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Repo *repo;
@property (nonatomic, weak) IBOutlet UITableView *issuesTable;
@property (nonatomic, strong) NSMutableArray *issues;
@property (nonatomic) NSInteger *currentPage;
@property (nonatomic, strong) MBProgressHUD *hud;

- (void)performHouseKeepingTasks;
- (void)registerNib;
- (void)registerEvents;
- (void)displayIssues:(NSNotification *)notification;

@end
