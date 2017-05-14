//
//  CTImagePreViewController.m
//  Community
//
//  Created by My Mac on 18/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import "CTImagePreViewController.h"
#import "ImageNamesFile.h"
@interface CTImagePreViewController ()

@end

@implementation CTImagePreViewController
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [self backButton];
    self.preview.image = self.previewimg;
    // Do any additional setup after loading the view from its nib.
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
