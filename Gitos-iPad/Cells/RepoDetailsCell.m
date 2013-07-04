//
//  RepoDetailsCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoDetailsCell.h"

@implementation RepoDetailsCell

@synthesize repo, fontAwesomeLabel, fieldValue, fieldLabel;

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

- (void)renderForIndexPath:(NSIndexPath *)indexPath
{
    NSString *fieldLabelText = @"", *fieldValueText = @"", *fontAwesome = @"";
    NSString *homepage = [repo getHomepage];

    if (homepage.length >= REPO_DETAILS_MAX_CHARS) {
        homepage = [[homepage substringToIndex:REPO_DETAILS_MAX_CHARS] stringByAppendingString:@"..."];
    }

    switch (indexPath.row) {
        case 0:
            fontAwesome    = @"icon-info-sign";
            fieldLabelText = @"Name";
            fieldValueText = [repo getName];
            break;
        case 1:
            fontAwesome    = @"icon-link";
            fieldLabelText = @"Website";
            fieldValueText = homepage;
            break;
        case 2:
            fontAwesome    = @"icon-eye-open";
            fieldLabelText = @"Watchers";
            fieldValueText = [NSNumberFormatter localizedStringFromNumber:@([repo getWatchers])
                                                              numberStyle:NSNumberFormatterDecimalStyle];
            break;
        case 3:
            fontAwesome    = @"icon-code-fork";
            fieldLabelText = @"Forks";
            fieldValueText = [NSNumberFormatter localizedStringFromNumber:@([repo getForks])
                                                              numberStyle:NSNumberFormatterDecimalStyle];
            break;
        case 4:
            fontAwesome    = @"icon-terminal";
            fieldLabelText = @"Language";
            fieldValueText = [repo getLanguage];
            break;
        case 5:
            fontAwesome    = @"icon-calendar-empty";
            fieldLabelText = @"Created";
            fieldValueText = [repo getCreatedAt];
            break;
        case 6:
            fontAwesome    = @"icon-calendar";
            fieldLabelText = @"Last Updated";
            fieldValueText = [repo getUpdatedAt];
            break;
        case 7:
            fontAwesome    = @"icon-male";
            fieldLabelText = @"Author";
            fieldValueText = [repo getAuthorName];
            break;
        case 8:
            fontAwesome    = @"icon-warning-sign";
            fieldLabelText = @"Issues";
            if ([repo hasIssues]) {
                fieldValueText = [NSNumberFormatter localizedStringFromNumber:@([repo getOpenIssues])
                                                                  numberStyle:NSNumberFormatterDecimalStyle];
            } else {
                fieldValueText = @"Issues are disabled for this repo";
            }
            break;
        case 9:
            fontAwesome    = @"icon-file-alt";
            fieldLabelText = @"Readme";
            fieldValueText = @"README";
            break;
        case 10:
            fontAwesome    = @"icon-ellipsis-horizontal";
            fieldLabelText = @"Misc";
            fieldValueText = @"Details";
            break;
    }

    fontAwesomeLabel.font  = [UIFont fontWithName:kFontAwesomeFamilyName size:15];
    fontAwesomeLabel.text  = [NSString fontAwesomeIconStringForIconIdentifier:fontAwesome];
    fieldLabel.text = fieldLabelText;
    fieldValue.text = fieldValueText;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
}

@end
