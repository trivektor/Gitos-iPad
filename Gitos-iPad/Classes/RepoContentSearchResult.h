//
//  RepoContentSearchResult.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 11/19/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RepoContentSearchResult : NSObject

@property (nonatomic, strong) NSDictionary *data;

- (id)initWithData:(NSDictionary *)resultData;

- (NSString *)getName;
- (NSString *)getPath;
- (double)getScore;
- (NSArray *)getTextMatches;

@end
