//
//  RepoTreeCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoTreeCell.h"

@implementation RepoTreeCell

@synthesize node;

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
    if ([self.node isTree]) {
        self.imageView.image = [UIImage imageNamed:@"folder_16.png"];
    } else if ([self.node isBlob]) {
        self.imageView.image = [UIImage imageNamed:@"file_16.png"];
    }
    self.textLabel.font = [UIFont fontWithName:@"Arial" size:13.0];
    self.textLabel.text = [self.node path];
}

@end
