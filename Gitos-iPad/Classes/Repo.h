//
//  Repo.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repo : NSObject

@property(nonatomic, strong) NSDictionary *data;

- (id)initWithData:(NSDictionary *)data;

- (NSString *)getName;
- (NSString *)getFullName;
- (NSInteger)getForks;
- (NSInteger)getWatchers;
- (NSString *)getLanguage;
- (NSString *)getBranchesUrl;
- (NSString *)getTreeUrl;
- (NSInteger)getSize;
- (NSString *)getPushedAt;
- (NSString *)getDescription;

@end