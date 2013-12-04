//
//  RepoContributorsViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 7/4/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface RepoContributorsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *contributorsTable;
@property (nonatomic, strong) NSMutableArray *contributors;
@property (nonatomic, strong) Repo *repo;
@property (nonatomic, strong) MBProgressHUD *hud;

- (void)performHouseKeepingTasks;
- (void)registerEvents;
- (void)displayContributors:(NSNotification *)notification;

@end
