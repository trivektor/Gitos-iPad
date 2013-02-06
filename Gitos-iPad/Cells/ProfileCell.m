//
//  ProfileCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "ProfileCell.h"
#import "RelativeDateDescriptor.h"
#import "NSString+FontAwesome.h"

@implementation ProfileCell

@synthesize fieldIcon, fieldDetails, fontAwesomeLabel;

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

    NSString *detailsText, *fontAwesome;

    if (indexPath.row == 0) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-map-marker"];
        detailsText = [NSString stringWithFormat:@"Location: %@", [user getLocation]];
    } else if (indexPath.row == 1) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-globe"];
        detailsText = [NSString stringWithFormat:@"Website: %@", [user getWebsite]];
    } else if (indexPath.row == 2) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-envelope"];
        detailsText = [NSString stringWithFormat:@"Email: %@", [user getEmail]];
    } else if (indexPath.row == 3) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-group"];
        detailsText = [NSString stringWithFormat:@"%i followers", [user getFollowers]];
    } else if (indexPath.row == 4) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-group"];
        detailsText = [NSString stringWithFormat:@"%i following", [user getFollowing]];
    } else if (indexPath.row == 5) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-briefcase"];
        detailsText = [NSString stringWithFormat:@"Company: %@", [user getCompany]];
    } else if (indexPath.row == 6) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-folder-open"];
        detailsText = [NSString stringWithFormat:@"Repos: %i", [user getNumberOfRepos]];
    } else if (indexPath.row == 7) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-calendar"];
        detailsText = [NSString stringWithFormat:@"Joined: %@", [user getCreatedAt]];
    } else if (indexPath.row == 8) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-rss"];
        detailsText = @"Recent Activity";
    }
    
    //self.fieldIcon.image        = image;
    self.fontAwesomeLabel.text  = fontAwesome;
    self.fieldDetails.text      = detailsText;
    //self.fieldIcon.contentMode  = UIViewContentModeScaleAspectFit;
    self.selectionStyle         = UITableViewCellSelectionStyleNone;
    self.backgroundColor        = [UIColor clearColor];
}

@end
