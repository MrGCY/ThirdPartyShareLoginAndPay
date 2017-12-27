//
//  PuchaseTool.h
//  ThirdPartyShareLoginAndPay
//
//  Created by Gauss on 2017/12/27.
//  Copyright © 2017年 Gauss. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol PuchaseToolDelegate<NSObject>
//购买成功
-(void)puchaseSuccessWithUpdatedTransactions:(NSArray *)transactions;
//购买失败
-(void)puchaseFailWithUpdatedTransactions:(NSArray *)transactions;
//重复购买
-(void)puchaseRestoredWithUpdatedTransactions:(NSArray *)transactions;
//购买是请求产品列表错误信息
-(void)puchaseRequestFailWithError:(NSError *)error;
//购买是请求产品列表完成
-(void)puchaseRequestFinish;
@end
@interface PuchaseTool : NSObject
/**
 是否可以支付
 */
@property (assign, nonatomic,readonly) BOOL canPay;
@property (weak, nonatomic) id <PuchaseToolDelegate>delegate;
#pragma mark - 初始化方法
+ (PuchaseTool *)shareInstance;
/**
 添加支付监听
 */
-(void)addTransactionObserver;
/**
移除支付监听
 */
-(void)removeTransactionObserver;
//请求产品信息
-(void)requestProductInfoWithProductArray:(NSArray *)product;
@end
