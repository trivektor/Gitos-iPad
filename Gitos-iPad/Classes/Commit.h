//
//  Commit.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/13/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Commit : NSObject

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) RelativeDateDescriptor *relativeDateDescriptor;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

- (id)initWithData:(NSDictionary *)commitData;
- (NSString *)getSha;
- (NSString *)getUrl;
- (NSString *)getCommentsUrl;
- (NSDictionary *)getDetails;
- (NSString *)getMessage;
- (NSDictionary *)getParent;
- (NSString *)getParentSha;
- (NSString *)getParentUrl;
- (NSDictionary *)getStats;
- (NSArray *)getFiles;
- (User *)getAuthor;
- (NSString *)getCommittedAt;

@end
