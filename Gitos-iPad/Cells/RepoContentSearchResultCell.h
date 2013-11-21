//
//  RepoContentSearchResultCell.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 11/21/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepoContentSearchResult.h"

@interface RepoContentSearchResultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *pathLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (nonatomic, strong) RepoContentSearchResult *result;
@property (weak, nonatomic) IBOutlet UITextView *textMatchField;

- (void)render;

@end
