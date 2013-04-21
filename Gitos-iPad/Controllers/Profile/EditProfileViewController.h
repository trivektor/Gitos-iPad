//
//  EditProfileViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 4/20/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) User *user;

@property (nonatomic, strong) IBOutlet UITableViewCell *nameCell;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;

@property (nonatomic, strong) IBOutlet UITableViewCell *emailCell;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;

@property (nonatomic, strong) IBOutlet UITableViewCell *websiteCell;
@property (nonatomic, weak) IBOutlet UITextField *websiteTextField;

@property (nonatomic, strong) IBOutlet UITableViewCell *companyCell;
@property (nonatomic, weak) IBOutlet UITextField *companyTextField;

@property (nonatomic, strong) IBOutlet UITableViewCell *locationCell;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;

@property (weak, nonatomic) IBOutlet UITableView *profileTableForm;


- (void)performHousekeepingTasks;
- (void)populateUserInfo;
- (void)updateInfo;

@end
