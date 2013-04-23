//
//  NewsfeedDetailsViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelineEvent.h"

@interface NewsfeedDetailsViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) TimelineEvent *event;

- (void)performHouseKeepingTasks;
- (void)loadNewsfeedDetails;
- (void)reloadNewsfeedDetails;
- (void)showMenu;

@end

