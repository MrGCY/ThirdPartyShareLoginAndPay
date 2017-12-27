//
//  ThirdPartyLoginContans.h
//  cmksApp
//
//  Created by Mr.GCY on 2017/9/19.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#ifndef ThirdPartyLoginContans_h
#define ThirdPartyLoginContans_h
//----------------------------帐号id key 相关-------------------
//QQ
static NSString* const KTencentAPPID=@"1106561436";
static NSString* const KTencentSchema=@"tencent1106561436";
static NSString* const KTencentURLSchema=@"QQ41f4c99c";

//微信
static NSString* const KWXAPPID=@"wx69302eaae9f8698a";
static NSString* const KWXURLSchema=@"wx69302eaae9f8698a";
static NSString* const KWXSecret=@"e117dd5e2e7cf274d3f873cee8208f34";

//微博
static NSString* const KWBAPPID=@"4267146815";
static NSString* const KWBURLSchema=@"wb4267146815";
static NSString* const KWBSecret=@"571b9e7fe73ff1acaa5c23896cfb1b4f";
static NSString* const KWBRedirectURL=@"http://www.weibo.com";


//----------------------------通知相关-------------------
//QQ通知
static NSString *const TencentOAuthManagerLoginSuccessed = @"TencentOAuthManagerLoginSuccessed";
static NSString *const TencentOAuthManagerLoginFailed = @"TencentOAuthManagerLoginFailed";
static NSString *const TencentOAuthManagerLoginCancelled = @"TencentOAuthManagerLoginCancelled";
static NSString *const TencentOAuthManagerDidLogout = @"TencentOAuthManagerDidLogout";

static NSString *const TencentOAuthManagerUpdateSuccessed = @"TencentOAuthManagerUpdateSuccessed";
static NSString *const TencentOAuthManagerUpdateFailed = @"TencentOAuthManagerUpdateFailed";


//----------------------------提示语相关-------------------
//QQ
static NSString *const QQToastLoginSuccessed = @"授权成功,正在登录中";
static NSString *const QQToastLoginFailed = @"用户授权失败";
static NSString *const QQToastLoginCancelled = @"用户取消授权";
static NSString *const QQToastNetworkError = @"网络出现问题";
static NSString *const QQToastShareSuccessed = @"QQ分享成功";
static NSString *const QQToastShareFailed = @"QQ分享失败";
//微信
static NSString *const WXToastLoginSuccessed = @"微信正在登录中";
static NSString *const WXToastLoginRefused = @"您已拒绝微信登录";
static NSString *const WXToastLoginCancelled = @"您已取消微信登录";
static NSString *const WXToastShareCancelled = @"微信分享取消";
static NSString *const WXToastShareSuccessed = @"已成功分享到微信";
static NSString *const WXToastShareFailed = @"微信分享失败";
//微博
static NSString *const WBToastLoginSuccessed = @"微信正在登录中";
static NSString *const WBToastLoginFailed = @"微博登录失败";
static NSString *const WBToastLoginCancelled = @"您已取消微博登录";
static NSString *const WBToastShareCancelled = @"微博分享取消";
static NSString *const WBToastShareSuccessed = @"已成功分享到微博";
static NSString *const WBToastShareFailed = @"微博分享失败";
#endif /* ThirdPartyLoginContans_h */
