//
//  NSMutableDictionary+MarkerDetails.h
//  Community
//
//  Created by practice on 20/03/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (MarkerDetails)
-(NSString*)apiMarkerURL;
-(NSString*)category;
-(NSString*)marker;
-(NSData*)markerBytes;
-(NSString*)markerURL;
-(UIImage*)markerImage;
-(void)setMarkerImage:(UIImage*)image;
@end
