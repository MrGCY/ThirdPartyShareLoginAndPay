//
//  CYBaseViewController.m
//  ThirdPartyShareLoginAndPay
//
//  Created by Gauss on 2017/12/27.
//  Copyright © 2017年 Gauss. All rights reserved.
//

#import "CYBaseViewController.h"
#import "MBProgressHUD.h"
@interface CYBaseViewController ()

@end

@implementation CYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorMainBackGround;
}
#pragma mark- toast相关
- (void)showHUDError {
    [self showHUDHintWithText:@"加载失败,请检查网络"];
}
- (void)showHUDErrorMessage:(NSString *)message{
    [self showHUDHintWithText:message];
}
- (void)showHUDHintWithText:(NSString *)text {
    if (!text) {
        return;
    }
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hub.mode = MBProgressHUDModeText;
    //    hub.labelText = text;
    hub.detailsLabelText = text;
    hub.removeFromSuperViewOnHide = YES;
    [hub show:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [hub hide:YES afterDelay:2];
        });
    });
}
@end
