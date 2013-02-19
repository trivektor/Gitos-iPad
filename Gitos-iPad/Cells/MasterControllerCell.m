//
//  MasterControllerCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/3/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "MasterControllerCell.h"

@implementation MasterControllerCell

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

- (void)renderForIndexPath:(NSIndexPath *)indexPath
{
    self.fontAwesomeLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];

    NSString *fontAwesome = @"", *optionLabelText = @"";

    switch (indexPath.row) {
        case 0:
            fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-rss"];
            optionLabelText  = @"News Feed";
            break;
        case 1:
            fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-github"];
            optionLabelText  = @"Repositories";
            break;
        case 2:
            fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-star"];
            optionLabelText  = @"Watched";
            break;
        case 3:
            fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-file-alt"];
            optionLabelText  = @"Gists";
            break;
        case 4:
            fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-user"];
            optionLabelText  = @"Profile";
            break;
        case 5:
            fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-search"];
            optionLabelText  = @"Search";
            break;
        case 6:
            fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-bullhorn"];
            optionLabelText  = @"Notifications";
            break;
        case 7:
            fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-thumbs-up"];
            optionLabelText  = @"Feedback";
            break;
        case 8:
            fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-signout"];
            optionLabelText  = @"Sign out";
            break;
        default:
            break;
    }

    self.fontAwesomeLabel.text = fontAwesome;
    self.optionLabel.text      = optionLabelText;
}

@end
