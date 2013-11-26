//
//  ProfileCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "ProfileCell.h"

@implementation ProfileCell

@synthesize fontAwesomeLabel, fieldDetails, fieldLabel;

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
    fontAwesomeLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:19];

    NSString *labelText, *detailsText, *fontAwesome;

    if (indexPath.row == 0) {
        fontAwesome = @"icon-map-marker";
        labelText   = @"Location";
        detailsText = [user getLocation] == (id)[NSNull null] ? @"n/a" : [user getLocation];
    } else if (indexPath.row == 1) {
        fontAwesome = @"icon-globe";
        labelText   = @"Website";
        detailsText = [user getWebsite] == (id)[NSNull null] ? @"n/a" : [user getWebsite];
    } else if (indexPath.row == 2) {
        fontAwesome = @"icon-envelope-alt";
        labelText   = @"Email";
        detailsText = [user getEmail] == (id)[NSNull null] ? @"n/a" : [user getEmail];
    } else if (indexPath.row == 3) {
        fontAwesome = @"icon-building";
        labelText   = @"Company";
        detailsText = [user getCompany] == (id)[NSNull null] ? @"n/a" : [user getCompany];
    } else if (indexPath.row == 4) {
        fontAwesome = @"icon-group";
        labelText   = @"Followers";
        detailsText = [NSNumberFormatter localizedStringFromNumber:@([user getFollowers]) numberStyle:NSNumberFormatterDecimalStyle];
    } else if (indexPath.row == 5) {
        fontAwesome = @"icon-group";
        labelText   = @"Following";
        detailsText = [NSNumberFormatter localizedStringFromNumber:@([user getFollowing]) numberStyle:NSNumberFormatterDecimalStyle];
    } else if (indexPath.row == 6) {
        fontAwesome = @"icon-github-alt";
        labelText   = @"Repos";
        detailsText = [NSString stringWithFormat:@"%i", [user getNumberOfRepos]];
    } else if (indexPath.row == 7) {
        fontAwesome = @"icon-code";
        labelText   = @"Gists";
        detailsText = [NSString stringWithFormat:@"%i", [user getNumberOfGists]];
    } else if (indexPath.row == 8) {
        fontAwesome = @"icon-time";
        labelText   = @"Joined";
        detailsText = [user getCreatedAt];
    } else if (indexPath.row == 9) {
        fontAwesome = @"icon-sitemap";
        labelText   = @"Organizations";
        detailsText = @"view all";
    } else if (indexPath.row == 10) {
        fontAwesome = @"icon-rss";
        labelText   = @"Recent Activity";
        detailsText = @"view all";
    } else if (indexPath.row == 11) {
        fontAwesome = @"icon-trophy";
        labelText   = @"Contributions";
        detailsText = @"view all";
    } else if (indexPath.row == 12) {
        fontAwesome = @"icon-bar-chart";
        labelText = @"Report Card";
        detailsText = @"view";
    }

    fontAwesomeLabel.text  = [NSString fontAwesomeIconStringForIconIdentifier:fontAwesome];
    fieldLabel.text        = labelText;
    fieldDetails.text      = detailsText;
    self.selectionStyle    = UITableViewCellSelectionStyleNone;
}

@end
