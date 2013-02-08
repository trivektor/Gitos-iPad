//
//  RepoSearchViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "User.h"
#import "MBProgressHUD.h"

@interface RepoSearchViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property(nonatomic, weak) IBOutlet UITableView *searchResultsTable;
@property(nonatomic, strong) NSString *accessToken;
@property(nonatomic, strong) MBProgressHUD *hud;
@property(nonatomic, strong) NSMutableArray *searchResults;
@property(nonatomic, strong) User *user;

- (void)performHouseKeepingTasks;
- (void)prepareTableView;

@end