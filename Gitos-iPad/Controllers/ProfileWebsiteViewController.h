//
//  ProfileWebsiteViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/5/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "SpinnerView.h"

@interface ProfileWebsiteViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *profileWebView;
@property (nonatomic, strong) SpinnerView *spinnerView;
@property (nonatomic, strong) User *user;

- (void)loadWebPage;

@end
