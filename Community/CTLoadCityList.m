//
//  CTLoadCityList.m
//  Community
//
//  Created by ADMIN on 01/06/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import "CTLoadCityList.h"
#import "CTDataModel_FilterViewController.h"
@interface CTLoadCityList ()

@end

@implementation CTLoadCityList

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"chec it. -- > %@",self.CityResult);
    
    CityArray = [[NSMutableArray alloc]init];
    
    CityArray = [_CityResult valueForKey:@"displayText"];
    //NSLog(@"CITYARRAT %@",CityArray);
    
    self.CityTable.alpha = 0.6;
    
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CityArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIDentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIDentifier];
        cell.backgroundColor = [UIColor blackColor];
    }
    
    else
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIDentifier];
        cell.backgroundColor = [UIColor blackColor];
    }
    cell.textLabel.font=[UIFont fontWithName:@"Lato-Black" size:17.0];
    
    [cell.accessoryView removeFromSuperview];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = CityArray[indexPath.row];
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.textColor = [UIColor whiteColor];
    //NSLog(@"hello array %@",cell.textLabel.text);
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([CTCommonMethods sharedInstance].SearchCitySelector) {
        if ([[CTCommonMethods sharedInstance].SearchCitySelector count] > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:CT_Observers_SearchLocation object:self userInfo:[[CTCommonMethods sharedInstance].SearchCitySelector objectAtIndex:indexPath.row]];
            NSLog(@"indexpath %ld",(long)indexPath.row);
            [self.view removeFromSuperview];
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:CT_Observers_SearchLocation object:self];
            NSLog(@"indexpathnw %ld",(long)indexPath.row);
        }
        //[self hideFilterPicker:YES];
        return;
    }
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
