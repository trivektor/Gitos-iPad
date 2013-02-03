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
    self.fontAwesomeLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];

    NSString *detailsText, *fontAwesome;

    if (indexPath.row == 0) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-map-marker"];
        detailsText = [NSString stringWithFormat:@"Location: %@", user.location];
    } else if (indexPath.row == 1) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-globe"];
        detailsText = [NSString stringWithFormat:@"Website: %@", user.blog];
    } else if (indexPath.row == 2) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-envelope"];
        detailsText = [NSString stringWithFormat:@"Email: %@", user.email];
    } else if (indexPath.row == 3) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-group"];
        detailsText = [NSString stringWithFormat:@"%i followers", user.followers];
    } else if (indexPath.row == 4) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-group"];
        detailsText = [NSString stringWithFormat:@"%i following", user.following];
    } else if (indexPath.row == 5) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-briefcase"];
        detailsText = [NSString stringWithFormat:@"Company: %@", user.company];
    } else if (indexPath.row == 6) {
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-folder-open"];
        detailsText = [NSString stringWithFormat:@"Repos: %i", user.publicRepos];
    } else if (indexPath.row == 7) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
        NSDate *date  = [dateFormatter dateFromString:user.createdAt];

        RelativeDateDescriptor *relativeDateDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
        
        fontAwesome = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-calendar"];
        detailsText = [NSString stringWithFormat:@"Joined: %@", [relativeDateDescriptor describeDate:date relativeTo:[NSDate date]]];
    }
    
    //self.fieldIcon.image        = image;
    self.fontAwesomeLabel.text  = fontAwesome;
    self.fieldDetails.text      = detailsText;
    //self.fieldIcon.contentMode  = UIViewContentModeScaleAspectFit;
    self.selectionStyle         = UITableViewCellSelectionStyleNone;
    self.backgroundColor        = [UIColor clearColor];
}

@end
