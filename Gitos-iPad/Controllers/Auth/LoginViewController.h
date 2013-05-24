//
//  LoginViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate>
{
    __weak IBOutlet UITableView *loginTable;
    __weak IBOutlet UITextField *usernameField;
    __weak IBOutlet UITextField *passwordField;
}

@property(nonatomic, strong) IBOutlet UITableViewCell *usernameCell;
@property(nonatomic, strong) IBOutlet UITableViewCell *passwordCell;
@property(nonatomic, strong) MBProgressHUD *hud;
@property(nonatomic, strong) NSMutableDictionary *oauthParams;
@property (weak, nonatomic) IBOutlet FUIButton *signinButton;
@property (nonatomic, strong) UIActionSheet *optionsSheet;


- (void)performHousekeepingTasks;
- (void)prepLoginTable;
- (void)prepAccountOptions;
- (void)registerEvents;
- (void)authenticate;
- (void)fetchUser;
- (void)deleteExistingAuthorizations;
- (void)setDelegates;
- (void)handleInvalidCredentials;
- (void)blurFields;
- (void)showAccountOptions;

@end