//
//  ContributionsViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/23/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContributionsViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) User *user;
@property (nonatomic, weak) IBOutlet UIWebView *contributionsView;

- (void)performHouseKeepingTasks;
- (void)fetchContributions;

@end
