//
//  FeedbackViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface FeedbackViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (nonatomic, strong) IBOutlet UITextField *emailField;
@property (nonatomic, strong) IBOutlet UITextView *messageField;
@property (nonatomic, strong) MBProgressHUD *hud;

- (void)performHouseKeepingTasks;
- (void)applyCustomStyling;
- (void)sendFeedback;

@end

@interface CustomUITextField : UITextField

@property (nonatomic, assign) float verticalPadding;
@property (nonatomic, assign) float horizontalPadding;

@end

