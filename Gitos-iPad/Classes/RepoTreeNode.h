//
//  RepoTreeNode.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RepoTreeNode : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *sha;
@property (nonatomic, strong) NSString *mode;
@property (nonatomic) NSInteger size;
@property (nonatomic, strong) NSString *url;

- (id)initWithData:(NSDictionary *)data;
- (BOOL)isTree;
- (BOOL)isBlob;

@end
