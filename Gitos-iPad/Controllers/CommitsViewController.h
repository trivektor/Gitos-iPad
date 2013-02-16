//
//  CommitsViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/13/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repo.h"
#import "MBProgressHUD.h"

@interface CommitsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) Repo *repo;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSString *branch;
@property (nonatomic, strong) NSString *sha;
@property (nonatomic, strong) NSString *endSha;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSMutableArray *commits;
@property (nonatomic) NSInteger currentPage;

@property (nonatomic, weak) IBOutlet UITableView *commitsTable;

- (void)performHouseKeepingTasks;
- (void)registerNib;
- (void)fetchCommits;

@end
