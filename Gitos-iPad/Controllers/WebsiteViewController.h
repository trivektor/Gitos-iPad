//
//  WebsiteViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/5/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface WebsiteViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSString *requestedUrl;
@property (nonatomic, weak) IBOutlet UIWebView *websiteView;
@property (nonatomic, strong) MBProgressHUD *hud;

- (void)loadWebsite;

@end
