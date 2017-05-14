//
//  NSDictionary+CMPortal.h
//  CommunityApp
//
//  Copyright (c) 2013 apploom.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CMPortal)

- (id)objectForKeyCheckingNull:(id)key;
- (id)valueForKeyPathCheckingNull:(NSString *)keyPath;

@end
