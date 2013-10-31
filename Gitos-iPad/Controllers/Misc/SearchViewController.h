//
//  SearchViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/16/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

@interface SearchViewController : GitosViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) UISegmentedControl *searchCriteria;
@property (nonatomic, weak) IBOutlet UITableView *resultsTable;
@property (nonatomic, strong) User *user;

- (void)performHouseKeepingTasks;
- (BOOL)isUserSearch;
- (BOOL)isRepoSearch;
- (void)searchUsers:(NSString *)term;
- (void)searchRepos:(NSString *)term;
- (void)fetchUserAtIndexPath:(NSIndexPath *)indexPath;
- (void)fetchRepoAtIndexPath:(NSIndexPath *)indexPath;

@end
