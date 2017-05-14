//
//  CTRestaurantHomeViewController.m
//  Community
//
//  Created by dinesh on 28/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTRestaurantHomeViewController.h"
#import "CTGalleryCell.h"
#import "CTNavigationBar.h"
#import "ImageNamesFile.h"
#import "CTRestaurantHomeViewController.h"
#import "NSDictionary+GetRestaurantDetails.h"
#import "NSMutableDictionary+SASLSummaryByUIDAndLocation.h"
#import "NSArray+RetrieveMediaMetaDataBySASL.h"
#import "UrlDownloaderOperation.h"
#import "CTPhotoUploadViewController.h"
#import "CTAppDelegate.h"
#import "CTParentViewController.h"
#import "MBProgressHUD.h"
#import "CTRootControllerDataModel.h"
#import "CTAppDelegate.h"
#import "CTSpecialOfferView.h"
//#import "CTMessageViewController.h"
#import "CTChatViewController.h"
#import "CTYelpReviewsViewController.h"
#define kGalleryTitleView_FontSize 24
#define kGalleryMessage_FontSize 14

//typedef void(^GalleryImageDownloadCompletionblock)(NSMutableDictionary *dictionary,UIImage* image,NSError *error);
//@interface GalleryImageDownloadRequest: NSObject <NSURLConnectionDataDelegate,NSURLConnectionDelegate>{
//    NSMutableData* mutableData;
//    GalleryImageDownloadCompletionblock downloadBlock;
//    NSMutableDictionary *galleryDictionary;
//    CTGalleryCell *cell;
//}
//-(void)downloadImageForURL:(NSString*)url galleryDictionary:(NSDictionary*)dictionary completionBlock:(GalleryImageDownloadCompletionblock)block;
//@end
//@implementation GalleryImageDownloadRequest
//-(void)downloadImageForURL:(NSString*)url galleryDictionary:(NSMutableDictionary*)dictionary completionBlock:(GalleryImageDownloadCompletionblock)block {
//    downloadBlock = block;
//    galleryDictionary = dictionary;
//    NSURLConnection *connection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[dictionary valueForKey:@"url"]]] delegate:self];
//    if(connection) {
//        mutableData = [NSMutableData data];
//        [connection start];
//    }
////    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[dictionary valueForKey:@"url"]]] queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
////        if(!connectionError) {
////            UIImage *image = [UIImage imageWithData:data];
////            if(!image && [image isKindOfClass:[UIImage class]] == false)
////                block(cell,nil,nil,[NSError errorWithDomain:@"com.domain.ImageNotFound" code:42 userInfo:[NSDictionary dictionaryWithObject:@"Image not found" forKey:NSLocalizedDescriptionKey]]);
////            else {
////                    block(cell,dictionary,image,nil);
////            }
////        }else
////            block(cell,nil,nil,connectionError);
////    }];
//}
//#pragma NSURLConnectionDataDelegate
//
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//
//}
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    [mutableData appendData:data];
//    UIImage *img =[UIImage imageWithData:data];
//    if(img)
//        downloadBlock(galleryDictionary,img,nil);
//}
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    UIImage *image = [UIImage imageWithData:mutableData];
//    if(!image && [image isKindOfClass:[UIImage class]] == false)
//        downloadBlock(nil,nil,[NSError errorWithDomain:@"com.domain.ImageNotFound" code:42 userInfo:[NSDictionary dictionaryWithObject:@"Image not found" forKey:NSLocalizedDescriptionKey]]);
//    else {
//        downloadBlock(galleryDictionary,image,nil);
//    }
//
//}
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//    downloadBlock(galleryDictionary,nil,error);
//}
//@end
@interface UILabel (Html)
- (void) setHtml: (NSString*) html;
-(CGFloat)htmlTextHeight;
@end
@implementation UILabel (Html)

- (void) setHtml: (NSString*) html
{
    NSError *err = nil;
    self.attributedText =
    [[NSAttributedString alloc]
     initWithData: [html dataUsingEncoding:NSUTF8StringEncoding]
     options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
     documentAttributes: nil
     error: &err];
    if(err)
        NSLog(@"Unable to parse label text: %@", err);
}
-(CGFloat)htmlTextHeight {
    NSLog(@"attributed string %@",[self.attributedText string]);
    CGFloat width = 300;
    CGRect rect = [self.attributedText boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size.height;
}
@end
@interface CTRestaurantHomeViewController ()
@property (nonatomic,strong)CTNavigationBar *ctNavigationBar;
@property (weak, nonatomic) IBOutlet UITableView *galleryTableView;
@property (nonatomic,retain)NSMutableArray *galleryMediaArray;
//@property (nonatomic,retain)NSMutableArray *imageSizeArray;
@property (weak, nonatomic) IBOutlet UIImageView *hintMaskView;
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UIWebView *messageTxtWebView;

@property (nonatomic,retain) NSArray *mediaArray;
@end

@implementation CTRestaurantHomeViewController
@synthesize restaurantDetailsDict;
-(void)setRestaurantDetailsDict:(NSMutableDictionary *)aRestaurantDetailsDict {
    if(restaurantDetailsDict != aRestaurantDetailsDict) {
        restaurantDetailsDict = nil;
        restaurantDetailsDict = aRestaurantDetailsDict;
    }
    [[CTRootControllerDataModel sharedInstance]setSelectedRestDetails:self.restaurantDetailsDict];
}
#pragma Scope Methods
-(CGSize)aspectFitSizeForImageSize:(CGSize)size {
    CGFloat ratio = 305/size.width;
    CGFloat height = size.height *ratio;
    size.width = 305;
    size.height = height;
    return size;
}
-(NSUInteger)webViewHeight:(NSUInteger)index {
    NSNumber *webViewHeight = [[self.galleryMediaArray objectAtIndex:index] valueForKey:@"WebViewHeight"];
    NSUInteger height = 20;
    if(webViewHeight != nil)
        height = [webViewHeight intValue]+20;
    return height;
}
-(NSUInteger)labelHeight:(NSUInteger)index {
    NSString *title = [[self.galleryMediaArray title:index] stringByTrimmingLeadingAndTrailingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    CGSize titleSize = [title sizeWithFont:[UIFont boldSystemFontOfSize:kGalleryTitleView_FontSize]];
    return titleSize.height;
}
-(NSUInteger)imageHeight:(NSUInteger)index {
    CGFloat height =[[[self.galleryMediaArray objectAtIndex:index] valueForKey:@"imageheight"] floatValue];
    CGFloat width =[[[self.galleryMediaArray objectAtIndex:index]valueForKey:@"imagewidth"] floatValue];
    if(width>=305) {
        CGFloat ratio = 305/width;
//        width = 305;
        height = height *ratio;
        //        NSLog(@"ratio %f image height %f",ratio,height);
    }
    return height;
}
- (CGFloat)minHeightForText:(NSString *)_text {
    UIFont* textFont = [UIFont boldSystemFontOfSize:16];
	   
    return [_text
            sizeWithFont:textFont
            constrainedToSize:CGSizeMake(320, 999999)
            lineBreakMode:NSLineBreakByWordWrapping
            ].height;
}
-(CTGalleryCell*)configureCell:(CTGalleryCell*)cell forIndexPath:(NSIndexPath*)indexPath {
    cell.backgroundColor=[UIColor clearColor];
    if([self.galleryMediaArray count]!=0){
        CGFloat height =[[[self.galleryMediaArray objectAtIndex:indexPath.row] valueForKey:@"imageheight"] floatValue];
        CGFloat width =[[[self.galleryMediaArray objectAtIndex:indexPath.row]valueForKey:@"imagewidth"] floatValue];
        NSLog(@"WIDTH %f HEIGHT %f",width,height);
        CGSize imageSize = CGSizeMake(width, height);
        if(width>=305)
            imageSize = [self aspectFitSizeForImageSize:CGSizeMake(width, height)];
        // cell without image view.
        //        cell.galleryImageView.image = nil;
        //        cell.galleryTitleView.text = @"";
        //        cell.messageLbl.text = @"";
        if(!cell.galleryTitleView)
            cell.galleryTitleView = [[UILabel alloc]initWithFrame:CGRectZero];
        cell.galleryTitleView.font = [UIFont boldSystemFontOfSize:kGalleryTitleView_FontSize];
        cell.galleryTitleView.text=[[self.galleryMediaArray title:indexPath.row] stringByTrimmingLeadingAndTrailingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        cell.galleryTitleView.frame=CGRectMake(10,5, 305,[cell.galleryTitleView.text sizeWithFont:cell.galleryTitleView.font].height);
        [cell.contentView addSubview:cell.galleryTitleView];
        //        NSLog(@"gallery title %@ frame %@",cell.galleryTitleView.text,NSStringFromCGRect(cell.galleryTitleView.frame));
        // cell.messageLbl.text=[self.mediaArray message:indexPath.row];
        if(!cell.galleryImageView)
            cell.galleryImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        cell.galleryImageView.frame=CGRectMake((320-imageSize.width)/2,cell.galleryTitleView.frame.origin.y+cell.galleryTitleView.frame.size.height+5, imageSize.width, imageSize.height);
        [cell.contentView addSubview:cell.galleryImageView];
        NSLog(@"image frame %@",NSStringFromCGRect(cell.galleryImageView.frame));
        if([[self.galleryMediaArray objectAtIndex:indexPath.row] valueForKey:@"GalleryImage"]) {
            cell.galleryImageView.image= [[self.galleryMediaArray objectAtIndex:indexPath.row] valueForKey:@"GalleryImage"];
            [cell.activityIndicator stopAnimating];
        }
        else {
            NSMutableDictionary *mutableDictionary = [self.galleryMediaArray objectAtIndex:indexPath.row];
            NSNumber *number = [[self.galleryMediaArray objectAtIndex:indexPath.row] valueForKey:@"ISDOWNLOADINGIMAGE"];
            if(number == nil || [number boolValue] == FALSE) {
                UrlDownloaderOperation *operation = [[UrlDownloaderOperation alloc]initWithUrl:[NSURL URLWithString:[self.galleryMediaArray url:indexPath.row]] object:mutableDictionary ];
                operation.delegate= self;
                [mutableDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"ISDOWNLOADINGIMAGE"];
                [galleryImagesDownloadOperationQueue addOperation:operation];
                //                GalleryImageDownloadRequest *request =[[GalleryImageDownloadRequest alloc]init];
                //                [request downloadImageForURL:[self.galleryMediaArray url:indexPath.row] galleryDictionary:[self.galleryMediaArray objectAtIndex:indexPath.row] completionBlock:^(NSMutableDictionary *dictionary, UIImage *image, NSError *error) {
                //                    [dictionary setObject:[NSNumber numberWithBool:YES] forKey:@"ISDOWNLOADINGIMAGE"];
                //                    if(image) {
                //                        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                //                            [dictionary setObject:image forKey:@"GalleryImage"];
                //                            cell.galleryImageView.image= [[self.galleryMediaArray objectAtIndex:indexPath.row] valueForKey:@"GalleryImage"];
                //                            //                        CGSize imageSize = [self aspectFitSizeForImageSize:tableCell.galleryImageView.image.size];
                //                            //                        tableCell.galleryImageView.frame=CGRectMake(0,0, imageSize.width, imageSize.height);
                //                            NSLog(@"title frame %@ %@",NSStringFromCGRect(cell.galleryTitleView.frame),NSStringFromCGRect(cell.galleryImageView.frame));
                //                            [cell.activityIndicator stopAnimating];
                //                            NSUInteger index = [self.galleryMediaArray indexOfObject:dictionary];
                //                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                //                            @try {
                //                                [self.tableV reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                //                            }
                //                            @catch (NSException *exception) {
                //                                NSLog(@"EXCEPTION RELOADING ROW AT INDEX PATH %@",indexPath);
                //                            }
                //
                //                        }];
                //                    }
                //                }];
            }
        }
        cell.messageWebView.tag = indexPath.row;
        //        NSUInteger webViewHeight = [self webViewHeight:indexPath.row];
        //        NSNumber *num = [[self.galleryMediaArray objectAtIndex:indexPath.row] valueForKey:@"WebViewLoaded"];
        //        if(!num)
        //            num = [NSNumber numberWithBool:FALSE];
        //        if([num boolValue] == FALSE)
        [cell.messageWebView removeFromSuperview];
        NSString *wrappedText = [self.galleryMediaArray message:indexPath.row];
        //        if(!cell.messageWebView)
        cell.messageWebView = [[UIWebView alloc] initWithFrame:CGRectMake(10,cell.galleryTitleView.frame.size.height+imageSize.height+15, 305, [self minHeightForText:wrappedText])];
        //        cell.messageWebView.frame = CGRectMake(5.0f, [self.galleryTableView.delegate tableView:self.galleryTableView heightForRowAtIndexPath:indexPath], 320.0f, cell.messageWebView.frame.size.height);
        cell.messageWebView.tag = indexPath.row;
        [cell.messageWebView loadHTMLString:wrappedText baseURL:nil];
        cell.messageWebView.delegate = self;
        cell.messageWebView.layer.cornerRadius = 0;
        cell.messageWebView.userInteractionEnabled = YES;
        cell.messageWebView.multipleTouchEnabled = YES;
        cell.messageWebView.clipsToBounds = YES;
        cell.messageWebView.scalesPageToFit = NO;
        cell.messageWebView.backgroundColor = [UIColor clearColor];
        cell.messageWebView.scrollView.scrollEnabled = NO;
        cell.messageWebView.scrollView.bounces = NO;
        [cell.contentView addSubview:cell.messageWebView];
        
        //        [cell.messageWebView setDelegate:self];
        //        cell.messageWebView.center = CGPointMake(cell.frame.size.width/2, cell.frame.size.height-(cell.messageWebView.frame.size.height/2));
        //        NSLog(@"message view frame %@ %@",NSStringFromCGRect(cell.messageWebView.frame),NSStringFromCGRect(cell.frame));
        
    }
    return cell;
}

-(void)downloadGalleryImages:(NSArray*)images {
    for(NSMutableDictionary *dictionary in images) {
        UrlDownloaderOperation *operation = [[UrlDownloaderOperation alloc]initWithUrl:[NSURL URLWithString:[dictionary valueForKey:@"url"]] object:dictionary ];
        operation.delegate= self;
        [dictionary setObject:[NSNumber numberWithBool:YES] forKey:@"ISDOWNLOADINGIMAGE"];
        [galleryImagesDownloadOperationQueue addOperation:operation];
        //        [operationQueue addOperationWithBlock:^{
        //            GalleryImageDownloadRequest *request =[[GalleryImageDownloadRequest alloc]init];
        //            [request downloadImageForURL:[dictionary valueForKey:@"url"] galleryDictionary:dictionary completionBlock:^(NSMutableDictionary *_dictionary, UIImage *image, NSError *error) {
        //                [_dictionary setObject:[NSNumber numberWithBool:FALSE] forKey:@"ISDOWNLOADINGIMAGE"];
        //                if(!error) {
        //                    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        //                        [_dictionary setObject:image forKey:@"GalleryImage"];
        //                        NSUInteger index = [self.galleryMediaArray indexOfObject:dictionary];
        //                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        //                        if(indexPath.row<self.galleryMediaArray.count) {
        //                            @try {
        //                                [self.tableV reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        //                            }
        //                            @catch (NSException *exception) {
        //                                NSLog(@"EXCEPTION RELOADING ROW AT INDEX PATH %@",indexPath);
        //                            }
        //                        }
        //                    }];
        //
        //                }
        //            }];
        //        }];
        
    }
    //        }];
    //    }
}
-(void)awakeFromNib {
    [super awakeFromNib];
    galleryImagesDownloadOperationQueue = [NSOperationQueue new];
    galleryImagesDownloadOperationQueue.maxConcurrentOperationCount = 10;
    
}
//-(id)initWithStyle:(UITableViewStyle)style
//{
//    if(self = [super initWithStyle:style]) {
//        galleryImagesDownloadOperationQueue = [NSOperationQueue new];
//        galleryImagesDownloadOperationQueue.maxConcurrentOperationCount = 10;
//    }
//    return self;
//}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        galleryImagesDownloadOperationQueue = [NSOperationQueue new];
        galleryImagesDownloadOperationQueue.maxConcurrentOperationCount = 10;
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    for(UrlDownloaderOperation *opetaion in galleryImagesDownloadOperationQueue.operations)
        [opetaion cancelOperation];
    [galleryImagesDownloadOperationQueue performSelectorOnMainThread:@selector(cancelAllOperations) withObject:nil waitUntilDone:FALSE];
    galleryImagesDownloadOperationQueue = nil;
    [menuView removeFromSuperview];
    //    [self.restaurantMenuView removeFromSuperview];
}
-(void)addLegendController {
    
    // add legend controller.
    if( [self.restaurantDetailsDict inNetwork])
        legendController = [[CTHomeLegendViewController alloc]initWithNibName:@"CTHomeLegendViewController" bundle:nil];
    else
        legendController = [[CTHomeLegendViewController alloc]initWithNibName:@"CTHomeLegendViewControllerOutOfNetwork" bundle:nil];
    legendController.delegate = self;
    [self.view addSubview:legendController.view];
    [self addChildViewController:legendController];
    legendController.view.center = CGPointMake(-((legendController.view.frame.size.width/2)-25), legendController.view.center.y);
    if([self.restaurantDetailsDict reservationServiceConfigurationEnabled] == NO)
        legendController.reservationButton.enabled = NO;
    if([self.restaurantDetailsDict promotionServiceConfigurationEnabled] == NO)
        legendController.specialOfferButton.enabled = NO;
    if([self.restaurantDetailsDict messagingServiceConfigurationEnabled] == NO)
        legendController.messageButton.enabled = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    //    [self.galleryTableView registerNib:[UINib nibWithNibName:@"CTGalleryCell" bundle:nil] forCellReuseIdentifier:@"gallery"];
    self.title=@"Gallery";
    if(![[NSUserDefaults standardUserDefaults]objectForKey:@"showAtFirstTime"]){
        [self.navigationController.view addSubview:self.hintMaskView];
        [self addTapGestureEvent];
    }else{
        [self.hintMaskView removeFromSuperview];
    }
    //    self.imageSizeArray=[[NSMutaimageSizeArraybleArray alloc]init];
    self.galleryTableView.backgroundColor=[UIColor clearColor];
    //    self.galleryTableView.tableFooterView=[[UIView alloc]init];
    self.galleryMediaArray=[[NSMutableArray alloc]init];
    //    [self setCustomNavigationBar];
    // set buttons
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
    CTParentViewController *parentController = (CTParentViewController*)appDelegate.window.rootViewController;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:[self backButton],flexibleSpace,[self markAsFavoriteButton],flexibleSpace, nil];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:flexibleSpace,[parentController listMenuBtn],flexibleSpace,[self shareButton],flexibleSpace, nil];
    [self loadNavTitleLogo];
    //   [self.view addSubview:[self setRestaurantMenuView]];
    
    [self addLegendController];
    
    [self setTheme];
    [self checkiOS7];
    //    [self retriveMediaMetaDatabySaSl];
    self.titleTextView.hidden=YES;
    self.messageTxtWebView.hidden=YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark add Tap gesture
-(void)addTapGestureEvent{
    [[NSUserDefaults standardUserDefaults]setObject:@"hint" forKey:@"showAtFirstTime"];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired=1;
    tap.delegate=self;
    [self.hintMaskView addGestureRecognizer:tap];
}
-(void)tapAction:(UITapGestureRecognizer *)gesture{
    [self.hintMaskView removeFromSuperview];
}
#pragma mark create custom navigation bar
-(void)deleteRestaurantFromFavorites {
    
}
-(void)markAsFavoriteBtnTaped:(id)sender {
    if([CTCommonMethods isUIDStoredInDevice]){
        UIButton *btn = (UIButton*)sender;
        if([btn isSelected]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[CTFavoritesDataModel sharedInstance] deleteFavoriteRestaurant:[self.restaurantDetailsDict permanentURL] completionBlock:^(NSError *error, id JSON) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if(!error) {
                    [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Item removed from your favorite list"];
                    [btn setSelected:FALSE];
                }else {
                    if(error) {
                        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:error.localizedRecoverySuggestion];
                    }else {
                        NSLog(@"FAILED");
                        NSError *jsonError = [CTCommonMethods validateJSON:JSON];
                        //        NSDictionary *errorDict=(NSDictionary *)JSON;
                        //        NSDictionary *errorMsgDict=[errorDict objectForKey:@"error"];
                        //        NSString *errorMsgStr=[errorMsgDict objectForKey:@"message"];
                        if(jsonError)
                            [CTCommonMethods showErrorAlertMessageWithTitle:jsonError.localizedFailureReason andMessage:jsonError.localizedDescription];
                        else
                            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:CT_DefaultAlertMessage];
                    }
                }
            }];        }else {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                NSLog(@"permanent url  %@",[self.restaurantDetailsDict permanentURL]);
                [[CTFavoritesDataModel sharedInstance]markAsFavoriteWithURLKey:[(NSMutableDictionary*)self.restaurantDetailsDict permanentURL] completionBlock:^(NSError *error, id JSON) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    if(!error) {
                        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Favorite restaurant is added successfully"];
                        [btn setSelected:YES];
                    }else {
                        if(error) {
                            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:error.localizedRecoverySuggestion];
                        }else {
                            NSLog(@"FAILED");
                            NSError *jsonError = [CTCommonMethods validateJSON:JSON];
                            //        NSDictionary *errorDict=(NSDictionary *)JSON;
                            //        NSDictionary *errorMsgDict=[errorDict objectForKey:@"error"];
                            //        NSString *errorMsgStr=[errorMsgDict objectForKey:@"message"];
                            if(jsonError)
                                [CTCommonMethods showErrorAlertMessageWithTitle:jsonError.localizedFailureReason andMessage:jsonError.localizedDescription];
                            else
                                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:CT_DefaultAlertMessage];
                        }
                    }
                }];
            }
    }else {
        CTLoginPopup *login = [[CTLoginPopup alloc]init];
        CTAppDelegate *appDelegate = (CTAppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate.window.rootViewController.view addSubview:login];
    }
}

-(void)backBtnTaped:(id)sender {
    [self.restaurantMenuView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)shareBtnTaped:(id)sender {
    if([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *controller=[[MFMailComposeViewController alloc]init];
        controller.mailComposeDelegate=self;
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
}
-(UIBarButtonItem *)markAsFavoriteButton{
    UIButton* favoriteButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [favoriteButton setFrame:CGRectMake(50, 0, 25, 25)];
    [favoriteButton setImage:[UIImage imageNamed:CT_FavoriteIcon] forState:UIControlStateNormal];
    [favoriteButton setImage:[UIImage imageNamed:CT_GoldStar] forState:UIControlStateSelected];
    //NSLog(@"dictionary %@",self.restaurantDetailsDict);
    if([(NSMutableDictionary*)[CTRootControllerDataModel sharedInstance].selectedRestaurant isFavorite])
        [favoriteButton setSelected:YES];
    [favoriteButton addTarget:self action:@selector(markAsFavoriteBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithCustomView:favoriteButton];
    return leftBarbutton;
    
}
-(UIBarButtonItem *)backButton{
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[backButton setFrame:CGRectMake(0, 0, 35, 35)];
    [backButton setFrame:CGRectMake(0, 0, 60, 44)];
    [backButton setImage:[UIImage imageNamed:CT_BackIcon] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    return leftBarbutton;
    
}
-(UIBarButtonItem *)shareButton{
    UIButton* shareButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setFrame:CGRectMake(0, 0, 32, 32)];
    [shareButton setImage:[UIImage imageNamed:CT_ShareIcon] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithCustomView:shareButton];
    return leftBarbutton;
    
}
-(void)setCustomNavigationBar{
    self.ctNavigationBar=[[CTNavigationBar alloc]init];
    self.ctNavigationBar.navigationController=self.navigationController;
    self.ctNavigationBar.sliderView=self.view;
    //    self.ctNavigationBar.isMainMenuSlideOut=YES;
    //    self.ctNavigationBar.isFavoriteList=YES;
    self.ctNavigationBar.isFavoriteFromHome=YES;
    //self.navigationItem.leftBarButtonItem=[self setBackButton];
    self.navigationItem.leftBarButtonItems=[NSArray arrayWithObjects:[self setBackButton],[self.ctNavigationBar setFavotiteButton] ,nil];
    NSLog(@"icon url %@",[self.restaurantDetailsDict restaurantNameIcon]);
    //self.navigationItem.titleView=[self.ctNavigationBar setRestaurantLogo:[self.restaurantDetailsDict restaurantNameIcon]];
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:[self.ctNavigationBar setMenuButton],[self.ctNavigationBar setShareButton], nil];
    // self.navigationItem.rightBarButtonItem=[self.ctNavigationBar setMenuButton];
    [self loadNavTitleLogo];
    [self storeRestaurantDetails];
    [self performSelector:@selector(showMainMenuView) withObject:self afterDelay:0.5];
}

-(void)loadNavTitleLogo{
    dispatch_queue_t backgroundQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(backgroundQueue, ^{
        NSURL *url=[NSURL URLWithString:[self.restaurantDetailsDict logoURL]];
        NSData *data=[NSData dataWithContentsOfURL:url];
        dispatch_queue_t mainQueue=dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            UIImageView *logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 35)];
            UIImage *logo=[UIImage imageWithData:data];
            logoImageView.image=logo;
            self.navigationItem.titleView=logoImageView;
            [self.restaurantDetailsDict setObject:logo forKey:kLogoImageKey];
        });
    });
}
-(void)storeRestaurantDetails{
    
    NSData *data=[NSKeyedArchiver archivedDataWithRootObject:self.restaurantDetailsDict];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:CT_Observers_getSASL];
    [defaults synchronize];
}
#pragma mark set Theme
-(void)setTheme{
    UIColor *color=nil;
    NSDictionary*themeColors =[self.restaurantDetailsDict objectForKey:@"themeColors"];
    NSDictionary *anchor=[self.restaurantDetailsDict anchorURL];
    NSLog(@"ANCHOR %@",anchor);
    NSLog(@"permanentURL %@",[anchor objectForKey:@"permanentURL"] );
    [[NSUserDefaults standardUserDefaults]setObject:[anchor objectForKey:@"permanentURL"] forKey:CT_URLKey];
    NSLog(@"themeColors %@",themeColors);
    if(!themeColors){
        NSString *backgroundColor=[themeColors background];
        NSLog(@"background color %@",backgroundColor);
        NSUInteger red, green, blue;
        //        sscanf([backgroundColor UTF8String], "#%02X%02X%02X", &red, &green, &blue);
        color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
        self.view.backgroundColor=color;
    }else{
        self.view.backgroundColor=[UIColor whiteColor];
    }
    
}
#pragma mark restaurantMenuView
-(UIView *)setRestaurantMenuView{
    if([self.restaurantDetailsDict inNetwork]) {
        CGRect slideFrame=CGRectMake(0 ,0,265, self.view.frame.size.height);
        menuView=[[CTRestaurantMenuView alloc]initWithFrame:slideFrame];
        menuView.delegate = self;
        menuView.viewController=self;
        menuView.navigationController=self.navigationController;
        
        self.restaurantMenuView = menuView;
        if([self.restaurantDetailsDict reservationServiceConfigurationEnabled] == NO)
            menuView.reservationButton.enabled = NO;
        if([self.restaurantDetailsDict promotionServiceConfigurationEnabled] == NO)
            menuView.specialOfferButton.enabled = NO;
        if([self.restaurantDetailsDict messagingServiceConfigurationEnabled] == NO)
            menuView.messageButton.enabled = NO;
        //        if([self.restaurantDetailsDict mediaserviceConfigurationEnabled] == NO)
        //            menuView.cameraButton.enabled = NO;
        
        //        if([self.restaurantDetailsDict smsEnabled] == NO)
        //            menuView.messageButton.enabled= NO;
        return self.restaurantMenuView;
    }else {
        CGRect slideFrame=CGRectMake(-115 ,0,115, self.view.frame.size.height);
        self.restaurantMenuView=[[CTOutOfNetworkMenuView alloc]initWithFrame:slideFrame];
        // self.outOfNetworkMenuView.viewController=self;
        //self.restaurantMenuView.navigationController=self.navigationController;
        return self.restaurantMenuView;
    }
    
}
#pragma mark back button
-(UIBarButtonItem *)setBackButton{
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[backButton setFrame:CGRectMake(0, 0, 35, 35)];
    [backButton setFrame:CGRectMake(0, 0, 60, 44)];
    [backButton setImage:[UIImage imageNamed:CT_BackIcon] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    return leftBarbutton;
    
}
-(void)backButtonAction:(id)sender{
    [self.ctNavigationBar.favoriteView removeFromSuperview];
    [self.ctNavigationBar.slideMainMenu removeFromSuperview];
    [self.restaurantMenuView removeFromSuperview];
    [self.ctNavigationBar.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.ctNavigationBar removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark Menu
-(void)showMainMenuView{
    [self.view addSubview:[self setRestaurantMenuView]];
    //    [self.view addSubview:[self.ctNavigationBar favoriteListView]];
    UIView *mainMenu = [self.ctNavigationBar sliderMainMenu];
    [self.view addSubview:mainMenu];
    [self.view bringSubviewToFront:mainMenu];
    self.ctNavigationBar.slideMainMenu.isMessageControllerIsOpen=YES;
}
#pragma mark iOS7 check
-(void)checkiOS7{
    
    if(isIOS7){
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
}
#pragma mark retriveMediaMetaDatabySaSl
-(void)retriveMediaMetaDatabySaSl{
    NSString *sa,*sl;
    if(self.restaurantDetailsDict == nil) {
        sa = [[[CTRootControllerDataModel sharedInstance] selectedRestaurant] serviceAccommodatorId];
        sl = [[[CTRootControllerDataModel sharedInstance]selectedRestaurant] serviceLocationId];
    }else {
        sa = [self.restaurantDetailsDict serviceAccommodatorId];
        sl = [self.restaurantDetailsDict serviceLocationId];
    }
    NSString *params=[NSString stringWithFormat:@"serviceAccommodatorId=%@&serviceLocationId=%@&lastIndex=0&count=10&mediaType=ALL",sa,sl];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_getMediaMetaDatabySASL,params];
    NSLog(@"URL STRING %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        @synchronized (self) {
            if(!connectionError) {
                NSError *error = nil;
                NSArray *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                NSError *jsonError;
                if([JSON isKindOfClass:[NSDictionary class]])
                    jsonError = [CTCommonMethods validateJSON:JSON];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@",@"error"];
                if(!error && !jsonError) {
                    if(JSON && (([JSON isKindOfClass:[NSArray class]] && [JSON filteredArrayUsingPredicate:predicate].count == 0) || [JSON valueForKey:@"error"] == nil)) {
                        // did get json
                        self.galleryMediaArray = [JSON deepMutableCopy];
                        NSLog(@"json %@",self.galleryMediaArray);
                        [self.galleryTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:FALSE];
                        [self downloadGalleryImages:self.galleryMediaArray];
                    }else {
                        NSLog(@"JSON ERROR %@",error);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:CT_DefaultAlertMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                            [alert show];
                        });
                        
                    }
                }else if(error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                        [alert show];
                    });
                    
                }else if(jsonError) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:jsonError.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                        [alert show];
                    });
                    
                }
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:connectionError.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];
                });
                
            }
        }
    }];
    //    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    //
    //       self.mediaArray=(NSArray *)JSON;
    //        NSLog(@"MEDIA ARAY %@",self.mediaArray);
    //        if([self.mediaArray count]!=0){
    //        for(int i=0;i<[self.mediaArray count];i++){
    //        [self.messageTxtWebView loadHTMLString:[self.mediaArray message:i] baseURL:nil];
    //            self.titleTextView.text=[self.mediaArray title:i];
    //            [self.galleryMediaArray insertObject:[UIImage imageNamed:@"Default.png"] atIndex:i];
    //            NSString *titleHeight=[NSString stringWithFormat:@"%f",self.titleTextView.contentSize.height];
    //            NSString *webViewHeight=[NSString stringWithFormat:@"%f",self.messageTxtWebView.scrollView.contentSize.height];
    //            NSString *mediaHeight=[[self.mediaArray valueForKey:@"imageheight"] objectAtIndex:i];
    //            NSString *mediaWidth=[[self.mediaArray valueForKey:@"imagewidth"]objectAtIndex:i];
    //            [self.imageSizeArray addObject:[NSArray arrayWithObjects:mediaHeight,mediaWidth,titleHeight,webViewHeight,nil]];
    //            [self loadGalleryImage:self.mediaArray];
    //            //[self setDynamicContentScrollView:mediaArray];
    //            NSLog(@"SUCCESS  %@",[self.mediaArray url:0 ]);
    //        }
    //        }
    //        else{
    //            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"No Gallery images found. Please select some other server in settings"];
    //        }
    //
    //
    //    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    //        NSLog(@"FAILED");
    //    }];
    //    [operation start];
    
    
}
#pragma mark tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.galleryMediaArray count];
}
-(GLfloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.galleryMediaArray count]!=0){
        return [self labelHeight:indexPath.row]+[self imageHeight:indexPath.row]+[self webViewHeight:indexPath.row];
    }
    else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CTGalleryCell *cell=(CTGalleryCell *)[tableView dequeueReusableCellWithIdentifier:@"gallery"];
    if(cell == nil)
        cell = [[CTGalleryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"gallery"];
    return [self configureCell:cell forIndexPath:indexPath];
    //    cell.backgroundColor=[UIColor clearColor];
    //    if([self.galleryMediaArray count]!=0){
    ////        NSMutableDictionary *dictionary = [self.galleryMediaArray objectAtIndex:indexPath.row];
    ////        NSLog(@"dictionary %@",dictionary);
    ////        NSString *mediaHeight= [NSString stringWithFormat:@"%d",[self.galleryMediaArray imageheight:indexPath.row]];
    ////        NSString *mediaWidth=[NSString stringWithFormat:@"%d",[self.galleryMediaArray imagewidth:indexPath.row]];
    //        NSString *titleHeight=[NSString stringWithFormat:@"%f",self.titleTextView.contentSize.height];
    ////        NSString *webViewHeight=[NSString stringWithFormat:@"%f",self.messageTxtWebVsiew.scrollView.contentSize.height];
    //        NSLog(@"TITLE %@",[[self.galleryMediaArray title:indexPath.row] stringByTrimmingLeadingAndTrailingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
    //        cell.galleryTitleView.font = [UIFont boldSystemFontOfSize:kGalleryMessage_FontSize];
    //        cell.galleryTitleView.text=[[self.galleryMediaArray title:indexPath.row] stringByTrimmingLeadingAndTrailingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //        cell.galleryTitleView.frame=CGRectMake(0,0, 320,[cell.galleryTitleView.text sizeWithFont:cell.galleryTitleView.font].height);
    //       // cell.messageLbl.text=[self.mediaArray message:indexPath.row];
    //        if([[self.galleryMediaArray objectAtIndex:indexPath.row] valueForKey:@"GalleryImage"]) {
    //            cell.galleryImageView.image= [[self.galleryMediaArray objectAtIndex:indexPath.row] valueForKey:@"GalleryImage"];
    //            [cell.activityIndicator stopAnimating];
    //        }
    //        else {
    //            GalleryImageDownloadRequest *request =[[GalleryImageDownloadRequest alloc]init];
    //            [request downloadImageForCell:cell withURL:[self.galleryMediaArray url:indexPath.row] galleryDictionary:[self.galleryMediaArray objectAtIndex:indexPath.row] completionBlock:^(CTGalleryCell* tableCell,NSMutableDictionary *dictionary, UIImage *image, NSError *error) {
    //                if(image) {
    //                    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
    //                        [dictionary setObject:image forKey:@"GalleryImage"];
    //                        tableCell.galleryImageView.image= [[self.galleryMediaArray objectAtIndex:indexPath.row] valueForKey:@"GalleryImage"];
    //                        CGSize imageSize = [CTCommonMethods imageSizeAfterAspectFit:tableCell.galleryImageView];
    //                        tableCell.galleryImageView.frame=CGRectMake(0,0, imageSize.width, imageSize.height);
    //                        NSLog(@"title frame %@ %@",NSStringFromCGRect(tableCell.galleryTitleView.frame),NSStringFromCGRect(tableCell.galleryImageView.frame));
    //                        [tableCell.activityIndicator stopAnimating];
    //                        NSUInteger index = [self.galleryMediaArray indexOfObject:dictionary];
    //                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    //                        @try {
    //                            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    //                        }
    //                        @catch (NSException *exception) {
    //                            NSLog(@"EXCEPTION RELOADING ROW AT INDEX PATH %@",indexPath);
    //                        }
    //
    //                    }];
    //                }
    //            }];
    //        }
    //        cell.messageLbl.text = [self.galleryMediaArray message:indexPath.row];
    //        cell.messageLbl.font = [UIFont systemFontOfSize:kGalleryMessage_FontSize];
    //
    ////        [cell.webView loadHTMLString:[dictionary valueForKey:@"message"] baseURL:nil];
    ////        int webHeight=[mediaHeight intValue]+60;
    ////        cell.webView.frame=CGRectMake(13, webHeight, 299 , [webViewHeight intValue]);
    //    }
    //    return cell;
}

-(void)loadGalleryImage:(NSArray *)galleryMedia{
    
    NSOperationQueue *backgroundQueue=[[NSOperationQueue alloc]init];
    [backgroundQueue addOperationWithBlock:^{
        for(int i=0;i<[galleryMedia count];i++){
            
            NSURL *url=[NSURL URLWithString:[galleryMedia url:i]];
            NSData *data=[NSData dataWithContentsOfURL:url];
            UIImage *imageData=[UIImage imageWithData:data];
            if(imageData!=NULL){
                [self.galleryMediaArray replaceObjectAtIndex:i withObject:imageData];
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.galleryTableView reloadData];
            }];
        }
    }];
}

#pragma UrlDownloaderOperationDelegate
-(void)didDownloadData:(NSData*)data forObject:(id)object {
    NSLog(@"CHECK HERE");
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        NSMutableDictionary *dictionary = (NSMutableDictionary*)object;
        [dictionary setObject:[NSNumber numberWithBool:FALSE] forKey:@"ISDOWNLOADINGIMAGE"];
        UIImage *image = [UIImage imageWithData:data];
        if(image)
            [dictionary setObject:image forKey:@"GalleryImage"];
        NSUInteger index = [self.galleryMediaArray indexOfObject:dictionary];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        if(indexPath.row<self.galleryMediaArray.count) {
            @try {
                CTGalleryCell *cell = (CTGalleryCell*)[self.galleryTableView cellForRowAtIndexPath:indexPath];
                if(cell)
                    cell.galleryImageView.image = [UIImage imageWithData:data];
            }
            @catch (NSException *exception) {
                NSLog(@"EXCEPTION RELOADING ROW AT INDEX PATH %@",indexPath);
            }
        }
    }];
    
}
-(void)didFailWithError:(NSError*)error forObject:(id)object {
    NSMutableDictionary *dictionary = (NSMutableDictionary*)object;
    [dictionary setObject:[NSNumber numberWithBool:FALSE] forKey:@"ISDOWNLOADINGIMAGE"];
    NSLog(@"FAILED OPERATION WITH ERROR %@",error);
}
-(void)didFinishWithData:(NSData*)data forObject:(id)object {
    [(NSMutableDictionary*)object setObject:[NSNumber numberWithBool:FALSE] forKey:@"ISDOWNLOADINGIMAGE"];
}

#pragma CTRestaurantMenuViewDelegate
-(void)didTapCameraBtn {
    
    CTPhotoUploadViewController *controller = [[CTPhotoUploadViewController alloc]initWithNibName:@"CTPhotoUploadViewController" bundle:nil];
    [controller setRestaurantDictionary:self.restaurantDetailsDict];
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    //    [self presentViewController:controller animated:FALSE completion:nil];
    //    [self.navigationController addChildViewController:controller];
    //    [self.navigationController.view addSubview:controller.view];
}
-(void)didTapSpecialOfferView {
    // show special offer view.
    CTSpecialOfferView *offerView = [[CTSpecialOfferView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:offerView];
    offerView.center = CGPointMake(-(offerView.frame.size.width -(offerView.frame.size.width/2)), offerView.center.y);
    [offerView showSpecialOfferViewWithMenuView:menuView];
}
-(void)didTapReservationViewBtn {
    CTReservationView *reservationView = [[CTReservationView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    reservationView.center = CGPointMake(-(reservationView.frame.size.width -(reservationView.frame.size.width/2)), reservationView.center.y);
    [self.view addSubview:reservationView];
    [reservationView showReservationViewWithMenuView:menuView];
}
-(void)didTapMessageBtn {
    //    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    //    CTMessageViewController *messageController=[storyboard instantiateViewControllerWithIdentifier:@"CTMessageViewController"];
    //    messageController.view.center = CGPointMake(-(messageController.view.frame.size.width -(messageController.view.frame.size.width/2)), messageController.view.center.y);
    //    [self addChildViewController:messageController];
    //    [self.view addSubview:messageController.view];
    //    [messageController showMessageViewWithMenuView:menuView];
    CTChatViewController *chatController = [[CTChatViewController alloc]init];
    chatController.view.center = CGPointMake(-(chatController.view.frame.size.width -(chatController.view.frame.size.width/2)), chatController.view.center.y);
    [self addChildViewController:chatController];
    [self.view addSubview:chatController.view];
    [chatController showMessageViewWithMenuView:menuView];
}
-(void)didTapYelpBtn {
    CTYelpReviewsViewController *yelpReviewsController = [[CTYelpReviewsViewController alloc]init];
    yelpReviewsController.view.center = CGPointMake(-(yelpReviewsController.view.frame.size.width -(yelpReviewsController.view.frame.size.width/2)), yelpReviewsController.view.center.y);
    [self addChildViewController:yelpReviewsController];
    [self.view addSubview:yelpReviewsController.view];
    //    yelpReviewsController.view.frame = CGRectMake(yelpReviewsController.view.frame.origin.x, yelpReviewsController.view.frame.origin.y-20, yelpReviewsController.view.frame.size.width, yelpReviewsController.view.frame.size.height-44);
    [yelpReviewsController showYelpReviewViewWithMenuView:menuView];
}
-(void)didShowLegend {
    [self.navigationItem.rightBarButtonItems makeObjectsPerformSelector:@selector(setEnabled:) withObject:[NSNumber numberWithBool:NO]];
    [[self.navigationItem.leftBarButtonItems objectAtIndex:2]setEnabled:NO];
}
-(void)didHideLegend {
    for(UIBarButtonItem *item in self.navigationItem.rightBarButtonItems)
        [item setEnabled:YES];
    [[self.navigationItem.leftBarButtonItems objectAtIndex:2]setEnabled:YES];
    
}
#pragma UIWebViewDelgate
-(void)webViewDidFinishLoad:(UIWebView *)aWebView {
    
    CGRect frame = aWebView.frame;
    frame.size.height = 1;
    aWebView.frame = frame;
    // Asks the view to calculate and return the size that best fits its subviews.
    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    aWebView.frame = frame;
    NSMutableDictionary *dictionary =[self.galleryMediaArray objectAtIndex:aWebView.tag];
    [dictionary setObject:[NSNumber numberWithInt:frame.size.height] forKey:@"WebViewHeight"];
    [self.galleryTableView beginUpdates];
    [self.galleryTableView  endUpdates];
    //
    
}
@end
