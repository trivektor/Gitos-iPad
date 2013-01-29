//
//  GistCell.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gist.h"
#import "RelativeDateDescriptor.h"

@interface GistCell : UITableViewCell

@property (nonatomic, strong) Gist *gist;
@property (nonatomic, strong) RelativeDateDescriptor *relativeDateDescriptor;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) IBOutlet UILabel *gistName;
@property (nonatomic, strong) IBOutlet UILabel *gistDescription;
@property (nonatomic, strong) IBOutlet UILabel *gistCreatedAt;

- (void)render;

@end