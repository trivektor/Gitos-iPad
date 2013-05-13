//
//  GistCommentsViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/12/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gist.h"

@interface GistCommentsViewController : UIViewController

@property (nonatomic, strong) Gist *gist;

- (void)performHouseKeepingTasks;
- (void)registerEvents;
- (void)displayComments:(NSNotification *)notification;

@end
