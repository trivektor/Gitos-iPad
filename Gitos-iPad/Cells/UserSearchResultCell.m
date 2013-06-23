//
//  UserSearchResultCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/16/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "UserSearchResultCell.h"

@implementation UserSearchResultCell

@synthesize avatar, name, username, user;

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
    NSData *data  = [NSData dataWithContentsOfURL:[NSURL URLWithString:[user getAvatarUrl]]];
    avatar.image  = [UIImage imageWithData:data];
    name.text     = [user getName];
    username.text = [user getLogin];
    self.nuiClass = @"AsbestosColor";
}

@end