//
//  NSArray+RetrieveMediaMetaDataBySASL.h
//  Community
//
//  Created by dinesh on 30/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (RetrieveMediaMetaDataBySASL)
-(NSString *)thumbURL:(int)i;
-(NSString *)title:(int)i;
-(NSString *)message:(int)i;
-(NSString *)groupId:(int)i;
-(int)imagewidth:(int)i;
-(int)imageheight:(int)i;
-(BOOL)portrait:(int)i;
-(NSString *)serviceAccommodatorId:(int)i;
-(NSString *)serviceLocationId:(int)i;
-(int)retriveId:(int)i;
-(int)index:(int)i;
-(NSString *)status:(int)i;
-(BOOL)isOfficial:(int)i;
-(NSString *)minUserSASLLevel:(int)i;
-(NSString *)activationDate:(int)i;
-(NSString *)expirationDate:(int)i;
-(NSString *)url:(int)i;
@end
