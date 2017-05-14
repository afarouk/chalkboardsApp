//
//  CTMoreInfoWebViewController.h
//  Community
//
//  Created by ADMIN on 18/05/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTMoreInfoWebViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView * webViewDetail;
}
@property(nonatomic,strong)NSString *WebUrl;

@end
