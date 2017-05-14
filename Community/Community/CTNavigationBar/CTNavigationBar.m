//
//  CTNavigationBar.m
//  Community
//
//  Created by dinesh on 19/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTNavigationBar.h"
#import "ImageNamesFile.h"
#import "CTLoginPopup.h"
#import "CTAppDelegate.h"
@implementation CTNavigationBar
@synthesize navigationController;
@synthesize slideRestaurantListView;
@synthesize sliderView;
@synthesize filterView;
@synthesize filterButton;
@synthesize menuButton;
@synthesize listButton;
//@synthesize isRestaurantSlideout;
@synthesize slideMainMenu;
//@synthesize isMainMenuSlideOut;
//@synthesize isFilterPopup;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        CFBridgingRetain(self);
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetRestaurantSlideOut) name:@"ResetRestaurantSlide" object:nil];
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetMainMenuSlideOut) name:@"ResetMainMenuSlide" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetFilterPopup) name:@"ResetFilterPopup" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetFavoriteList) name:@"ResetFavoriteList" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showFavoriteList) name:@"showfavoriteView" object:nil];
        selectedBarButton = SelectedToolBarButton_None;
    }
    return self;
}

#pragma mark set filter button
-(UIBarButtonItem *)setFilterButton{
    
    self.filterButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.filterButton setFrame:CGRectMake(0, 0, 25, 25)];
    [self.filterButton setImage:[UIImage imageNamed:CT_FilterIcon] forState:UIControlStateNormal];
    [self.filterButton addTarget:self action:@selector(filterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithCustomView:filterButton];
    return leftBarbutton;
    
}
#pragma mark set menu buuton
-(UIBarButtonItem *)setMenuButton{
    
    self.menuButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.menuButton setFrame:CGRectMake(0, 0, 25, 25)];
    [self.menuButton setImage:[UIImage imageNamed:CT_MenuIcon] forState:UIControlStateNormal];
    [self.menuButton addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc]initWithCustomView:menuButton];
    return  rightBarButton;
}
#pragma mark set back button
-(UIBarButtonItem *)setBackButton{
    self.backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[self.backButton setFrame:CGRectMake(0, 0, 25, 25)];
    [self.backButton setFrame:CGRectMake(0, 0, 60, 44)];
    [self.backButton setImage:[UIImage imageNamed:CT_BackIcon] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithCustomView:self.backButton];
    return leftBarbutton;

}
#pragma mark set list button
-(UIBarButtonItem *)setListButton{
    
    self.listButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.listButton setFrame:CGRectMake(0, 0, 25, 25)];
    [self.listButton setImage:[UIImage imageNamed:CT_ListIcon] forState:UIControlStateNormal];
    [self.listButton addTarget:self action:@selector(listButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithCustomView:self.listButton];
    return leftBarbutton;
   
}
#pragma mark space button
-(UIBarButtonItem *)spaceButton{
    UIButton *spaceButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [spaceButton setFrame:CGRectMake(0, 0, 32, 32)];
    //[self.shareButton setImage:[UIImage imageNamed:CT_ShareIcon] forState:UIControlStateNormal];
   // [self.shareButton addTarget:self action:@selector(openEmail) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithCustomView:spaceButton];
    return leftBarbutton;
}
#pragma mark share button
-(UIBarButtonItem *)setShareButton{
    self.shareButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareButton setFrame:CGRectMake(0, 0, 32, 32)];
    [self.shareButton setImage:[UIImage imageNamed:CT_ShareIcon] forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(openEmail) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithCustomView:self.shareButton];
    return leftBarbutton;

}
#pragma mark favorite button
-(UIBarButtonItem *)setFavotiteButton{
    self.favoriteButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.favoriteButton setFrame:CGRectMake(50, 0, 25, 25)];
    [self.favoriteButton setImage:[UIImage imageNamed:CT_FavoriteIcon] forState:UIControlStateNormal];
    [self.favoriteButton addTarget:self action:@selector(favoriteListButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarbutton=[[UIBarButtonItem alloc]initWithCustomView:self.favoriteButton];
    return leftBarbutton;

}
#pragma mark set restaurantLogo
-(UIImageView *)setRestaurantLogo:(NSString *)imageString{
    UIImageView *logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 35)];
    UIImage *logo=[UIImage imageWithData:[NSData dataFromBase64String:imageString]];
    logoImageView.image=logo;
    return logoImageView;
}
-(NSData *)logoURL:(NSString *)urlString{
    
    NSURL *url=[NSURL URLWithString:urlString];
    NSData *data=[NSData dataWithContentsOfURL:url];
    return data;

}
#pragma mark create restaurant slider menu
-(UIView *)restuarantListSliderMenu{
    //[self.slideMainMenu removeFromSuperview];
      CGRect slideFrame=CGRectMake(-275 ,0,[UIScreen mainScreen].applicationFrame.size.width, self.sliderView.frame.size.height);
    self.slideRestaurantListView=[[CTSlideRestaurantListView alloc]initWithFrame:slideFrame];
    self.slideRestaurantListView.delegate = self;
    self.slideRestaurantListView.navigationController=self.navigationController;
    return self.slideRestaurantListView;
}
#pragma mark create slider menu
-(UIView *)sliderMainMenu{
    //[self.slideRestaurantListView removeFromSuperview];
    CGRect slideFrame=CGRectMake(-275 ,0,[UIScreen mainScreen].applicationFrame.size.width, self.sliderView.frame.size.height);
    self.slideMainMenu=[[CTSliderMenuView alloc]initWithFrame:slideFrame];
    self.slideMainMenu.delegate = self;
    self.slideMainMenu.navigationController=self.navigationController;
    NSLog(self.isMessageControllerIsOpen ? @"YES":@"NO");
    self.slideMainMenu.isMessageControllerIsOpen=self.isMessageControllerIsOpen;
    return self.slideMainMenu;
}
#pragma mark create filter menu
-(UIView *)filterPopupMenu{
    CGRect filterFrame=CGRectMake(-275 ,0,[UIScreen mainScreen].applicationFrame.size.width, self.sliderView.frame.size.height);
    self.filterView=[[CTFilterView alloc]initWithFrame:filterFrame];
    self.filterView.delegate = self;
    return self.filterView;
}
#pragma mark favorite list view
-(UIView *)favoriteListView{
    CGRect filterFrame=CGRectMake(-275 ,0,[UIScreen mainScreen].applicationFrame.size.width, self.sliderView.frame.size.height);
    self.favoriteView=[[CTFavoriteView alloc]initWithFrame:filterFrame];
    self.favoriteView.delegate = self;
    return self.favoriteView;
}
-(void)showFavoriteList{
    [self favoriteViewSlideOutAnimation];
    
}
#pragma mark Reset Slideout animation
-(void)resetRestaurantSlideOut{
  
    selectedBarButton = SelectedToolBarButton_None;
    [self userInteractionForFilterButton:YES forMenuButton:YES forListButton:YES forFavoriteList:YES];
}
-(void)resetMainMenuSlideOut{
    
    selectedBarButton = SelectedToolBarButton_None;
     [self userInteractionForFilterButton:YES forMenuButton:YES forListButton:YES forFavoriteList:YES];
}
-(void)resetFilterPopup{
    selectedBarButton = SelectedToolBarButton_None;
     [self userInteractionForFilterButton:YES forMenuButton:YES forListButton:YES forFavoriteList:YES];
}
-(void)resetFavoriteList{
    selectedBarButton = SelectedToolBarButton_None;
    [self userInteractionForFilterButton:YES forMenuButton:YES forListButton:YES forFavoriteList:YES];
}
#pragma mark navigation bar color
-(UIColor *)navColor{
    
    UIColor *color=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44];
    return color;
}
#pragma mark Filter button Action
-(void)filterButtonAction:(id)sender{
    if(selectedBarButton == SelectedToolBarButton_None){
        selectedBarButton = SelectedToolBarButton_Filter;
        [self userInteractionForFilterButton:YES forMenuButton:NO forListButton:NO forFavoriteList:NO];
        [UIView animateWithDuration:0.3f animations:^{
            self.filterView.frame=CGRectMake(0, 0, 275, self.filterView.frame.size.height);
            [self.filterView.superview bringSubviewToFront:self.filterView];

        } completion:^(BOOL finished) {
            [self.filterView enableHitDetectionArea];

        }];

    }
    else{
        if(selectedBarButton == SelectedToolBarButton_Filter) {
            selectedBarButton = SelectedToolBarButton_None;
        [self userInteractionForFilterButton:YES forMenuButton:YES forListButton:YES forFavoriteList:YES];
            [UIView animateWithDuration:0.3f animations:^{
                self.filterView.frame=CGRectMake(0, 0, -275, self.filterView.frame.size.height);

            } completion:^(BOOL finished) {
                [self.filterView disableHitDetectionArea];

            }];


        }
    }

}
#pragma mark Menu Button Action
-(void)menuButtonAction:(id)sender{
    if(selectedBarButton == SelectedToolBarButton_None){
        NSLog(@"slider menu %@",self.slideMainMenu);
        selectedBarButton = SelectedToolBarButton_ListMenu;
         [self userInteractionForFilterButton:NO forMenuButton:YES forListButton:NO forFavoriteList:NO];
        [self bringSubviewToFront:self.slideMainMenu];
        [UIView animateWithDuration:0.3f animations:^{
            self.slideMainMenu.frame=CGRectMake(0, 0, 275, [[UIScreen mainScreen]applicationFrame].size.height);

        } completion:^(BOOL finished) {
            [self.slideMainMenu enableHitDetectionArea];

        }];

    }
    else{
        if(selectedBarButton == SelectedToolBarButton_ListMenu) {
            selectedBarButton = SelectedToolBarButton_None;
        [self userInteractionForFilterButton:YES forMenuButton:YES forListButton:YES forFavoriteList:YES];
            [UIView animateWithDuration:0.3f animations:^{
                self.slideMainMenu.frame=CGRectMake(0, 0, -275, self.filterView.frame.size.height);

            } completion:^(BOOL finished) {
                [self.slideMainMenu disableHitDetectionArea];

            }];

    }
    }

}
#pragma mark List Button Action
-(void)listButtonAction:(id)sender{
    if(selectedBarButton == SelectedToolBarButton_None){
        selectedBarButton = SelectedToolBarButton_RestaurantList;
        [self userInteractionForFilterButton:NO forMenuButton:NO forListButton:YES forFavoriteList:NO];
        [UIView animateWithDuration:0.3f animations:^{
            self.slideRestaurantListView.frame=CGRectMake(0, 0, 275, self.filterView.frame.size.height);;
            [self.slideRestaurantListView.restaurantListTableView reloadData];
        } completion:^(BOOL finished) {
            [self.slideRestaurantListView enableHitDetectionArea];

        }];
    }
    else{
        if(selectedBarButton == SelectedToolBarButton_RestaurantList) {
            selectedBarButton = SelectedToolBarButton_None;
        [self userInteractionForFilterButton:YES forMenuButton:YES forListButton:YES forFavoriteList:YES];
            [UIView animateWithDuration:0.3f animations:^{
                self.slideRestaurantListView.frame=CGRectMake(0, 0, -275, self.filterView.frame.size.height);

            } completion:^(BOOL finished) {
                [self.slideRestaurantListView disableHitDetectionArea];

            }];

        }
    }
}
#pragma mark favorite button action
-(void)favoriteListButtonAction:(id)sender{
 if([CTCommonMethods isUIDStoredInDevice]){
    if(self.isFavoriteFromHome){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"retriveFav" object:self];
            [self addFavorite];
        }
    else{
            [self favoriteViewSlideOutAnimation];
        }
 }
 else{
     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CT_AlertTitle message:@"Please login to access this feature" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
//        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Please login to access this feature"];
     [alert show];
 }
}
-(void)favoriteViewSlideOutAnimation{
    if(selectedBarButton == SelectedToolBarButton_None){
        selectedBarButton = SelectedToolBarButton_Favorites;
        [self userInteractionForFilterButton:NO forMenuButton:NO forListButton:NO forFavoriteList:YES];
        [UIView animateWithDuration:0.3f animations:^{
            self.favoriteView.frame=CGRectMake(0, 0, 275, self.filterView.frame.size.height);

        } completion:^(BOOL finished) {
            [self.favoriteView enableHitDetectionArea];

        }];

    }
    else{
        if(selectedBarButton == SelectedToolBarButton_Favorites) {
            selectedBarButton = SelectedToolBarButton_None;
        [self userInteractionForFilterButton:YES forMenuButton:YES forListButton:YES forFavoriteList:YES];
            [UIView animateWithDuration:0.3f animations:^{
                self.favoriteView.frame=CGRectMake(0, 0, -275, self.filterView.frame.size.height);

            } completion:^(BOOL finished) {
                [self.favoriteView disableHitDetectionArea];

            }];

        }
    }

}
#pragma mark back button Action
-(void)backButtonAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)userInteractionForFilterButton:(BOOL)isFilter forMenuButton:(BOOL)isMenu forListButton:(BOOL)isList forFavoriteList:(BOOL)isFav{
    
    self.filterButton.userInteractionEnabled=isFilter;
    self.menuButton.userInteractionEnabled=isMenu;
    self.listButton.userInteractionEnabled=isList;
    self.favoriteView.userInteractionEnabled=isFav;
}
#pragma mark openEmail
-(void)openEmail{
    
    if([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *controller=[[MFMailComposeViewController alloc]init];
        controller.mailComposeDelegate=self;
        [self.navigationController presentModalViewController:controller animated:YES];
    }
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissModalViewControllerAnimated:YES];
}
-(void)addFavorite{
    
    NSString *UID=[CTCommonMethods UID];
    NSString *urlKey=[[NSUserDefaults standardUserDefaults]objectForKey:CT_URLKey];
    NSString *params=[NSString stringWithFormat:@"UID=%@&urlKey=%@",UID,urlKey];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_FavoriteByURL,params];
    NSLog(@"url String %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSData dataWithBytes:[urlString UTF8String] length:strlen([urlString UTF8String])]];
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"SUCESS %@",(NSDictionary *)JSON);
        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Favorite restaurant is added successfully"];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if(error) {
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:error.localizedRecoverySuggestion];
        }else {
            NSLog(@"FAILED");
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
    [operation start];

}
#pragma CTCTSlideRestaurantListViewDelegate
-(void)didTapOnSlideRestaurantListView {
    // hide the list menu.
    [self userInteractionForFilterButton:YES forMenuButton:YES forListButton:YES forFavoriteList:YES];
    [self listButtonAction:nil];
    selectedBarButton = SelectedToolBarButton_None;
}
#pragma CTSliderMenuViewDelegate
-(void)didTapOnSlideMenuView {
    [self userInteractionForFilterButton:YES forMenuButton:YES forListButton:YES forFavoriteList:YES];
    [self menuButtonAction:nil];
    selectedBarButton = SelectedToolBarButton_None;

}

#pragma CTFavoriteViewDelegate
-(void)didTapOnFavoriteView {
    [self userInteractionForFilterButton:YES forMenuButton:YES forListButton:YES forFavoriteList:YES];
    [self favoriteListButtonAction:nil];
    selectedBarButton = SelectedToolBarButton_None;
}
#pragma CTFilterViewDelegate
-(void)didTapOnFilterView {
    [self userInteractionForFilterButton:YES forMenuButton:YES forListButton:YES forFavoriteList:YES];
    [self filterButtonAction:nil];
    selectedBarButton = SelectedToolBarButton_None;
}
#pragma UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex != alertView.cancelButtonIndex) {
        CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication]delegate];
        CTLoginPopup *loginPopup = [[CTLoginPopup alloc]init];
        [appDelegate.window.rootViewController.view addSubview:loginPopup];
    }
}
@end
