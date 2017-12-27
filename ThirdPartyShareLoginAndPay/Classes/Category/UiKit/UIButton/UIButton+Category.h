//
//  UIButton+Category.h
//  SmileHelper
//
//  Created by 微笑吧阳光 on 2017/3/1.
//  Copyright © 2017年 www.imee.vc. All rights reserved.
//

#import <UIKit/UIKit.h>

//按钮点击Block
typedef void (^BtnClickBlock)(NSInteger tag);

@interface UIButton (Category)


-(void)add_BtnClickHandler:(BtnClickBlock)clickHandler;

/**
 *  @brief  使用颜色设置按钮背景
 *
 *  @param backgroundColor 背景颜色
 *  @param state           按钮状态
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;


/**
 *  @brief  设置按钮额外热区
 */
@property (nonatomic, assign) UIEdgeInsets touchAreaInsets;

/**
 *  @brief  倒计时按钮
 *
 *  @param timeout 时间
 *  @param tittle           tittle
 *  @param waitTittle           waitTittle
 */
-(void)add_startTime:(NSInteger )timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle;


/**
 *  点赞动画
 */
- (void)start_ZanAnimation;



@end
