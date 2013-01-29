//
//  RepoTreeNode.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoTreeNode.h"

@implementation RepoTreeNode

@synthesize type, path, sha, mode, size, url;

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    
    self.type = [data valueForKey:@"type"];
    self.path = [data valueForKey:@"path"];
    self.sha  = [data valueForKey:@"sha"];
    self.mode = [data valueForKey:@"mode"];
    self.size = [[data valueForKey:@"size"] integerValue];
    self.url  = [data valueForKey:@"url"];
    
    return self;
}

- (BOOL)isTree
{
    return [self.type isEqualToString:@"tree"];
}

- (BOOL)isBlob
{
    return [self.type isEqualToString:@"blob"];
}

@end
