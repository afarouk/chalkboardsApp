//
//  NSArray+RetrieveMediaMetaDataBySASL.m
//  Community
//
//  Created by dinesh on 30/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "NSArray+RetrieveMediaMetaDataBySASL.h"

@implementation NSArray (RetrieveMediaMetaDataBySASL)
-(NSString *)thumbURL:(int)i{
    
    return [[self valueForKey:@"thumbURL"]objectAtIndex:i];
}
-(NSString *)title:(int)i{
    return [[self valueForKey:@"title"] objectAtIndex:i];
}
-(NSString *)message:(int)i{
    return [[self valueForKey:@"message"]objectAtIndex:i];
}
-(NSString *)groupId:(int)i{
    return [[self valueForKey:@"groupId"] objectAtIndex:i];
}
-(int)imagewidth:(int)i{
    
    return [[[self valueForKey:@"imagewidth"] objectAtIndex:i]intValue];
}
-(int)imageheight:(int)i{
    return [[[self valueForKey:@"imageheight"] objectAtIndex:i]intValue];
}
-(BOOL)portrait:(int)i{
    return [[[self valueForKey:@"portrait"] objectAtIndex:i]boolValue];
}
-(NSString *)serviceAccommodatorId:(int)i{
    return [[self valueForKey:@"serviceAccommodatorId"] objectAtIndex:i];
    
}
-(NSString *)serviceLocationId:(int)i{
    return [[self valueForKey:@"serviceLocationId"] objectAtIndex:i];
    
}
-(int)retriveId:(int)i{
    return [[[self valueForKey:@"id"] objectAtIndex:i]intValue];
}
-(int)index:(int)i{
    return [[[self valueForKey:@"index"] objectAtIndex:i]intValue];
}
-(NSString *)status:(int)i{
    return [[self valueForKey:@"status"] objectAtIndex:i];
}
-(BOOL)isOfficial:(int)i{
    return [[[self valueForKey:@"isOfficial"] objectAtIndex:i]boolValue];
}
-(NSString *)minUserSASLLevel:(int)i{
    return [[self valueForKey:@"minUserSASLLevel"] objectAtIndex:i];
}
-(NSString *)activationDate:(int)i{
    return [[self valueForKey:@"activationDate"] objectAtIndex:i];
    
}
-(NSString *)expirationDate:(int)i{
    return [[self valueForKey:@"expirationDate"] objectAtIndex:i];
}
-(NSString *)url:(int)i{
     return [[self valueForKey:@"url"] objectAtIndex:i];
}
@end
