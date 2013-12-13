//
//  JobsViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 12/4/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Job.h"

@interface JobsViewController : GitosViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *jobs;
@property (weak, nonatomic) IBOutlet UITableView *jobsTable;

- (void)performHousekeepingTasks;
- (void)registerEvents;
- (void)displayJobs:(NSNotification *)notification;

@end
