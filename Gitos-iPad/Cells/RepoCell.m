//
//  RepoCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoCell.h"

@implementation RepoCell

@synthesize repo, fontAwesomeLabel, repoNameLabel, starLabel, forkLabel, descriptionLabel;

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
    fontAwesomeLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];

    if ([repo isForked]) {
        fontAwesomeLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-random"];
    } else {
        fontAwesomeLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-book"];
    }

    repoNameLabel.text = [repo getName];

    // Float the Forks and Watchers labels side by side
    // http://stackoverflow.com/questions/5891384/place-two-uilabels-side-by-side-left-and-right-without-knowing-string-length-of

    NSInteger _forks = [repo getForks];
    NSString *forks;

    NSInteger MAX_COUNT = 1000.0;

    if (_forks > MAX_COUNT) {
        forks = [NSString stringWithFormat:@"%.1fk", _forks/MAX_COUNT*1.0];
    } else {
        forks = [NSString stringWithFormat:@"%i", _forks];
    }

    NSInteger _watchers = [repo getWatchers];
    NSString *watchers;

    if (_watchers > MAX_COUNT) {
        watchers = [NSString stringWithFormat:@"%.1fk", _watchers/MAX_COUNT*1.0];
    } else {
        watchers = [NSString stringWithFormat:@"%i", _watchers];
    }

    CGSize forksSize = [forks sizeWithFont:forkLabel.font];
    CGSize watchersSize = [watchers sizeWithFont:starLabel.font];

    forkLabel.text = forks;
    starLabel.text = watchers;

    forkLabel.frame = CGRectMake(forkLabel.frame.origin.x,
                                      forkLabel.frame.origin.y,
                                      forksSize.width,
                                      forksSize.height);

    starLabel.frame = CGRectMake(starLabel.frame.origin.x,
                                      starLabel.frame.origin.y,
                                      watchersSize.width,
                                      watchersSize.height);

    descriptionLabel.text = [repo getDescription];
    [self defineSelectedColor:[UIColor asbestosColor]];
    [self defineAccessoryType];
}

@end
