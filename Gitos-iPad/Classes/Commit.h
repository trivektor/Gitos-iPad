//
//  Commit.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/13/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Commit : NSObject

@property (nonatomic, strong) NSDictionary *data;

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

@end
