//
//  RepoSearchResultCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoSearchResultCell.h"
#import "RelativeDateDescriptor.h"

@implementation RepoSearchResultCell

@synthesize repo, repoNameLabel, repoDescriptionLabel, repoDetailsLabel;

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
    [self renderName];
    [self renderDescription];
    
    RelativeDateDescriptor *relativeDateDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    
    NSInteger size = [self.repo getSize];
    
    NSString *sizeLabel;
    if (size <= 1024) {
        sizeLabel = [NSString stringWithFormat:@"%i KB", size];
    } else {
        sizeLabel = [NSString stringWithFormat:@"%.1f MB", size/1024.0];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:sszzz"];
    NSDate *pushedAt  = [dateFormatter dateFromString:[self.repo getPushedAt]];
    
    NSMutableArray *labels = [[NSMutableArray alloc] initWithCapacity:0];
    [labels addObject:sizeLabel];
    [labels addObject:[NSString stringWithFormat:@"%i forks", [[self.repoDetails objectForKey:@"forks"] integerValue]]];
    [labels addObject:[NSString stringWithFormat:@"%i watchers", [[self.repoDetails objectForKey:@"watchers"] integerValue]]];
    [labels addObject:[NSString stringWithFormat:@"last activity %@", [relativeDateDescriptor describeDate:pushedAt relativeTo:[NSDate date]]]];
    [self.repoDetailsLabel setText:[labels componentsJoinedByString:@" | "]];
    //    [self.repoDetailsLabel setNumberOfLines:0];
    //    [self.repoDetailsLabel setLineBreakMode:NSLineBreakByWordWrapping];
    //    [self.repoDetailsLabel sizeToFit];
}

- (void)renderName
{
    [self.repoNameLabel setText:[self.repo getName]];
}

- (void)renderDescription
{
    NSString *description = [self.repo getDescription];
    
    if (description == (id)[NSNull null]) {
        [self.repoDescriptionLabel setText:@"no description"];
        return;
    }
    
    if (description.length == 0) {
        [self.repoDescriptionLabel setText:@"no description"];
    } else {
        [self.repoDescriptionLabel setText:description];
    }
}

@end
