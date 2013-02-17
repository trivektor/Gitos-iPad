//
//  SearchViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/16/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UISegmentedControl *searchCriteria;
@property (nonatomic, weak) IBOutlet UITableView *resultsTable;

- (void)performHouseKeepingTasks;
- (void)prepareSearchBar;
- (BOOL)isUserSearch;
- (BOOL)isRepoSearch;
- (void)searchUsers:(NSString *)term;
- (void)searchRepos:(NSString *)term;

@end
