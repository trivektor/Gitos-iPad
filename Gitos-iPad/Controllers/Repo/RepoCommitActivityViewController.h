//
//  RepoCommitActivityViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 7/6/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepoCommitActivityViewController : UIViewController

@property (nonatomic, strong) Repo *repo;

- (void)performHouseKeepingTasks;

@end
