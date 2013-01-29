//
//  LoginViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SpinnerView.h"

@interface LoginViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    
    __weak IBOutlet UITextField *usernameField;
    __weak IBOutlet UITextField *passwordField;
    __weak IBOutlet UITableView *loginTable;
}

@property(nonatomic, strong) IBOutlet UITableViewCell *usernameCell;
@property(nonatomic, strong) IBOutlet UITableViewCell *passwordCell;
@property(nonatomic, strong) SpinnerView *spinnerView;

- (void)performHousekeepingTasks;
- (void)authenticate;
- (void)deleteExistingAuthorizations;
- (void)setDelegates;

@end