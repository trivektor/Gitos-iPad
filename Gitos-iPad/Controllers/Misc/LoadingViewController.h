//
//  LoadingViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 4/26/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingViewController : UIViewController

@property (nonatomic, strong) MBProgressHUD *hud;

- (void)enterMainStage:(NSNotification *)notification;

@end
