//
//  CTPhotoUploadViewController.m
//  Community
//
//  Created by practice on 03/04/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTPhotoUploadViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "NSDictionary+GetRestaurantDetails.h"
#import "CTLoginPopup.h"
@interface CTPhotoUploadViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation CTPhotoUploadViewController
#pragma Scope Methods
-(void)presentImagePickerControllerWithType:(UIImagePickerControllerSourceType)type {
    @try {
        UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
        imagePicker.delegate=self;
        NSArray *mediaTypes=[NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
        imagePicker.mediaTypes=mediaTypes;
        imagePicker.sourceType=type;
        if(type == UIImagePickerControllerSourceTypeCamera)
            imagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    @catch (NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Feature requires camera" message:@"Camera is not available to capture photo" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
  
    
}
#pragma Control Methods

-(IBAction)pickPhoto:(id)sender {
    [self presentImagePickerControllerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
}
-(IBAction)takePhoto:(id)sender {
    [self presentImagePickerControllerWithType:UIImagePickerControllerSourceTypeCamera];
}
-(IBAction)closeBtnTaped:(id)sender {
//    [self dismissViewControllerAnimated:FALSE completion:nil];
//    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
- (void)uploadImageWithCompletionBlock:(void (^)(id, NSError *))completion {
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[CTCommonMethods getChoosenServer]]];
    
    NSString *suffixURL = [NSString stringWithFormat:@"%@UID=%@",CT_createWNewPictureNewMetaData,[CTCommonMethods UID]];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:
                            [NSArray arrayWithObjects:@"UPloadTest",@"0,0",[self.restaurantDictionary serviceAccommodatorId],[self.restaurantDictionary serviceLocationId],@"PROPOSED",@"false", nil]
                                                       forKeys:
                            [NSArray arrayWithObjects:@"message",@"messageLocation",@"serviceAccommodatorId",@"serviceLocationId",@"status",@"isOfficial", nil]];
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 1.0f);
    NSMutableURLRequest *request=[httpClient multipartFormRequestWithMethod:@"POST" path:suffixURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                  {
                                      NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
                                      [formData appendPartWithFormData:data name:@"mediametadata" contentType:@"text/plain"];
                                      
                                      if(imageData)
                                      {
                                          [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpg"];
                                      }
                                  }];
    AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        //      NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        //      NSLog(@"UPLOAD => %f", ((float)(totalBytesWritten) / (float)(totalBytesExpectedToWrite)));
        float percentDone = ((float)(totalBytesWritten) / (float)(totalBytesExpectedToWrite));
        NSLog(@"percent done %f",percentDone);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(completion)
         {
             completion(responseObject, nil);
         }
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error  %@", error);
         if(completion)
         {
             completion(nil, error);
         }
     }];
    [httpClient enqueueHTTPRequestOperation:operation];
}
-(IBAction)uploadBtnTaped:(id)sender {
    if([CTCommonMethods isUIDStoredInDevice] == NO) {
        CTLoginPopup* loginView=[[CTLoginPopup alloc]init];
        loginView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        //    self.backgroundColor=[UIColor clearColor];
        [self.view addSubview:loginView];
    }else if(self.imageView.image == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No image selected" message:@"Please take photo with camera or pick from photo library" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    else {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    [self uploadImageWithCompletionBlock:^(id response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(!error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sucessfully Posted" message:@"The image has been sucessfully posted" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [self dismissViewControllerAnimated:FALSE completion:nil];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Request could not be completed" message:@"The server stoped responding, please try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    }];
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image=[info valueForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
