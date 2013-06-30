//
//  AttributionsViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 6/29/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttributionsViewController : GitosViewController

@property (weak, nonatomic) IBOutlet UIWebView *fileWebView;

- (void)loadAttributions;

@end
