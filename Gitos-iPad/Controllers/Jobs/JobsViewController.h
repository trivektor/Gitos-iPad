//
//  JobsViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 12/4/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Job.h"
#import "JobCell.h"

@interface JobsViewController : GitosViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *jobs;
@property (weak, nonatomic) IBOutlet UITableView *jobsTable;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic) int currentPage;

- (void)performHousekeepingTasks;
- (void)registerNib;
- (void)registerEvents;
- (void)displayJobs:(NSNotification *)notification;
- (void)searchJobs;

@end
