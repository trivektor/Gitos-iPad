//
//  OrganizationsViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/6/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "User.h"

@interface OrganizationsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *organizationsTable;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSMutableArray *organizations;

- (void)performHouseKeepingTasks;
- (void)fetchOrganizations;

@end
