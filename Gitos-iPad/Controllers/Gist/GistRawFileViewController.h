//
//  GistRawFileViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GistFile.h"

@interface GistRawFileViewController : UIViewController <UIWebViewDelegate, NSURLConnectionDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *fileWebView;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) GistFile *gistFile;
@property (nonatomic, strong) NSString *theme;
@property (nonatomic, strong) NSArray *themes;
@property (nonatomic, strong) UIActionSheet *themesOptions;

- (void)performHouseKeepingTasks;
- (void)fetchRawFile;
- (void)switchTheme;
- (NSString *)encodeHtmlEntities:(NSString *)rawHtmlString;

@end