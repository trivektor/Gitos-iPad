//
//  UITableView+Shadow.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "UITableView+Shadow.h"

@implementation UITableView (TableShadows)

- (void)drawShadow
{
    [self setClipsToBounds:YES];

    CALayer *layer = self.layer;

    [layer setShouldRasterize:YES];
    [layer setMasksToBounds:YES];
    [layer setShadowColor:[[UIColor blackColor] CGColor]];
    [layer setShadowOffset:CGSizeMake(1, 2)];
    [layer setShadowRadius:1.0];
    [layer setShadowOpacity:0.1];
    [layer setRasterizationScale:[[UIScreen mainScreen] scale]];
}

@end
