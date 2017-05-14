//
//  CTImageAddViewController.h
//  Community
//
//  Created by My Mac on 18/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CTImageAddDelegate <NSObject>
- (void)setUserSelectedImage:(UIImage*)image;
-(void)CancelViewMethod;
@end

@interface CTImageAddViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UIScrollViewDelegate>
{
    CGPoint maskCenter;
    CGFloat y;
    BOOL imageSelected;
    BOOL canDismissView;
    UIImage *crop;
    UIImage *image;
}
@property (nonatomic, retain) NSString *titleForView;
@property (nonatomic, assign) id<CTImageAddDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIImageView *preview;


@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIImageView *mainimage;


@property (strong, nonatomic) IBOutlet UIView *MaskOrientationView;
@property (strong, nonatomic) IBOutlet UIButton *btPortrait;
@property (strong, nonatomic) IBOutlet UIButton *btLandscape;
@property (strong, nonatomic) IBOutlet UIButton *btPreview;

@property (strong, nonatomic) IBOutlet UIButton *btRotateRight;

@property (strong, nonatomic) IBOutlet UIButton *btRotateLeft;
@property (strong, nonatomic) IBOutlet UIButton *mask;
@property (strong, nonatomic) IBOutlet UILabel *lblNoImage;
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) IBOutlet UIButton *btCamera;

- (IBAction)actionPortrait:(id)sender;
- (IBAction)actionLandscape:(id)sender;
- (IBAction)buttonRotateLeft:(id)sender;
- (IBAction)camera:(id)sender;
- (IBAction)buttonRotateRight:(id)sender;
- (IBAction)Preview_Pressed:(id)sender;

@end
