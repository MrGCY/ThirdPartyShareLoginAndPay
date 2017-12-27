//
//  CYMainTabBarViewController.m
//  ThirdPartyShareLoginAndPay
//
//  Created by Gauss on 2017/12/27.
//  Copyright © 2017年 Gauss. All rights reserved.
//

#import "CYMainTabBarViewController.h"
#import "CYBaseNavigationViewController.h"
@interface CYMainTabBarViewController ()<UITabBarControllerDelegate>
@property(nonatomic,assign)NSInteger indexFlag;
@property (copy, nonatomic) NSArray * controllerArray;
@end

@implementation CYMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAllViewController];
}
//初始化所有控制器
-(void)setupAllViewController{
    for (NSDictionary * dic in self.controllerArray) {
        NSString * className = [dic objectForKey:@"vcClassName"];
        NSString * title = [dic objectForKey:@"title"];
        [self addChildViewController:[self setupOneViewControllerWithClassName:className andTitle:title]];
    }
}
-(UIViewController *)setupOneViewControllerWithClassName:(NSString *)className andTitle:(NSString *)title{
    Class cls = NSClassFromString(className);
    UIViewController * vc = (UIViewController *)[[cls alloc] init];
    vc.title = title;
    CYBaseNavigationViewController * nav = [[CYBaseNavigationViewController alloc] initWithRootViewController:vc];
    return nav;
}
#pragma mark- 懒加载数据
-(NSArray *)controllerArray{
    if (!_controllerArray) {
        _controllerArray = @[
                             @{@"vcClassName":@"CYShareViewController",@"title":@"分享"},
                             @{@"vcClassName":@"CYPayViewController",@"title":@"支付"},
                             @{@"vcClassName":@"CYPurchaseViewController",@"title":@"内购"},
                             ];
    }
    return _controllerArray;
}
#pragma mark- UITabBarControllerDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (self.indexFlag != index) {
        [self animationWithIndex:index];
    }
}
// 动画
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.08;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.3];
    [[tabbarbuttonArray[index] layer]
     addAnimation:pulse forKey:nil];
    self.indexFlag = index;
    
}
@end
