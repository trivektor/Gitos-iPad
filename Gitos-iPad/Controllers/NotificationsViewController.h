//
//  NotificationsViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *notificationsTable;
@property (nonatomic, strong) NSMutableArray *notifications;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic) NSInteger *currentPage;
@property (nonatomic, strong) NSString *accessToken;

- (void)performHouseKeepingTasks;
- (void)registerNib;
- (void)setupPullToRefresh;
- (void)fetchNotificationsForPage:(NSInteger)page;

@end
