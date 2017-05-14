//
//  NSDictionary+CMPortal.m
//  CommunityApp
//
//  Copyright (c) 2013 apploom.com. All rights reserved.
//

#import "NSDictionary+CMPortal.h"

@implementation NSDictionary (CMPortal)

- (id)objectForKeyCheckingNull:(id)key {
    id obj = self[key];
    if (obj == [NSNull null]) {
        return nil;
    }
    return obj;
}

- (id)valueForKeyPathCheckingNull:(NSString *)keyPath {
    id obj = [self valueForKeyPath:keyPath];
    if (obj == [NSNull null]) {
        return nil;
    }
    return obj;
}


@end
