//
//  GistsViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface GistsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *gistsTable;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *gists;
@property (nonatomic, strong) User *user;
@property (nonatomic) BOOL hideBackButton;

- (void)registerNib;
- (void)getUserInfo;
- (void)getUserGists:(NSInteger)page;
- (void)setupPullToRefresh;

@end
