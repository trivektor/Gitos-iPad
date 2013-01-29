//
//  GistViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gist.h"
#import "User.h"
#import "SpinnerView.h"

@interface GistViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UITableView *detailsTable;
    __weak IBOutlet UITableView *filesTable;
}

@property (nonatomic, strong) Gist *gist;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSDictionary *accessTokenParams;
@property (nonatomic, strong) NSMutableArray *files;
@property (nonatomic, strong) SpinnerView *spinnerView;

- (void)performHouseKeepingTasks;
- (void)getGistStats;
- (void)setGistStats:(NSDictionary *)stats;

@end