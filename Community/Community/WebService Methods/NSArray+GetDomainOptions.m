//
//  NSArray+GetDomainOptions.m
//  Community
//
//  Created by dinesh on 01/02/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "NSArray+GetDomainOptions.h"

@implementation NSArray (GetDomainOptions)
-(NSString *)displayText:(int)i{
    
    NSString *display=[[self valueForKeyPath:@"displayText"]objectAtIndex:i];
    return display;
}
-(NSString *)enumText:(int)i{
    NSString *enumtext=[[self valueForKeyPath:@"enumText"]objectAtIndex:i];
    return enumtext;
}
-(NSString*)category:(int)i {
    NSString *str = [[self valueForKeyPath:@"category"] objectAtIndex:i];
    return str;
}
-(NSString*)domain:(int)i {
    NSString *str = [[self valueForKeyPath:@"domain"] objectAtIndex:i];
    return str;
}
@end
