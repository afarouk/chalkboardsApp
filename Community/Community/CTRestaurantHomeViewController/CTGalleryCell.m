//
//  CTGalleryCell.m
//  Community
//
//  Created by dinesh on 30/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTGalleryCell.h"

@implementation CTGalleryCell
#define DEFAULTWEBVIEWFONTSIZE 18
#define updatedFontSize 9
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
//    self = [[[NSBundle mainBundle]loadNibNamed:@"CTGalleryCell" owner:self options:nil] objectAtIndex:0];
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//-(void)webViewDidFinishLoad:(UIWebView *)aWebView {
//    
//    CGRect frame = aWebView.frame;
//	frame.size.height = 1;
//	aWebView.frame = frame;
//    // Asks the view to calculate and return the size that best fits its subviews.
//	CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
//	frame.size = fittingSize;
//	aWebView.frame = frame;
//	[self.tableView beginUpdates];
//	[self.tableView  endUpdates];
//    
//}
@end
