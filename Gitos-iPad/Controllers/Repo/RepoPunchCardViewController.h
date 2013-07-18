//
//  RepoPunchCardViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 7/17/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepoPunchCardViewController : UIViewController

@property (nonatomic, strong) Repo *repo;
@property (weak, nonatomic) IBOutlet UIWebView *dataWebView;

- (void)displayPunchCard;

@end
