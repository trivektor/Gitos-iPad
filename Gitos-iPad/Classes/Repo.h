//
//  Repo.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Branch.h"
#import "RepoTreeNode.h"
#import "Readme.h"

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
- (NSString *)getUrl;
- (NSString *)getBranchesUrl;
- (NSString *)getTreeUrl;
- (NSString *)getStarredUrl;
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
- (BOOL)hasIssues;
- (BOOL)isForked;
- (NSString *)getGithubUrl;
- (void)checkStar;
- (void)fetchBranches;
- (void)fetchIssuesForPage:(int)page;
- (void)fetchFullInfo;
- (void)fetchReadme;
- (void)fetchLanguages;
- (void)fetchContributors;
- (void)forkForAuthenticatedUser;
- (void)save:(NSDictionary *)info;
- (BOOL)isDestroyable;
- (void)destroy;

- (void)createIssueWithData:(NSDictionary *)issueData;

- (void)fetchTopLayerForBranch:(Branch *)branch;
+ (void)createNewWithData:(NSDictionary *)data;

@end