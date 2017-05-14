//
//  MKMapView+ZoomLevel.m
//  Community
//
//  Created by Mac on 5/8/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MKMapView+ZoomLevel.h"


@implementation MKMapView (ZoomLevel)

#pragma mark -
#pragma mark Map conversion methods

-(MKMapRect)adjustRectForZoomOut:(MKMapRect)zoomRect {
    double minimumZoom = 12000; // for my purposes the width/height have same min zoom
    BOOL needChange = NO;
    double x = MKMapRectGetMinX(zoomRect);
    double y = MKMapRectGetMinY(zoomRect);
    double w = MKMapRectGetWidth(zoomRect);
    double h = MKMapRectGetHeight(zoomRect);
    double centerX = MKMapRectGetMidX(zoomRect);
    double centerY = MKMapRectGetMidY(zoomRect);
    
    if (h < minimumZoom) {  // no need to call MKMapRectGetHeight again; we just got its value!
        // get the multiplicative factor used to scale old height to new,
        // then apply it to the old width to get a proportionate new width
        double factor = minimumZoom / h;
        h = minimumZoom;
        w *= factor;
        x = centerX - w/2;
        y = centerY - h/2;
        needChange = YES;
    }
    
    if (w < minimumZoom) {
        // since we've already adjusted the width, there's a chance this
        // won't even need to execute
        double factor = minimumZoom / w;
        w = minimumZoom;
        h *= factor;
        x = centerX - w/2;
        y = centerY - h/2;
        needChange = YES;
    }
    
    if (needChange) {
        zoomRect = MKMapRectMake(x, y, w, h);
    }
    return zoomRect;
}
- (double)longitudeToPixelSpaceX:(double)longitude
{
    return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / 180.0);
}

- (double)latitudeToPixelSpaceY:(double)latitude
{
    return round(MERCATOR_OFFSET - MERCATOR_RADIUS * logf((1 + sinf(latitude * M_PI / 180.0)) / (1 - sinf(latitude * M_PI / 180.0))) / 2.0);
}

- (double)pixelSpaceXToLongitude:(double)pixelX
{
    return ((round(pixelX) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * 180.0 / M_PI;
}

- (double)pixelSpaceYToLatitude:(double)pixelY
{
    return (M_PI / 2.0 - 2.0 * atan(exp((round(pixelY) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * 180.0 / M_PI;
}

#pragma mark -
#pragma mark Helper methods

- (MKCoordinateSpan)coordinateSpanWithMapView:(MKMapView *)mapView
                             centerCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                 andZoomLevel:(double)zoomLevel
{
    NSLog(@"in custom zoomlevel-->%f",zoomLevel);
    // convert center coordiate to pixel space
    double centerPixelX = [self longitudeToPixelSpaceX:centerCoordinate.longitude];
    double centerPixelY = [self latitudeToPixelSpaceY:centerCoordinate.latitude];
    
    // determine the scale value from the zoom level
    double zoomExponent = 20.0 - zoomLevel;
    double zoomScale = pow(2, zoomExponent);
    
    // scale the map’s size in pixel space
    CGSize mapSizeInPixels = mapView.bounds.size;
    double scaledMapWidth = mapSizeInPixels.width * zoomScale;
    double scaledMapHeight = mapSizeInPixels.height * zoomScale;
    
    // figure out the position of the top-left pixel
    double topLeftPixelX = centerPixelX - (scaledMapWidth / 2);
    double topLeftPixelY = centerPixelY - (scaledMapHeight / 2);
    
    // find delta between left and right longitudes
    CLLocationDegrees minLng = [self pixelSpaceXToLongitude:topLeftPixelX];
    CLLocationDegrees maxLng = [self pixelSpaceXToLongitude:topLeftPixelX + scaledMapWidth];
    CLLocationDegrees longitudeDelta = maxLng - minLng;
    
    // find delta between top and bottom latitudes
    CLLocationDegrees minLat = [self pixelSpaceYToLatitude:topLeftPixelY];
    CLLocationDegrees maxLat = [self pixelSpaceYToLatitude:topLeftPixelY + scaledMapHeight];
    CLLocationDegrees latitudeDelta = -1 * (maxLat - minLat);
    
    // create and return the lat/lng span
    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
    return span;
}

#pragma mark -
#pragma mark Public methods

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(double)zoomLevel
                   animated:(BOOL)animated
{
    // clamp large numbers to 28
    zoomLevel = MIN(zoomLevel, 28);
    
    // use the zoom level to compute the region
    MKCoordinateSpan span = [self coordinateSpanWithMapView:self centerCoordinate:centerCoordinate andZoomLevel:zoomLevel];
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
    
    // set the region like normal
    [self setRegion:region animated:animated];
}
- (double)getZoomLevel
{
    CLLocationDegrees longitudeDelta = self.region.span.longitudeDelta;
    CGFloat mapWidthInPixels = self.bounds.size.width;
    double zoomScale = longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * mapWidthInPixels);
    double zoomer = MAX_GOOGLE_LEVELS - log2( zoomScale );
    if ( zoomer < 0 ) zoomer = 0;
    //  zoomer = round(zoomer);
    return zoomer;
}
@end 

