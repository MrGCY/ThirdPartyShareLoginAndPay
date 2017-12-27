//
//  CYLoginViewController.m
//  ThirdPartyShareLoginAndPay
//
//  Created by Gauss on 2017/12/27.
//  Copyright © 2017年 Gauss. All rights reserved.
//

#import "CYLoginViewController.h"
#import "AppDelegate.h"
@interface CYLoginViewController ()

@end

@implementation CYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
}
- (IBAction)clickQQLoginEvent:(UIButton *)sender {
    
}
- (IBAction)clickWeiBoLoginEvent:(UIButton *)sender {
    
}
- (IBAction)clickWeixinLoginEvent:(UIButton *)sender {
    
}
- (IBAction)clickJumpEvent:(UIButton *)sender {
    [[AppDelegate appDelegate] enterMainController];
}

@end
