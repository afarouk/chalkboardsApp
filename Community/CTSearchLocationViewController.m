//
//  CTSearchLocationViewController.m
//  Community
//
//  Created by practice on 27/05/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTSearchLocationViewController.h"
#import "ImageNamesFile.h"
@interface CTSearchLocationViewController ()

@end

@implementation CTSearchLocationViewController
@synthesize  streetName,cityName,zipCode;
#pragma Scope Methods
-(UINavigationBar*)navBarForKeyboard {
    UINavigationBar *nav = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UINavigationItem *navItem = [[UINavigationItem alloc]initWithTitle:@""];
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideKeyboard:)];
    navItem.rightBarButtonItem = done;
    [nav setItems:[NSArray arrayWithObject:navItem]];
    return nav;
}
-(void)hideKeyboard:(id)sender {
    [self resignAllTextFieldResponders];
}
-(void)resignAllTextFieldResponders {
    [self.view endEditing:YES];
}
-(void)showMenu:(BOOL)animated withRootNavController:(UINavigationController*)_rootNavController{
    rootNavController = _rootNavController;
    CGFloat duration = 0.0f;
    if(animated)
        duration = 0.3f;
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.navigationController.view.frame;
        frame.origin.x = 0;
        self.navigationController.view.frame = frame;
        //
        CGRect rootFrame = _rootNavController.view.frame;
        rootFrame.origin.x = 130;
        _rootNavController.view.frame = rootFrame;
        
    }completion:^(BOOL finished) {
        //        [self.tableView reloadData];
    }];
}
-(void)hideMenu:(BOOL)animated withRootNavController:(UINavigationController *)_rootNavController{
    CGFloat duration = 0.0f;
    if(animated)
        duration = 0.3f;
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.navigationController.view.frame;
        frame.origin.x = -frame.size.width;
        self.navigationController.view.frame = frame;
        //
        CGRect rootFrame = _rootNavController.view.frame;
        rootFrame.origin.x = 0;
        _rootNavController.view.frame = rootFrame;
    } completion:^(BOOL finished) {
    }];
}
-(BOOL)isVisible {
    if(self.navigationController.view.frame.origin.x>=0)
        return YES;
    return NO;
}
#pragma Control Methods
-(void)didTapHideBtn:(id)sender {
    [self hideMenu:YES withRootNavController:rootNavController];
}
-(void)textFieldEditingChanged:(UITextField*)textField {
    switch (textField.tag) {
        case 0:
            streetName = textField.text;
            break;
        case 1:
            cityName = textField.text;
            break;
        case 2:
            zipCode = textField.text;
            break;
        default:
            break;
    }
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:CT_BackIcon];
    [self.hideBtn setImage:img forState:UIControlStateNormal];
    [self.hideBtn setFrame:CGRectMake(0,0, img.size.width, img.size.height)];
//    [self.hideBtn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;    
    self.tableView.backgroundColor = [[UIColor darkGrayColor]colorWithAlphaComponent:1.0f];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    // table footer view
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-45, 60)];
    view.backgroundColor = [UIColor clearColor];
    UIButton* submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setBackgroundColor:[UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1.0f]];
    submitBtn.frame = CGRectMake(0, 0, view.frame.size.width-30, 40);
    submitBtn.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
    [submitBtn setTitle:@"Go" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(searchBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:submitBtn];
    self.tableView.tableFooterView = view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)searchBtnTaped:(id)sender {
    self.callBack(self.streetName,self.cityName,self.zipCode);
}
#pragma mark - Table view data source
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
//    view.backgroundColor  = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0f];
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *img = [UIImage imageNamed:CT_BackIcon];
//    [btn setImage:img forState:UIControlStateNormal];
//    [btn setFrame:CGRectMake(self.view.frame.size.width-img.size.width-10, (40-img.size.height)/2, img.size.width, img.size.height)];
//    [btn addTarget:self action:@selector(didTapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:btn];
//    return view;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view.backgroundColor  = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0f];
    self.hideBtn.center = CGPointMake(self.view.frame.size.width-(self.hideBtn.frame.size.width/2)-10, self.hideBtn.imageView.image.size.height/2);
    [view addSubview:self.hideBtn];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return  60;
//}
//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
//    view.backgroundColor = [UIColor clearColor];
//    UIButton* submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    submitBtn.frame = CGRectMake(0, 0, view.frame.size.width, 40);
//    submitBtn.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
//    [submitBtn setTitle:@"Go" forState:UIControlStateNormal];
//    [submitBtn addTarget:self action:@selector(searchBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:submitBtn];
//    return view;
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    // Configure the cell...
    cell.accessoryView = nil;
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 44)];
    textField.backgroundColor = [UIColor clearColor];
    textField.tag = indexPath.row;
    textField.inputAccessoryView = [self navBarForKeyboard];
    textField.textColor = [UIColor whiteColor];
    [textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [textField setFont:[UIFont systemFontOfSize:14.0f]];
    UIColor *color;
    if([textField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        color = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        
    }
    cell.accessoryView = textField;
    switch (indexPath.row) {
        case 0:
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Street" attributes:@{NSForegroundColorAttributeName: color}];
            if(streetName.length>0)
                textField.text = streetName;
            break;
        case 1:
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"City" attributes:@{NSForegroundColorAttributeName: color}];
            if(cityName.length>0)
                textField.text = cityName;
            break;
        case 2:
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Zip" attributes:@{NSForegroundColorAttributeName: color}];
            textField.keyboardType = UIKeyboardTypeNumberPad;
            if(zipCode.length>0)
                textField.text = zipCode;
            break;
        default:
            break;
    }
    // background color
    cell.contentView.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0f];
    cell.backgroundColor = cell.contentView.backgroundColor;
    // seperator
    UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-1, self.tableView.frame.size.width, 1)];
    separator.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:0.10f];
    [cell.contentView addSubview:separator];
    // selected background
    UIView *selectedBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    selectedBackground.backgroundColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1.0f];
    cell.selectedBackgroundView = selectedBackground;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
