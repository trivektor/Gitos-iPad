//
//  AccountViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/23/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webpageView;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *pageTitle;

- (void)loadUrl;
- (void)cancel;

@end
