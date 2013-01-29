//
//  GistDetailsCell.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gist.h"

@interface GistDetailsCell : UITableViewCell
{
    __weak IBOutlet UILabel *fieldLabel;
    __weak IBOutlet UILabel *fieldValue;
}

@property (nonatomic, strong) Gist *gist;

- (void)renderForIndexPath:(NSIndexPath *)indexPath;

@end