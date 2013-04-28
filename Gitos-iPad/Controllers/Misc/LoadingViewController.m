//
//  LoadingViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 4/26/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "LoadingViewController.h"
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

    [User fetchInfoForUserWithToken:[AppHelper getAccessToken]];
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
