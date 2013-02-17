//
//  Repo.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RelativeDateDescriptor.h"

@interface Repo : NSObject

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) RelativeDateDescriptor *relativeDateDescriptor;

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
- (NSString *)getHomepage;
- (NSInteger)getOpenIssues;
- (NSString *)getIssuesUrl;
- (NSString *)getCommitsUrl;
- (NSString *)getCreatedAt;
- (NSString *)getUpdatedAt;
- (NSString *)getAuthorName;
- (NSString *)convertToRelativeDate:(NSString *)originalDateString;
- (NSString *)getOwner;

@end