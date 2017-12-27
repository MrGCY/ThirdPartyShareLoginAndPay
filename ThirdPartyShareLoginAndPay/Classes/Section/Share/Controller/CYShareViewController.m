//
//  CYShareViewController.m
//  ThirdPartyShareLoginAndPay
//
//  Created by Gauss on 2017/12/27.
//  Copyright © 2017年 Gauss. All rights reserved.
//

#import "CYShareViewController.h"
#import "CYShareView.h"
@interface CYShareViewController ()
@property (strong, nonatomic) CYShareView * shareView;
@end

@implementation CYShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)clickShareEvent:(UIButton *)sender {
    [self.shareView showShareView];
}
#pragma mark- 懒加载
-(CYShareView *)shareView{
    if (!_shareView) {
        _shareView = [CYShareView createShareView];
        WEAKSELF
        _shareView.clickShareBlock = ^(ShareType shareType) {
            STRONGSELFFor(weakSelf);
            [strongSelf clickShareWithType:shareType];
        };
    }
    return _shareView;
}
-(void)clickShareWithType:(ShareType)type{
    switch (type) {
        case ShareTypeQQ:
            
            break;
        case ShareTypeWeiBo:
            
            break;
        case ShareTypeWeixin:
            
            break;
        case ShareTypeQQZone:
            
            break;
        case ShareTypeFriend:
            
            break;
        default:
            break;
    }
}
@end
