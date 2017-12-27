//
//  CMShareView.m
//  cmksApp
//
//  Created by Mr.GCY on 2017/9/21.
//  Copyright © 2017年 Mr.GCY. All rights reserved.


#import "CYShareView.h"
@interface CYShareView()
@property (weak, nonatomic) IBOutlet UIView *shareBottomView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@end
@implementation CYShareView
+(instancetype)createShareView{
    CYShareView * shareView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    [shareView setupUI];
    return shareView;
}
-(void)setupUI{
    KViewRadius(self.shareBottomView, 20);
    KViewRadius(self.cancelBtn, 5);
    self.frame = [UIScreen mainScreen].bounds;
    
    UIView * tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    tapView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:tapView];
    [self insertSubview:tapView belowSubview:self.shareBottomView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDissmisView)];
    [tapView addGestureRecognizer:tap];
}
-(void)tapDissmisView{
    [self hideShareView];
}
//显示
-(void)showShareView{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    WEAKSELF
    [UIView animateWithDuration:0.3 animations:^{
        STRONGSELFFor(weakSelf)
        strongSelf.shareBottomView.transform = CGAffineTransformMakeTranslation(0, -(strongSelf.shareBottomView.height - 20));
    }];
}
//隐藏
-(void)hideShareView{
    WEAKSELF
    [UIView animateWithDuration:0.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        STRONGSELFFor(weakSelf)
        strongSelf.shareBottomView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        STRONGSELFFor(weakSelf)
        [strongSelf removeFromSuperview];
    }];
}
#pragma mark- QQ分享
- (IBAction)clickQQShare:(id)sender {
    [self clickShareViewEventWithType:ShareTypeQQ];
}
#pragma mark- 微信分享
- (IBAction)clickWeixinShare:(id)sender {
    [self clickShareViewEventWithType:ShareTypeWeixin];
}
#pragma mark- 微博分享
- (IBAction)clickWeiboShare:(id)sender {
    [self clickShareViewEventWithType:ShareTypeWeiBo];
}
#pragma mark- 微信朋友圈分享
- (IBAction)clickFriendShare:(id)sender {
    [self clickShareViewEventWithType:ShareTypeFriend];
}
#pragma mark- QQ空间分享
- (IBAction)clickQQZoneShare:(id)sender {
    [self clickShareViewEventWithType:ShareTypeQQZone];
}
#pragma mark- 举报
- (IBAction)clickReportEvent:(id)sender {
    [self clickShareViewEventWithType:ShareTypeReport];
}
-(void)clickShareViewEventWithType:(ShareType)type{
    [self hideShareView];
    if (self.clickShareBlock) {
        self.clickShareBlock(type);
    }
}
#pragma mark- 取消分享
- (IBAction)clickCancelBtn:(id)sender {
    [self tapDissmisView];
}
@end
