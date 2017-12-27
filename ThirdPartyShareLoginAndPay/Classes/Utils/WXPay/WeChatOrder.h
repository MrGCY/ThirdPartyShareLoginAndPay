// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2015-2016 Hangzhou Freewind Technology Co., Ltd.
// All rights reserved.
// http://company.zaoing.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  WeChatOrder.h
//  beibei
//
//  Created by Sailor on 16/6/15.
//  Copyright © 2016年 iSailor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeChatOrder : NSObject

@property(nonatomic,copy) NSString *orderName;//订单描述，展示给用户
@property(nonatomic,copy) NSString *orderPrice;//订单金额，单位为分
@property(nonatomic,copy) NSString *orderNo;//商户订单号
@property(nonatomic,copy) NSString *attach;//附加数据

@end
