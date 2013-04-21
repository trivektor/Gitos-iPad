//
//  GistsViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GistsViewController : GitosViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *gistsTable;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic) int currentPage;
@property (nonatomic, strong) NSMutableArray *gists;
@property (nonatomic, strong) User *user;
@property (nonatomic) BOOL hideBackButton;

- (void)registerNib;
- (void)registerEvents;
- (void)getUserGists:(int)page;
- (void)displayUserGists:(NSNotification *)notification;
- (void)setupPullToRefresh;

@end
