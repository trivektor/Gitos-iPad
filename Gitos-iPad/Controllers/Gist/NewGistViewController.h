//
//  NewGistViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 4/23/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewGistViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *gistFormTable;

@property (strong, nonatomic) IBOutlet UITableViewCell *descriptionCell;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;

@property (strong, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (strong, nonatomic) IBOutlet UITableViewCell *contentCell;
@property (weak, nonatomic) IBOutlet UITextView *contentTextField;


- (void)performHouseKeepingTasks;
- (void)registerEvents;
- (void)submitGist;
- (NSDictionary *)prepDataForSubmission;
- (void)handleServerResponse:(NSNotification *)notification;
- (void)blurTextFields;

@end
