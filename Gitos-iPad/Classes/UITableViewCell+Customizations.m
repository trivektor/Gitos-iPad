//
//  UITableViewCell+Customizations.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/19/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "UITableViewCell+Customizations.h"
#import "CustomCellBackgroundView.h"

@implementation UITableViewCell (UITableViewCellCustomizations)

- (void)defineSelectedColor:(UIColor *)color
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
    backgroundView.backgroundColor = [UIColor colorWithRed:244/255.0
                                                     green:244/255.0
                                                      blue:244/255.0
                                                     alpha:1.0];
    self.selectedBackgroundView = backgroundView;
}

- (void)defineSelectedColor:(UIColor *)color forRowAtIndexPath:(NSIndexPath *)indexPath withTotalRows:(int)rows
{
    CustomCellBackgroundViewPosition pos = CustomCellBackgroundViewPositionBottom;

    if (indexPath.row == 0) {
        pos = CustomCellBackgroundViewPositionTop;
    } else {
        if (indexPath.row < rows - 1) {
            pos = CustomCellBackgroundViewPositionMiddle;
        }
    }

    if (rows == 1) {
        pos = CustomCellBackgroundViewPositionSingle;
    }

    CustomCellBackgroundView *backgroundView = [[CustomCellBackgroundView alloc] initWithFrame:self.bounds];
    backgroundView.fillColor = [UIColor colorWithRed:244/255.0
                                               green:244/255.0
                                                blue:244/255.0
                                               alpha:1.0];
    backgroundView.position = pos;
    backgroundView.borderColor = [UIColor colorWithRed:180/255.0
                                                 green:180/255.0
                                                  blue:180/255.0
                                                 alpha:1.0];
    backgroundView.layer.masksToBounds = YES;
    backgroundView.clipsToBounds = YES;
    self.selectedBackgroundView = backgroundView;
}

- (void)defineAccessoryType
{
    DTCustomColoredAccessory *accessory = [DTCustomColoredAccessory accessoryWithColor:[UIColor asbestosColor]];
    accessory.highlightedColor = [UIColor asbestosColor];
    self.accessoryView = accessory;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
