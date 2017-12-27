//
//  CYBaseViewController.h
//  ThirdPartyShareLoginAndPay
//
//  Created by Gauss on 2017/12/27.
//  Copyright © 2017年 Gauss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYBaseViewController : UIViewController
#pragma mark- toast相关
- (void)showHUDError;
- (void)showHUDErrorMessage:(NSString *)message;
- (void)showHUDHintWithText:(NSString *)text;
@end
