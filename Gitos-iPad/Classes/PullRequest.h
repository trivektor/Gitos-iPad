//
//  PullRequest.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/24/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Repo.h"

@interface PullRequest : NSObject

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) Repo *repo;

- (id)initWithData:(NSDictionary *)pullRequestData;
- (Repo *)getRepo;
- (NSDictionary *)getSubjet;
- (NSString *)getTitle;
- (NSString *)getCommentUrl;

@end
