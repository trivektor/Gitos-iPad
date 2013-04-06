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

- (void)fetchTree
{
    NSURL *treeNodeUrl = [NSURL URLWithString:self.url];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:treeNodeUrl];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:treeNodeUrl.absoluteString parameters:[AppHelper getAccessTokenParams]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         NSArray *treeNodes = [json valueForKey:@"tree"];

         NSMutableArray *nodes = [[NSMutableArray alloc] initWithCapacity:0];

         for (int i=0; i < treeNodes.count; i++) {
             [nodes addObject:[[RepoTreeNode alloc] initWithData:[treeNodes objectAtIndex:i]]];
         }

         NSDictionary *userInfo = [NSDictionary dictionaryWithObject:nodes forKey:@"Nodes"];

         [[NSNotificationCenter defaultCenter] postNotificationName:@"TreeFetched" object:nil userInfo:userInfo];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

    [operation start];
}

@end
