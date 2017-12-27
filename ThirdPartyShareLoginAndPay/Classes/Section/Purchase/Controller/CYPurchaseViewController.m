//
//  CYPurchaseViewController.m
//  ThirdPartyShareLoginAndPay
//
//  Created by Gauss on 2017/12/27.
//  Copyright © 2017年 Gauss. All rights reserved.
//

#import "CYPurchaseViewController.h"
#import <StoreKit/StoreKit.h>
#import "PuchaseTool.h"
typedef NS_ENUM(NSInteger,buyCoinsTag) {
    buyCoinsTagNone,
    buyCoinsTagIAPp12,
    buyCoinsTagIAPp30,
    buyCoinsTagIAPp50,
    buyCoinsTagIAPp98,
    buyCoinsTagIAPp488,
    buyCoinsTagIAPp998,
};

//在内购项目中创的商品单号
#define ProductID_IAPp12 @"com.quzhua.app1"//12
#define ProductID_IAPp30 @"com.quzhua.app2" //30
#define ProductID_IAPp50 @"com.quzhua.app3" //50
#define ProductID_IAPp98 @"com.quzhua.app4" //98
#define ProductID_IAPp488 @"com.quzhua.app5" //488
#define ProductID_IAPp998 @"com.quzhua.app6" //998
@interface CYPurchaseViewController ()<PuchaseToolDelegate>
{
    buyCoinsTag buyType;
    buyCoinsTag selectBuyType;
}
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (strong, nonatomic) UIButton * lastBtn;
//是否完成支付
@property (assign, nonatomic) BOOL isFinishPay;
//选择的金额
@property (assign, nonatomic) NSInteger selectPrice;
//订单号
@property (copy, nonatomic) NSString * orderId;
@property (strong, nonatomic) PuchaseTool * puchaseTool;
@end

@implementation CYPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self setupData];
}
#pragma mark- 懒加载数据
-(PuchaseTool *)puchaseTool{
    if (!_puchaseTool) {
        _puchaseTool = [PuchaseTool shareInstance];
        _puchaseTool.delegate = self;
    }
    return _puchaseTool;
}
-(void)setupSubviews{
    [self.puchaseTool addTransactionObserver];
}
-(void)setupData{
    selectBuyType = buyCoinsTagNone;
    self.isFinishPay = YES;
    self.selectPrice = 0;
}
//金币充值选择
- (IBAction)clickCoinSelectEvent:(UIButton *)sender {
    if (sender.tag == self.lastBtn.tag) {
        //点击的是自己 取消选中
        [self cancelSeletedStatusWithBtn:sender];
        self.lastBtn = [UIButton new];
        selectBuyType = buyCoinsTagNone;
        self.selectPrice = 0;
    }else{
        //选中
        if (self.lastBtn.tag > 0) {
            [self cancelSeletedStatusWithBtn:self.lastBtn];
        }
        [self setSelectedStatusWithBtn:sender];
        self.lastBtn = sender;
    }
}
//取消选中状态
-(void)cancelSeletedStatusWithBtn:(UIButton *)btn{
    UILabel * lastCoinLabel = (UILabel *)[self.view viewWithTag:btn.tag + 100];
    lastCoinLabel.textColor = ColorMainBase;
    UILabel * lastMoneyLabel = (UILabel *)[self.view viewWithTag:btn.tag + 101];
    lastMoneyLabel.textColor = ColorMainBase;
    btn.selected = NO;
}
//设置选中状态
-(void)setSelectedStatusWithBtn:(UIButton *)btn{
    UILabel * coinLabel = (UILabel *)[self.view viewWithTag:btn.tag + 100];
    coinLabel.textColor = [UIColor whiteColor];
    UILabel * moneyLabel = (UILabel *)[self.view viewWithTag:btn.tag + 101];
    moneyLabel.textColor = [UIColor whiteColor];
    btn.selected = YES;
    [self setSelectBuyTypeWithBtn:btn];
}
//设置选择金额
-(void)setSelectBuyTypeWithBtn:(UIButton *)btn{
    switch (btn.tag) {
        case 1:
            selectBuyType = buyCoinsTagIAPp12;
            self.selectPrice = 12;
            break;
        case 3:
            selectBuyType = buyCoinsTagIAPp30;
            self.selectPrice = 30;
            break;
        case 5:
            selectBuyType = buyCoinsTagIAPp50;
            self.selectPrice = 50;
            break;
        case 10:
            selectBuyType = buyCoinsTagIAPp98;
            self.selectPrice = 98;
            break;
        case 50:
            selectBuyType = buyCoinsTagIAPp488;
            self.selectPrice = 488;
            break;
        case 100:
            selectBuyType = buyCoinsTagIAPp998;
            self.selectPrice =998;
            break;
        default:
            break;
    }
}
- (IBAction)clickSureEvent:(UIButton *)sender {
    if (selectBuyType == buyCoinsTagNone) {
        [self showHUDHintWithText:@"请选择需要充值的金额!"];
        return;
    }
    if (!self.isFinishPay) {
        //正在支付中
        return;
    }
    self.isFinishPay = NO;
    //创建苹果支付的订单
    [self createApplePayOrder];
}
//创建苹果支付的订单
-(void)createApplePayOrder{
    //可以先告诉客户端并生成订单  然后 去支付
    //去支付
    [self buy:selectBuyType];
}
//购买对应的商品
-(void)buy:(int)type
{
    buyType = type;
    if ([self.puchaseTool canPay]) {
        [self RequestProductData];
        NSLog(@"允许程序内付费购买");
    }else{
        NSLog(@"不允许程序内付费购买");
        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您的手机没有打开程序内付费购买"
                                                           delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
        
        [alerView show];
    }
}
//请求对应商品信息
-(void)RequestProductData
{
    NSLog(@"---------请求对应的产品信息------------");
    NSArray *product = nil;
    switch (buyType) {
        case buyCoinsTagIAPp12:
            product=[[NSArray alloc] initWithObjects:ProductID_IAPp12,nil];
            break;
        case buyCoinsTagIAPp30:
            product=[[NSArray alloc] initWithObjects:ProductID_IAPp30,nil];
            break;
        case buyCoinsTagIAPp50:
            product=[[NSArray alloc] initWithObjects:ProductID_IAPp50,nil];
            break;
        case buyCoinsTagIAPp98:
            product=[[NSArray alloc] initWithObjects:ProductID_IAPp98,nil];
            break;
        case buyCoinsTagIAPp488:
            product=[[NSArray alloc] initWithObjects:ProductID_IAPp488,nil];
            break;
        case buyCoinsTagIAPp998:
            product=[[NSArray alloc] initWithObjects:ProductID_IAPp998,nil];
            break;
        default:
            break;
    }
    [self.puchaseTool requestProductInfoWithProductArray:product];
}
#pragma mark- PuchaseToolDelegate
-(void)puchaseRestoredWithUpdatedTransactions:(NSArray *)transactions{
    self.isFinishPay = YES;
    NSLog(@"-----已经购买过该商品 --------");
}
-(void)puchaseFailWithUpdatedTransactions:(NSArray *)transactions{
    self.isFinishPay = YES;
    NSLog(@"-----交易失败 --------");
    UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"购买失败，请重新尝试购买"
                                                        delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
    
    [alerView2 show];
}
-(void)puchaseSuccessWithUpdatedTransactions:(NSArray *)transactions{
    self.isFinishPay = YES;
    NSLog(@"-----交易完成 --------");
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"购买成功"
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
    
    [alerView show];
    self.coinLabel.text = [NSString stringWithFormat:@"%zd",self.selectPrice];
}
-(void)puchaseRequestFailWithError:(NSError *)error{
    NSLog(@"-------弹出错误信息----------");
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
}
-(void)puchaseRequestFinish{
    NSLog(@"----------反馈信息结束--------------");
}
-(void)dealloc
{
    [self.puchaseTool removeTransactionObserver];//解除监听
}
@end
