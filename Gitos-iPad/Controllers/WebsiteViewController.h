//
//  WebsiteViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/5/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface WebsiteViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSString *requestedUrl;
@property (nonatomic, weak) IBOutlet UIWebView *websiteView;
@property (nonatomic, strong) MBProgressHUD *hud;

- (void)performHouseKeepingTasks;
- (void)loadWebsite;
- (void)showOptions;
- (void)openInSafari;
- (void)mailLink;
- (void)copyLink;

@end
