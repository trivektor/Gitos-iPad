//
//  MasterControllerCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/3/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "MasterControllerCell.h"

@implementation MasterControllerCell

@synthesize fontAwesomeLabel, optionLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)renderForIndexPath:(NSIndexPath *)indexPath withNumRows:(int)numRows
{
    fontAwesomeLabel.font      = [UIFont fontWithName:kFontAwesomeFamilyName size:15];
    fontAwesomeLabel.textColor = [UIColor whiteColor];
    optionLabel.textColor      = [UIColor whiteColor];

    NSString *fontAwesome = @"", *optionLabelText = @"";

    if (indexPath.section == 1 && indexPath.row == 0) {
        fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-rss"];
        optionLabelText  = @"News Feed";
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-github"];
                optionLabelText  = @"Personal";
                break;
            case 1:
                fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-star-empty"];
                optionLabelText  = @"Starred";
                break;
            case 2:
                fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-plus-sign"];
                optionLabelText  = @"New Repository";
                break;
        }
    } else if (indexPath.section == 3) {
        switch (indexPath.row) {
            case 0:
                fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-code"];
                optionLabelText  = @"Gists";
                break;
            case 1:
                fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-search"];
                optionLabelText  = @"Search";
                break;
            case 2:
                fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-bullhorn"];
                optionLabelText  = @"Notifications";
                break;
            case 3:
                fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-envelope"];
                optionLabelText  = @"Feedback";
                break;
            case 4:
                fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-off"];
                optionLabelText  = @"Sign out";
                break;
            case 5:
                fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-legal"];
                optionLabelText  = @"Attributions";
                break;
        }
    }

    fontAwesomeLabel.text = fontAwesome;
    optionLabel.text      = optionLabelText;

    if (indexPath.row < numRows - 1) {
        UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 190, 1)];
        bottomBorder.backgroundColor = [UIColor colorWithRed:255/255.0
                                                       green:255/255.0
                                                        blue:255/255.0
                                                       alpha:0.3];
        [self.contentView addSubview:bottomBorder];
    }

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

@end
