//
//  ReadmeViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/10/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadmeViewController : UIViewController

@property (nonatomic, strong) Readme *readme;
@property (weak, nonatomic) IBOutlet UIWebView *fileView;

- (void)displayReadmeContent;

@end
