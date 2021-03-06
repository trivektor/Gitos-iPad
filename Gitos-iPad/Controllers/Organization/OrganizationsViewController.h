//
//  OrganizationsViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/6/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "User.h"

@interface OrganizationsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *organizationsTable;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSMutableArray *organizations;
@property (nonatomic) int currentPage;

- (void)performHouseKeepingTasks;
- (void)registerEvents;
- (void)fetchOrganizations;
- (void)displayOrganizations:(NSNotification *)notification;

@end
