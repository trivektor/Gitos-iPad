//
//  RepoLanguagesViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/11/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepoLanguagesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Repo *repo;
@property (nonatomic, strong) NSMutableDictionary *languages;
@property (weak, nonatomic) IBOutlet UITableView *languagesTable;

- (void)performHouseKeepingTasks;
- (void)registerEvents;
- (void)fetchLanguages;
- (void)displayLanguages:(NSNotification *)notification;

@end
