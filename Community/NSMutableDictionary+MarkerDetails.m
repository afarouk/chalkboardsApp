//
//  NSMutableDictionary+MarkerDetails.m
//  Community
//
//  Created by practice on 20/03/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "NSMutableDictionary+MarkerDetails.h"

@implementation NSMutableDictionary (MarkerDetails)
-(NSString*)apiMarkerURL {
    return [self valueForKey:@"apiMarkerURL"];
}
-(NSString*)category {
    return [self valueForKey:@"category"];
}
-(NSString*)marker {
    return [self valueForKey:@"marker"];
}
-(NSData*)markerBytes {
    return [self valueForKey:@"markerBytes"];
}
-(NSString*)markerURL {
    return [self valueForKey:@"markerURL"];
}
-(UIImage*)markerImage {
    return [self valueForKey:@"markerImage"];
}
-(void)setMarkerImage:(UIImage*)image {
    [self setObject:image forKey:@"markerImage"];
//    NSLog(@"check now %@",self);
}
@end
