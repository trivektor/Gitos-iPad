//
//  RepoDetailsCell.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoDetailsCell.h"

@implementation RepoDetailsCell

@synthesize repo, fieldValue, fieldLabel;

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
    NSString *fieldLabelText = @"", *fieldValueText = @"";
    NSString *homepage = [repo getHomepage];

    if (homepage.length >= REPO_DETAILS_MAX_CHARS) {
        homepage = [[homepage substringToIndex:REPO_DETAILS_MAX_CHARS] stringByAppendingString:@"..."];
    }

    switch (indexPath.row) {
        case 0:
            fieldLabelText = @"Name";
            fieldValueText = [repo getName];
            break;
        case 1:
            fieldLabelText = @"Website";
            fieldValueText = homepage;
            break;
        case 2:
            fieldLabelText = @"Watchers";
            fieldValueText = [NSNumberFormatter localizedStringFromNumber:@([repo getWatchers]) numberStyle:NSNumberFormatterDecimalStyle];
            break;
        case 3:
            fieldLabelText = @"Forks";
            fieldValueText = [NSNumberFormatter localizedStringFromNumber:@([repo getForks]) numberStyle:NSNumberFormatterDecimalStyle];
            break;
        case 4:
            fieldLabelText = @"Language";
            fieldValueText = [repo getLanguage];
            break;
        case 5:
            fieldLabelText = @"Created";
            fieldValueText = [repo getCreatedAt];
            break;
        case 6:
            fieldLabelText = @"Last Updated";
            fieldValueText = [repo getUpdatedAt];
            break;
        case 7:
            fieldLabelText = @"Author";
            fieldValueText = [repo getAuthorName];
            break;
        case 8:
            fieldLabelText = @"Issues";
            fieldValueText = [NSNumberFormatter localizedStringFromNumber:@([repo getOpenIssues]) numberStyle:NSNumberFormatterDecimalStyle];
        default:
            break;
    }

    fieldLabel.text = fieldLabelText;
    fieldValue.text = fieldValueText;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
}

@end
