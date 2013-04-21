//
//  FollowViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/4/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface FollowViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) User *user;

@property (nonatomic, weak) IBOutlet UITableView *usersTable;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *controllerTitle;

@property (nonatomic, strong) NSString *usersUrl;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic) NSInteger currentPage;

- (void)fetchUsers:(NSInteger)page;

@end
