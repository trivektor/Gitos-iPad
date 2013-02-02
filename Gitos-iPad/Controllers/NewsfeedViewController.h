//
//  NewsfeedViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "SpinnerView.h"
#import "RelativeDateDescriptor.h"
#import "TimelineEvent.h"
#import "MasterViewController.h"

@interface NewsfeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UITableView *newsFeedTable;
}

@property (nonatomic, strong) NSMutableArray *newsFeed;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) SpinnerView *spinnerView;
@property (nonatomic) NSInteger currentPage;

- (void)performHouseKeepingTasks;
- (void)prepareTableView;
- (void)getUserInfoAndNewsFeed;
- (void)getUserNewsFeed:(NSInteger)page;
- (void)setupPullToRefresh;
- (void)reloadNewsfeed;

@end
