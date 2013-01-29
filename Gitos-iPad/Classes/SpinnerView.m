//
//  SpinnerView.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "SpinnerView.h"

@implementation SpinnerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

+ (SpinnerView *)loadSpinnerIntoView:(UIView *)superView{
    CGRect frame = CGRectMake(500, 250, 60, 60);
    // Create a new view with the same frame size as the superView
    SpinnerView *spinnerView = [[SpinnerView alloc] initWithFrame:frame];
    // If something's gone wrong, abort!
    if(!spinnerView){ return nil; }
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin|
    UIViewAutoresizingFlexibleRightMargin|
    UIViewAutoresizingFlexibleLeftMargin|
    UIViewAutoresizingFlexibleBottomMargin;
    [spinnerView addSubview:indicator];
    [indicator setCenter:CGPointMake(30, 30)];
    [indicator startAnimating];
    
    // Just to show we've done something, let's make the background black
    spinnerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    spinnerView.layer.cornerRadius = 4.0;
    spinnerView.layer.masksToBounds = YES;
    [superView addSubview:spinnerView];
    return spinnerView;
}

- (UIImage *)addBackground
{
    // Create an image context (think of this as a canvas for our masterpiece) the same size as the view
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 1);
    // Our gradient only has two locations - start and finish. More complex gradients might have more colours
    size_t num_locations = 2;
    // The location of the colors is at the start and end
    CGFloat locations[2] = { 0.0, 1.0 };
    // These are the colors! That's two RBGA values
    CGFloat components[8] = {
        0.4,0.4,0.4, 0.8,
        0.1,0.1,0.1, 0.5 };
    // Create a color space
    CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
    // Create a gradient with the values we've set up
    CGGradientRef myGradient = CGGradientCreateWithColorComponents (myColorspace, components, locations, num_locations);
    // Set the radius to a nice size, 80% of the width. You can adjust this
    float myRadius = (self.bounds.size.width*.8)/2;
    // Now we draw the gradient into the context. Think painting onto the canvas
    CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), myGradient, self.center, 0, self.center, myRadius, kCGGradientDrawsAfterEndLocation);
    // Rip the 'canvas' into a UIImage object
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // And release memory
    CGColorSpaceRelease(myColorspace);
    CGGradientRelease(myGradient);
    UIGraphicsEndImageContext();
    // … obvious.
    return image;
}

- (void)removeSpinner
{
    [super removeFromSuperview];
}
@end
