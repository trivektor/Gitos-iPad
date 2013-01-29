//
//  GistCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//


#import "GistCell.h"

@implementation GistCell

@synthesize  gist, dateFormatter, relativeDateDescriptor, gistName, gistDescription, gistCreatedAt;

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
    self.gistName.text = [self.gist getName];
    self.gistDescription.text = [self.gist getDescription];
    
    NSDate *date  = [self.dateFormatter dateFromString:[self.gist getCreatedAt]];
    
    self.gistCreatedAt.text = [self.relativeDateDescriptor describeDate:date relativeTo:[NSDate date]];
}

@end
