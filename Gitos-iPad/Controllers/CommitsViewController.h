//
//  CommitsViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/13/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommitsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *branch;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSMutableArray *commits;

@property (nonatomic, weak) IBOutlet UITableView *commitsTable;

- (void)performHouseKeepingTasks;
- (void)registerNib;

@end
