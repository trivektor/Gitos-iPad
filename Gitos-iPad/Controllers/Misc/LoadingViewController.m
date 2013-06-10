//
//  LoadingViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 4/26/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "LoadingViewController.h"
#import "LoginViewController.h"
#import "AppInitialization.h"

@interface LoadingViewController ()

@end

@implementation LoadingViewController

@synthesize hud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(enterMainStage:)
                                                     name:@"AuthenticatedUserFetched"
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = LOADING_MESSAGE;

    [self registerEvents];

    [User fetchInfoForUserWithToken:[AppHelper getAccessToken]];
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRevokedToken)
                                                 name:@"AccessTokenRevoked"
                                               object:nil];
}

- (void)handleRevokedToken
{
    NSLog(@"Access token revoked");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Looks like your access has been revoked. Please relogin" delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //'OK' was clicked
        [SSKeychain deletePasswordForService:@"access_token"
                                     account:@"gitos"];

        LoginViewController *loginController = [[LoginViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginController];
        [self.view.window setRootViewController:navController];
    }
}

- (void)enterMainStage:(NSNotification *)notification
{
    User *currentUser = (User *)notification.object;
    [CurrentUserManager initializeWithUser:currentUser];
    NSString *account = [AppConfig getConfigValue:@"KeychainAccountName"];
    [SSKeychain setPassword:[currentUser getLogin] forService:@"username" account:account];
    [AppInitialization run:(self.view.window) withUser:currentUser];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
