//
//  IssuesViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/10/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Repo.h"
#import "User.h"

@interface IssuesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Repo *repo;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, weak) IBOutlet UITableView *issuesTable;
@property (nonatomic, strong) NSMutableArray *issues;
@property (nonatomic) NSInteger *currentPage;

- (void)performHouseKeepingTasks;
- (void)fetchIssues:(NSInteger)page;

@end
