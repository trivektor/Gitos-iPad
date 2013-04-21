//
//  RepoTreeNode.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoTreeNode.h"

@implementation RepoTreeNode

@synthesize data, type, path, sha, mode, size, url;

- (id)initWithData:(NSDictionary *)nodeData
{
    self = [super init];
    data = nodeData;
    return self;
}

- (NSString *)getType
{
    return [data valueForKey:@"type"];
}

- (NSString *)getPath
{
    return [data valueForKey:@"path"];
}

- (NSString *)getSha
{
    return [data valueForKey:@"sha"];
}

- (NSString *)getMode
{
    return [data valueForKey:@"mode"];
}

- (int)getSize
{
    return [[data valueForKey:@"size"] intValue];
}

- (NSString *)getUrl
{
    return [data valueForKey:@"url"];
}

- (BOOL)isTree
{
    return [[self getType] isEqualToString:@"tree"];
}

- (BOOL)isBlob
{
    return [[self getType] isEqualToString:@"blob"];
}

- (void)fetchTree
{
    NSURL *treeNodeUrl = [NSURL URLWithString:[self getUrl]];

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

         [[NSNotificationCenter defaultCenter] postNotificationName:@"TreeFetched" object:nodes];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

    [operation start];
}

@end
