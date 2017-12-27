//
//  CYPayViewController.m
//  ThirdPartyShareLoginAndPay
//
//  Created by Gauss on 2017/12/27.
//  Copyright © 2017年 Gauss. All rights reserved.
//

#import "CYPayViewController.h"
#import "AlipayTool.h"
#import "ThirdPartyLoginAndShareManager.h"
@interface CYPayViewController ()

@end

@implementation CYPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)clickWeixinPayEvent:(UIButton *)sender {
    WEAKSELF
    [[ThirdPartyLoginAndShareManager sharedInstance] weChatPayOrderTitle:@"礼物" andAttach:@"购买礼物" andPrice:@"1" andPayResponse:^(BOOL success, NSString *message, int type) {
        STRONGSELFFor(weakSelf);
        if (success) {
            [strongSelf showHUDHintWithText:@"支付成功"];
        }else{
            [strongSelf showHUDHintWithText:message];
        }
    }];
}
- (IBAction)clickAliPayEvent:(UIButton *)sender {
    WEAKSELF
    [[AlipayTool alipayTool] alipayWithPrice:@"0.01" andTitle:@"礼物" andDesc:@"购买礼物" andTradeNo:[AlipayTool generateTradeNO] success:^(NSDictionary *resultDic) {
        NSLog(@"支付成功 ---- %@",resultDic);
        STRONGSELFFor(weakSelf);
        [strongSelf showHUDHintWithText:@"支付成功"];
    } failBlock:^(NSDictionary *resultDic, NSString *message) {
        NSLog(@"支付失败 ---- %@",resultDic);
        STRONGSELFFor(weakSelf);
        [strongSelf showHUDHintWithText:message];
    }];
}

@end
