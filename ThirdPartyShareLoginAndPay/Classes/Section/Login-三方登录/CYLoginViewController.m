//
//  CYLoginViewController.m
//  ThirdPartyShareLoginAndPay
//
//  Created by Gauss on 2017/12/27.
//  Copyright © 2017年 Gauss. All rights reserved.
//

#import "CYLoginViewController.h"
#import "AppDelegate.h"
#import "ThirdPartyLoginAndShareManager.h"
@interface CYLoginViewController ()<ThirdPartyLoginAndShareManagerDelegate>

@end

@implementation CYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    [ThirdPartyLoginAndShareManager sharedInstance].thirdPartyDelegate = self;
}
- (IBAction)clickQQLoginEvent:(UIButton *)sender {
    //QQ
    [[ThirdPartyLoginAndShareManager sharedInstance].qqUtils QQOauthLogin];
}
- (IBAction)clickWeiBoLoginEvent:(UIButton *)sender {
    //微博
    [[ThirdPartyLoginAndShareManager sharedInstance].wbUtils WBOauthLogin];
}
- (IBAction)clickWeixinLoginEvent:(UIButton *)sender {
    //微信
    [[ThirdPartyLoginAndShareManager sharedInstance].wxUtils WXOauthLogin];
}
- (IBAction)clickJumpEvent:(UIButton *)sender {
    [[AppDelegate appDelegate] enterMainController];
}
#pragma mark- ThirdPartyLoginAndShareManagerDelegate
-(void)thirdPartyDidLoginSuccess:(NSDictionary *)responseObject{
    [[AppDelegate appDelegate] enterMainController];
}
-(void)thirdPartyDidShowToastMessage:(NSString *)message{
    [self showHUDHintWithText:message];
}
@end
