//
//  CommitActivity.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 7/6/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommitActivity : NSObject

@property (nonatomic, strong) NSDictionary *data;

- (id)initWithCommitActivityData:(NSDictionary *)commitActivityData;
- (int)getTotal;
- (int)getWeek;

@end
