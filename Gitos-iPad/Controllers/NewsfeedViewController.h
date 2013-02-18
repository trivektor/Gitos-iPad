//
//  NewsfeedViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "TimelineEvent.h"
#import "MasterViewController.h"

@interface NewsfeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UITableView *newsFeedTable;
}

@property (nonatomic, strong) NSMutableArray *newsFeed;
@property (nonatomic, strong) User *user;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSString *accessToken;

- (void)performHouseKeepingTasks;
- (void)prepareTableView;
- (void)getUserInfoAndNewsFeed;
- (void)getUserNewsFeed:(NSInteger)page;
- (void)setupPullToRefresh;
- (void)reloadNewsfeed;

@end
