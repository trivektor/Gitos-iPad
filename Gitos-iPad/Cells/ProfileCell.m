//
//  ProfileCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "ProfileCell.h"
#import "RelativeDateDescriptor.h"

@implementation ProfileCell

@synthesize fieldIcon, fieldDetails;

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
    UIImage *image;
    NSString *detailsText;
    
    if (indexPath.row == 0) {
        image       = [UIImage imageNamed:@"07-map-marker.png"];
        detailsText = [NSString stringWithFormat:@"Location: %@", user.location];
    } else if (indexPath.row == 1) {
        image       = [UIImage imageNamed:@"71-compass.png"];
        detailsText = [NSString stringWithFormat:@"Website: %@", user.blog];
    } else if (indexPath.row == 2) {
        image       = [UIImage imageNamed:@"287-at.png"];
        detailsText = [NSString stringWithFormat:@"Email: %@", user.email];
    } else if (indexPath.row == 3) {
        image       = [UIImage imageNamed:@"112-group.png"];
        detailsText = [NSString stringWithFormat:@"%i followers", user.followers];
    } else if (indexPath.row == 4) {
        image       = [UIImage imageNamed:@"112-group.png"];
        detailsText = [NSString stringWithFormat:@"%i following", user.following];
    } else if (indexPath.row == 5) {
        image       = [UIImage imageNamed:@"37-suitcase.png"];
        detailsText = [NSString stringWithFormat:@"Company: %@", user.company];
    } else if (indexPath.row == 6) {
        image       = [UIImage imageNamed:@"351-bankers-box.png"];
        detailsText = [NSString stringWithFormat:@"Repos: %i", user.publicRepos];
    } else if (indexPath.row == 7) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
        NSDate *date  = [dateFormatter dateFromString:user.createdAt];
        
        RelativeDateDescriptor *relativeDateDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
        
        image       = [UIImage imageNamed:@"83-calendar.png"];
        detailsText = [NSString stringWithFormat:@"Joined: %@", [relativeDateDescriptor describeDate:date relativeTo:[NSDate date]]];
    }
    
    self.fieldIcon.image        = image;
    self.fieldDetails.text      = detailsText;
    self.fieldIcon.contentMode  = UIViewContentModeScaleAspectFit;
    self.selectionStyle         = UITableViewCellSelectionStyleNone;
    self.backgroundColor        = [UIColor clearColor];
}

@end
