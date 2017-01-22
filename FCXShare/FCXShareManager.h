//
//  FCXShareManager.h
//  FCXUniversial
//
//  Created by 冯 传祥 on 16/3/29.
//  Copyright © 2016年 冯 传祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FCXShareType) {
    FCXShareTypeDefault, //!<默认图文带连接的分享
    FCXShareTypeImage,   //!<图片分享
    FCXShareTypeText,   //!<文本分享
    FCXShareTypeEmotion, //!<表情数据，如GIF等
    FCXShareTypeMusic    //!<音乐分享
};

typedef NS_ENUM(NSInteger, FCXSharePlatform) {
    FCXSharePlatformWXSession = 100,   //!<微信聊天界面
    FCXSharePlatformWXTimeline,        //!<微信朋友圈
    FCXSharePlatformQQ,                //!<QQ
    FCXSharePlatformQzone,             //!<QQ空间
    FCXSharePlatformSina,              //!<新浪微博
    FCXSharePlatformSms,               //!<短信
    FCXSharePlatformCollection,        //!<收藏
    FCXSharePlatformCopy,              //!<复制
};

@interface FCXShareManager : UIView

/**
 presentedController 如果发送的平台微博只有一个并且没有授权，传入要授权的viewController，将弹出授权页面，进行授权。可以传nil，将不进行授权。
 */
@property (nonatomic, unsafe_unretained) UIViewController *presentedController;
@property (nonatomic, strong) NSString *shareTitle;//!<第三方平台显示分享的标题
@property (nonatomic, strong) NSString *shareContent;//!<第三方平台显示分享的内容
@property (nonatomic, strong) NSString *shareURL;//!<分享链接地址
@property (nonatomic, strong) UIImage *shareImage;//!<分享图片

//********************音乐分享用到的***************************
@property (nonatomic, strong) NSString *shareImageURL;//!<分享图片URL（qq分享音乐用）
@property (nonatomic, strong) NSString *musicURL;//!<音乐分享连接地址
@property (nonatomic, strong) NSData *emotionData;//!<分享的gif图片的data


/**
 *  分享的类型
 *  note:如果是音乐分享，在设置shareType前要先设置musicURL
 */
@property (nonatomic, unsafe_unretained) FCXShareType shareType;

@property (nonatomic, copy) dispatch_block_t shareSuccessBlock;
@property (nonatomic, copy) dispatch_block_t collectionBlock;
@property (nonatomic, copy) dispatch_block_t copyBlock;
@property (nonatomic, unsafe_unretained) BOOL collection;//!<是否收藏


//竖直方向的分享界面
+ (FCXShareManager *)verManager;
//水平滚动的分享界面
+ (FCXShareManager *)horManager;

- (void)showShareView;
- (void)showInviteFriendsShareView;//!<邀请好友显示的分享
- (void)showImageShare;//!<只分享图片
- (void)showTextShare;//!<文本图片
- (void)showEmotionShare;//!<表情数据，如GIF等
- (void)showMusicShare;//!<音乐分享

- (void)shareToWXSession;//!<微信聊天界面
- (void)shareToWXTimeline;//!<微信朋友圈
- (void)shareToQQ;
- (void)shareToQzone;
- (void)shareToSina;
- (void)shareToSms;
- (void)shareToPlatform:(FCXSharePlatform)platform;

@end
