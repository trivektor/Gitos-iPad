//
//  RepoCodeSearchViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 11/19/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepoCodeSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) Repo *repo;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *resultsTable;
@property (nonatomic, strong) NSMutableArray *searchResults;

- (void)registerEvents;
- (void)displaySearchResults:(NSNotification *)notification;

@end
