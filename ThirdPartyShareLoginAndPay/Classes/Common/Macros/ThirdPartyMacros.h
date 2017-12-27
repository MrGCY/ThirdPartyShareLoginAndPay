//
//  QuizzesMacros.h
//  QuizzesApp
//
//  Created by Mr.GCY on 2017/12/1.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#ifndef ThirdPartyMacros_h
#define ThirdPartyMacros_h
//当前版本
#define BundleVersion [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"]
//获取当前版本号
#define CurrentVersion [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]

//默认图
#define CoverPlaceholderImage [UIImage imageNamed:@"coverPlaceHolder.jpg"]
#define IconPlaceholderImage [UIImage imageNamed:@"icon_placeholder"]

#define KNetError KNSLocalizedString(@"网络错误")
// NSLocalizedString(key, comment) 本质
// NSlocalizeString 第一个参数是内容,根据第一个参数去对应语言的文件中取对应的字符串，第二个参数将会转化为字符串文件里的注释，可以传nil，也可以传空字符串@""。
#define KNSLocalizedString(key) NSLocalizedString(key, nil)

//----------------------------weak--------------------------------------
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(self) __strong strongSelf = self;
#define STRONGSELFFor(object) typeof(object) __strong strongSelf = object;

//----------------------------【 获取屏幕宽度与高度】-----------------------
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenSize [UIScreen mainScreen].bounds.size

//----------------------------- view 圆角和边框---------------------------
#define KViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

///----------------------------- View 圆角-------------------------------
#define KViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

/// ------------------------------ View加边框-----------------------------
#define KViewBorder(View, BorderColor, BorderWidth )\
\
View.layer.borderColor = BorderColor.CGColor;\
View.layer.borderWidth = BorderWidth;

//8.字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

//9.数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

//10.字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

//11.是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

#pragma mark - 💗💗💗【 常用的缩写 】
//////////////////////////////////////////////////////////////////////////////
/**
 *  💗【 常用的缩写 】
 **/
//////////////////////////////////////////////////////////////////////////////
#define kApplication        [UIApplication sharedApplication]
#define kKeyWindow          [UIApplication sharedApplication].keyWindow
#define kAppDelegate        [UIApplication sharedApplication].delegate
#define kUserDefaults      [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]
#endif /* QuizzesMacros_h */
