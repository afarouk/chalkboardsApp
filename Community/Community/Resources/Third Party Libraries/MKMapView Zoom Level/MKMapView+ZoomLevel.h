//
//  MKMapView+ZoomLevel.h
//  Community
//
//  Created by Mac on 5/8/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//
#import <MapKit/MapKit.h>

#define MERCATOR_OFFSET 268435456
#define MERCATOR_RADIUS 85445659.44705395

#define MERCATOR_RADIUS 85445659.44705395
#define MAX_GOOGLE_LEVELS 20

@interface MKMapView (ZoomLevel)
-(MKMapRect)adjustRectForZoomOut:(MKMapRect)zoomRect;
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(double)zoomLevel
                   animated:(BOOL)animated;
- (double)getZoomLevel;


@end 
