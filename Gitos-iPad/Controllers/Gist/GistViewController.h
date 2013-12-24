//
//  GistViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "Gist.h"
#import "User.h"

@interface GistViewController : GitosViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UITableView *detailsTable;
@property (nonatomic, strong) IBOutlet UITableView *filesTable;
@property (nonatomic, strong) Gist *gist;
@property (nonatomic, strong) NSMutableArray *files;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIActionSheet *actionOptions;
@property (nonatomic) BOOL isStarring;

- (void)performHouseKeepingTasks;
- (void)registerNib;
- (void)registerEvents;
- (void)getGistStats;
- (void)displayGistStats:(NSNotification *)notification;
- (UITableViewCell *)cellForDetailsTableAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)cellForBranchesTableAtIndexPath:(NSIndexPath *)indexPath;
- (void)prepareActionOptionsForStatus:(NSNotification *)notification;
- (void)showAvailableActions;
- (void)updateStarredStatus;
- (void)postToTwitter:(NSObject *)object;

@end