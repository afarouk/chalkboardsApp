//
//  CTMapAnnotation.h
//  Community
//
//  Created by dinesh on 20/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol CTMapAnnotationDelegate;
@interface CTMapAnnotation : NSObject<MKAnnotation,MKMapViewDelegate>
{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subTitle;
    NSString *pinImageURL;
    NSDictionary *restaurantDictObj;
    NSUInteger numberOfAttempts;
}
@property(nonatomic,assign) id<CTMapAnnotationDelegate> delegate;
@property (nonatomic,readonly)CLLocationCoordinate2D coordinate;
@property (nonatomic,readonly,copy)NSString *title;
@property (nonatomic,readonly,copy)NSString *subTitle;
@property (nonatomic,readonly,copy)NSString *pinImageURL;
@property(nonatomic) UIImage *pinImage;
@property (nonatomic,readonly)NSDictionary *restaurantDictObj;
// block defination
typedef void(^IconDownloadBlock)(CTMapAnnotation *annotation,NSMutableDictionary *dictionary,UIImage *image,NSError* error);

-(id)initWithCoordinate:(CLLocationCoordinate2D)annotationCoordinate withTitle:(NSString *)annotationTitle withSubTitle:(NSString *)annotationSubTitle withPinImageURL:(NSString *)pinName andRestaurantObj:(NSDictionary *)restaurantDict;
-(void)downloadImageForMarkerURL:(NSString*)url restDictionary:(NSMutableDictionary*)dictionary completionBlock:(IconDownloadBlock)block;
-(void)getImageForPinURL:(NSString*)pinURL;
@end
@protocol CTMapAnnotationDelegate <NSObject>
-(void)didDownloadAnnoationImage:(UIImage*)image forAnnotation:(CTMapAnnotation*)annotation;
@end