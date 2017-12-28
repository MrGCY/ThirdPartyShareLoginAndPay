//
//  PuchaseTool.m
//  ThirdPartyShareLoginAndPay
//
//  Created by Gauss on 2017/12/27.
//  Copyright © 2017年 Gauss. All rights reserved.
//

#import "PuchaseTool.h"
#import <StoreKit/StoreKit.h>
@interface PuchaseTool()<SKPaymentTransactionObserver,SKProductsRequestDelegate >

@end
@implementation PuchaseTool
#pragma mark- 创建单例
#pragma mark - 初始化方法
+ (PuchaseTool *)shareInstance
{
    static PuchaseTool * shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}
-(BOOL)canPay{
    return [SKPaymentQueue canMakePayments];
}
-(void)addTransactionObserver{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}
-(void)removeTransactionObserver{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听
}
//请求产品信息
-(void)requestProductInfoWithProductArray:(NSArray *)product{
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
    request.delegate=self;
    [request start];
}
#pragma mark- SKProductsRequestDelegate
//收到的产品信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    //-----------收到产品反馈信息--------------
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
    //---------发送购买请求------------
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}
- (void)requestProUpgradeProductData
{
    //------请求升级数据---------
    NSSet *productIdentifiers = [NSSet setWithObject:@"com.productid"];
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}
//弹出错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    //-------弹出错误信息----------
    if (self.delegate && [self.delegate respondsToSelector:@selector(puchaseRequestFailWithError:)]) {
        [self.delegate puchaseRequestFailWithError:error];
    }
}
-(void)requestDidFinish:(SKRequest *)request{
    //----------反馈信息结束--------------
    if (self.delegate && [self.delegate respondsToSelector:@selector(puchaseRequestFinish)]) {
        [self.delegate puchaseRequestFinish];
    }
}
-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction{
    //-----PurchasedTransaction----
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
}
#pragma mark- SKPaymentTransactionObserver
//----监听购买结果
//[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions//交易结果
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:{//交易完成
                //-----交易完成 --------
                [self completeTransaction:transaction];
                if (self.delegate && [self.delegate respondsToSelector:@selector(puchaseSuccessWithUpdatedTransactions:)]) {
                    [self.delegate puchaseSuccessWithUpdatedTransactions:transactions];
                }
            } break;
            case SKPaymentTransactionStateFailed://交易失败
            {
                //-----交易失败 --------
                [self failedTransaction:transaction];
                if (self.delegate && [self.delegate respondsToSelector:@selector(puchaseFailWithUpdatedTransactions:)]) {
                    [self.delegate puchaseFailWithUpdatedTransactions:transactions];
                }
                
            }break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
            {
                //-----已经购买过该商品 --------
                [self restoreTransaction:transaction];
                if (self.delegate && [self.delegate respondsToSelector:@selector(puchaseRestoredWithUpdatedTransactions:)]) {
                    [self.delegate puchaseRestoredWithUpdatedTransactions:transactions];
                }
            }
                break;
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                //-----商品添加进列表 --------
                break;
            default:
                break;
        }
    }
}
//-----------------------购买成功-----------------
- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
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
    [self removeTransactionObserver];
}
@end
