//
//  RepoContentSearchResultCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 11/21/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoContentSearchResultCell.h"
#import "TextMatch.h"

@implementation RepoContentSearchResultCell

@synthesize pathLabel, languageLabel, textMatchField, result;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)render
{
    pathLabel.text = [result getPath];
    NSArray *textMatches = [result getTextMatches];
    if (textMatches.count) {
        TextMatch *t = [textMatches firstObject];
        textMatchField.text = [t getFragment];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
