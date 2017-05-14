//
//  CTFilterViewController.m
//  Community
//
//  Created by practice on 14/04/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTFilterViewController.h"
#import "CTDataModel_FilterViewController.h"
#import "MBProgressHUD.h"
#import "CTParentViewController.h"
@interface CTFilterViewController ()

@end

@implementation CTFilterViewController

@synthesize searchResult;

-(void)showFilterPicker:(BOOL)animated{
    CGFloat duration = 0.0f;
    if(animated)
        duration = 0.3f;
    [SelectButton setTitle:@"Select City" forState:UIControlStateNormal];
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.navigationController.view.frame;
        frame.origin.y = 0;
        self.navigationController.view.frame = frame;
        
    }completion:^(BOOL finished) {
        //        if([CTDataModel_FilterViewController sharedInstance].domains.count == 0) {
        //        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        hud.mode=MBProgressHUDModeIndeterminate;
        //        [[CTDataModel_FilterViewController sharedInstance]getDomainsWithCompletionBlock:^(NSArray *array, NSError *error) {
        //            [self.pickerView performSelectorOnMainThread:@selector(reloadAllComponents) withObject:nil waitUntilDone:FALSE];
        //            if(array && array.count>0) {
        //                NSString *domain = [array enumText:0];
        //                [[CTDataModel_FilterViewController sharedInstance]getFilterOptionsForDomain:domain withCompletionBlock:^(NSArray *array, NSError *error) {
        //                    dispatch_async(dispatch_get_main_queue(), ^{
        //                        [self.pickerView performSelectorOnMainThread:@selector(reloadAllComponents) withObject:nil waitUntilDone:FALSE];
        //                        [MBProgressHUD hideHUDForView:self.view animated:FALSE];
        //                    });
        //                }];
        //            }else {
        //                dispatch_async(dispatch_get_main_queue(), ^{
        //                    [MBProgressHUD hideHUDForView:self.view animated:FALSE];
        //                });
        //            }
        //        }];
        //        }else {
        //
        //            [[CTDataModel_FilterViewController sharedInstance]getFilterOptionsForDomain:[[CTDataModel_FilterViewController sharedInstance].domains enumText:[self.pickerView selectedRowInComponent:0]] withCompletionBlock:^(NSArray *array, NSError *error) {
        //                dispatch_async(dispatch_get_main_queue(), ^{
        //                    [self.pickerView performSelectorOnMainThread:@selector(reloadAllComponents) withObject:nil waitUntilDone:FALSE];
        //                    [MBProgressHUD hideHUDForView:self.view animated:FALSE];
        //                });
        //            }];
        //        }
        //        if([CTDataModel_FilterViewController sharedInstance].filterOptions.count == 0) {
        
        // V: filter selection
        CTParentViewController *parent = (CTParentViewController*)self.navigationController.parentViewController;
        btnCancel.hidden = parent.rootViewController.isFirstTimeLoaded;
        
        if (searchResult) {
            [self.pickerView performSelectorOnMainThread:@selector(reloadAllComponents) withObject:nil waitUntilDone:YES];
            [self.pickerView selectRow:0 inComponent:0 animated:YES];
            // item.customView.hidden = YES;
            return;
        }
        
        item.customView.hidden = NO;
        
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode=MBProgressHUDModeIndeterminate;
        [[CTDataModel_FilterViewController sharedInstance]getDomainAndFilterOptions:^(NSArray *array, NSError *error) {
            NSLog(@"array %@",array);
            [self.pickerView performSelectorOnMainThread:@selector(reloadAllComponents) withObject:nil waitUntilDone:FALSE];
            if(array && array.count>0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SelectButton setTitle:@"Select Catagory" forState:UIControlStateNormal];
                    SelectButton.titleLabel.text = @"Select Category";
                    [self.pickerView performSelectorOnMainThread:@selector(reloadAllComponents) withObject:nil waitUntilDone:FALSE];
                    [self.pickerView selectRow:0 inComponent:0 animated:YES];
                    [MBProgressHUD hideHUDForView:self.view animated:FALSE];
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([CTDataModel_FilterViewController sharedInstance].filterOptions.count>0)
                        [self.pickerView selectRow:0 inComponent:0 animated:NO];
                    [MBProgressHUD hideHUDForView:self.view animated:FALSE];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Community" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];
                });
            }
        }];
        //        }else {
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                [self.pickerView performSelectorOnMainThread:@selector(reloadAllComponents) withObject:nil waitUntilDone:FALSE];
        //                [MBProgressHUD hideHUDForView:self.view animated:FALSE];
        //            });
        //        }
        //
    }];
    
}
-(void)hideFilterPicker:(BOOL)animated {
    CGFloat duration = 0.0f;
    if(animated)
        duration = 0.3f;
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.navigationController.view.frame;
        frame.origin.y = frame.size.height;
        self.navigationController.view.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

-(BOOL)isVisible {
    if(self.navigationController.view.frame.origin.y == 0)
        return YES;
    return NO;
}

#pragma Control Methods
-(IBAction)didTapCancelBtn:(id)sender {
    [self hideFilterPicker:YES];
}
-(IBAction)didTapSubmitBtn:(id)sender {
    //    NSUInteger selectedDomainRow = [self.pickerView selectedRowInComponent:0];
    //    NSUInteger selectedFilterRow = [self.pickerView selectedRowInComponent:1];
    
    NSLog(@"------------->");
    if ([CTCommonMethods sharedInstance].SPLASHIMAGE == NO)
    {
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"OpenTile" object:nil];
    }
    
    [CTCommonMethods sharedInstance].SPLASHIMAGE = YES;
    
    // V: filter selection
    CTParentViewController *parent = (CTParentViewController*)self.navigationController.parentViewController;
    if(parent.rootViewController.isFirstTimeLoaded){
        parent.rootViewController.isFirstTimeLoaded = NO;
        [parent.rootViewController showOrHideInfoButton];
        [parent.rootViewController.locationManager stopUpdatingLocation];
    }
   
    [CTCommonMethods sharedInstance].SelectCityFirstTime = [searchResult objectAtIndex:[self.pickerView selectedRowInComponent:0]];
//     NSLog(@"Check it = %@",[CTCommonMethods sharedInstance].SelectCityFirstTime);
    if (searchResult) {
        if ([searchResult count] > 0) {
            NSLog(@"i'm some");
            [[NSNotificationCenter defaultCenter] postNotificationName:CT_Observers_SearchLocation object:self userInfo:[searchResult objectAtIndex:[self.pickerView selectedRowInComponent:0]]];
        }
        else {
            NSLog(@"i'm some not");
            [[NSNotificationCenter defaultCenter] postNotificationName:CT_Observers_SearchLocation object:self];
        }
        [self hideFilterPicker:YES];
        return;
    }
    
    NSUInteger selectedRow = [self.pickerView selectedRowInComponent:0];
    NSString *filter = @"UNKNOWN";
    //    if(selectedRow <[CTDataModel_FilterViewController sharedInstance].filterOptions.count)
    filter = [[CTDataModel_FilterViewController sharedInstance].filterOptions category:selectedRow];
    //    NSDictionary *selectedCategoryName=[NSDictionary dictionaryWithObjectsAndKeys:[[CTDataModel_FilterViewController sharedInstance].domains enumText:selectedDomainRow],@"domain",filter,@"category", nil];
    NSDictionary *selectedCategoryName=[NSDictionary dictionaryWithObjectsAndKeys:[[CTDataModel_FilterViewController sharedInstance].filterOptions domain:selectedRow],@"domain",filter,@"category", nil];
    
    NSLog(@"DictisOk %@",selectedCategoryName);
    [[NSNotificationCenter defaultCenter]postNotificationName:CT_Observers_FilterCategory object:self userInfo:selectedCategoryName];
    [self hideFilterPicker:YES];
}

#pragma Scope Methods

-(void)didTapOnView:(UITapGestureRecognizer*)tap {
    // V: filter selection
    CTParentViewController *parent = (CTParentViewController*)self.navigationController.parentViewController;
    if(parent.rootViewController.isFirstTimeLoaded)
        return;
    
    [self hideFilterPicker:YES];
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
    // tap gesture
    if (searchResult) {
        // item.customView.hidden = YES;
    }
    goButton.customView.layer.cornerRadius = 5.0f;
    goButton.customView.clipsToBounds = YES;
    goButton.customView.layer.borderColor = [UIColor whiteColor].CGColor;
    goButton.customView.layer.borderWidth = 2.0f;
    
//    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,250,320,230)];//to change the height
//    _pickerView.delegate =self;
//    _pickerView.dataSource =self;
//    _pickerView.showsSelectionIndicator = YES;
//    [self.view addSubview:_pickerView];
    
    self.tapableView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width, [UIScreen mainScreen].applicationFrame.size.height-self.pickerView.frame.size.height-24)];
    self.tapableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tapableView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOnView:)];
    tap.delegate = self;
    [self.tapableView addGestureRecognizer:tap];
    
    
    [[CTCommonMethods sharedInstance]setFontFamily:@"Lato-Black" forView:self.view andSubViews:YES];
    
    
    //    [btnCancel addTarget:self action:@selector(didTapCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma Instance methods



#pragma UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    //    return 2;
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    //    if(component == 0)
    //        return [CTDataModel_FilterViewController sharedInstance].domains.count;
    //    else
    //        return [CTDataModel_FilterViewController sharedInstance].filterOptions.count;
    
    NSInteger count = 0;
    if (searchResult)
        count = [searchResult count];
    else
        count = [CTDataModel_FilterViewController sharedInstance].filterOptions.count;
    
    return count;
}
#pragma UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //    if(component == 0)
    //        return [[CTDataModel_FilterViewController sharedInstance].domains displayText:row];
    //    else
    //        return [[CTDataModel_FilterViewController sharedInstance].filterOptions displayText:row];
    
    NSString * strValue = @"";
    if (searchResult) {
        if([searchResult count] > 0)
            strValue = [searchResult displayText:row];
    }
    else {
        strValue = [[CTDataModel_FilterViewController sharedInstance].filterOptions displayText:row];
    }
    
    
    return strValue;
}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    NSString *title;
//    if(component == 0)
//        title = [[CTDataModel_FilterViewController sharedInstance].domains displayText:row];
//    else
//        title = [[CTDataModel_FilterViewController sharedInstance].filterOptions displayText:row];
//    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor], nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, nil]]];
//
//    return attString;
//
//}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    
    //WithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 60)];
    
    //    if(component == 0)
    //        label.text = [[CTDataModel_FilterViewController sharedInstance].domains displayText:row];
    //    else
    //        label.text = [[CTDataModel_FilterViewController sharedInstance].filterOptions displayText:row];
    
    if (searchResult) {
        if([searchResult count] > 0)
            label.text = [searchResult displayText:row];
    }
    else{
        label.text = [[CTDataModel_FilterViewController sharedInstance].filterOptions displayText:row];
    }
    
    return label;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //    if(component == 0) {
    //        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //        [[CTDataModel_FilterViewController sharedInstance]getFilterOptionsForDomain:[[CTDataModel_FilterViewController sharedInstance].domains enumText:row] withCompletionBlock:^(NSArray *array, NSError *error) {
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                [self.pickerView reloadComponent:1];
    //                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //            });
    //        }];
    //    }
}
#pragma UIGestureRecognizerDelegate

@end
