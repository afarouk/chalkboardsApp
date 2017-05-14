//
//  CTRootControllerDataModel.m
//  Community
//
//  Created by practice on 20/03/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTRootControllerDataModel.h"

@implementation CTRootControllerDataModel
static CTRootControllerDataModel *sharedInstance;
@synthesize saslSummaryArray,listoftilesData,getarray,listofSaslData,getTilesData;
+(CTRootControllerDataModel*)sharedInstance {
    if(sharedInstance == nil)
        sharedInstance = [[CTRootControllerDataModel alloc]init];
    return sharedInstance;
}
-(void)saveSASLSummaryArray:(NSArray*)array {
    for(NSDictionary *restaurnatDictionary in array) {
        
    }
}
-(NSString *)calculateKilometersFromLatitude:(NSString *)lat andLongitude:(NSString *)lon latitude1:(NSString*)lat1 longitude1:(NSString*)long1{
    
    //    NSString *currentLat=[[NSUserDefaults standardUserDefaults]objectForKey:CT_Latitude];
    //    NSString *currentLon=[[NSUserDefaults standardUserDefaults]objectForKey:CT_Longitude];
    
    CLLocationCoordinate2D coordinate1;
    coordinate1.latitude=[lat1 doubleValue];
    coordinate1.longitude=[long1 doubleValue];
    
    CLLocationCoordinate2D coordinate2;
    coordinate2.latitude=[lat doubleValue];
    coordinate2.longitude=[lon doubleValue];
    
    CLLocation *location1=[[CLLocation alloc]initWithLatitude:coordinate1.latitude longitude:coordinate1.longitude];
    
    CLLocation *location2=[[CLLocation alloc]initWithLatitude:coordinate2.latitude longitude:coordinate2.longitude];
    
    CLLocationDistance distance=[location1 distanceFromLocation:location2];
    double km = distance * 0.001;
    NSString * kmStr=[NSString stringWithFormat:@"%0.2f",km];
    return kmStr;
}

-(void)setSaslSummaryArray:(NSMutableArray *)summArray {
    
    
    
    NSURL *url = [NSURL URLWithString:[CTCommonMethods sharedInstance].SelectTileSaSL];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
//    NSLog(@"It's my Dict value %@",dict);
    

//    NSLog(@"SummArraygetarray %@",getarray);
    listoftilesData = [[NSMutableArray alloc] init];
    listofSaslData = [[NSMutableArray alloc]init];
    [CTCommonMethods sharedInstance].friendlyURL = [[NSMutableArray alloc]init];
    [CTCommonMethods sharedInstance].tileUUIDtype = [[NSMutableArray alloc]init];
    [CTCommonMethods sharedInstance].tileUUID = [[NSMutableArray alloc]init];
    [CTCommonMethods sharedInstance].serviceLocationId = [[NSMutableArray alloc]init];
    [CTCommonMethods sharedInstance].serviceAccommodatorId = [[NSMutableArray alloc]init];
    [CTCommonMethods sharedInstance].SASLTitleName = [[NSMutableArray alloc]init];
    [CTCommonMethods sharedInstance].tileURL = [[NSMutableArray alloc]init];
    [CTCommonMethods sharedInstance].SASLStars = [[NSMutableArray alloc]init];
    [CTCommonMethods sharedInstance].tileContactList = [[NSMutableArray alloc] init];
    [CTCommonMethods sharedInstance].tileAddressList = [[NSMutableArray alloc]init];
    [CTCommonMethods sharedInstance].tileviewLati = [[NSMutableArray alloc]init];
    [CTCommonMethods sharedInstance].tileviewLong = [[NSMutableArray alloc] init];
    [CTCommonMethods sharedInstance].tileonClickURL = [[NSMutableArray alloc]init];
    [CTCommonMethods sharedInstance].TileHasAlert = [[NSMutableArray alloc]init];
    [CTCommonMethods sharedInstance].TileadAlertMessage = [[NSMutableArray alloc]init];
    
    saslSummaryArray = [summArray valueForKey:@"sasls"];
    getarray = summArray;
    NSLog(@"getarray = %d",getarray.count);
    //getarray = [dict valueForKey:@"tiles"];
    //NSLog(@"hello restro new%@",getarray);
    
    for (int p = 0; p<getarray.count; p++)
    {
        
        NSArray *saslarray = [getarray valueForKey:@"sasls"];
//         NSLog(@"saslarray %@",saslarray);
        getTilesData = [getarray valueForKey:@"sasls"];
        for (int k = 0; k < saslarray.count ; k++)
        {
            //        if ([[saslarray[k] valueForKey:@"hasAdAlert"] boolValue] == YES)
            //        {
            ////            //[[CTCommonMethods sharedInstance].TileadAlertMessage addObject:@"redcolor"];
            ////            [[CTCommonMethods sharedInstance].TileHasAlert addObject:@"redcolor"];
            ////            [[CTCommonMethods sharedInstance].friendlyURL addObject: @"redcolor"];
            ////            [[CTCommonMethods sharedInstance].serviceLocationId addObject:@"redcolor"];
            ////            [[CTCommonMethods sharedInstance].serviceAccommodatorId addObject:@"redcolor"];
            ////            [[CTCommonMethods sharedInstance].SASLTitleName addObject:@"redcolor"];
            ////            [[CTCommonMethods sharedInstance].SASLStars addObject:@"redcolor"];
            ////            [[CTCommonMethods sharedInstance].tileContactList addObject:@"redcolor"];
            ////            [[CTCommonMethods sharedInstance].tileAddressList addObject:@"redcolor"];
            ////            [[CTCommonMethods sharedInstance].tileviewLati addObject:@"redcolor"];
            ////            [[CTCommonMethods sharedInstance].tileviewLong addObject:@"redcolor"];
            ////            [[CTCommonMethods sharedInstance].tileURL addObject:@"redcolor"];
            ////
            ////            [listoftilesData addObject: @"redcolor"];
            //
            //                        [[CTCommonMethods sharedInstance].tileURL addObject:@"redcolor"];
            //                        [[CTCommonMethods sharedInstance].tileUUIDtype addObject:@"redcolor"];
            //                        [[CTCommonMethods sharedInstance].tileonClickURL addObject:@"redcolor"];
            //                        [[CTCommonMethods sharedInstance].tileUUID addObject:@"redcolor"];
            //                        [[CTCommonMethods sharedInstance].TileHasAlert addObject:@"redcolor"];
            //                        [[CTCommonMethods sharedInstance].friendlyURL addObject: @"redcolor"];
            //                        [[CTCommonMethods sharedInstance].serviceLocationId addObject:@"redcolor"];
            //                        [[CTCommonMethods sharedInstance].serviceAccommodatorId addObject:@"redcolor"];
            //                        [[CTCommonMethods sharedInstance].SASLTitleName addObject:@"redcolor"];
            //                        [[CTCommonMethods sharedInstance].SASLStars addObject:@"redcolor"];
            //                        [[CTCommonMethods sharedInstance].tileContactList addObject:@"redcolor"];
            //                        [[CTCommonMethods sharedInstance].tileAddressList addObject:@"redcolor"];
            //                        [[CTCommonMethods sharedInstance].tileviewLati addObject:@"redcolor"];
            //                        [[CTCommonMethods sharedInstance].tileviewLong addObject:@"redcolor"];
            //
            //
            //                        //NSString *adAlertMessage = [getarray[k] valueForKey:@"adAlertMessage"];
            //                        //[[CTCommonMethods sharedInstance].TileadAlertMessage addObject:adAlertMessage];
            //
            //                        [listoftilesData addObject: @"redcolor"];
            //        }
            
//            NSLog(@"getarray summary  = %@",saslarray[k]);
            NSMutableDictionary *tempsa = saslarray[k];
//            [tempsa setObject:@"320" forKey:@"iconWidth"];
//            [tempsa setObject:@"50" forKey:@"iconHeight"];
//            [tempsa setObject:@1 forKey:@"allowNavigationToSitelette"];
//            [tempsa setObject:@"http://simfel.com/apptsvc/rest/sasl/retrieveATC60bySASL?serviceAccommodatorId=ATMFFF3&serviceLocationId=ATMFFF3" forKey:@"iconURL"];
//            [tempsa setObject:@"http://simfel.com/apptsvc/rest/sasl/retrieveATC60bySASL?serviceAccommodatorId=ATMFFF3&serviceLocationId=ATMFFF3" forKey:@"appIconURL"];
            
//            [tempsa setObject:@"" forKey:@"adAlertMessage"];
            [tempsa setObject:@0 forKey:@"hasAdAlert"];
            [listofSaslData addObject:tempsa];
            
            //comingSoon
            //NSString * hasalert = [saslarray [k] valueForKey:@"hasAdAlert"];
            //[[CTCommonMethods sharedInstance].TileHasAlert addObject:hasalert];
            
            
            
//            NSString * serviceLocationId = [saslarray [k] valueForKey:@"serviceLocationId"];
//            [[CTCommonMethods sharedInstance].serviceLocationId addObject:serviceLocationId];
//            
//            NSString * serviceAccommodatorId = [saslarray [k] valueForKey:@"serviceAccommodatorId"];
//            [[CTCommonMethods sharedInstance].serviceAccommodatorId addObject:serviceAccommodatorId];
            
            //NSString *Rating = [saslarray[k] valueForKey:@"rating"];
            //[[CTCommonMethods sharedInstance].SASLStars addObject:Rating];
            //NSLog(@"Ratingallnw %@",Rating);
            
//            id getcontact = [saslarray[k] valueForKey:@"contact"];
//            [[CTCommonMethods sharedInstance].tileContactList addObject:getcontact];
//            
//            id getaddress = [saslarray[k] valueForKey:@"address"];
//            [[CTCommonMethods sharedInstance].tileAddressList addObject:getaddress];
            
            
            //NSLog(@"Tilelog %@",tilelog);
        }
    }
    
//    NSLog(@"saslarray %@",listofSaslData);;
    NSArray * gettiles = [dict valueForKey:@"tiles"];
//    NSLog(@"Get Tiles = %lu",(unsigned long)gettiles.count);
    
    if (gettiles.count > 0)
    {
        for (int j = 0; j < gettiles.count; j++)
        {
            NSString *promotype = [[gettiles[j] valueForKey:@"promoType"]valueForKey:@"enumText"];
            
            //NSString *enmtext = [gettiles[j] valueForKey:@"enumText"];
//            NSLog(@"hy enum %@",promotype);
            
            
            
            ///AdAlert(RedColor) Comment Now
//            if ([promotype isEqualToString:@"AD_ALERT"])
//            {
//                [[CTCommonMethods sharedInstance].tileUUIDtype addObject:@"redcolor"];
//                [[CTCommonMethods sharedInstance].tileonClickURL addObject:@"redcolor"];
//                [[CTCommonMethods sharedInstance].tileUUID addObject:@"redcolor"];
//                [[CTCommonMethods sharedInstance].tileURL addObject:@"redcolor"];
//                 NSString *name = [gettiles [j] valueForKey:@"saslName"];
//                [[CTCommonMethods sharedInstance].SASLTitleName addObject:name];
//                [[CTCommonMethods sharedInstance].TilePromoType addObject:@"redcolor"];
//                [listoftilesData addObject:@"redcolor"];
//                [[CTCommonMethods sharedInstance].tileContactList addObject:@"redcolor"];
//                [[CTCommonMethods sharedInstance].tileAddressList addObject:@"redcolor"];
//                NSString *adAlertMessage = [gettiles[j] valueForKey:@"message"];
//                [[CTCommonMethods sharedInstance].TileadAlertMessage addObject:adAlertMessage];
//                [[CTCommonMethods sharedInstance].serviceLocationId addObject:@"redcolor"];
//                [[CTCommonMethods sharedInstance].serviceAccommodatorId addObject:@"redcolor"];
//                [[CTCommonMethods sharedInstance].friendlyURL addObject: @"redcolor"];
//                [[CTCommonMethods sharedInstance].tileviewLati addObject:@"0.00"];
//                [[CTCommonMethods sharedInstance].tileviewLong addObject:@"0.00"];
//            }
           
            
            NSArray *tileURL = [gettiles[j] valueForKey:@"url"];
            if ([tileURL isEqual:[NSNull null]])
            {
                [[CTCommonMethods sharedInstance].tileURL addObject:@"k"];
            }
            else
            {
                [[CTCommonMethods sharedInstance].tileURL addObject:tileURL];
            }
            
            
            NSString * friendlyURL = [gettiles [j] valueForKeyPath:@"friendlyURL"];
            [[CTCommonMethods sharedInstance].friendlyURL addObject: friendlyURL];
            
            NSString * tilelati = [gettiles [j] valueForKeyPath:@"latLong.latitude"];
            [[CTCommonMethods sharedInstance].tileviewLati addObject:tilelati];
            //NSLog(@"Tilelati %@",tilelati);
            
            NSString * tilelog = [gettiles [j] valueForKeyPath:@"latLong.longitude"];
            [[CTCommonMethods sharedInstance].tileviewLong addObject:tilelog];
            
            [[CTCommonMethods sharedInstance].TilePromoType addObject:promotype];
            //NSLog(@"gettiles %@",gettiles[j]);
            [listoftilesData addObject:gettiles[j]];
            //NSLog(@"listarray %@ COUNT %d",listoftilesData,listoftilesData.count);
            id getcontact = [gettiles[j] valueForKey:@"contact"];
            [[CTCommonMethods sharedInstance].tileContactList addObject:getcontact];
            
            NSString * serviceLocationId = [gettiles [j] valueForKey:@"serviceLocationId"];
            [[CTCommonMethods sharedInstance].serviceLocationId addObject:serviceLocationId];
            
            NSString * serviceAccommodatorId = [gettiles [j] valueForKey:@"serviceAccommodatorId"];
            [[CTCommonMethods sharedInstance].serviceAccommodatorId addObject:serviceAccommodatorId];
           
            [[CTCommonMethods sharedInstance].TileadAlertMessage addObject:@"redcolor"];
            
            NSString * tempType = [gettiles[j] valueForKey:@"uuidtype"];
            [[CTCommonMethods sharedInstance].tileUUIDtype addObject:tempType];
            
            NSString *onClickURL = [gettiles[j] valueForKey:@"onClickURL"];
            [[CTCommonMethods sharedInstance].tileonClickURL addObject:onClickURL];
            
            NSString * tempUUID = [gettiles[j] valueForKey:@"uuid"];
            [[CTCommonMethods sharedInstance].tileUUID addObject:tempUUID];
            
            NSString *name = [gettiles [j] valueForKey:@"saslName"];
            [[CTCommonMethods sharedInstance].SASLTitleName addObject:name];
            id getaddress = [gettiles [j] valueForKey:@"address"];
            [[CTCommonMethods sharedInstance].tileAddressList addObject:getaddress];
            //NSLog(@"nameField %@",name);
        }
    }
    
//    NSLog(@"listarray COUNT %d",listoftilesData.count);
//    NSLog(@"listarray COUNT %d",[CTCommonMethods sharedInstance].tileURL.count);
//    NSLog(@"name tiles %@ %lu",[CTCommonMethods sharedInstance].TileadAlertMessage,(unsigned long)[CTCommonMethods sharedInstance].TileadAlertMessage.count);
//
//    NSLog(@"tempUUID tiles %@ %lu",[CTCommonMethods sharedInstance].tileUUID,(unsigned long)[CTCommonMethods sharedInstance].tileUUID.count);
//    
//    NSLog(@"onClickURL tiles %@ %lu",[CTCommonMethods sharedInstance].tileonClickURL,(unsigned long)[CTCommonMethods sharedInstance].tileonClickURL.count);
//    
//    NSLog(@"tempType tiles %@ %lu",[CTCommonMethods sharedInstance].tileUUIDtype,(unsigned long)[CTCommonMethods sharedInstance].tileUUIDtype.count);
//    
//    NSLog(@"TilePromotType %@ %lu",[CTCommonMethods sharedInstance].TilePromoType,(unsigned long)[CTCommonMethods sharedInstance].TilePromoType.count);
//    
//    NSLog(@"listoftilesData %@ %lu",listoftilesData,(unsigned long)listoftilesData.count);
    
    for(NSMutableDictionary *dictionary in [getarray valueForKey:@"sasls"]) {
//        NSLog(@"dictionary %@",dictionary);
        NSString *currentLat=[[NSUserDefaults standardUserDefaults]objectForKey:CT_Latitude];
        NSString *currentLon=[[NSUserDefaults standardUserDefaults]objectForKey:CT_Longitude];
        NSString *lat=[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"latitude"]];
        NSString *lon=[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"longitude"]];
        NSString *km = [self calculateKilometersFromLatitude:lat andLongitude:lon latitude1:currentLat longitude1:currentLon];
        [dictionary setObject:km forKey:kDistanceInKmKey];
    }
    
    //for (int k = 0; k < getarray.count ; k++)
    //{
    //NSLog(@"getarray summary  = %@",getarray[k]);
    //        //NSString * anchorURL = [getarray [k] valueForKeyPath:@"anchorURL.friendlyURL"];
    //        // NSLog(@"Kaushal TRy this === %@",[getarray [k] valueForKey:@"serviceAccommodatorId"]);
    //        if ([[getarray [k] valueForKey:@"hasAdAlert"] boolValue] == YES)
    //        {
    //            [[CTCommonMethods sharedInstance].tileURL addObject:@"redcolor"];
    //            [[CTCommonMethods sharedInstance].tileUUIDtype addObject:@"redcolor"];
    //            [[CTCommonMethods sharedInstance].tileonClickURL addObject:@"redcolor"];
    //            [[CTCommonMethods sharedInstance].tileUUID addObject:@"redcolor"];
    //            [[CTCommonMethods sharedInstance].TileHasAlert addObject:@"redcolor"];
    //            [[CTCommonMethods sharedInstance].friendlyURL addObject: @"redcolor"];
    //            [[CTCommonMethods sharedInstance].serviceLocationId addObject:@"redcolor"];
    //            [[CTCommonMethods sharedInstance].serviceAccommodatorId addObject:@"redcolor"];
    //            [[CTCommonMethods sharedInstance].SASLTitleName addObject:@"redcolor"];
    //            [[CTCommonMethods sharedInstance].SASLStars addObject:@"redcolor"];
    //            [[CTCommonMethods sharedInstance].tileContactList addObject:@"redcolor"];
    //            [[CTCommonMethods sharedInstance].tileAddressList addObject:@"redcolor"];
    //            [[CTCommonMethods sharedInstance].tileviewLati addObject:@"redcolor"];
    //            [[CTCommonMethods sharedInstance].tileviewLong addObject:@"redcolor"];
    //
    //
    //            NSString *adAlertMessage = [getarray[k] valueForKey:@"adAlertMessage"];
    //            [[CTCommonMethods sharedInstance].TileadAlertMessage addObject:adAlertMessage];
    //
    //            [listoftilesData addObject: @"redcolor"];
    //        }
    //
    //        NSArray * tiles = [getarray [k] valueForKey:@"tiles"];
    //        for (int p = 0; p<tiles.count; p++)
    //        {
    //
    //            //NSString * tempType = [tiles[p] valueForKey:@"tileUUIDtype"];
    //            NSString * tempType = [tiles[p] valueForKey:@"uuidtype"];
    //            [[CTCommonMethods sharedInstance].tileUUIDtype addObject:tempType];
    //
    //            NSString *onClickURL = [tiles[p] valueForKey:@"onClickURL"];
    //            [[CTCommonMethods sharedInstance].tileonClickURL addObject:onClickURL];
    //
    //            //NSString * tempUUID = [tiles[p] valueForKey:@"tileUUID"];
    //            NSString * tempUUID = [tiles[p] valueForKey:@"uuid"];
    //            [[CTCommonMethods sharedInstance].tileUUID addObject:tempUUID];
    //
    //            NSString *tileURL = [tiles[p] valueForKey:@"url"];
    //            [[CTCommonMethods sharedInstance].tileURL addObject:tileURL];
    //
    //            NSString * hasalert = [getarray [k] valueForKey:@"hasAdAlert"];
    //            [[CTCommonMethods sharedInstance].TileHasAlert addObject:hasalert];
    //
    //            [[CTCommonMethods sharedInstance].friendlyURL addObject: [getarray [k] valueForKeyPath:@"anchorURL.friendlyURL"]];
    //
    //            NSString * serviceLocationId = [getarray [k] valueForKey:@"hasAdAlert"];
    //            [[CTCommonMethods sharedInstance].serviceLocationId addObject:serviceLocationId];
    //
    //            NSString * serviceAccommodatorId = [getarray [k] valueForKey:@"serviceAccommodatorId"];
    //
    //            [[CTCommonMethods sharedInstance].serviceAccommodatorId addObject:serviceAccommodatorId];
    //            //[CTCommonMethods sharedInstance].serviceAccommodatorId =[getarray [k] valueForKey:@"serviceAccommodatorId"];
    //
    //            NSString *name = [getarray [k] valueForKey:@"name"];
    //
    //            [[CTCommonMethods sharedInstance].SASLTitleName addObject:name];
    //
    //            //NSLog(@"nameField %@",name);
    //
    //
    //            NSString *Rating = [getarray[k] valueForKey:@"rating"];
    //            [[CTCommonMethods sharedInstance].SASLStars addObject:Rating];
    //            //NSLog(@"Ratingallnw %@",Rating);
    //
    //            id getcontact = [getarray[k] valueForKey:@"contact"];
    //            [[CTCommonMethods sharedInstance].tileContactList addObject:getcontact];
    //
    //            id getaddress = [getarray[k] valueForKey:@"address"];
    //            [[CTCommonMethods sharedInstance].tileAddressList addObject:getaddress];
    //
    //
    //            NSString * tilelati = [getarray [k] valueForKey:@"latitude"];
    //            [[CTCommonMethods sharedInstance].tileviewLati addObject:tilelati];
    //
    //            NSString * tilelog = [getarray [k] valueForKey:@"longitude"];
    //            [[CTCommonMethods sharedInstance].tileviewLong addObject:tilelog];
    //
    //
    //            NSString *adAlertMessage = [getarray[k] valueForKey:@"adAlertMessage"];
    //            //[[CTCommonMethods sharedInstance].TileadAlertMessage addObject:adAlertMessage];
    //            [[CTCommonMethods sharedInstance].TileadAlertMessage addObject:@"redcolor"];
    //        }
    //
    //        //NSLog(@"hello serviceAccommodatorId %@",[CTCommonMethods sharedInstance].serviceLocationId);
    //        // NSLog(@"hello serviceLocationId %@",[CTCommonMethods sharedInstance].serviceLocationId);
    //
    //        NSArray * gettiles = [getarray[k] valueForKey:@"tiles"];
    //
    //        if (gettiles.count > 0)
    //        {
    //            for (int j = 0; j < gettiles.count; j++)
    //            {
    //                [listoftilesData addObject:gettiles[j]];
    //            }
    //        }
    //}
    //NSLog(@"listoftilesData %@ count= %d",listoftilesData,listoftilesData.count);
    // NSLog(@"salsummary %@ count = %lu",[CTCommonMethods sharedInstance].SASLTitleName,(unsigned long)[CTCommonMethods sharedInstance].SASLTitleName.count);
    //NSLog(@"serviceLocationId Kaushal %@ count = %lu",[CTCommonMethods sharedInstance].serviceLocationId,(unsigned long)[CTCommonMethods sharedInstance].serviceLocationId.count);
    //NSLog(@"tileUUIDtypetileUUID123 %@ count = %lu",[CTCommonMethods sharedInstance].tileUUID,(unsigned long)[CTCommonMethods sharedInstance].tileUUID.count);
    //NSLog(@"tileUUIDtypetileUUIDtype123 %@ count = %lu",[CTCommonMethods sharedInstance].tileUUIDtype,(unsigned long)[CTCommonMethods sharedInstance].tileUUIDtype.count);
    //     NSLog(@"friendlyURL123 %@ count = %lu",[CTCommonMethods sharedInstance].friendlyURL,(unsigned long)[CTCommonMethods sharedInstance].friendlyURL.count);
    // apply sorting by distance
    
}
@end
