//
//  NewIssueCommentViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/12/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewIssueCommentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *commentTextField;
@property (nonatomic, strong) Repo *repo;
@property (nonatomic, strong) Issue *issue;

- (void)performHouseKeepingTasks;
- (void)registerEvents;
- (void)dismiss;
- (void)submitComment;
- (void)handleCommentSubmittedEvent:(NSNotification *)notification;

@end
