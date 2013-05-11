//
//  NewRepoViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/5/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewRepoViewController : GitosViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UITableView *repoFormTable;

@property (strong, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (strong, nonatomic) IBOutlet UITableViewCell *descriptionCell;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;

@property (strong, nonatomic) IBOutlet UITableViewCell *homePageCell;
@property (weak, nonatomic) IBOutlet UITextField *homePageTextField;

@property (strong, nonatomic) IBOutlet UITableViewCell *visibilityCell;

- (void)performHousekeepingTasks;
- (void)registerEvents;
- (void)submitNewRepo;
- (void)handleSuccessfulCreation:(NSNotification *)notification;
- (void)handleCreationFailure:(NSNotification *)notification;
- (void)blurFields;

@end
