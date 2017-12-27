//
//  CYShareViewController.m
//  ThirdPartyShareLoginAndPay
//
//  Created by Gauss on 2017/12/27.
//  Copyright © 2017年 Gauss. All rights reserved.
//

#import "CYShareViewController.h"
#import "CYShareView.h"
#import "ThirdPartyLoginAndShareManager.h"
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
    //分享地址
    NSString * detailLinks = @"www.baidu.com";
    //分享标题
    NSString * title = @"分享功能";
    //分享描述信息
    NSString * message = @"第三方分享功能的使用-人生苦短必须性感";
    //分享图片
    UIImage * shareImg = [UIImage imageNamed:@""];
    switch (type) {
        case ShareTypeQQ:{
            [[ThirdPartyLoginAndShareManager sharedInstance].qqUtils sharedLinkToQQWithTitle:title message:message detailUrl:detailLinks image:shareImg shareType:QQShareMessage];
        }
            break;
        case ShareTypeWeiBo:{
            [[ThirdPartyLoginAndShareManager sharedInstance].wbUtils sharedLinkToSinaWeiboWithTitle:title webURL:detailLinks message:message coverImage:shareImg];
        }
            break;
        case ShareTypeWeixin:{
            [[ThirdPartyLoginAndShareManager sharedInstance].wxUtils sharedLinkToWeChat:title description:message detailUrl:detailLinks image:shareImg shareType:WXShareSceneTypeSession];
        }
            break;
        case ShareTypeFriend:{
            [[ThirdPartyLoginAndShareManager sharedInstance].wxUtils sharedLinkToWeChat:title description:message detailUrl:detailLinks image:shareImg shareType:WXShareSceneTypeTimeline];
        }
            break;
        case ShareTypeQQZone:{
            [[ThirdPartyLoginAndShareManager sharedInstance].qqUtils sharedLinkToQQWithTitle:title message:message detailUrl:detailLinks image:shareImg shareType:QQShareZone];
        }
            break;
        default:
            break;
    }
}
@end
