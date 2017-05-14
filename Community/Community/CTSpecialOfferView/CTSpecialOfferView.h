//
//  CTSpecialOfferView.h
//  Community
//
//  Created by dinesh on 04/02/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PromoSlideImageView : UIImageView
@property(nonatomic,strong) NSString *promoUID;
@property(nonatomic) BOOL isDownloadInProgress;
@property(nonatomic,strong) NSDictionary *promoMetaData;
@end
@interface CTSpecialOfferView : UIView <UIScrollViewDelegate> {
    UIView *menuView;
}
@property (nonatomic,retain) NSString *sa;
@property (nonatomic,retain)NSString *sl;
@property(nonatomic,strong) NSMutableArray *promoImagesArray;
@property (weak, nonatomic) IBOutlet UIImageView *promotionImage;
@property(weak,nonatomic) IBOutlet UIScrollView *scrollView;
@property(weak,nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(weak,nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic,retain)NSMutableArray *imageDataArray;
@property (nonatomic,assign)int imageCount;
@property(weak,nonatomic) IBOutlet UITextField *titleTextField;
@property(weak,nonatomic) IBOutlet UITextView *descriptionTextView;
// show and hide
-(void)showSpecialOfferViewWithMenuView:(UIView*)menuView;
@end
