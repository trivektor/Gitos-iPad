//
//  GistRawFileViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "GistFile.h"

@interface GistRawFileViewController : UIViewController <UIWebViewDelegate, NSURLConnectionDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *fileWebView;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) GistFile *gistFile;

- (void)performHouseKeepingTasks;
- (NSString *)encodeHtmlEntities:(NSString *)rawHtmlString;

@end