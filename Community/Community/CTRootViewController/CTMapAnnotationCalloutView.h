//
//  CTMappAnnotationCalloutView.h
//  Community
//
//  Created by dinesh on 20/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
@protocol CTMapAnnotationCalloutViewDelegate;

@interface CustomCallout : UIView {
    UIImageView *dropArrowImageView;
    UIView *labelContainer;
}
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIButton *rightCalloutButton;
@end
@interface CTMapAnnotationCalloutView : MKAnnotationView {
    UILabel *label;
    UIImageView *pinImageView;
    BOOL didTapByCustomGesture;
}
@property(nonatomic,strong)     CustomCallout *callout;
@property(nonatomic,assign) id<CTMapAnnotationCalloutViewDelegate> delegate;
@property(nonatomic) BOOL didTapHitDetectionArea;
-(void)setImage:(UIImage *)image withText:(NSString*)text;
-(void)setImage:(UIImage *)image withText:(NSString*)text withFlag:(BOOL)flag;
-(void)showLabel:(BOOL)animated;
-(void)hideLabel:(BOOL)animated;
@end
@protocol CTMapAnnotationCalloutViewDelegate
-(void)didTapOnCalloutView:(CTMapAnnotationCalloutView*)view;
-(void)didTapCalloutAccessoryView:(CTMapAnnotationCalloutView*)annotationView;
-(void)didTapMarker:(CTMapAnnotationCalloutView*)view;
@end