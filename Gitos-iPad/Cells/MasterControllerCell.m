//
//  MasterControllerCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/3/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "MasterControllerCell.h"
#import "NSString+FontAwesome.h"

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

    NSString *fontAwesome, *optionLabelText;

    if (indexPath.row == 0) {
        fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-rss"];
        optionLabelText  = @"News Feed";
    } else if (indexPath.row == 1) {
        fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-github"];
        optionLabelText  = @"Repositories";
    } else if (indexPath.row == 2) {
        fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-star"];
        optionLabelText  = @"Watched";
    } else if (indexPath.row == 3) {
        fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-file-alt"];
        optionLabelText  = @"Gists";
    } else if (indexPath.row == 4) {
        fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-user"];
        optionLabelText  = @"Profile";
    } else if (indexPath.row == 5) {
        fontAwesome      = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-search"];
        optionLabelText  = @"Search";
    }

    self.fontAwesomeLabel.text = fontAwesome;
    self.optionLabel.text      = optionLabelText;
}

@end
