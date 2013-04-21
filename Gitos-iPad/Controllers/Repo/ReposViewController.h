//
//  ReposViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "User.h"

@interface ReposViewController : GitosViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) User *user;
@property (nonatomic, weak) IBOutlet UITableView *reposTable;
@property (nonatomic, strong) NSMutableArray *repos;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic) Boolean hideBackButton;
@property (nonatomic) int currentPage;

- (void)registerNib;
- (void)registerEvents;
- (void)getUserRepos;
- (void)displayUserRepos:(NSNotification *)notification;

@end