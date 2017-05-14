//
//  NSArray+GetDomainOptions.h
//  Community
//
//  Created by dinesh on 01/02/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (GetDomainOptions)
-(NSString *)displayText:(int)i;
-(NSString *)enumText:(int)i;
-(NSString*)category:(int)i;
-(NSString*)domain:(int)i;
@end
