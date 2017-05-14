//
//  MapViewController.m
//  Miller
//
//  Created by kadir pekel on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapView.h"
#import "CTDriveMapViewController.h"

@interface MapView()

-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded :(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t ;
-(void) updateRouteView;
-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) from to: (CLLocationCoordinate2D) to;
-(void) centerMap;

@end

@implementation MapView

//@synthesize lineColor;
@synthesize mapView;
- (id) initWithFrame:(CGRect) frame
{
	self = [super initWithFrame:frame];
	if (self != nil) {
		mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		mapView.showsUserLocation = YES;
		[mapView setDelegate:self];
		[self addSubview:mapView];
		routeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mapView.frame.size.width, mapView.frame.size.height)];
		routeView.userInteractionEnabled = NO;
		[mapView addSubview:routeView];
        mapView.showsUserLocation = YES;
		
//		self.lineColor = [UIColor colorWithWhite:0.2 alpha:0.5];
	}
	return self;
}


-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded :(CLLocationCoordinate2D)f to: (CLLocationCoordinate2D) t {
	[encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
								options:NSLiteralSearch
								  range:NSMakeRange(0, [encoded length])];
//    NSLog(@"hello encoded %@",encoded);
	NSInteger len = [encoded length];
	NSInteger index = 0;
	NSMutableArray *array = [[NSMutableArray alloc] init];
	NSInteger lat=0;
	NSInteger lng=0;
	while (index < len) {
		NSInteger b;
		NSInteger shift = 0;
		NSInteger result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lat += dlat;
		shift = 0;
		result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lng += dlng;
		NSNumber *latitude = [[[NSNumber alloc] initWithFloat:lat * 1e-5] autorelease];
		NSNumber *longitude = [[[NSNumber alloc] initWithFloat:lng * 1e-5] autorelease];
		printf("[%f,", [latitude floatValue]);
		printf("%f]", [longitude floatValue]);
		CLLocation *loc = [[[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]] autorelease];
		[array addObject:loc];
	}
    CLLocation *first = [[[CLLocation alloc] initWithLatitude:[[NSNumber numberWithFloat:f.latitude] floatValue] longitude:[[NSNumber numberWithFloat:f.longitude] floatValue] ] autorelease];
    CLLocation *end = [[[CLLocation alloc] initWithLatitude:[[NSNumber numberWithFloat:t.latitude] floatValue] longitude:[[NSNumber numberWithFloat:t.longitude] floatValue] ] autorelease];
	[array insertObject:first atIndex:0];
    [array addObject:end];
    
   // NSLog(@"hellooo arrayyy %@",array);
	return array;
}

-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t {

    NSString *apiResponse ;//= [NSString stringWithContentsOfURL:apiUrl];
    NSError *error;
    NSString *mode;
    //mode =@"TRANSIT";//driving//bicycling
    mode = @"driving";

    NSString *baseUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=true&mode=%@", f.latitude,  f.longitude, t.latitude,  t.longitude,mode];
    NSLog(@"baseUrl = %@",baseUrl);
    apiResponse= [NSString stringWithContentsOfURL:[NSURL URLWithString:baseUrl] encoding:NSASCIIStringEncoding error:&error];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:[apiResponse dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
//    NSLog(@"hello result %@",result);

    @try {
        NSArray *dist=[[[[[result objectForKey:@"routes"]objectAtIndex:0]objectForKey:@"legs"]objectAtIndex:0]objectForKey:@"distance"];
        _destination=[dist valueForKey:@"text"];
        
        distance =[dist valueForKey:@"text"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"dist" object:nil];
        
        NSArray *distmin=[[[[[result objectForKey:@"routes"]objectAtIndex:0]objectForKey:@"legs"]objectAtIndex:0]objectForKey:@"duration"];
        _destmin=[distmin valueForKey:@"text"];
        
        min =[distmin valueForKey:@"text"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"min" object:nil];
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"error");
    }
    @finally {
        
    }
    
    
   

//    ViewController *viewcon = [[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
//    viewcon.distance_lbl.text = _destination;
    
    
   // distance_lbl.text=destination;
    
    routes= [result objectForKey:@"routes"];
    NSString* encodedPath = nil;
    if (routes.count == 0)
    {
        
    }
    else{
        NSDictionary *firstRoute = [routes objectAtIndex:0];
        encodedPath = [firstRoute[@"overview_polyline"] objectForKey:@"points"];
        return [self decodePolyLine:[encodedPath mutableCopy]:f to:t];
    }
    
    return [[NSArray alloc] init];
}

-(void) centerMap {

	MKCoordinateRegion region;

	CLLocationDegrees maxLat = -90;
	CLLocationDegrees maxLon = -180;
	CLLocationDegrees minLat = 90;
	CLLocationDegrees minLon = 180;
    if (routes.count >0)
    {
        for(int idx = 0; idx < routes.count; idx++)
        {
            CLLocation* currentLocation = [routes objectAtIndex:idx];
            if(currentLocation.coordinate.latitude > maxLat)
                maxLat = currentLocation.coordinate.latitude;
            if(currentLocation.coordinate.latitude < minLat)
                minLat = currentLocation.coordinate.latitude;
            if(currentLocation.coordinate.longitude > maxLon)
                maxLon = currentLocation.coordinate.longitude;
            if(currentLocation.coordinate.longitude < minLon)
                minLon = currentLocation.coordinate.longitude;
        }
        region.center.latitude     = (maxLat + minLat) / 2;
        region.center.longitude    = (maxLon + minLon) / 2;
        region.span.latitudeDelta  = maxLat - minLat + 0.018;
        region.span.longitudeDelta = maxLon - minLon + 0.018;
        
        [mapView setRegion:region animated:YES];
    }
    else
    {
        [[[UIAlertView alloc]initWithTitle:@"Wrong Location" message:@"Please Enter Valid Location" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil]show];
    }
}

-(void) showRouteFrom: (Place*) f to:(Place*) t {
	
	if(routes) {
		//[mapView removeAnnotations:[mapView annotations]];
		//[routes release];
	}
    
    PlaceMark* from = [[[PlaceMark alloc] initWithPlace:f] autorelease];
    PlaceMark* to = [[[PlaceMark alloc] initWithPlace:t] autorelease];
    
    [mapView addAnnotation:from];
    [mapView addAnnotation:to];
    
    routes = [self calculateRoutesFrom:from.coordinate to:to.coordinate];
    [self updateRouteView];
    [self centerMap];
}

-(void) updateRouteView {
   // [mapView removeOverlays:mapView.overlays];

    CLLocationCoordinate2D pointsToUse[[routes count]];
    if (routes.count > 0) {
        for (int i = 0; i < [routes count]; i++) {
            CLLocationCoordinate2D coords;
            CLLocation *loc = [routes objectAtIndex:i];
            coords.latitude = loc.coordinate.latitude;
            coords.longitude = loc.coordinate.longitude;
            pointsToUse[i] = coords;
        }
        MKPolyline *lineOne = [MKPolyline polylineWithCoordinates:pointsToUse count:[routes count]];
        [mapView addOverlay:lineOne];
    }
    
//********************作者源代码********************
//直接画线。
//	CGContextRef context = 	CGBitmapContextCreate(nil, 
//												  routeView.frame.size.width, 
//												  routeView.frame.size.height, 
//												  8, 
//												  4 * routeView.frame.size.width,
//												  CGColorSpaceCreateDeviceRGB(),
//												  kCGImageAlphaPremultipliedLast);
//	
//	CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
//	CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
//	CGContextSetLineWidth(context, 10);
//	CGContextSetAlpha(context, 0.5);
//    CGContextSetLineJoin(context, kCGLineJoinRound);
//    CGContextSetLineCap(context, kCGLineCapRound);
//	for(int i = 0; i < routes.count; i++) {
//		CLLocation* location = [routes objectAtIndex:i];
//		CGPoint point = [mapView convertCoordinate:location.coordinate toPointToView:routeView];
//		
//		if(i == 0) {
//			CGContextMoveToPoint(context, point.x, routeView.frame.size.height - point.y);
//		} else {
//			CGContextAddLineToPoint(context, point.x, routeView.frame.size.height - point.y);
//		}
//	}
//	
//	CGContextStrokePath(context);
//	
//	CGImageRef image = CGBitmapContextCreateImage(context);
//	UIImage* img = [UIImage imageWithCGImage:image];
//	
//	routeView.image = img;
//	CGContextRelease(context);
//
}

#pragma mark mapView delegate functions
//作者源代码
//- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
//{
//	routeView.hidden = YES;
//}
//
//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
//{
//	[self updateRouteView];
//	routeView.hidden = NO;
//	[routeView setNeedsDisplay];
//}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView *lineview=[[MKPolylineView alloc] initWithOverlay:overlay] ;
        //路线颜色.3
        float randomRed = arc4random() % 255;
        float randomGreen = arc4random() % 255;
        float randomBlue = arc4random() % 255;
        
    
        lineview.strokeColor=[UIColor colorWithRed:randomRed/255 green:randomGreen/255 blue:randomBlue/255 alpha:1.0];
        
        lineview.lineWidth=8.0;
        return lineview;
    }
    return nil;
}

- (void)dealloc {
	if(routes) {
		[routes release];
	}
	[mapView release];
	[routeView release];
    [super dealloc];
}

@end
