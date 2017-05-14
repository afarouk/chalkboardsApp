//
//  CTOutOfNetworkViewController.m
//  Community
//
//  Created by dinesh on 12/02/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTOutOfNetworkViewController.h"
#import "NSDictionary+GetRestaurantDetails.h"
#import "CTNavigationBar.h"
#import "CTRestaurantMenuView.h"
#import "CTOutOfNetworkMenuView.h"
#import "ImageNamesFile.h"

@interface CTOutOfNetworkViewController ()
@property (nonatomic,strong)CTNavigationBar *ctNavigationBar;
@property (nonatomic,retain)CTRestaurantMenuView *restaurantMenuView;
@property (weak, nonatomic) IBOutlet UILabel *telephoneLbl;
@property (weak, nonatomic) IBOutlet UITextView *restaurantAddressLbl;
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLbl;
@property (nonatomic,retain)CTOutOfNetworkMenuView *outOfNetworkMenuView;
@end

@implementation CTOutOfNetworkViewController

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
	// Do any additional setup after loading the view.
    //self.view.backgroundColor=[UIColor lightGrayColor];
    [self setCustomNavigationBar];
    [self checkiOS7];
    NSLog(@"DICT %@",self.restaurantDetailsDict);
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark create custom navigation bar
-(void)setCustomNavigationBar{
    self.ctNavigationBar=[[CTNavigationBar alloc]init];
    self.ctNavigationBar.navigationController=self.navigationController;
    self.ctNavigationBar.sliderView=self.view;
//    self.ctNavigationBar.isMainMenuSlideOut=YES;
//    self.ctNavigationBar.isFavoriteList=YES;
    self.navigationItem.leftBarButtonItem=[self setBackButton];
    //self.navigationItem.titleView=[self.ctNavigationBar setRestaurantLogo:[self.restaurantDetailsDict restaurantNameIcon]];
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:[self.ctNavigationBar setMenuButton],[self.ctNavigationBar setShareButton], nil];
    [self loadNavTitleLogo];
    // self.navigationItem.rightBarButtonItem=[self.ctNavigationBar setMenuButton];
    [self performSelector:@selector(showMainMenuView) withObject:self afterDelay:0.5];
}
-(void)loadNavTitleLogo{
    
    dispatch_queue_t backgroundQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(backgroundQueue, ^{
        NSData *data=[self.ctNavigationBar logoURL:[self.restaurantDetailsDict objectForKey:@"iconURL"]];
        dispatch_queue_t mainQueue=dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            UIImageView *logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 35)];
            UIImage *logo=[UIImage imageWithData:data];
            logoImageView.image=logo;
            self.navigationItem.titleView=logoImageView;
        });
    });
}
#pragma mark restaurantMenuView
-(UIView *)setRestaurantMenuView{
    
    CGRect slideFrame=CGRectMake(-115 ,0,115, self.view.frame.size.height);
    self.outOfNetworkMenuView=[[CTOutOfNetworkMenuView alloc]initWithFrame:slideFrame];
   // self.outOfNetworkMenuView.viewController=self;
    //self.restaurantMenuView.navigationController=self.navigationController;
    return self.outOfNetworkMenuView;
    
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
    [self.outOfNetworkMenuView removeFromSuperview];
    [self.ctNavigationBar.slideMainMenu removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark Menu
-(void)showMainMenuView{
    [self.view addSubview:[self.ctNavigationBar favoriteListView]];
    [self.view addSubview:[self.ctNavigationBar sliderMainMenu]];
    [self.view addSubview:[self setRestaurantMenuView]];
    self.ctNavigationBar.slideMainMenu.isMessageControllerIsOpen=YES;
}
#pragma mark iOS7 check
-(void)checkiOS7{
    
    if(isIOS7){
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
}
#pragma mark loadData
-(void)loadData{
    
    NSDictionary *address=[self.restaurantDetailsDict address];
    NSDictionary *contact=[self.restaurantDetailsDict contact];
    self.restaurantNameLbl.text=[self.restaurantDetailsDict restaurantName];
    NSString *restaurantAddress=[NSString stringWithFormat:@"Address: %@,%@,%@,%@,%@",[address street1],[address street2],[address city],[address country],[address postalCode]];
    NSString *phone=[NSString stringWithFormat:@"Tel: %@",[contact telephone]];
    self.restaurantAddressLbl.text=restaurantAddress;
    self.telephoneLbl.text=phone;
    

}
@end
