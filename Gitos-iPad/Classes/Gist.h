//
//  Gist.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gist : NSObject

@property (nonatomic, retain) NSDictionary *data;
@property (nonatomic, retain) NSDictionary *details;
@property (nonatomic, strong) RelativeDateDescriptor *relativeDateDescriptor;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSString *createdAt;

- (id)initWithData:(NSDictionary *)gistData;

- (NSString *)getId;
- (NSString *)getName;
- (NSString *)getDescription;
- (NSString *)getCreatedAt;
- (NSInteger)getNumberOfForks;
- (NSInteger)getNumberOfFiles;
- (NSDictionary *)getFiles;
- (NSArray *)getGistFiles;
- (NSInteger)getNumberOfComments;
- (NSString *)convertToRelativeDate:(NSString *)originalDateString;
- (NSString *)getUrl;
- (NSString *)getStarredUrl;
- (NSString *)getHtmlUrl;
- (NSString *)getCommentsUrl;
- (void)checkStar;
- (void)fetchStats;
- (void)fetchComments;
+ (void)save:(NSDictionary *)data;

@end