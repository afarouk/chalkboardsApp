//
//  CTSpecialOfferView.m
//  Community
//
//  Created by dinesh on 04/02/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTSpecialOfferView.h"
#import "MBProgressHUD.h"
#import "NSDictionary+CTSpecialOffer.h"
#import "CTRootControllerDataModel.h"
#define kScrollViewContentsTagStartIndex 100
@interface UIScrollView (CurrentPage)
-(int) currentPage;
@end
@implementation UIScrollView (CurrentPage)
-(int) currentPage{
    CGFloat pageWidth = self.frame.size.width;
    return floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}
@end
@implementation PromoSlideImageView
@end
@implementation CTSpecialOfferView
-(void)showSpecialOfferViewWithMenuView:(UIView*)_menuView {
    menuView = _menuView;
    [UIView animateWithDuration:0.3f animations:^{
        self.center= CGPointMake(self.frame.size.width/2, self.center.y);
        menuView.center = CGPointMake(self.frame.size.width+(menuView.frame.size.width/2), menuView.center.y);
        
    } completion:^(BOOL finished) {
        
    }];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle]loadNibNamed:@"CTSpecialOfferView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        // Initialization code
//        CFBridgingRetain(self);
//        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CTSpecialOfferView" owner:self options:nil];
//        self=[nib objectAtIndex:0];
//        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
        self.imageDataArray=[[NSMutableArray alloc]init];
        [self retriveSpecialOffer];
    }
    return self;
}

- (IBAction)backButton:(id)sender {
    
    [self dismissView];
}
-(void)dismissView{
    [UIView animateWithDuration:0.3f animations:^{
        menuView.center = CGPointMake(menuView.frame.size.width/2, menuView.center.y);
        self.center = CGPointMake(-(self.frame.size.width-(self.frame.size.width/2)), self.center.y);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
//    [UIView beginAnimations:@"slideAnim" context:nil];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:0.3];
//    self.frame=CGRectOffset(self.frame,-275, 0);
//    [UIView commitAnimations];
//   // [self postNotification];
//    [self performSelector:@selector(removeFromView) withObject:self afterDelay:0.5];
    
}
#pragma mark removeFromView
-(void)removeFromView{
    [self removeFromSuperview];
}
#pragma mark post notification
-(void)postNotification{
    [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_RestaurantMenu object:self];
}
#pragma mark storedRestaurantDetails
-(void)getStoredRestaurantDetails{
    
//    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:CT_Observers_getSASL];
//    NSDictionary *dict=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.sa=[(NSMutableDictionary*)[CTRootControllerDataModel sharedInstance].selectedRestaurant serviceAccommodatorId];
    self.sl=[(NSMutableDictionary*)[CTRootControllerDataModel sharedInstance].selectedRestaurant serviceLocationId];
}
-(void)getPromoMetaDataForImageView:(PromoSlideImageView*)imageView {
    NSString *params=[NSString stringWithFormat:@"promoUUID=%@",imageView.promoUID];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_retreiveMetaDataForPromoUUID,params];
    imageView.isDownloadInProgress = YES;
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        @synchronized(self) {
            if(data) {
                NSLog(@"DID DOWNLOAD IMAGE for index %d",imageView.tag);
                NSError *jsonError;
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                if(dictionary && !jsonError) {
                    [imageView setPromoMetaData:dictionary];
                    if([self.promoImagesArray indexOfObject:imageView] == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.titleTextField.text = [imageView.promoMetaData valueForKey:@"promotionSASLName"];
                            self.descriptionTextView.text = [imageView.promoMetaData valueForKey:@"displayText"];
                        });
                        
                    }
                }
            }
            
        }
    }];
}
-(void)downloadImageForPromoImageView:(PromoSlideImageView*)imageView forOperationQueue:(NSOperationQueue*)operationQueue{
//    [[NSOperationQueue new]addOperationWithBlock:^{
            NSString *params=[NSString stringWithFormat:@"promoUUID=%@",imageView.promoUID];
            NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_retreiveImageForPromoUUID,params];
            imageView.isDownloadInProgress = YES;
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                @synchronized(self) {
                imageView.isDownloadInProgress = NO;
                if(data) {
                    NSLog(@"DID DOWNLOAD IMAGE for index %d",imageView.tag);
                    UIImage *image = [UIImage imageWithData:data];
                    [imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
                    
                }
                    
                }
            }];
//    }];
}
-(void)downloadFirstImage:(PromoSlideImageView*)imageView {
    
}
#pragma mark retrive special offer
-(void)retriveSpecialOffer{
    [self getStoredRestaurantDetails];
    NSString *params=[NSString stringWithFormat:@"UID=%@&serviceAccommodatorId=%@&serviceLocationId=%@&status=ACTIVE&startIndex=0&count=10",[CTCommonMethods UID],self.sa,self.sl];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_retreivePromotionsUUIDs,params];
//    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self animated:YES];
            if(connectionError) {
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@" Special offers is not available"];
                [self.activityIndicator stopAnimating];
            }else {
                NSError *jsonError;
                id JSON =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                NSError *exception  =[CTCommonMethods validateJSON:JSON];
                if(jsonError || exception) {
                    [self.activityIndicator stopAnimating];
                    [CTCommonMethods showErrorAlertMessageWithTitle:exception.localizedFailureReason andMessage:exception.localizedDescription];
                }else {
                    NSArray *promoUUIDs = [JSON valueForKey:@"promoUUIDList"];
                    if(promoUUIDs.count>0) {
                        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*promoUUIDs.count, self.scrollView.frame.size.height);
//                        [self bringSubviewToFront:self.scrollView];
                        self.pageControl.numberOfPages = promoUUIDs.count;
                        NSLog(@"content size %@",NSStringFromCGSize(self.scrollView.contentSize));
                        // add image views.
                        NSOperationQueue *operationQueue = [NSOperationQueue new];
                        for(int counter=0;counter<promoUUIDs.count;counter++) {
                            PromoSlideImageView *imageView =[[PromoSlideImageView alloc]initWithFrame:CGRectMake(counter*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
                            imageView.tag = kScrollViewContentsTagStartIndex+counter;
                            imageView.promoUID = [promoUUIDs objectAtIndex:counter];
                            [self.scrollView addSubview:imageView];
                            if(self.promoImagesArray == nil)
                                self.promoImagesArray = [NSMutableArray array];
                            [self.promoImagesArray addObject:imageView];
                            [self downloadImageForPromoImageView:imageView forOperationQueue:operationQueue];
                            // get meta data as well.
                            [self getPromoMetaDataForImageView:imageView];
                        }
                       
                        
                    }else {
                        [self.activityIndicator stopAnimating];
                        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"No record exist for selected option"];
                    }
                }

            }
        });
     
    }];
    
//    NSString *params=[NSString stringWithFormat:@"serviceAccommodatorId=%@&serviceLocationId=%@&status=ACTIVE&startIndex=0&count=10",self.sa,self.sl];
//    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_specialOffer,params];
//    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self animated:YES];
//    hud.mode=MBProgressHUDModeIndeterminate;
//    dispatch_queue_t backgroundQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
//    dispatch_async(backgroundQueue, ^{
//       id responseObject=[self getCTHttpGetMultipartRequestData:urlString];
//        if([responseObject isKindOfClass:[NSDictionary class]]){
//            
//            NSDictionary *res=(NSDictionary *)responseObject;
//            NSLog(@"RESPONSE %@",res);
//            [self parseSpecialOfferResponse:res];
//        }else if ([responseObject isKindOfClass:[NSData class]]){
//            
//        }
//        dispatch_queue_t mainQueue=dispatch_get_main_queue();
//        dispatch_async(mainQueue, ^{
//            if([self.imageDataArray count]!=0){
//                self.imageCount=0;
//                self.promotionImage.image=[UIImage imageWithData:[self.imageDataArray objectAtIndex:0]];
//            }
//            else{
//                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@" Special offers is not available"];
//            }
//            [MBProgressHUD hideHUDForView:self animated:YES];
//        });
//    });
    

    
}
-(id)getCTHttpGetMultipartRequestData:(NSString *)requestData{
    
    NSURL *url=[NSURL URLWithString:requestData];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    
    NSHTTPURLResponse *response=nil;
    NSError *error;
    NSData *returnData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *contentType = [[response allHeaderFields]valueForKey:@"Content-Type"];
    if([contentType hasPrefix:@"image"]){
        return returnData;
    }
    else if([contentType hasPrefix:@"multipart"]) {
        NSDictionary *multipartDictionary = [returnData multipartDictionary];
        NSLog(@"KEYS %@",[multipartDictionary allKeys]);
        NSLog(@"MULTIPART DATA----> %@",multipartDictionary);
        return multipartDictionary;
    }
    
    return returnData;
    
}
-(void)parseSpecialOfferResponse:(NSDictionary *)response{
    
    NSArray *keysArray=[response allKeys];
    for(int i=0;i<[keysArray count];i++){
        NSString *keyName=[NSString stringWithFormat:@"%@",[keysArray objectAtIndex:i]];
        NSDictionary *dictKey=[response dictionarKey:keyName];
        NSString *contentType=[dictKey objectForKey:@"Content-Type"];
        if(![contentType isEqualToString:@"application/json"]){
        NSData *imageData=[dictKey data];
        [self.imageDataArray addObject:imageData];
        }
    }
    NSLog(@"IMGAE ARRAY COUNT %d",[self.imageDataArray count]);
}
-(void)updateUIForPageIndex:(NSUInteger)pageIndex {
    PromoSlideImageView *imageView = [self.promoImagesArray objectAtIndex:pageIndex];
    if(imageView.isDownloadInProgress == NO && imageView.image == nil) {
        [self downloadImageForPromoImageView:imageView forOperationQueue:[NSOperationQueue new]];
    }if(imageView.promoMetaData == nil)
        [self getPromoMetaDataForImageView:imageView];
    else {
        NSLog(@"image view promo meta data %@",imageView.promoMetaData);
        self.titleTextField.text = [imageView.promoMetaData valueForKey:@"promotionSASLName"];
        self.descriptionTextView.text = [imageView.promoMetaData valueForKey:@"displayText"];
    }
}
- (IBAction)previous:(id)sender {
    NSUInteger currentPage =[self.scrollView currentPage];
    if(currentPage != 0) {
        [self.scrollView setContentOffset:CGPointMake((currentPage-1)*self.scrollView.frame.size.width, self.scrollView.contentOffset.y) animated:YES];
        self.pageControl.currentPage = currentPage-1;
        [self updateUIForPageIndex:self.pageControl.currentPage];
    }
   
}
- (IBAction)next:(id)sender {
    NSUInteger currentPage =[self.scrollView currentPage];
    if(currentPage+1 < self.promoImagesArray.count) {
        [self.scrollView setContentOffset:CGPointMake((currentPage+1)*self.scrollView.frame.size.width, self.scrollView.contentOffset.y) animated:YES];
        self.pageControl.currentPage = currentPage+1;
        [self updateUIForPageIndex:self.pageControl.currentPage];

    }
}
- (IBAction)booknow:(id)sender {
}
#pragma UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
//    CGFloat pageWidth = sender.frame.size.width;
//    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = self.scrollView.currentPage;
    // check 
    [self updateUIForPageIndex:self.pageControl.currentPage];

}
@end
