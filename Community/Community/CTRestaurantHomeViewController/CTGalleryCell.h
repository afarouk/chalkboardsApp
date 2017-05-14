//
//  CTGalleryCell.h
//  Community
//
//  Created by dinesh on 30/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTGalleryCell : UITableViewCell  <UIWebViewDelegate> {
    BOOL webviewLoaded;
}
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UILabel *messageLbl;
@property (strong, nonatomic)  UIWebView *messageWebView;
@property (strong, nonatomic)  UILabel *galleryTitleView;
@property (strong, nonatomic)  UIImageView *galleryImageView;
@property(weak,nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end
