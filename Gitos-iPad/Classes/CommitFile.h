//
//  CommitFile.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/14/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommitFile : NSObject

@property (nonatomic, strong) NSDictionary *data;

- (id)initWithData:(NSDictionary *)fileData;

- (NSString *)getSha;
- (NSString *)getFileName;
- (NSString *)getStatus;
- (NSInteger)getAdditions;
- (NSInteger)getDeletions;
- (NSInteger)getChanges;
- (NSString *)getPatch;

@end
