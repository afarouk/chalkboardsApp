//
//  CTTileViewController.m
//  Community
//
//  Created by practice on 08/06/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTTileViewController.h"
#import "CTRootControllerDataModel.h"
#import "NSArray+RestaurantSummaryByUIDAndLocation.h"
#import "NSDictionary+RestaurantSummaryByUIDAndLocation_Package.h"
#import "NSMutableDictionary+MarkerDetails.h"
#import "NSArray+SASLSummaryByUIDAndLocation_Package.h"
#import "NSMutableDictionary+SASLSummaryByUIDAndLocation.h"
#import "CTTileViewCell.h"
#import "MBProgressHUD.h"
#import "CTWebviewDetailsViewController.h"
#import "CTAppDelegate.h"
#import "CTParentViewController.h"
#import "ImageNamesFile.h"
#import "UIViewController+MJPopupViewController.h"

#define ButtonTag 101

@interface CTTileViewController ()<MJSecondPopupDelegate>

@end

@implementation CTTileViewController
#define kTileView_AppIconURLKey  @"appIconURL"
//#define kTileView_TileImageKey   @"tileURL"
#define kTileView_TileImageKey   @"url"
//#define kTileView_TitleKey       @"tileTitle"
#define kTileView_TitleKey       @"title"
//#define kTileView_TileMessageKey @"tileMessage"
#define kTileView_TileMessageKey @"message"
#define kTileView_TileSASLName   @"name"

#define kDictionaryKey_TitleImage @"TitleViewImage"
#define kDictionaryKey_AppIcon @"TitleViewAppIcon"

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // change in array.
    NSLog(@"observe value here");
    if ([keyPath isEqual:@"saslSummaryArray"]) {
        @synchronized(self.tableView) {
            [imageDownloadedDictionary removeAllObjects];
            //            if(tempSaslSummaryArray.count>0)
            //                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [self.tableView reloadData];
        }
    }
    /*
     Be sure to call the superclass's implementation *if it implements it*.
     NSObject does not implement the method.
     */
    //    [super observeValueForKeyPath:keyPath
    //                         ofObject:object
    //                           change:change
    //                          context:context];
}
-(CGSize)sizeForRowIfImageDownloaded:(UIImage*)img {
    CGSize size = img.size;
    CGFloat width = 180;
    if(size.width<=width)
        return size;
    else {
        // calculate ration
        // calculate percentage
        CGFloat percentage = width/size.width;
        if(size.height*percentage>=138)
            return CGSizeMake(width, size.height*percentage);
        else {
            //            percentage = width/size.height;
            if(percentage*width<=180)
                return CGSizeMake(width, size.height*percentage);
            return CGSizeZero;
        }
    }
}

-(UIImage*)markerImageInDictionary:(NSDictionary*)dictionary {
    @try{
        NSString *selectedCategory = [[CTRootControllerDataModel sharedInstance]selectedCategory];
        NSMutableArray  *mapMarkers=(NSMutableArray*)[dictionary saslMapMarkers];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@",selectedCategory];
        NSArray *filtered = [mapMarkers filteredArrayUsingPredicate:predicate];
        if(filtered.count>0) {
            NSMutableDictionary *markerDictionary = [filtered lastObject];

            UIImage *markerImage; //= [markerDictionary markerImage];
            NSString * markImagestring = [markerDictionary apiMarkerURL];
//            NSLog(@"markImagestring = %@",markImagestring);
            NSURL *url = [NSURL URLWithString:markImagestring];
            UIImageView * myimageview =[[UIImageView alloc] init];
            NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (data) {
                    UIImage *image = [UIImage imageWithData:data];
                    if (image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            myimageview.image = image;
                           
                        });
                    }
                }
            }];
            [task resume];
            markerImage = myimageview.image;
//            NSLog(@"hello image %@",markerImage);
//            NSLog(@"make dict %@",[markerDictionary markerImage]);
            return markerImage;
        }
        return nil;
    }
    @catch (NSException *exception)
    {
        NSLog(@"CELL RATING URL EXCEPTION %@",exception);
    }
    
}


-(CTTileViewCell*)configureCell:(CTTileViewCell*)cell forIndexPath:(NSIndexPath*)indexPath {
    
    if (indexPath.row == 19)
    {
        
    }
    
    __block NSMutableDictionary *dictionary = [[[CTRootControllerDataModel sharedInstance]listoftilesData]objectAtIndex:indexPath.row];
//    NSLog(@"dictionary = %@",dictionary);
    //NSLog(@"list data %@ COUNT %d",dictionary,dictionary.count);
    // __block NSMutableDictionary *dictionarynw = [[[CTRootControllerDataModel sharedInstance]listofSaslData]objectAtIndex:indexPath.row];
    //NSLog(@"list data %@ COUNT %d",[[CTRootControllerDataModel sharedInstance]listoftilesData],[[CTRootControllerDataModel sharedInstance]listoftilesData].count);
    if ([[[CTCommonMethods sharedInstance].tileURL objectAtIndex:indexPath.row]isEqualToString:@"redcolor"])
    {
        cell.titleLabel.hidden = YES;
        cell.backgroundColor = [UIColor redColor];
        cell.PromoLabel.hidden = YES;
        cell.messageLabel.hidden = YES;
        cell.PromoLabel.hidden = YES;
        cell.bgLabel.hidden = YES;
        cell.saslNameLabel.hidden = YES;
        cell.markerImageView.hidden = YES;
        cell.shareImg.hidden = YES;
        cell.AdAlertMsg.hidden = NO;
//        cell.AdAlertMsg.text = [NSString stringWithFormat:@"%@ : %@",[CTCommonMethods sharedInstance].SASLTitleName[indexPath.row],[CTCommonMethods sharedInstance].TileadAlertMessage[indexPath.row]];
        NSString *testString=[NSString stringWithFormat:@"%@ : %@",[CTCommonMethods sharedInstance].SASLTitleName[indexPath.row],[CTCommonMethods sharedInstance].TileadAlertMessage[indexPath.row]];
        
        NSRange range = [testString rangeOfString:@":"];
        
        NSUInteger firstCharacterPosition = range.location;
//        NSUInteger lastCharacterPosition = range.location + range.length;
        
        NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:testString];
        [hogan addAttribute:NSFontAttributeName
                      value:[UIFont boldSystemFontOfSize:20.0]
                      range:NSMakeRange(0, firstCharacterPosition)];
        [cell.AdAlertMsg setAttributedText:hogan];
    }
    else
    {
        
        //    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        //__block NSMutableDictionary *dictionarynw = [[[CTRootControllerDataModel sharedInstance]saslSummaryArray]objectAtIndex:indexPath.row];
        //__block NSMutableDictionary *dictionarynw = [[CTCommonMethods sharedInstance].tileUUIDtype objectAtIndex:indexPath.row];
        
        
        
        //NSLog(@"dictionary = %@",dictionary);
        //__block NSMutableDictionary *getdictionary = [[[CTRootControllerDataModel sharedInstance]getarray]objectAtIndex:indexPath.row];
        
        //NSLog(@"hello dictionarynw %@",dictionarynw);
        
        //NSLog(@"hello listoftiles %@",[[CTRootControllerDataModel sharedInstance]listoftilesData]);
        
        //NSLog(@"call this dictionary %@",[[[CTRootControllerDataModel sharedInstance]listoftilesData] objectAtIndex:indexPath.row]);
        // tile Title
        //    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(165, 0, 150, 48)];
        //    label.backgroundColor = [UIColor clearColor];
        //    label.textColor = [UIColor blackColor];
        //    label.font = [UIFont boldSystemFontOfSize:14.0f];
        //    label.textAlignment = NSTextAlignmentRight;
        //    label.numberOfLines =0;
        //    label.lineBreakMode = NSLineBreakByWordWrapping;
        //    label.text = [dictionary valueForKey:kTileView_TitleKey];
        
        //    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(165, 50, 150, 80)];
        //    message.backgroundColor = [UIColor clearColor];
        //    message.textColor = [UIColor blackColor];
        //    message.font = [UIFont systemFontOfSize:12.0f];
        //    message.numberOfLines = 0;
        //    message.lineBreakMode = NSLineBreakByWordWrapping;
        //    message.textAlignment = NSTextAlignmentRight;
        //    message.text = [dictionary valueForKey:kTileView_TileMessageKey];
        //    [message sizeToFit];
        //    [cell.contentView addSubview:label];
        //    [cell.contentView addSubview:message];
        //    NSLog(@"dictionary = %@",dictionary);
        
        cell.titleLabel.text = [dictionary valueForKey:kTileView_TitleKey];
        //NSLog(@"titleLabel %@",cell.titleLabel.text);
        
        cell.messageLabel.text = [dictionary valueForKey:kTileView_TileMessageKey];
        //NSLog(@"msg %@",cell.messageLabel.text);
        
        NSArray *tiletype = [dictionary valueForKey:@"promoType"];
        cell.PromoLabel.text = [tiletype valueForKey:@"displayText"];
        NSString * enumtext = [tiletype valueForKey:@"enumText"];
        
        if ([enumtext isEqualToString:@"DISCOUNT"])
        {
            cell.promoimage.image = [UIImage imageNamed:@"DISCOUNT.png"];
        }
        else if ([enumtext isEqualToString:@"OTHER"])
        {
            cell.promoimage.image = [UIImage imageNamed:@"OTHER.png"];
        }
        else if ([enumtext isEqualToString:@"DINING_DEAL"])
        {
            cell.promoimage.image = [UIImage imageNamed:@"DINING_DEAL.png"];
        }
        else if ([enumtext isEqualToString:@"ENTERTAINMENT"])
        {
            cell.promoimage.image = [UIImage imageNamed:@"ENTERTAINMENT.png"];
        }
        else if ([enumtext isEqualToString:@"CAMPAIGN_PROMOTION"])
        {
            cell.promoimage.image = [UIImage imageNamed:@"CAMPAIGN_PROMOTION.png"];
        }
        else if ([enumtext isEqualToString:@"ACTIVITY"])
        {
            cell.promoimage.image = [UIImage imageNamed:@"ACTIVITY.png"];
        }
        else if ([enumtext isEqualToString:@"CAMPAIGN_SUBSCRIBE_FOR_NOTIFICATION"])
        {
            cell.promoimage.image = [UIImage imageNamed:@"NOTIFICATION.png"];
        }
        else if ([enumtext isEqualToString:@"HAPPYHOUR"])
        {
            cell.promoimage.image = [UIImage imageNamed:@"HAPPYHOUR.png"];
        }
        else if ([enumtext isEqualToString:@"AD_ALERT"])
        {
            cell.promoimage.image = [UIImage imageNamed:@"AD_ALERT_Tile.png"];
        }
        else if ([enumtext isEqualToString:@"EVENT"])
        {
            cell.promoimage.image = [UIImage imageNamed:@"EVENT.png"];
        }
        else if ([enumtext isEqualToString:@"PHOTO_CONTEST"])
        {
            cell.promoimage.image = [UIImage imageNamed:@"PHOTO_CONTEST.png"];
        }
        else if ([enumtext isEqualToString:@"POLL"])
        {
            cell.promoimage.image = [UIImage imageNamed:@"POLL.png"];
        }
        
        //[cell setRating:[NSString stringWithFormat:@"%@",[CTCommonMethods sharedInstance].SASLStars[indexPath.row]]];
        //NSLog(@"MyRating %@",[NSString stringWithFormat:@"%@",[CTCommonMethods sharedInstance].SASLStars[indexPath.row]]);
        NSString *hexString = [tiletype valueForKey:@"color"];
        //NSLog(@"Hexa %@",hexString);
        
        if (hexString)
        {
            cell.PromoLabel.textColor =[CTCommonMethods colorWithHexString:hexString];
        }
        
        //        if ([CTCommonMethods sharedInstance].SASLTitleName > 0) {
        //            cell.saslNameLabel.text = [NSString stringWithFormat:@"%@",[CTCommonMethods sharedInstance].SASLTitleName[indexPath.row]];
        //            [cell.saslNameLabel setHidden:NO];
        //        }
        //        else{
        //            [cell.saslNameLabel setHidden:YES];
        //        }
        
        if ([CTCommonMethods sharedInstance].SASLTitleName > 0) {
            cell.saslNameLabel.text = [dictionary valueForKey:@"saslName"];
            [cell.saslNameLabel setHidden:NO];
        }
        else{
            [cell.saslNameLabel setHidden:YES];
        }
        
        __block CTTileViewCell *cellObj = cell;
        
        
        
        //NSLog(@"tileImageArr %@",[CTCommonMethods sharedInstance].tileURL);
        for (int l = 0; l<[CTCommonMethods sharedInstance].tileURL.count; l++)
        {
            helloimage = [NSString stringWithFormat:@"%@",[CTCommonMethods sharedInstance].tileURL[l]];
            //NSLog(@"new Images %@ Count",helloimage);
        }
        
        NSString *tileImageURL = [dictionary valueForKey:kTileView_TileImageKey];
        
        tilelistarr = [[NSMutableArray alloc]init];
        tilelistarr = [dictionary valueForKey:kTileView_TileImageKey];
        
        
        //NSLog(@"hellooINDEX %lu VALUE %@",(unsigned long)tilelistarr.count,tilelistarr);
        
        //    BOOL hasAdAlert = [dictionary valueForKey:@"hasAdAlert"];
        //
        //    if (hasAdAlert == TRUE)
        //    {
        //
        //    }
        //    else
        //    {
        //        //[[CTCommonMethods sharedInstance].tileURL insertObject:@"1" atIndex:0];
        //    }
        
        //NSString *tileImageURL = [NSString stringWithFormat:@"%@",[CTCommonMethods sharedInstance].tileURL];
        //NSLog(@"hello tile %@",tileImageURL);
        
        //NSString *iconURL = [dictionary valueForKey:kTileView_AppIconURLKey];
        //NSLog(@"tile image %@",tileImageURL);
        //    NSLog(@"icon url %@",iconURL);
        cell.tileImageView.image = nil;
//        if ([enumtext isEqualToString:@"CAMPAIGN_PROMOTION"])
//        {
//            cell.tileImageView.image = [UIImage imageNamed:@"campaign_promotion_320x240.jpg"];
//        }
//        else{
            if ([dictionary inNetwork] || [tileImageURL isEqual:[NSNull null]]) {
                cell.tileImageView.image = [UIImage imageNamed:@"yourimagehere_320x240.jpg"];
            }
            else{
                
                @try {
                    if([imageDownloadedDictionary valueForKey:[NSString stringWithFormat:@"tileImage_%ld",(long)indexPath.row]] == nil && tileImageURL && tileImageURL.length>0) {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:tileImageURL]];
                            UIImage *img =[UIImage imageWithData:data];
                            if(img && [img isKindOfClass:[UIImage class]]) {
                                [imageDownloadedDictionary setObject:img forKey:[NSString stringWithFormat:@"tileImage_%ld",(long)indexPath.row]];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    //                    UIImageView *imageView = [[UIImageView alloc]initWithImage:img];
                                    CGSize cellSize = [self sizeForRowIfImageDownloaded:img];
                                    if(CGSizeEqualToSize(cellSize, CGSizeZero) == NO && cellObj)
                                        cellObj.tileImageView.frame = CGRectMake(0, 0, cellSize.width, cellSize.height);
                                    //                    [cell.contentView addSubview:imageView];
                                    if(cellObj)
                                        [cellObj.tileImageView setImage:img];
                                    @try {
                                        if(cellObj){
                                            [self.tableView beginUpdates];
                                            [cellObj setNeedsLayout];
                                            [self.tableView endUpdates];
                                        }
                                    }
                                    @catch (NSException *exception) {
                                        NSLog(@"exception reloading data %@",exception);
                                    }
                                });
                                
                            }
                        });
                    }else {
                        UIImage *img = [imageDownloadedDictionary valueForKey:[NSString stringWithFormat:@"tileImage_%ld",(long)indexPath.row]];
                        //        UIImageView *imageView = [[UIImageView alloc]initWithImage:img];
                        CGSize cellSize = [self sizeForRowIfImageDownloaded:img];
                        if(CGSizeEqualToSize(cellSize, CGSizeZero) == NO)
                            cell.tileImageView.frame = CGRectMake(0, 0, cellSize.width, cellSize.height);
                        //        [cell.contentView addSubview:imageView];
                        [cell.tileImageView setImage:img];
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"It's Catch Exception Error!! %@",exception);
                }
                @finally {
                    
                }
                
                
            }
        //}
        //[phonenumber isEqual:[NSNull null]
        
        
        //        cell.iconImageView.image = nil;
        //        if([imageDownloadedDictionary valueForKey:[NSString stringWithFormat:@"iconImage_%ld",(long)indexPath.row]] == nil && iconURL && iconURL.length>0) {
        //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        //                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:iconURL]];
        //                UIImage *img =[UIImage imageWithData:data];
        //                if(img && [img isKindOfClass:[UIImage class]]) {
        //                    [imageDownloadedDictionary setObject:img forKey:[NSString stringWithFormat:@"iconImage_%ld",(long)indexPath.row]];
        //                    dispatch_async(dispatch_get_main_queue(), ^{
        //                        //                    UIImageView *imageView = [[UIImageView alloc]initWithImage:img];
        //                        //                    imageView.frame = CGRectMake(cell.frame.size.width-50, cell.frame.size.height-50, 50, 50);
        //                        //                    imageView.contentMode = UIViewContentModeScaleAspectFit;
        //                        //                    [cell.contentView addSubview:imageView];
        //                        //                    [cell setNeedsLayout];
        //                        @try{
        //                            if(cellObj){
        //                                [cellObj.iconImageView setImage:img];
        //                                [cellObj setNeedsLayout];
        //                            }
        //                        }
        //                        @catch (NSException *exception){
        //                            NSLog(@"Exception in configure cell \n%@",exception);
        //                        }
        //                    });
        //                }
        //            });
        //        }else {
        //            UIImage *img = [imageDownloadedDictionary valueForKey:[NSString stringWithFormat:@"iconImage_%ld",(long)indexPath.row]];
        //            //        UIImageView *imageView = [[UIImageView alloc]initWithImage:img];
        //            //        imageView.frame = CGRectMake(cell.frame.size.width-50, cell.frame.size.height-50, 50, 50);
        //            //        imageView.contentMode = UIViewContentModeScaleAspectFit;
        //            //        [cell.contentView addSubview:imageView];
        //            //        imageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        //
        //            [cell.iconImageView setImage:img];
        //        }
        
        // marker image
        cell.markerImageView.image = nil;
//        NSLog(@"dictionary 123 = %@",dictionary);
        
        NSString *selectedCategory = [[CTRootControllerDataModel sharedInstance]selectedCategory];
        NSMutableArray  *mapMarkers=(NSMutableArray*)[dictionary saslMapMarkers];
        if (![mapMarkers isEqual:[NSNull null]])
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@",selectedCategory];
            NSArray *filtered = [mapMarkers filteredArrayUsingPredicate:predicate];
            if(filtered.count>0) {
                NSMutableDictionary *markerDictionary = [filtered lastObject];
                
                // UIImage *markerImage; //= [markerDictionary markerImage];
                NSString * markImagestring = [markerDictionary apiMarkerURL];
//                NSLog(@"markImagestring = %@",markImagestring);
                NSURL *url = [NSURL URLWithString:markImagestring];
                NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (data) {
                        UIImage *image = [UIImage imageWithData:data];
                        if (image) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [cell.markerImageView setImage: image];
                                
                            });
                        }
                    }
                }];
                [task resume];
            }
        }
        
//        UIImage *markerImage = [self markerImageInDictionary:dictionary];
//        NSLog(@"markerImage = %@",markerImage);
//        if(!markerImage)
//        {
//            NSLog(@"markerimage again %@",markerImage);
//            [cell.markerImageView setImage:markerImage];
//        }
//        NSLog(@"cell.image %@",cell.markerImageView);
        
        //    NSLog(@"Cell Frame : %@",NSStringFromCGSize(cell.frame.size));
    }
    return cell;
    
    // }
}
//-(void)didTapMapBtn:(id)sender {
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:CT_Observers_MarkerImageDownloaded object:nil];
//    [[CTRootControllerDataModel sharedInstance]removeObserver:self forKeyPath:@"saslSummaryArray"];
//    [self.view removeFromSuperview];
////    [[self.navigationController.view viewWithTag:ButtonTag] removeFromSuperview];
//    [self removeFromParentViewController];
//}
-(void)markerImageDownloaded:(NSNotification*)notif {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *restDictionary = notif.object;
        //NSLog(@"sasal array is %@",[[CTRootControllerDataModel sharedInstance]saslSummaryArray]);
        NSMutableArray *sasl =[[CTRootControllerDataModel sharedInstance]getTilesData] ;
        NSUInteger index = [sasl indexOfObject:restDictionary];
//        NSLog(@"Tile View= %@",restDictionary);
        //cell.imageview <AsyncImageView: 0x7fc6c6ac38b0; baseClass = UIImageView; frame = (377 5; 41 54); opaque = NO; autoresize = RM+BM;
        @try {
            CTTileViewCell *cell = (CTTileViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            UIImage *markerImage = [self markerImageInDictionary:restDictionary];
            
            if(markerImage) {
                [cell.markerImageView setImage:markerImage];
//                NSLog(@"cell.imageview %@",cell.markerImageView);
                [cell setNeedsLayout];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"EXCEPTION RELOADING ROW");
        }
    });
    
    
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        imageDownloadedDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:CT_NavigationBg] forBarMetrics:UIBarMetricsDefault];
    
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 132.0f);
    
    
    switch ([CTCommonMethods getIPhoneVersion]) {
        case iPhone4:{
            // iPhone Classic
            _imageview = [[UIImageView alloc]
                          initWithFrame:CGRectMake(0, -50, 340, self.view.frame.size.height)];
            
        }
            break;
        case iPhone5:{
            // iPhone 5
            _imageview = [[UIImageView alloc]
                          initWithFrame:CGRectMake(0, -120, 320, self.view.frame.size.height)];
        }
            break;
        case iPhone6:{
            // iPhone 6
            _imageview = [[UIImageView alloc]
                          initWithFrame:CGRectMake(0, -120, 380, self.view.frame.size.height)];
        }
            break;
        case iPhone6Plus:{
            // iPhone 6 Plus
            _imageview = [[UIImageView alloc]
                          initWithFrame:CGRectMake(0, -130, 420, self.view.frame.size.height)];
        }
            break;
        default:
            break;
    }
    //[_imageview setImage:[UIImage imageNamed:@"splash_city_selector.png"]];
    [_imageview setContentMode:UIViewContentModeScaleAspectFit];
    _imageview.hidden = [CTCommonMethods sharedInstance].SPLASHIMAGE;
//    [self.view addSubview:_imageview];
    
    //self.tableView.backgroundColor = [UIColor clearColor];
    //self.view.backgroundColor = [UIColor clearColor];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tileView_background.png"]];
    [self.tableView.backgroundView setContentMode:UIViewContentModeScaleAspectFill];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blue-tweed-background.jpg"]];
    //self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue-tweed-background.jpg"]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // marker image
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(markerImageDownloaded:) name:CT_Observers_MarkerImageDownloaded object:nil];
    if([UIDevice currentDevice].systemVersion.floatValue>=7.0)
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.separatorColor = [UIColor colorWithWhite:0 alpha:.8];
    
    //    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    //    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    //    [parentController.btnTiles setImage:[UIImage imageNamed:CT_MapIcon] forState:UIControlStateNormal];
    //    [parentController.btnTiles setTitle:@"Map" forState:UIControlStateNormal];
    //
    //    UIEdgeInsets titleInsets = UIEdgeInsetsMake(33.0, -29.0, 0.0, 0.0);
    //    parentController.btnTiles.titleEdgeInsets = titleInsets;
    //
    //    UIEdgeInsets imageInsets = UIEdgeInsetsMake(-11.0, 5.0, 0.0, 0.0);
    //    parentController.btnTiles.imageEdgeInsets = imageInsets;
    //
    //    [parentController.btnTiles addTarget:self action:@selector(didTapMapBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //    UIButton *btnNearMe = [UIButton buttonWithType:UIButtonTypeCustom];
    //    btnNearMe.frame= CGRectMake(280, 20, 30, 30);
    //    btnNearMe.tag = ButtonTag;
    //    [btnNearMe setImage:[UIImage imageNamed:@"near_me_map.png"] forState:UIControlStateNormal];
    //    [btnNearMe addTarget:self action:@selector(didTapMapBtn:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.navigationController.view addSubview:btnNearMe];
    
    
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self.view andSubViews:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [[CTRootControllerDataModel sharedInstance]addObserver:self forKeyPath:@"saslSummaryArray" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[CTRootControllerDataModel sharedInstance]removeObserver:self forKeyPath:@"saslSummaryArray"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage *img = [imageDownloadedDictionary valueForKey:[NSString stringWithFormat:@"tileImage_%ld",(long)indexPath.row]];
    CGSize size =[self sizeForRowIfImageDownloaded:img];
    
    if ([[[CTCommonMethods sharedInstance].tileURL objectAtIndex:indexPath.row]isEqualToString:@"redcolor"])
    {
        return 100;
    }
    else
    {
        if((img == nil && CGSizeEqualToSize(size, CGSizeZero)) || (size.height < 202))
        return 202;
        else {
        return size.height*1.5;
        }
    }
    
    return 202;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 50;
//}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
//    //    footer.backgroundColor = [[UIColor darkGrayColor]colorWithAlphaComponent:0.75f];
//    footer.backgroundColor = [UIColor clearColor];
//
//    // set footer
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame= CGRectMake(280, 20, 30, 30);
//    //    btn.center = CGPointMake(footer.frame.size.width/2, footer.frame.size.height/2);
//    //    [btn setTitle:@"Map" forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:@"near_me_map.png"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(didTapMapBtn:) forControlEvents:UIControlEventTouchUpInside];
//    //    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    //    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
//    [footer addSubview:btn];
//    return footer;
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 40;
//}
//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
////    footer.backgroundColor = [[UIColor darkGrayColor]colorWithAlphaComponent:0.75f];
//    footer.backgroundColor = [UIColor clearColor];
//
//    // set footer
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame= CGRectMake(43, 0, 30, 30);
////    btn.center = CGPointMake(footer.frame.size.width/2, footer.frame.size.height/2);
////    [btn setTitle:@"Map" forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:@"near_me_map.png"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(didTapMapBtn:) forControlEvents:UIControlEventTouchUpInside];
////    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
////    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
//    [footer addSubview:btn];
//    return footer;
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return [[CTRootControllerDataModel sharedInstance]saslSummaryArray].count;
    // return [[CTRootControllerDataModel sharedInstance]listoftilesData].count;
    //return [CTCommonMethods sharedInstance].tileUUIDtype.count;
    
    //return [CTCommonMethods sharedInstance].tileURL.count;
    return [[CTRootControllerDataModel sharedInstance]listoftilesData].count;
    //return tilelistarr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //NSLog(@"Tableview cEll == %@",[[CTCommonMethods sharedInstance].tileURL objectAtIndex:indexPath.row]);
    CTTileViewCell *cell;// = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ([[[CTCommonMethods sharedInstance].tileURL objectAtIndex:indexPath.row]isEqualToString:@"redcolor"])
    {
        static NSString *cellIdentifier1 = @"cell1";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (!cell) {
            cell = [[CTTileViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier1];
        }
        return [self configureCell:cell forIndexPath:indexPath];
        //cell.tileImageView.image = [UIImage imageNamed:@"yourimagehere_320x240.jpg"];
        //return cell;
    }
    else
    {
        if(cell == nil)
        {
            cell = [[CTTileViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
        }
        return [self configureCell:cell forIndexPath:indexPath];
        //return cell;
    }
    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    tableView.allowsSelection = NO;
    /// NSMutableDictionary *restaurant = [[[CTRootControllerDataModel sharedInstance]saslSummaryArray] objectAtIndex:indexPath.row];
    //[[CTRootControllerDataModel sharedInstance]setSelectedRestaurant:restaurant];
//    NSMutableDictionary *restaurant = [[[CTRootControllerDataModel sharedInstance]listofSaslData] objectAtIndex:indexPath.row];
//    NSLog(@"restaurant = %@",restaurant);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DropDownHide" object:nil];
    
    
    id restaurant1 = [[[CTRootControllerDataModel sharedInstance]listoftilesData] objectAtIndex:indexPath.row];
    if ([restaurant1 isKindOfClass:[NSString class]]) {
        if ([restaurant1 isEqualToString:@"redcolor"])
        {
            return;
        }
    }
    self.indexValue = indexPath.row;
//    NSLog(@"restaurant = %@",restaurant1);
//    NSLog(@"indesxpath = %d",self.indexValue);
    
    NSString *sa=[NSString stringWithFormat:@"%@",[CTCommonMethods sharedInstance].serviceAccommodatorId[self.indexValue]];
    NSLog(@"Sa select = %@",sa);
    
    //NSLog(@"LISTOFTILE %@",restaurant1);
    //    NSLog(@"selectecd %@",[dictionary name]);
    //    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.mode=MBProgressHUDModeIndeterminate;
    
    //    [[self.navigationController.view viewWithTag:ButtonTag] removeFromSuperview];
    
    // NSString *sa=[restaurant serviceAccommodatorId];
    //NSString *sl=[restaurant serviceLocationId];
    // call in web view
    //NSString *url= [NSString stringWithFormat:@"http://cmtyapps.com/?serviceAccommodatorId=%@&serviceLocationId=%@",sa,sl];
    //NSString *url= [NSString stringWithFormat:[CTCommonMethods getChoosenHTMLServer],sa,sl];
    //    self.navigationController.navigationBarHidden = NO;
    //    self.navigationController.toolbarHidden = YES;
    
    //    if([[CTCommonMethods simulate] isEqualToString:@"true"])
    //        url = [url stringByAppendingString:@"&demo=true"];
    
    //if ([restaurant valueForKeyPath:@"showURL"] && [[restaurant valueForKeyPath:@"showURL"] boolValue] == YES && [restaurant valueForKeyPath:@"url"]) {
    //url = [restaurant valueForKeyPath:@"url"];
    //NSLog(@"my url %@",[restaurant valueForKeyPath:@"url"]);
    // }
    
    //__block NSMutableDictionary *dictionary = [[[CTRootControllerDataModel sharedInstance]listoftilesData]objectAtIndex:indexPath.row];
//    NSLog(@"restorunt == %@",[restaurant1 valueForKeyPath:@"promoType.enumText"] );
    if ([[restaurant1 valueForKeyPath:@"promoType.enumText"] isEqualToString:@"CAMPAIGN_SUBSCRIBE_FOR_NOTIFICATION"])
    {
        if([CTCommonMethods isUIDStoredInDevice])
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SUBS" object:nil];
            [self callAPI];
            @try {
                CTWebviewDetailsViewController *webController = [[CTWebviewDetailsViewController alloc] initWithNibName:@"CTWebviewDetailsViewController" bundle:nil];
                webController.DisTitle = [restaurant1 valueForKey:kTileView_TitleKey];
                webController.DisMessage = [restaurant1 valueForKey:kTileView_TileMessageKey];
                webController.isFromRootView = NO;
                //webController.strLoadUrl = url;
                
                
                if ([CTCommonMethods sharedInstance].tileContactList[indexPath.row] == [NSNull null])
                {
//                    NSLog(@"it's null value");
                    webController.listofContact = @"";
                }
                else
                {
//                    NSLog(@"it's not null value");
                    webController.listofContact = [CTCommonMethods sharedInstance].tileContactList[indexPath.row];
                }
                
                webController.showURL = [[restaurant1 valueForKey:@"showURL"] boolValue];
                webController.tileClickUrl = [restaurant1 valueForKey:@"onClickURL"];
                webController.tileEnumText = [restaurant1 valueForKeyPath:@"promoType.enumText"];
                webController.tileSA = [NSString stringWithFormat:@"%@",[CTCommonMethods sharedInstance].serviceAccommodatorId[self.indexValue]];
                webController.tileSL = [NSString stringWithFormat:@"%@",[CTCommonMethods sharedInstance].serviceLocationId[self.indexValue]];
                webController.indexValue = (int)self.indexValue;
                webController.delegate = self;
                webController.animationType = MJPopupViewAnimationSlideBottomTop;
                webController.DisPromotitle = [restaurant1 valueForKeyPath:@"promoType.displayText"];
                webController.Disenumtext = [restaurant1 valueForKeyPath:@"promoType.enumText"];
                NSLog(@"dispaly text %@",webController.DisPromotitle);
                webController.DisImage =[restaurant1 valueForKey:kTileView_TileImageKey];
                //NSLog(@"myimg %@",[restaurant1 valueForKey:kTileView_TileImageKey]);
                webController.DisSASLName = [CTCommonMethods sharedInstance].SASLTitleName[indexPath.row];
                webController.DisLattitude = [CTCommonMethods sharedInstance].tileviewLati[indexPath.row];
                webController.DisLongitude = [CTCommonMethods sharedInstance].tileviewLong[indexPath.row];
                webController.DisOnClikUrl = [CTCommonMethods sharedInstance].tileonClickURL[indexPath.row];
                webController.MapAddress = [CTCommonMethods sharedInstance].tileAddressList[indexPath.row];
                webController.DisUDID = [CTCommonMethods sharedInstance].tileUUID[indexPath.row];
                [UIView animateWithDuration:0.35f animations:^{
                    self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                } completion:^(BOOL finished) {
                    //        self.mapview.frame = CGRectMake(0, 0, self.mapview.frame.size.width, self.mapview.frame.size.height);
                }];
                
                [self presentPopupViewController:webController animationType:MJPopupViewAnimationSlideTopBottom];
            }
            @catch (NSException *exception) {
                NSLog(@"TileView TableViewDidSelect Method: %@", exception.name);
                NSLog(@"TileView TableViewDidSelect Method: %@", exception.reason);
            }
            @finally {
                
            }
        }
        else
        {
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callAPIAgain:) name:@"SUBS" object:nil];
            CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
            CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
            CTLoginViewController * promotion = [[CTLoginViewController alloc] initWithNibName:@"CTLoginViewController" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:promotion];
            promotion.delegate = parentController;
            promotion.navigationItem.leftBarButtonItem = [self backButton];
            promotion.navigationItem.title = @"Chalkboard Login";
            //            isCREATE = true;
            [UIView animateWithDuration:0.1 animations:^{
                
                [parentController presentViewController:nav animated:YES completion:nil];
                
            } completion:^(BOOL finished) {
                //            [searchController.hideBtn removeTarget:searchController action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
                [promotion.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
            }];
        }
        
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SUBS" object:nil];
        //@try {
//        NSLog(@"resturant = %@",restaurant1);
            CTWebviewDetailsViewController *webController = [[CTWebviewDetailsViewController alloc] initWithNibName:@"CTWebviewDetailsViewController" bundle:nil];
            webController.DisTitle = [restaurant1 valueForKey:kTileView_TitleKey];
            webController.DisMessage = [restaurant1 valueForKey:kTileView_TileMessageKey];
            webController.isFromRootView = NO;
            webController.tileSA = [NSString stringWithFormat:@"%@",[CTCommonMethods sharedInstance].serviceAccommodatorId[self.indexValue]];
            webController.tileSL = [NSString stringWithFormat:@"%@",[CTCommonMethods sharedInstance].serviceLocationId[self.indexValue]];
            //webController.strLoadUrl = url;
            
            
            if ([CTCommonMethods sharedInstance].tileContactList[indexPath.row] == [NSNull null])
            {
                //NSLog(@"it's null value");
                webController.listofContact = @"";
            }
            else
            {
                //NSLog(@"it's not null value");
                webController.listofContact = [CTCommonMethods sharedInstance].tileContactList[indexPath.row];
            }
            
            webController.showURL = [[restaurant1 valueForKey:@"showURL"] boolValue];
            webController.tileClickUrl = [restaurant1 valueForKey:@"onClickURL"];
            webController.tileEnumText = [restaurant1 valueForKeyPath:@"promoType.enumText"];
            webController.DisPromotitle = [restaurant1 valueForKeyPath:@"promoType.displayText"];
            NSLog(@"dispaly text %@",webController.DisPromotitle);
            webController.DisImage =[restaurant1 valueForKey:kTileView_TileImageKey];
            webController.indexValue = (int)self.indexValue;
            webController.delegate = self;
            webController.animationType = MJPopupViewAnimationSlideBottomTop;
        
            if ([restaurant1 valueForKey:kTileView_TileImageKey] == [NSNull null])
            {
                //webController.DisImage = [NSString stringWithFormat:@"%@",[UIImage imageNamed:@"yourimagehere_320x240.jpg"]];
                webController.DisImage =@"yourimagehere_320x240.jpg";
                //NSLog(@"webcontrol %@",webController.DisImage);
            }
            else
            {
                webController.DisImage =[restaurant1 valueForKey:kTileView_TileImageKey];
               // NSLog(@"webcontrol123 %@",webController.DisImage);
            }
        
            //NSLog(@"myimg %@",[restaurant1 valueForKey:kTileView_TileImageKey]);
            webController.DisSASLName = [CTCommonMethods sharedInstance].SASLTitleName[indexPath.row];
            webController.DisLattitude = [CTCommonMethods sharedInstance].tileviewLati[indexPath.row];
            webController.DisLongitude = [CTCommonMethods sharedInstance].tileviewLong[indexPath.row];
            webController.DisOnClikUrl = [CTCommonMethods sharedInstance].tileonClickURL[indexPath.row];
            webController.MapAddress = [CTCommonMethods sharedInstance].tileAddressList[indexPath.row];
            webController.DisUDID = [CTCommonMethods sharedInstance].tileUUID[indexPath.row];
            webController.Disenumtext = [restaurant1 valueForKeyPath:@"promoType.enumText"];
        
            [UIView animateWithDuration:0.35f animations:^{
                self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
            } completion:^(BOOL finished) {
                //        self.mapview.frame = CGRectMake(0, 0, self.mapview.frame.size.width, self.mapview.frame.size.height);
            }];
            
            [self presentPopupViewController:webController animationType:MJPopupViewAnimationSlideTopBottom];
        //}
//        @catch (NSException *exception) {
//            NSLog(@"TileView TableViewDidSelect Method: %@", exception.name);
//            NSLog(@"TileView TableViewDidSelect Method: %@", exception.reason);
//        }
//        @finally {
//            
//        }
    }
    
   

    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    //        tableView.allowsSelection = YES;
    //    });
}
-(void)callAPI
{
    if([CTCommonMethods isUIDStoredInDevice])
    {
        //MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:webViewDetail animated:YES];
        //hud.mode=MBProgressHUDModeIndeterminate;
        
        NSDictionary *restaurantDetails = [[CTRootControllerDataModel sharedInstance]selectedRestaurant];
        //NSString *sa=[NSString stringWithFormat:@"%@",[restaurantDetails objectForKey:@"serviceAccommodatorId"]];
        //NSString *sl=[NSString stringWithFormat:@"%@",[restaurantDetails objectForKey:@"serviceLocationId"]];
        NSString *sa=[NSString stringWithFormat:@"%@",[CTCommonMethods sharedInstance].serviceAccommodatorId[self.indexValue]];
        NSLog(@"it's sa %@",sa);
        NSString *sl=[NSString stringWithFormat:@"%@",[CTCommonMethods sharedInstance].serviceLocationId[self.indexValue]];
        NSLog(@"it's sl %@",sl);
        NSString *url=[NSString stringWithFormat:@"%@usersasl/addSASLToFavorites?UID=%@&serviceAccommodatorId=%@&serviceLocationId=%@",[CTCommonMethods getChoosenServer],[CTCommonMethods UID],sa,sl];
        NSLog(@"it's url %@",url);
//        __block id btnFav = sender;
//        [btnFav setUserInteractionEnabled:NO];
        
        [CTWebServicesMethods sendRequestWithURL:url params:nil method:kHTTPMethod_POST contentType:@"application/json" success:^(id JSON) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                [btnFav setUserInteractionEnabled:YES];
//                isFavourite = YES;
//                [self addToolBarItems];
                
                if (JSON && [JSON count] > 1 && [JSON valueForKeyPath:@"messageBody"]) {
                    @try {
                        NSString *strMessage = [JSON valueForKeyPath:@"messageBody"];
                        [CTCommonMethods showErrorAlertMessageWithTitle:strMessage andMessage:@""];
                        
                    }
                    @catch (NSException *exception) {
                        NSLog(@"exception in notifyPollingContestWinner %@",exception);
                    }
                }
                NSLog(@"notifyPollingContestWinner Response JSON = %@",JSON);
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //[btnFav setUserInteractionEnabled:YES];
                NSLog(@"notifyPollingContestWinner Error %@",error);
                [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            });
        }];
    }
    else {
        NSLog(@"else PArt Calling");//(NSNotification *)notification
        
    }
}

-(void)callAPIAgain :(NSNotification *)notification
{
    NSString *sa=[NSString stringWithFormat:@"%@",[CTCommonMethods sharedInstance].serviceAccommodatorId[self.indexValue]];
//    NSLog(@"it's sa %@",sa);
    NSString *sl=[NSString stringWithFormat:@"%@",[CTCommonMethods sharedInstance].serviceLocationId[self.indexValue]];
//    NSLog(@"it's sl %@",sl);
    NSString *url=[NSString stringWithFormat:@"%@usersasl/addSASLToFavorites?UID=%@&serviceAccommodatorId=%@&serviceLocationId=%@",[CTCommonMethods getChoosenServer],[CTCommonMethods UID],sa,sl];
//    NSLog(@"it's url %@",url);
    //        __block id btnFav = sender;
    //        [btnFav setUserInteractionEnabled:NO];
    
    [CTWebServicesMethods sendRequestWithURL:url params:nil method:kHTTPMethod_POST contentType:@"application/json" success:^(id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //                [btnFav setUserInteractionEnabled:YES];
            //                isFavourite = YES;
            //                [self addToolBarItems];
            
            if (JSON && [JSON count] > 1 && [JSON valueForKeyPath:@"messageBody"]) {
                @try {
                    NSString *strMessage = [JSON valueForKeyPath:@"messageBody"];
                    [CTCommonMethods showErrorAlertMessageWithTitle:strMessage andMessage:@""];
                }
                @catch (NSException *exception) {
                    NSLog(@"exception in notifyPollingContestWinner %@",exception);
                }
            }
            NSLog(@"notifyPollingContestWinner Response JSON = %@",JSON);
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[btnFav setUserInteractionEnabled:YES];
            NSLog(@"notifyPollingContestWinner Error %@",error);
            [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        });
    }];
    
    
    id restaurant1 = [[[CTRootControllerDataModel sharedInstance]listoftilesData] objectAtIndex:self.indexValue];
    NSLog(@"restaurant1 - %@",restaurant1);
    CTWebviewDetailsViewController *webController = [[CTWebviewDetailsViewController alloc] initWithNibName:@"CTWebviewDetailsViewController" bundle:nil];
    webController.DisTitle = [restaurant1 valueForKey:kTileView_TitleKey];
    webController.DisMessage = [restaurant1 valueForKey:kTileView_TileMessageKey];
    webController.isFromRootView = NO;
    //webController.strLoadUrl = url;
    
    
    if ([CTCommonMethods sharedInstance].tileContactList[self.indexValue] == [NSNull null])
    {
//        NSLog(@"it's null value");
        webController.listofContact = @"";
    }
    else
    {
//        NSLog(@"it's not null value");
        webController.listofContact = [CTCommonMethods sharedInstance].tileContactList[self.indexValue];
    }
    
    webController.showURL = [[restaurant1 valueForKey:@"showURL"] boolValue];
    webController.tileClickUrl = [restaurant1 valueForKey:@"onClickURL"];
    webController.tileEnumText = [restaurant1 valueForKeyPath:@"promoType.enumText"];
    webController.indexValue = (int)self.indexValue;
    webController.delegate = self;
    webController.animationType = MJPopupViewAnimationSlideBottomTop;
    
    if ([restaurant1 valueForKey:kTileView_TileImageKey] == [NSNull null])
    {
        //webController.DisImage = [NSString stringWithFormat:@"%@",[UIImage imageNamed:@"yourimagehere_320x240.jpg"]];
        webController.DisImage =@"yourimagehere_320x240.jpg";
//        NSLog(@"webcontrol %@",webController.DisImage);
    }
    else
    {
        webController.DisImage =[restaurant1 valueForKey:kTileView_TileImageKey];
//        NSLog(@"webcontrol123 %@",webController.DisImage);
    }
    
    //NSLog(@"myimg %@",[restaurant1 valueForKey:kTileView_TileImageKey]);
    webController.DisSASLName = [CTCommonMethods sharedInstance].SASLTitleName[self.indexValue];
    webController.DisLattitude = [CTCommonMethods sharedInstance].tileviewLati[self.indexValue];
    webController.DisLongitude = [CTCommonMethods sharedInstance].tileviewLong[self.indexValue];
    webController.DisOnClikUrl = [CTCommonMethods sharedInstance].tileonClickURL[self.indexValue];
    webController.MapAddress = [CTCommonMethods sharedInstance].tileAddressList[self.indexValue];
    webController.DisUDID = [CTCommonMethods sharedInstance].tileUUID[self.indexValue];
    [UIView animateWithDuration:0.35f animations:^{
        self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        //        self.mapview.frame = CGRectMake(0, 0, self.mapview.frame.size.width, self.mapview.frame.size.height);
    }];
    
    [self presentPopupViewController:webController animationType:MJPopupViewAnimationSlideTopBottom];
}
- (void)dismissSubViewWithAnimation {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop];
    [UIView animateWithDuration:0.35f animations:^{
        //        self.mapview.frame = CGRectMake(0, self.view.frame.size.height, self.mapview.frame.size.width, self.mapview.frame.size.height);
        self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height + 5 );
    } completion:^(BOOL finished) {
        //        self.mapview.frame = CGRectMake(0, 0, self.mapview.frame.size.width, self.mapview.frame.size.height);
    }];
}
-(void)didTapBackButtonOnFavorites:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UIBarButtonItem *)backButton{
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[backButton setFrame:CGRectMake(0, 0, 35, 35)];
    [backButton setFrame:CGRectMake(0, 0, 60, 44)];
    [backButton setImage:[UIImage imageNamed:CT_BackIcon] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(didTapBackButtonOnFavorites:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    return leftBarbutton;
    
}

//    CTWebviewDetailsViewController *webController = [[CTWebviewDetailsViewController alloc]initWithNibName:@"CTWebviewDetailsViewController" bundle:nil];
//    NSURLRequest *aRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//    [(UIWebView*)webController.view loadRequest:aRequest];
//    [self.navigationController pushViewController:webController animated:YES];

//    NSString *lat=[NSString stringWithFormat:@"%@",[restaurant latitude]];
//    NSString *lon=[NSString stringWithFormat:@"%@",[restaurant longitude]];
//    if([restaurant inNetwork]){
//        [CTWebServicesMethods getRestaurantBySa:sa SL:sl forLatitude:lat andLongitude:lon completionBlock:^(NSString *errorTitle, NSString *errorMessage, id JSON) {
//            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//            }];
//            if(JSON) {
//                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
//                    [self.delegate didTapAndGetRestaruantDetails:JSON];
//                }];
//
//            }else {
//                // it's an error.
//                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
//                    [MBProgressHUD hideHUDForView:self.view animated:YES];
//                    [CTCommonMethods showErrorAlertMessageWithTitle:errorTitle andMessage:errorMessage];
//                }];
//            }
//        }];
//        //        [self getRestaurantBySa:sa SL:sl forLatitude:lat andLongitude:lon];
//    }
//    else{
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        //        [self openOutOfNetworkviewController:restaurant];
//        [self.delegate didTapAndGetRestaruantDetails:nil];
//    }

//}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */


@end
