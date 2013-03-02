//
//  MasterViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/1/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MasterViewControllerDelegate;

@interface MasterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UISplitViewController *parentViewController;
@property (nonatomic, weak) IBOutlet UITableView *menuTable;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) id<MasterViewControllerDelegate> delegate;

- (void)performHouseKeepingTasks;
- (void)signout;

@end

@protocol MasterViewControllerDelegate <NSObject>

- (void)didSelectViewController:(UIViewController *)controller;

@end