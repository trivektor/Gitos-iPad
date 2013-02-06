//
//  RecentActivityViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/5/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "SpinnerView.h"

@interface RecentActivityViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *activityTable;
@property (nonatomic, strong) NSMutableArray *activities;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) SpinnerView *spinnerView;
@property (nonatomic, strong) NSString *accessToken;

- (void)fetchActivities;
- (void)performHouseKeepingTasks;

@end
