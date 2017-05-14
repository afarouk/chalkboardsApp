//
//  CTMapAnnotation.m
//  Community
//
//  Created by dinesh on 20/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTMapAnnotation.h"

// Blocks 

@implementation CTMapAnnotation
@synthesize coordinate;
@synthesize title;
@synthesize subTitle;
@synthesize pinImageURL;
@synthesize restaurantDictObj;
-(void)downloadImageForMarkerURL:(NSString*)url restDictionary:(NSMutableDictionary*)dictionary completionBlock:(IconDownloadBlock)block {
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(!connectionError) {
            
            UIImage *img = [[UIImage alloc]initWithData:data];
            if(img && [img isKindOfClass:[UIImage class]]) {
                block(self,dictionary,img,nil);
                [self.delegate didDownloadAnnoationImage:self.pinImage forAnnotation:self];
            }else {
                // pass default image
                self.pinImage = [UIImage imageNamed:CT_MapPinImage_Default];
                block(self,dictionary,[UIImage imageNamed:CT_MapPinImage_Default],nil);
                [self.delegate didDownloadAnnoationImage:self.pinImage forAnnotation:self];
//                NSDictionary *errorDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObject:@"Could not find resource"] forKeys:[NSArray arrayWithObject:NSLocalizedDescriptionKey]];
//                block(self,dictionary,nil,[NSError errorWithDomain:@"com.domain.ImageNotFound" code:42 userInfo:errorDictionary]);
            }
        }else {
            self.pinImage = [UIImage imageNamed:CT_MapPinImage_Default];
            block(self,dictionary,[UIImage imageNamed:CT_MapPinImage_Default],nil);
            [self.delegate didDownloadAnnoationImage:self.pinImage forAnnotation:self];
//            block(self,dictionary,nil,connectionError);
        }
    }];
}
-(void)getImageForPinURL:(NSString*)pinURL {
//    NSLog(@"Pin URL = %@",pinURL);
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pinImageURL]] queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        numberOfAttempts +=1;
        if(connectionError) {
            if(numberOfAttempts <= 3 )
            [self getImageForPinURL:pinURL];
            else {
                self.pinImage = [UIImage imageNamed:CT_MapPinImage_Default];
                numberOfAttempts = 0;
                [self.delegate didDownloadAnnoationImage:self.pinImage forAnnotation:self];
            }
        }else {
            
            self.pinImage = [UIImage imageWithData:data];
            [self.delegate didDownloadAnnoationImage:self.pinImage forAnnotation:self];
        }
    }];
}
-(id)init{
    
    CLLocationCoordinate2D c;
    c.latitude=0;
    c.longitude=0;
    return [self initWithCoordinate:c withTitle:nil withSubTitle:nil withPinImageURL:nil andRestaurantObj:nil];
}
-(id)initWithCoordinate:(CLLocationCoordinate2D)annotationCoordinate withTitle:(NSString *)annotationTitle withSubTitle:(NSString *)annotationSubTitle withPinImageURL:(NSString *)pinName andRestaurantObj:(NSDictionary *)restaurantDict;
{
    
    self=[super init];
//    NSLog(@"lati = %f",annotationCoordinate.latitude);
//    NSLog(@"long = %f",annotationCoordinate.longitude);
    coordinate=annotationCoordinate;
    title=annotationTitle;
    subTitle=annotationSubTitle;
    pinImageURL=pinName;
    restaurantDictObj=restaurantDict;
    [self getImageForPinURL:pinImageURL];
    return self;
}
@end
