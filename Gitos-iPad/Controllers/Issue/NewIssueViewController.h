//
//  NewIssueViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/25/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewIssueViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *issueFormTable;
@property (strong, nonatomic) IBOutlet UITableViewCell *titleCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *descriptionCell;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;

- (void)performHouseKeepingTasks;
- (void)prepIssueFormTable;
- (void)registerEvents;
- (void)submitIssue;

@end
