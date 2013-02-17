//
//  UserSearchResultCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/16/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "UserSearchResultCell.h"

@implementation UserSearchResultCell

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
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.user getAvatarUrl]]];
    self.avatar.image = [UIImage imageWithData:data];
    self.name.text = [self.user getName];
    self.username.text = [self.user getLogin];
}

@end
