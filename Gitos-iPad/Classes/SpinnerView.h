//
//  SpinnerView.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SpinnerView : UIView

+ (SpinnerView *)loadSpinnerIntoView:(UIView *)superView;
- (UIImage *)addBackground;
- (void)removeSpinner;

@end
