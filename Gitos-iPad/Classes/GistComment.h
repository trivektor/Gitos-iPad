//
//  GistComment.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/12/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GistComment : NSObject

@property (nonatomic, strong) NSDictionary *data;

- (id)initWithData:(NSDictionary *)gistData;

@end
