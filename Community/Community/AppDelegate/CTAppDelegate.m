//
//  CTAppDelegate.m
//  Community
//
//  Created by dinesh on 19/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTAppDelegate.h"
#import "RedirectNSLogs.h"
#import "AFHTTPClient.h"



@implementation CTAppDelegate
+(CTAppDelegate *)sharedNetworkStatus{
    
    return (CTAppDelegate *)[[UIApplication sharedApplication]delegate];
}
- (void) redirectConsoleLogToDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"console.log"];
    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#if TARGET_IPHONE_SIMULATOR == 0
    // redirects logs file to documents directory.
    [[RedirectNSLogs sharedInstance] redirectNSLogToDocuments];
#endif
    
    // Override point for customization after application launch.
    [CTCommonMethods registerDefaultsFromSettingsBundle];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"saslSummary"];
    if(![[NSUserDefaults standardUserDefaults]objectForKey:@"server"]){
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:CT_ProdServer forKey:@"server"];
        [defaults setBool:NO forKey:@"simulate"];
        [defaults synchronize];
    }
    
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
    NSMutableDictionary *mutableRetrievedDictionary = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DicKey"] mutableCopy];
    NSLog(@"mutable data %@",mutableRetrievedDictionary);
    
    [CTCommonMethods sharedInstance].OWNERFLAG = [[mutableRetrievedDictionary valueForKey:@"isOwner"] boolValue];
    [CTCommonMethods sharedInstance].EmailID = [mutableRetrievedDictionary valueForKey:@"email"];
    [CTCommonMethods sharedInstance].Onuser =[mutableRetrievedDictionary objectForKey:@"userName"];
    [CTCommonMethods setUID:[mutableRetrievedDictionary objectForKey:@"uid"]];
    NSLog(@"CTCommonMethods UID = %@",[CTCommonMethods UID]);
    
    NSMutableDictionary *mutableRetrievedDictionary1 = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SASLSelect"] mutableCopy];
    NSLog(@"mutable data %@",mutableRetrievedDictionary1);
    
    [CTCommonMethods sharedInstance].selectSa = [mutableRetrievedDictionary1 objectForKey:@"SelectSA"];
    [CTCommonMethods sharedInstance].selectSl = [mutableRetrievedDictionary1 objectForKey:@"SelectSL"];
    
    // saves logs in document directory.
//    if(!TARGET_IPHONE_SIMULATOR)
//        [self redirectConsoleLogToDocumentFolder];
    return YES;
}
//#pragma marl location manager delegate calls
//-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
//    
//    switch (status) {
//        case kCLAuthorizationStatusAuthorized:
//            self.isLocationServiceAllowed=YES;
//            break;
//        case kCLAuthorizationStatusDenied:
//            self.isLocationServiceAllowed=NO;
//            [CTCommonMethods showErrorAlertMessageWithTitle:CT_LocationDisabledTitle andMessage:CT_LocationDisbaledMessage];
//            break;
//        case kCLAuthorizationStatusNotDetermined:
//            self.isLocationServiceAllowed=NO;
//            //[CTCommonMethods showErrorAlertMessageWithTitle:CT_LocationDisabledTitle andMessage:CT_LocationDisbaledMessage];
//            break;
//        case kCLAuthorizationStatusRestricted:
//            self.isLocationServiceAllowed=NO;
//            [CTCommonMethods showErrorAlertMessageWithTitle:CT_LocationDisabledTitle andMessage:CT_LocationDisbaledMessage];
//            break;
//        default:
//            break;
//    }
//}
//-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
//    
//    self.currentLatitude=newLocation.coordinate.latitude;
//    self.currentLongitude=newLocation.coordinate.longitude;
//}

// A function for parsing URL parameters
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL urlWasHandled =
    [FBAppCall handleOpenURL:url
           sourceApplication:sourceApplication
             fallbackHandler:
     ^(FBAppCall *call) {
         // Parse the incoming URL to look for a target_url parameter
         NSString *query = [url query];
         NSDictionary *params = [self parseURLParams:query];
         // Check if target URL exists
         NSString *appLinkDataString = [params valueForKey:@"al_applink_data"];
         if (appLinkDataString) {
             NSError *error = nil;
             NSDictionary *applinkData =
             [NSJSONSerialization JSONObjectWithData:[appLinkDataString dataUsingEncoding:NSUTF8StringEncoding]
                                             options:0
                                               error:&error];
             if (!error &&
                 [applinkData isKindOfClass:[NSDictionary class]] &&
                 applinkData[@"target_url"]) {
                 self.refererAppLink = applinkData[@"referer_app_link"];
                 NSString *targetURLString = applinkData[@"target_url"];
                 // Show the incoming link in an alert
                 // Your code to direct the user to the
                 // appropriate flow within your app goes here
                 [[[UIAlertView alloc] initWithTitle:@"Received link:"
                                             message:targetURLString
                                            delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil] show];
             }
         }
     }];
    
    return urlWasHandled;
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}
-(void)getCurrentGeoPoints{
    [self.locationManager startUpdatingLocation];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self.locationManager startUpdatingLocation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//      [self.locationManager startUpdatingLocation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
