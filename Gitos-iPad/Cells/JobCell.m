//
//  JobCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 12/13/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "JobCell.h"

@implementation JobCell

@synthesize titleLabel, locationLabel, createdAtLabel, typeLabel, companyLogo, job;

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

- (void)render
{
    titleLabel.text = [job getTitle];
    locationLabel.text = [job getLocation];
    createdAtLabel.text = [job getRelativeCreatedAt];
    typeLabel.text = [job getType];

    [self defineAccessoryType];
    [self defineHighlightedColorsForLabels:@[titleLabel, locationLabel, createdAtLabel, typeLabel]];

    companyLogo.contentMode = UIViewContentModeScaleAspectFit;

    if ((id)[job getCompanyLogo] != [NSNull null]) {
        [companyLogo setImageWithURL:[NSURL URLWithString:[job getCompanyLogo]] placeholderImage:[UIImage imageNamed:@"briefcase.png"]];
    } else {
        [companyLogo setImage:[UIImage imageNamed:@"briefcase.png"]];
    }
}

@end
