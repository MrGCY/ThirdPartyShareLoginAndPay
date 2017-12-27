//
//  CYPurchaseViewController.m
//  ThirdPartyShareLoginAndPay
//
//  Created by Gauss on 2017/12/27.
//  Copyright © 2017年 Gauss. All rights reserved.
//

#import "CYPurchaseViewController.h"
#import <StoreKit/StoreKit.h>
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
@interface CYPurchaseViewController ()<SKPaymentTransactionObserver,SKProductsRequestDelegate >
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
@end

@implementation CYPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self setupData];
}
-(void)setupSubviews{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
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
    if ([SKPaymentQueue canMakePayments]) {
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
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
    request.delegate=self;
    [request start];
}
//<SKProductsRequestDelegate> 请求协议
//收到的产品信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *myProduct = response.products;
    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %d", (int)[myProduct count]);
    // populate UI
    for(SKProduct *product in myProduct){
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
    }
    SKPayment *payment = [SKPayment paymentWithProduct:(SKProduct *)myProduct.firstObject];
    NSLog(@"---------发送购买请求------------");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}
- (void)requestProUpgradeProductData
{
    NSLog(@"------请求升级数据---------");
    NSSet *productIdentifiers = [NSSet setWithObject:@"com.productid"];
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}
//弹出错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"-------弹出错误信息----------");
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
    
}
-(void) requestDidFinish:(SKRequest *)request
{
    NSLog(@"----------反馈信息结束--------------");
}
-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"-----PurchasedTransaction----");
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
}

//<SKPaymentTransactionObserver> 千万不要忘记绑定，代码如下：
//----监听购买结果
//[[SKPaymentQueue defaultQueue] addTransactionObserver:self];

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions//交易结果
{
    NSLog(@"-----paymentQueue--------");
    self.isFinishPay = YES;
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:{//交易完成
                [self completeTransaction:transaction];
                NSLog(@"-----交易完成 --------");
                UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@"购买成功"
                                                                   delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];

                [alerView show];
                self.coinLabel.text = [NSString stringWithFormat:@"%zd",self.selectPrice];
            } break;
            case SKPaymentTransactionStateFailed://交易失败
            {
                [self failedTransaction:transaction];
                NSLog(@"-----交易失败 --------");
                UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:@"购买失败，请重新尝试购买"
                                                                    delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];

                [alerView2 show];
                
            }break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [self restoreTransaction:transaction];
                NSLog(@"-----已经购买过该商品 --------");
                break;
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                NSLog(@"-----商品添加进列表 --------");
                break;
            default:
                break;
        }
    }
}
//-----------------------购买成功-----------------
- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"-----completeTransaction--------");
    // Your application should implement these two methods.
    NSString *product = transaction.payment.productIdentifier;
    if ([product length] > 0) {
        NSArray *tt = [product componentsSeparatedByString:@"."];
        NSString *bookid = [tt lastObject];
        if ([bookid length] > 0) {
            [self recordTransaction:bookid];
            [self provideContent:bookid];
        }
    }
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
//记录交易
-(void)recordTransaction:(NSString *)product{
    NSLog(@"-----记录交易--------");
}

//处理下载内容
-(void)provideContent:(NSString *)product{
    NSLog(@"-----下载--------");
}
//--------------------购买失败------------------
- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"失败");
    if (transaction.error.code != SKErrorPaymentCancelled){
        
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}
-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction{
    
}
//--------------------已经都买过了------------------
- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"交易恢复处理");
    
}
-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"-------paymentQueue----");
}
#pragma mark connection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%@",  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    switch([(NSHTTPURLResponse *)response statusCode]) {
        case 200:
        case 206:
            break;
        case 304:
            break;
        case 400:
            break;
        case 404:
            break;
        case 416:
            break;
        case 403:
            break;
        case 401:
        case 500:
            break;
        default:
            break;
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"test");
}
-(void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听
}
@end
