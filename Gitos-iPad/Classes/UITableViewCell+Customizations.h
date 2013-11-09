//
//  UITableViewCell+Customizations.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/19/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITableViewCell (UITableViewCellCustomizations);

- (void)defineSelectedColor:(UIColor *)color;
- (void)defineSelectedColor:(UIColor *)color forRowAtIndexPath:(NSIndexPath *)indexPath withTotalRows:(int)rows;
- (void)defineAccessoryType;
- (void)defineHighlightedColorsForLabels:(NSArray *)labels;

@end
