//
//  RepoTreeNode.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RepoTreeNode : NSObject

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *sha;
@property (nonatomic, strong) NSString *mode;
@property (nonatomic) int size;
@property (nonatomic, strong) NSString *url;

- (id)initWithData:(NSDictionary *)nodeData;
- (NSString *)getType;
- (NSString *)getPath;
- (NSString *)getSha;
- (NSString *)getMode;
- (int)getSize;
- (NSString *)getUrl;
- (BOOL)isTree;
- (BOOL)isBlob;
- (void)fetchTree;

@end
