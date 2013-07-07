//
//  Contribution.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 7/4/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contribution : NSObject

@property (nonatomic, strong) NSDictionary *data;

- (id)initWithData:(NSDictionary *)contributionData;

- (User *)getAuthor;
- (NSArray *)getWeeksData;

@end
