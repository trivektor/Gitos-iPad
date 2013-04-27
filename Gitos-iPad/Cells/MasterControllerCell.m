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
    // Set the background of a cell when it is selected
    // http://stackoverflow.com/questions/1998775/uitableview-cell-selected-color
    UIView *selectedBackgroundView  = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"selected_cell_bg.png"]]];
    self.selectedBackgroundView     = selectedBackgroundView;

    self.fontAwesomeLabel.font      = [UIFont fontWithName:kFontAwesomeFamilyName size:15];
    self.fontAwesomeLabel.textColor = [UIColor whiteColor];
    self.optionLabel.textColor      = [UIColor whiteColor];

    NSString *fontAwesome = @"", *optionLabelText = @"";

    switch (indexPath.row) {
        case 1:
            fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-rss"];
            optionLabelText  = @"News Feed";
            break;
        case 2:
            fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-github-alt"];
            optionLabelText  = @"Repositories";
            break;
        case 3:
            fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-star-empty"];
            optionLabelText  = @"Watched";
            break;
        case 4:
            fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-file-alt"];
            optionLabelText  = @"Gists";
            break;
        case 5:
            fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-edit"];
            optionLabelText  = @"Profile";
            break;
        case 6:
            fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-search"];
            optionLabelText  = @"Search";
            break;
        case 7:
            fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-bullhorn"];
            optionLabelText  = @"Notifications";
            break;
        case 8:
            fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-envelope"];
            optionLabelText  = @"Feedback";
            break;
        case 9:
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
