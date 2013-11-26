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
@property (nonatomic, strong) User *user;
@property (strong, nonatomic) IBOutlet UITableViewCell *profileCell;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

- (void)performHouseKeepingTasks;
- (void)navigateToSelectedController:(UINavigationController *)selectedController;
- (void)signout;
- (void)displayAvatarAndUsername;

@end

@protocol MasterViewControllerDelegate <NSObject>

- (void)didSelectViewController:(UIViewController *)controller;

@end