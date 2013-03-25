//
//  RawFileViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "Repo.h"
#import "Branch.h"

@interface RawFileViewController : UIViewController <UIWebViewDelegate, NSURLConnectionDataDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *fileWebView;
@property (nonatomic, strong) Repo *repo;
@property (nonatomic, strong) Branch *branch;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *mimeType;
@property (nonatomic, strong) NSURL *rawFileUrl;
@property (nonatomic, strong) NSURLRequest *rawFileRequest;
@property (nonatomic, strong) NSString *theme;
@property (nonatomic, strong) NSArray *themes;
@property (nonatomic, strong) UIActionSheet *themesOptions;

- (void)fetchRawFile;
- (void)switchTheme;
- (NSString *)encodeHtmlEntities:(NSString *)rawHtmlString;

@end