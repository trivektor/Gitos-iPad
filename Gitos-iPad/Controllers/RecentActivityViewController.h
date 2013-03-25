//
//  RecentActivityViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/5/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "User.h"

@interface RecentActivityViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *activityTable;
@property (nonatomic, strong) NSMutableArray *activities;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic) NSInteger currentPage;

- (void)fetchActivities:(NSInteger)page;
- (void)performHouseKeepingTasks;
- (void)registerNib;
- (void)reloadActivities;
- (void)setupPullToRefresh;

@end
