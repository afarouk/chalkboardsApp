//
//  NSDictionary+CTSpecialOffer.m
//  Community
//
//  Created by dinesh on 09/02/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "NSDictionary+CTSpecialOffer.h"

@implementation NSDictionary (CTSpecialOffer)
-(NSDictionary *)dictionarKey:(NSString *)keyName{
    
    NSDictionary *dict=[self objectForKey:keyName];
    return dict;
}
-(NSData *)data{
    NSData *imageData=[self objectForKey:@"data"];
    return imageData;
}
@end
