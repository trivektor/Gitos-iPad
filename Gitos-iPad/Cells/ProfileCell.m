//
//  ProfileCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "ProfileCell.h"

@implementation ProfileCell

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

- (void)displayByIndexPath:(NSIndexPath *)indexPath forUser:(User *)user
{
    self.fontAwesomeLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:19];

    NSString *labelText, *detailsText, *fontAwesome;

    if (indexPath.row == 0) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-map-marker"];
        labelText   = @"Location";
        detailsText = [user getLocation] == (id)[NSNull null] ? @"n/a" : [user getLocation];
    } else if (indexPath.row == 1) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-globe"];
        labelText   = @"Website";
        detailsText = [user getWebsite] == (id)[NSNull null] ? @"n/a" : [user getWebsite];
    } else if (indexPath.row == 2) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-envelope"];
        labelText   = @"Email";
        detailsText = [user getEmail] == (id)[NSNull null] ? @"n/a" : [user getEmail];
    } else if (indexPath.row == 3) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-briefcase"];
        labelText   = @"Company";
        detailsText = [user getCompany] == (id)[NSNull null] ? @"n/a" : [user getCompany];
    } else if (indexPath.row == 4) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-group"];
        labelText   = @"Followers";
        detailsText = [NSNumberFormatter localizedStringFromNumber:@([user getFollowers]) numberStyle:NSNumberFormatterDecimalStyle];
    } else if (indexPath.row == 5) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-group"];
        labelText   = @"Following";
        detailsText = [NSNumberFormatter localizedStringFromNumber:@([user getFollowing]) numberStyle:NSNumberFormatterDecimalStyle];
    } else if (indexPath.row == 6) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-folder-open"];
        labelText   = @"Repos";
        detailsText = [NSString stringWithFormat:@"%i", [user getNumberOfRepos]];
    } else if (indexPath.row == 7) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-pushpin"];
        labelText   = @"Gists";
        detailsText = [NSString stringWithFormat:@"%i", [user getNumberOfGists]];
    } else if (indexPath.row == 8) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-calendar"];
        labelText   = @"Joined";
        detailsText = [user getCreatedAt];
    } else if (indexPath.row == 9) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-sitemap"];
        labelText   = @"Organizations";
        detailsText = @"view all";
    } else if (indexPath.row == 10) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-rss"];
        labelText   = @"Recent Activity";
        detailsText = @"view all";
    }
    
    self.fontAwesomeLabel.text  = fontAwesome;
    self.fieldLabel.text        = labelText;
    self.fieldDetails.text      = detailsText;
    self.selectionStyle         = UITableViewCellSelectionStyleNone;
    self.backgroundColor        = [UIColor clearColor];
}

@end
