//
//  User.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSDictionary *data;

- (id)initWithData:(NSDictionary *)userData;

- (NSString *)getAvatarUrl;
- (NSString *)getGravatarId;
- (NSString *)getGistsUrl;
- (NSString *)getReceivedEventsUrl;
- (NSString *)getEventsUrl;
- (NSString *)getStarredUrl;
- (NSString *)getReposUrl;
- (NSString *)getOrganizationsUrl;
- (NSString *)getSubscriptionsUrl;
- (NSString *)getFollowersUrl;
- (NSString *)getFollowingUrl;
- (NSString *)getLogin;
- (NSString *)getName;
- (NSString *)getLocation;
- (NSString *)getWebsite;
- (NSString *)getEmail;
- (NSInteger)getFollowers;
- (NSInteger)getFollowing;
- (NSString *)getCompany;
- (NSInteger)getNumberOfRepos;
- (NSInteger)getNumberOfGists;
- (NSString *)getCreatedAt;
- (NSString *)getHtmlUrl;
- (BOOL)isEditable;
- (BOOL)isMyself;
- (void)update:(NSDictionary *)updatedInfo;

- (void)fetchNewsFeedForPage:(int)page;
- (void)fetchProfileInfo;
+ (void)fetchInfoForUserWithToken:(NSString *)accessToken;
- (void)fetchRecentActivityForPage:(int)page;
- (void)fetchReposForPage:(int)page;
- (void)fetchStarredReposForPage:(int)page;
- (void)fetchGistsForPage:(int)page;
- (void)fetchRelatedUsersWithUrl:(NSString *)url forPage:(int)page;
- (void)fetchFollowersForPage:(int)page;
- (void)fetchFollowingUsersForPage:(int)page;
- (void)fetchOrganizationsForPage:(int)page;
- (void)starRepo:(Repo *)repo;
- (void)unstarRepo:(Repo *)repo;
- (void)toggleStarringForRepo:(Repo *)repo withMethod:(NSString *)methodName;

@end
