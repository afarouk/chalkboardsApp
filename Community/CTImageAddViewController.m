//
//  CTImageAddViewController.m
//  Community
//
//  Created by My Mac on 18/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import "CTImageAddViewController.h"
#import "CTImagePreViewController.h"
#import "ImageNamesFile.h"

#define IMAGE_HEIGHT 568
#define IMAGE_WIDTH  320

#define IMAGE_SIZE   CGSizeMake(512, 384)

@interface CTImageAddViewController ()

@end
@implementation  UIImage (DE)

- (UIImage *)scaleToSize:(CGSize)size
{
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    CGContextRef context=CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
    
    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), self.CGImage);
    
    CGImageRef scaledImage=CGBitmapContextCreateImage(context);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    UIImage *image=[UIImage imageWithCGImage:scaledImage];
    
    CGImageRelease(scaledImage);
    
    return image;
}

- (UIImage *)crop:(CGRect)rect
{
    rect=CGRectMake(rect.origin.x*self.scale, rect.origin.y*self.scale, rect.size.width*self.scale, rect.size.height*self.scale);
    CGImageRef imageRef=CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *result=[UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    return result;
}

- (UIImage *)resizeAndCrop
{
    CGSize newSize={self.size.width*IMAGE_HEIGHT/self.size.height, IMAGE_HEIGHT};
    
    CGContextRef                context;
    CGImageRef                  imageRef;
    CGSize                      inputSize;
    UIImage                     *outputImage = nil;
    CGFloat                     scaleFactor, width;
    
    inputSize = self.size;
    scaleFactor = newSize.height / inputSize.height;
    width = roundf( inputSize.width * scaleFactor );
    
    if(width>newSize.width)
    {
        scaleFactor = newSize.width / inputSize.width;
        newSize.height = roundf( inputSize.height * scaleFactor );
    }
    else
    {
        newSize.width = width;
    }
    
    UIGraphicsBeginImageContext( newSize );
    
    context = UIGraphicsGetCurrentContext();
    CGContextDrawImage( context, CGRectMake( 0, 0, newSize.width, newSize.height ), self.CGImage );
    outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    inputSize=newSize;
    NSInteger cropX=(newSize.width-IMAGE_WIDTH)/2;
    CGRect cropRect={cropX, 0, IMAGE_WIDTH, IMAGE_HEIGHT};
    if( cropRect.origin.x >= inputSize.width || cropRect.origin.y >= inputSize.height )
    {
        return outputImage;
    }
    if( cropRect.origin.x + cropRect.size.width >= inputSize.width )
    {
        cropRect.size.width = inputSize.width - cropRect.origin.x;
    }
    if( cropRect.origin.y + cropRect.size.height >= inputSize.height )
    {
        cropRect.size.height = inputSize.height - cropRect.origin.y;
    }
    
    if((imageRef=CGImageCreateWithImageInRect(outputImage.CGImage, cropRect)))
    {
        outputImage=[[UIImage alloc] initWithCGImage:imageRef];
        CGImageRelease(imageRef);
    }
    
    return outputImage;
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    UIView *rotatedViewBox=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    CGAffineTransform transform=CGAffineTransformMakeRotation(degrees*M_PI/180);
    rotatedViewBox.transform=transform;
    CGSize rotatedSize=rotatedViewBox.frame.size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap=UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, degrees*M_PI/180);
    
    CGContextScaleCTM(bitmap, 1., -1.);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width/2, -self.size.height/2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end

@implementation CTImageAddViewController

#pragma mark - Back Button
-(void)didTapBackButtonOnFavorites:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)viewWillAppear:(BOOL)animated {
    if (_preview.image == nil)
    {
        self.lblNoImage.hidden = FALSE;
    }
    if (_mainimage.image == nil)
    {
        self.lblNoImage.hidden = FALSE;
    }
    
    y=self.view.frame.origin.y;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.titleForView) {
        self.title = self.titleForView;;
    }
    canDismissView = [[[self navigationController] viewControllers] count] == 1;
    
    _scroll.backgroundColor = [UIColor grayColor];
    
   
    //    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))        // iOS-7 code[current] or greater
    //    {
    //        self.edgesForExtendedLayout=UIRectEdgeNone;
    //        self.extendedLayoutIncludesOpaqueBars=NO;
    //        self.automaticallyAdjustsScrollViewInsets=NO;
    //        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil] ;
    //
    //    }
    //    else{
    //        //      UIButton *homeButton = [[UIButton alloc] init];
    //        //      [homeButton setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    //        //      homeButton.frame = CGRectMake(0, 0, homeButton.imageView.image.size.width, homeButton.imageView.image.size.height);
    //        //      [homeButton addTarget:self action:@selector(backBtnPressed:)forControlEvents:UIControlEventTouchUpInside];
    //        //      UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc]initWithCustomView:homeButton];
    //        //
    //        //      self.navigationItem.leftBarButtonItem = revealButtonItem;
    //
    //
    //    }
    
    
    if (!canDismissView) {
        
//        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backBtn setImage:[UIImage imageNamed:@"Back.png"] forState:UIControlStateNormal];
//        [backBtn sizeToFit];
        //UIButton *backBtn = [[CommonMethods sharedInstance]backButton];
        //[backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [self backButton];
    }
    
    UIButton *useButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[useButton setImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
    [useButton setTitle:@"Use" forState:UIControlStateNormal];
    useButton.backgroundColor = [UIColor colorWithRed:0/225.0 green:122/255.0 blue:255/255.0 alpha:1.0];
    useButton.frame = CGRectMake(0, 0, 70, 33);
    
    self.MaskOrientationView.layer.borderColor = [UIColor blackColor].CGColor;
    self.MaskOrientationView.layer.borderWidth = 2;
    
    [@[self.btPreview,useButton
       
       ] enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
           [[CTCommonMethods sharedInstance] applyBlackBorderAndCornersToButton:btn];
       }];
    
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self.view andSubViews:YES];
    // UIButton *infoButton = [[CommonMethods sharedInstance]infoButton];
    
    [useButton addTarget:self action:@selector(useButtonBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:useButton];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:homeBarButtonItem,nil];
    [[_mask layer] setBorderWidth:2.0f];
    [[_mask layer] setBorderColor:[UIColor blueColor].CGColor];
    _mask.hidden=YES;
    _btRotateLeft.hidden=YES;
    _btRotateRight.hidden=YES;
    
    self.MaskOrientationView.layer.borderColor = [UIColor blackColor].CGColor;
    self.MaskOrientationView.layer.borderWidth = 2;
    maskCenter = _mask.center;
    
    //    V: to set default landscape mode
    [self actionLandscape:nil];
    // Do any additional setup after loading the view from its nib.
    
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
    NSLog(@"Size of Image(bytes):%d",[imgData length]);
}

-(void)useButtonBtnTaped :(UIButton *)sender
{
    if(imageSelected == NO) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:StringAlertTitleNoImage message:StringAlertMsgSelectImage delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles: nil];
        [alert show];
    }
    else{
        if(!_preview.image)
        {
            [[[UIAlertView alloc] initWithTitle:nil message:StringAlertTitlePleaseAddPicture delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil] show];
            return;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(setUserSelectedImage:)]) {
            
            CGSize c=CGSizeMake(320, 240);
            UIImage * newimage = [self image:_preview.image scaledToSize:c];
            
//            NSLog(@"Image size width = %f & height = %f",newimage.image.size.width, newimage.image.size.height );
            [self.delegate performSelector:@selector(setUserSelectedImage:) withObject:newimage];
        }
        
        if (canDismissView) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image1;
}
- (void)viewDidUnload {
    [self setMainimage:nil];
    [self setBtCamera:nil];
    [self setPreview:nil];
    [self setMask:nil];
    [self setScroll:nil];
    [super viewDidUnload];
}


- (IBAction)buttonRotateLeft:(id)sender {
    [_btRotateLeft setUserInteractionEnabled:NO];
    [_btRotateRight setUserInteractionEnabled:NO];
    self.mainimage.image=[self.mainimage.image imageRotatedByDegrees:-90];
    
    NSLog(@"hello");
    [self cropImage];
    
}

- (IBAction)buttonRotateRight:(id)sender {
    [_btRotateLeft setUserInteractionEnabled:NO];
    [_btRotateRight setUserInteractionEnabled:NO];
    _mainimage.image=[_mainimage.image imageRotatedByDegrees:90];
    [self cropImage];
    NSLog(@"hello");
}

- (IBAction)camera:(id)sender {
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Camera",@"Album", nil];
    [actionsheet showFromRect:[sender frame] inView:[sender superview] animated:YES];
}

- (IBAction)actionPortrait:(id)sender
{
    NSLog(@"yo");
    _mask.frame=CGRectMake(_mask.frame.origin.x, _mask.frame.origin.y, _mask.frame.size.width, 322);
    _mask.center = maskCenter;
    //_mask.center = _scroll.center;
    [self.btPortrait setSelected:YES];
    [self.btLandscape setSelected:NO];
    //
    [self cropImage];
    [_mask setNeedsLayout];
}

- (IBAction)actionLandscape:(id)sender {
    NSLog(@"yo12");
    //_mask.frame=CGRectMake(_mask.frame.origin.x, _mask.frame.origin.y, _mask.frame.size.width, 120);
    _mask.frame=CGRectMake(_mask.frame.origin.x, _mask.frame.origin.y, _mask.frame.size.width, 120);
    _mask.center = maskCenter;
    //_mask.center = _scroll.center;
    [self.btPortrait setSelected:NO];
    [self.btLandscape setSelected:YES];
    //
    [self cropImage];
    [_mask setNeedsLayout];
}

- (IBAction)Preview_Pressed:(id)sender {
    CTImagePreViewController * previewbt = [[CTImagePreViewController alloc]initWithNibName:@"CTImagePreViewController" bundle:nil];
    NSLog(@"preview %@",_preview.image);
    
    previewbt.previewimg=_preview.image;
    
    [self.navigationController pushViewController:previewbt animated:YES];
    
    
}

- (void)cropImage
{
    //   CGRect cropRect=[_mainImage convertRect:_mask.frame fromView:self.view];
    //
    //   float xScale=(_mainImage.image.size.width/_mainImage.frame.size.width)*_scroll.zoomScale;
    //   float yScale=(_mainImage.image.size.height/_mainImage.frame.size.height)*_scroll.zoomScale;
    //
    //   cropRect.origin.x=cropRect.origin.x*xScale;
    //   cropRect.size.width=cropRect.size.width*xScale;
    //   cropRect.origin.y=cropRect.origin.y*yScale;
    //   cropRect.size.height=cropRect.size.height*yScale;
    //
    //   _preview.image=[_mainImage.image crop:cropRect];
    _mask.layer.borderColor = [UIColor clearColor].CGColor;
    CGRect cropRect = _mask.frame;
    UIGraphicsBeginImageContext(self.view.frame.size);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *fullScreenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef croppedImage = CGImageCreateWithImageInRect(fullScreenshot.CGImage, cropRect);
    crop = [UIImage imageWithCGImage:croppedImage];
    
    CGImageRelease(croppedImage);
    //   _preview.image=[_mainImage.image crop:cropRect];
    _preview.image= crop;
    _mask.layer.borderColor = [UIColor blueColor].CGColor;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [_btRotateLeft setUserInteractionEnabled:YES];
        [_btRotateRight setUserInteractionEnabled:YES];
    });
}

#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    imagePicker.allowsEditing = YES;
    if(buttonIndex == 1)
    {
        /*
         _mask.hidden=NO;
         buttonRotateLeft.hidden=NO;
         buttonRotateRight.hidden=NO;
         _lblNoImage.hidden = TRUE;
         _lblNoImage1.hidden = TRUE;
         UIImage *image=[[UIImage imageNamed:@"Default_portrait"] scaleToSize:IMAGE_SIZE];
         _mainImage.image=image;
         _preview.image=image;
         _scroll.clipsToBounds=YES;
         _scroll.decelerationRate=UIScrollViewDecelerationRateFast;
         _scroll.maximumZoomScale=3;
         _scroll.minimumZoomScale=0.4;
         _scroll.zoomScale=1;
         
         _mainImage.frame=CGRectMake(0, 0, image.size.width, image.size.height);
         [_mainImage sizeToFit];
         _scroll.contentSize=CGSizeMake(image.size.width+640, image.size.height+640);
         CGFloat offsetX=(_scroll.bounds.size.width>_scroll.contentSize.width)?(_scroll.bounds.size.width-_scroll.contentSize.width)*.5:0;
         CGFloat offsetY=(_scroll.bounds.size.height>_scroll.contentSize.height)?(_scroll.bounds.size.height-_scroll.contentSize.height)*.5:0;
         _mainImage.center=CGPointMake(_scroll.contentSize.width*.5+offsetX, _scroll.contentSize.height*.5+offsetY);
         
         _scroll.contentOffset=CGPointMake(320, 320);
         
         return;
         */
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                [self presentViewController:imagePicker animated:YES completion:nil];
            }];
            
        }else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera not available." message:@"The camera is not available, please use Photo Library instead." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        }
    }
    else if(buttonIndex == 2)
    {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            
            // _popover=[[UIPopoverController alloc] initWithContentViewController:imagePicker];
            
            // [_popover presentPopoverFromRect:[self.btCamera frame] inView:[self.btCamera superview] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            controller.allowsEditing = YES;
            controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
            controller.delegate = self;
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self presentViewController:controller animated:YES completion:nil];
            });
        }];
        
        
    }
}

#pragma mark - Image Picker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _mask.hidden=NO;
    _btRotateLeft.hidden=NO;
    _btRotateRight.hidden=NO;
    self.lblNoImage.hidden = TRUE;
    self.lblNoImage.hidden = TRUE;
    image=[info objectForKey:UIImagePickerControllerOriginalImage];
    _mainimage.image=image;
    _preview.image=image;
    NSLog(@"hello Preview %@",_preview.image);
    _scroll.clipsToBounds=YES;
    _scroll.decelerationRate=UIScrollViewDecelerationRateFast;
    _scroll.maximumZoomScale=3;
    _scroll.minimumZoomScale=0.4;
    _scroll.zoomScale=1;
    imageSelected = YES;
    //   _mainImage.frame=CGRectMake(0, 0, image.size.width, image.size.height);
    //   [_mainImage sizeToFit];
    _scroll.contentSize=CGSizeMake(image.size.width, image.size.height);
    CGFloat offsetX=(_scroll.bounds.size.width>_scroll.contentSize.width)?(_scroll.bounds.size.width-_scroll.contentSize.width)*.5:0;
    CGFloat offsetY=(_scroll.bounds.size.height>_scroll.contentSize.height)?(_scroll.bounds.size.height-_scroll.contentSize.height)*.5:0;
    // _mainimage.center=CGPointMake(_scroll.contentSize.width*.5+offsetX, _scroll.contentSize.height*.5+offsetY);
    _mainimage.center = _mask.center;//CGPointMake(575, 556);
    _scroll.contentOffset=CGPointMake(5, 135);
    
    [_popover dismissPopoverAnimated:YES];
    //    if (!canDismissView)
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_popover dismissPopoverAnimated:true];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- Scroll View Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _mainimage;
}

- (void)scrollViewDidZoom:(UIScrollView *)aScrollView
{
    
    _scroll.contentSize=CGSizeMake(_mainimage.frame.size.width+550, _mainimage.frame.size.height+450);
    CGFloat offsetX=(_scroll.bounds.size.width>_scroll.contentSize.width)?(_scroll.bounds.size.width-_scroll.contentSize.width)*.5:0;
    CGFloat offsetY=(_scroll.bounds.size.height>_scroll.contentSize.height)?(_scroll.bounds.size.height-_scroll.contentSize.height)*.5:0;
    NSLog(@"float x = %f",_scroll.center.x + _scroll.contentOffset.x);
    NSLog(@"float y = %f",_scroll.center.y + _scroll.contentOffset.y);
    //_mainimage.center=CGPointMake(_scroll.contentSize.width*.1+offsetX, _scroll.contentSize.height*.1+offsetY);
    

    _mainimage.center = _mask.center;
    _scroll.contentOffset=CGPointMake(5, 135);
    
    //_mainimage.center= CGPointMake(_scroll.center.x + _scroll.contentOffset.x + 50,_scroll.center.y + _scroll.contentOffset.y);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:.01];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self cropImage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
