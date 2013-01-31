//
//  GistRawFileViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"
#import "GistFile.h"

@interface GistRawFileViewController : UIViewController <UIWebViewDelegate, NSURLConnectionDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *fileWebView;
@property (nonatomic, strong) SpinnerView *spinnerView;
@property (nonatomic, strong) GistFile *gistFile;

@end