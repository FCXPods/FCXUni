//
//  FCXShareManager.m
//  FCXUniversial
//
//  Created by 冯 传祥 on 16/3/29.
//  Copyright © 2016年 冯 传祥. All rights reserved.
//

#import "FCXShareManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialQQHandler.h"
#import "WXApi.h"
#import <MessageUI/MessageUI.h>
#import <TencentOpenAPI/QQApiInterface.h>

#define SHARE_UICOLOR_FROMRGB(rgbValue) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) & 0xFF00) >> 8))/255.0 blue:((float)((rgbValue) & 0xFF))/255.0 alpha:1.0]

#define SHARE_TITLE_NORMALCOLOR SHARE_UICOLOR_FROMRGB(0x333333)
#define SHARE_TITLE_HCOLOR SHARE_UICOLOR_FROMRGB(0x999999)

static inline CGFloat Share_ScreenWidth() {
    return [UIScreen mainScreen].bounds.size.width;
}

static inline CGFloat Share_ScreenHeight() {
    return [UIScreen mainScreen].bounds.size.height;
}

UIImage *ImageWithColor(UIColor *color) {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@interface FCXShareButton : UIButton

@end

@implementation FCXShareButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

@end

@interface FCXShareManager ()
{
    UIView *_bottomView;
    CGFloat _bottomHeight;
    UIButton *_cancelButton;
}

@end

@implementation FCXShareManager

+ (FCXShareManager *)sharedManager {
    static FCXShareManager *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[FCXShareManager alloc] init];
    });
    return shareManager;
}

- (id)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, Share_ScreenWidth(), Share_ScreenHeight());
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
        
        [self judgeBottomHeight];
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Share_ScreenHeight(), Share_ScreenWidth(), _bottomHeight)];
        _bottomView.backgroundColor = SHARE_UICOLOR_FROMRGB(0xffffff);
        [self addSubview:_bottomView];
        
        [self createShareButtons];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setBackgroundImage:ImageWithColor([UIColor whiteColor]) forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:ImageWithColor(SHARE_UICOLOR_FROMRGB(0xebebeb)) forState:UIControlStateHighlighted];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:SHARE_TITLE_NORMALCOLOR forState:UIControlStateNormal];
        [_cancelButton setTitleColor:SHARE_TITLE_HCOLOR forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.frame = CGRectMake(0, _bottomHeight - 44, Share_ScreenWidth(), 44);
        [_bottomView addSubview:_cancelButton];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Share_ScreenWidth(), .5)];
        line.backgroundColor = SHARE_UICOLOR_FROMRGB(0xe0e0e0);
        [_cancelButton addSubview:line];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

//根据第三方平台是否安装情况判断显示高度
- (void)judgeBottomHeight {
    if ([WXApi isWXAppInstalled] && [QQApiInterface isQQInstalled]){
        _bottomHeight = 265;
    }else{
        _bottomHeight = 265 - 80;
    }
}

#pragma mark - 创建所有的分享按钮（每次show的时候都需要调用，因为本地的第三方软件随时可能发生变化，删除或者下载）
- (void)createShareButtons {
    int i = 0;
    CGFloat buttonWidth = 65;
    CGFloat buttonHeight = 85;
//    CGFloat top = (_bottomHeight - 44 - buttonHeight)/2.0;
    CGFloat top = 10;

    CGFloat space = (Share_ScreenWidth() - buttonWidth * 4)/5.0;

    for (int j = 0; j < 7; j++) {
        CGRect buttonFrame = CGRectMake(space + (i%4) * (buttonWidth + space), top + (i/4) * (buttonHeight + 5), buttonWidth, buttonHeight);
        UIButton *shareButton;
        switch (j) {
            case 0:
            {//微信
                if ([WXApi isWXAppInstalled]) {
                    i++;
                    shareButton = [self createShareButtonWithFrame:buttonFrame
                                                               tag:FCXSharePlatformWXSession
                                                             title:@"微信好友"
                                                       normalImage:@"share_wx"
                                                  highlightedImage:@"share_wx_h"];
                }
            }
                break;
            case 1:
            {//微信朋友圈
                if ([WXApi isWXAppInstalled]) {
                    i++;
                    shareButton = [self createShareButtonWithFrame:buttonFrame
                                                               tag:FCXSharePlatformWXTimeline
                                                             title:@"微信朋友圈"
                                                       normalImage:@"share_wxfc"
                                                  highlightedImage:@"share_wxfc_h"];
                }
            }
                break;
            case 2:
            {//QQ
                if ([QQApiInterface isQQInstalled]) {
                    i++;
                    shareButton = [self createShareButtonWithFrame:buttonFrame
                                                               tag:FCXSharePlatformQQ
                                                             title:@"QQ"
                                                       normalImage:@"share_qq"
                                                  highlightedImage:@"share_qq_h"];
                }
            }
                break;
            case 3:
            {//QQ空间
                if ([QQApiInterface isQQInstalled] && _shareType != FCXShareTypeImage) {//QQ空间不支持单图片分享
                    i++;
                    shareButton = [self createShareButtonWithFrame:buttonFrame
                                                               tag:FCXSharePlatformQzone
                                                             title:@"QQ空间"
                                                       normalImage:@"share_qqzone"
                                                  highlightedImage:@"share_qqzone_h"];
                }
            }
                break;
            case 4:
            {//新浪微博
                i++;
                shareButton = [self createShareButtonWithFrame:buttonFrame
                                                           tag:FCXSharePlatformSina
                                                         title:@"新浪微博"
                                                   normalImage:@"share_sina"
                                              highlightedImage:@"share_sina_h"];
            }
                break;
                
            case 5:
            {//短信
                if([MFMessageComposeViewController canSendText]) {
                    i++;
                    shareButton = [self createShareButtonWithFrame:buttonFrame
                                                               tag:FCXSharePlatformSms
                                                             title:@"短信"
                                                       normalImage:@"share_sms"
                                                  highlightedImage:@"share_sms_h"];
                }
            }
                break;
            default:
                break;
        }
        
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 45);
        shareButton.transform = transform;
        shareButton.alpha = .3;
        
        [UIView animateWithDuration:1. delay:j%4 * 0.03 usingSpringWithDamping:.5 initialSpringVelocity:8 options:UIViewAnimationOptionCurveEaseOut animations:^{
            shareButton.transform = CGAffineTransformIdentity;
            shareButton.alpha = 1;

        } completion:^(BOOL finished) {
            
        }];
    }
}

- (UIButton *)createShareButtonWithFrame:(CGRect)frame
                                     tag:(int)tag
                                   title:(NSString *)title
                             normalImage:(NSString *)normalImage
                        highlightedImage:(NSString *)highlightedImage {
    UIButton *button = (UIButton *)[_bottomView viewWithTag:tag];
    if ([button isKindOfClass:[UIButton class]]) {
        button.frame = frame;
        return button;
    }
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.titleEdgeInsets = UIEdgeInsetsMake(80, -65, 0, 0);
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0) {
        button.titleEdgeInsets = UIEdgeInsetsMake(80, -56, 0, 0);
    }
    [button setTitleColor:SHARE_TITLE_NORMALCOLOR forState:UIControlStateNormal];
    [button setTitleColor:SHARE_TITLE_HCOLOR forState:UIControlStateHighlighted];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    button.exclusiveTouch = YES;
    [_bottomView addSubview:button];
    return button;
}

- (void)tapAction {
    [self dismissView];
}

- (void)showShareView {
    //每次显示分享界面的时候，需要重新判断显示的分享平台
    for (UIButton *button in _bottomView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            button.frame = CGRectZero;
        }
    }
    [self judgeBottomHeight];
    _bottomView.frame = CGRectMake(0, Share_ScreenHeight(), Share_ScreenWidth(), _bottomHeight);
    _cancelButton.frame = CGRectMake(0, _bottomHeight - 50, Share_ScreenWidth(), 50);
    [self createShareButtons];
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [window addSubview:self];
    
    __weak typeof(self) weakSelf = self;
    
    UIView *weakBottomView = _bottomView;
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
        weakBottomView.frame = CGRectMake(0, Share_ScreenHeight() - _bottomHeight, Share_ScreenWidth(), _bottomHeight);
        
    } completion:^(BOOL finished){
        
    }];
}

- (void)dismissView {
    __weak typeof(self) weakSelf = self;
    UIView *weakBottomView = _bottomView;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:.0];
        weakBottomView.frame = CGRectMake(0, Share_ScreenHeight(), Share_ScreenWidth(), _bottomHeight);
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)setShareType:(FCXShareType)shareType {
    _shareType = shareType;
    
    switch (shareType) {
        case FCXShareTypeDefault:
        {
//            [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeDefault url:nil];
            self.musicURL = nil;
        }
            break;
        case FCXShareTypeImage:
        {
//            [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:nil];
            self.musicURL = nil;
            self.shareContent = nil;
        }
            break;
        case FCXShareTypeMusic:
        {
//            [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeMusic url:self.musicURL];
        }
            break;
    }
}

#pragma mark - 邀请好友的分享
- (void)showInviteFriendsShareView {
    self.shareType = FCXShareTypeDefault;
    [self showShareView];
}

#pragma mark - 只分享图片
- (void)showImageShare {
    self.shareType = FCXShareTypeImage;
    [self showShareView];
}

#pragma mark - 只分享文本
- (void)showTextShare {
    self.shareType = FCXShareTypeText;
    [self showShareView];
}

#pragma mark - 表情数据，如GIF等
- (void)showEmotionShare {
    self.shareType = FCXShareTypeEmotion;
    [self showShareView];
}

#pragma mark -  带音乐的分享
- (void)showMusicShare {
    self.shareType = FCXShareTypeMusic;
    [self showShareView];
}

- (void)shareMusicToWXWithType:(int)type {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.shareTitle;
    message.description = self.shareContent;
    [message setThumbImage:self.shareImage];
    
    WXMusicObject *musicObject = [WXMusicObject object];
    musicObject.musicUrl = self.shareURL;
    musicObject.musicDataUrl = self.musicURL;
    
    message.mediaObject = musicObject;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = type;
    
    [WXApi sendReq:req];
}

- (void)shareMusicToQQWithType:(int)type {
    QQApiAudioObject *audioObj =
    [QQApiAudioObject objectWithURL:[NSURL URLWithString:self.shareURL]
                              title:self.shareTitle
                        description:self.shareContent
                    previewImageURL:[NSURL URLWithString:self.shareImageURL]];
    [audioObj setFlashURL:[NSURL URLWithString:self.musicURL]];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:audioObj];
    //将内容分享到qq
    if (0 == type) {
        [QQApiInterface sendReq:req];
    }else{//将内容分享到qzone
        [QQApiInterface SendReqToQZone:req];
    }
}

- (void)shareToWXSession {
    [self shareToPlatform:FCXSharePlatformWXSession];
}

- (void)shareToWXTimeline {
    [self shareToPlatform:FCXSharePlatformWXTimeline];
}

- (void)shareToQQ {
    [self shareToPlatform:FCXSharePlatformQQ];
}

- (void)shareToQzone {
    [self shareToPlatform:FCXSharePlatformQzone];
}

- (void)shareToSina {
    [self shareToPlatform:FCXSharePlatformSina];
}

- (void)shareToSms {
    [self shareToPlatform:FCXSharePlatformSms];
}

#pragma mark - 分享
- (void)shareButtonAction:(UIButton *)button {
    [self dismissView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.27 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self shareToPlatform:button.tag];
    });
}

- (void)shareToPlatform:(FCXSharePlatform)platform {
    if (_shareType == FCXShareTypeEmotion) {
        [self shareEmotion:platform];
        return;
    }
    NSString *shareContent = [self getShortShareContent];
    UMSocialPlatformType platformType;
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.text = shareContent;

    if (_shareType == FCXShareTypeDefault) {//图文分享
        UMShareWebpageObject *shareObject = [[UMShareWebpageObject alloc] init];
        if (_shareURL) {
            shareObject.webpageUrl = _shareURL;
        }
        if (self.shareTitle) {
            shareObject.title = _shareTitle;
        }
        shareObject.thumbImage = _shareImage;
        shareObject.descr = shareContent;
        messageObject.shareObject = shareObject;
        
    }else if (_shareType == FCXShareTypeImage) {
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        shareObject.shareImage = self.shareImage;
        messageObject.shareObject = shareObject;
        
    }else if (_shareType == FCXShareTypeText) {
        messageObject.text = shareContent;
        
    }else if (_shareType == FCXShareTypeEmotion) {
        UMShareEmotionObject *shareObject = [UMShareEmotionObject shareObjectWithTitle:@"11" descr:@"de" thumImage:_shareImage];
        shareObject.emotionData = _emotionData;
        messageObject.shareObject = shareObject;

    }else if (_shareType == FCXShareTypeMusic) {
        UMShareMusicObject *shareObject = [[UMShareMusicObject alloc] init];
        shareObject.musicUrl = _musicURL;
        shareObject.musicDataUrl = _musicURL;
        
        if (self.shareTitle) {
            shareObject.title = _shareTitle;
        }
        shareObject.thumbImage = _shareImage;
        shareObject.descr = shareContent;
        messageObject.shareObject = shareObject;

        //音乐分享需要单独调用微信的，否则音乐url与跳转url冲突
//        [self shareMusicToWXWithType:WXSceneSession];
//        return;
    }

    
    switch (platform) {
        case FCXSharePlatformWXSession:
        {//微信
            platformType = UMSocialPlatformType_WechatSession;
        }
            break;
        case FCXSharePlatformWXTimeline:
        {//朋友圈
            platformType = UMSocialPlatformType_WechatTimeLine;
//            if (self.shareType == FCXShareTypeMusic) {
//                //音乐分享需要单独调用微信的，否则音乐url与跳转url冲突
//                [self shareMusicToWXWithType:WXSceneTimeline];
//                return;
//            }
        }
            break;
        case FCXSharePlatformQQ:
        {//QQ好友
            platformType = UMSocialPlatformType_QQ;
            
            if (self.shareType == FCXShareTypeMusic) {
                //音乐分享需要单独调用腾讯的，否则音乐url与跳转url冲突
//                [self shareMusicToQQWithType:0];
//                return;
            }
        }
            break;
        case FCXSharePlatformQzone:
        {//QQ空间
            platformType = UMSocialPlatformType_Qzone;
            if (self.shareType == FCXShareTypeMusic) {
                //音乐分享需要单独调用腾讯的，否则音乐url与跳转url冲突
//                [self shareMusicToQQWithType:1];
//                return;
            }
        }
            break;
        case FCXSharePlatformSina:
        {//新浪微博
            platformType = UMSocialPlatformType_Sina;
            if (self.shareType == FCXShareTypeMusic) {
                shareContent = [NSString stringWithFormat:@"%@%@", self.shareTitle, self.shareURL];
            }
            
        }
            break;
        case FCXSharePlatformSms:
        {//短信
            platformType = UMSocialPlatformType_Sms;
        }
            break;
        default:
            break;
    }
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self.presentedController completion:^(id data, NSError *error) {
        if (!error) {
            if (self.shareSuccessBlock) {
                self.shareSuccessBlock();
            }
        }
    }];
}

- (void)shareEmotion:(FCXSharePlatform)platform {
    if (platform == FCXSharePlatformQQ) {
        QQApiImageObject *imgObj = [QQApiImageObject objectWithData:_emotionData
                                                   previewImageData:_emotionData
                                                              title:nil
                                                        description:nil];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
        //将内容分享到qq
        [QQApiInterface sendReq:req];
    } else if (platform == FCXSharePlatformWXSession) {
        WXMediaMessage *message = [WXMediaMessage message];
        [message setThumbImage:[UIImage imageWithData:_emotionData]];
        
        WXEmoticonObject *imageObject = [WXEmoticonObject object];
        imageObject.emoticonData = _emotionData;
        
        message.mediaObject = imageObject;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;
        [WXApi sendReq:req];
    }
}

- (NSString *)getShortShareContent {
    if (self.shareContent.length > 150) {
        self.shareContent = [[self.shareContent substringToIndex:147] stringByAppendingString:@"..."];
    }
    return self.shareContent;
}

@end