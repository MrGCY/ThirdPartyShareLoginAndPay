//
//  CMShareView.h
//  cmksApp
//
//  Created by Mr.GCY on 2017/9/21.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ShareType){
    ShareTypeQQ,//qq分享
    ShareTypeWeixin,//微信分享
    ShareTypeWeiBo,//微博分享
    ShareTypeFriend,//微信朋友圈分享
    ShareTypeQQZone,//qq空间分享
    ShareTypeReport//举报
};
//分享Block
typedef void (^ClickShareBlcok) (ShareType shareType);
@interface CYShareView : UIView
@property(nonatomic,copy)ClickShareBlcok clickShareBlock;

+(instancetype)createShareView;
//显示
-(void)showShareView;
@end
