//
//  AlipaySDK.h
//  AlipaySDK
//
//  Created by alipay on 16-12-12.
//  Copyright (c) 2016年 Alipay. All rights reserved.
//


////////////////////////////////////////////////////////
///////////////// 支付宝标准版本支付SDK ///////////////////
/////////// version:15.3.1  motify:2017.02.20 ///////////
////////////////////////////////////////////////////////


#import "APayAuthInfo.h"
typedef enum {
    ALIPAY_TIDFACTOR_IMEI,
    ALIPAY_TIDFACTOR_IMSI,
    ALIPAY_TIDFACTOR_TID,
    ALIPAY_TIDFACTOR_CLIENTKEY,
    ALIPAY_TIDFACTOR_VIMEI,
    ALIPAY_TIDFACTOR_VIMSI,
    ALIPAY_TIDFACTOR_CLIENTID,
    ALIPAY_TIDFACTOR_APDID,
    ALIPAY_TIDFACTOR_MAX
} AlipayTidFactor;

typedef void(^CompletionBlock)(NSDictionary *resultDic);

@interface AlipaySDK : NSObject

/**
 *  创建支付单例服务
 *
 *  @return 返回单例对象
 */
+ (AlipaySDK *)defaultService;


//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////支付宝支付相关接口/////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

/**
 *  支付接口
 *
 *  @param orderStr       支付订单信息字串
 *  @param schemeStr      调用支付的app注册在info.plist中的scheme
 *  @param compltionBlock 支付结果回调Block，用于wap支付结果回调（非跳转钱包支付）
 */
- (void)payOrder:(NSString *)orderStr
      fromScheme:(NSString *)schemeStr
        callback:(CompletionBlock)completionBlock;

/**
 *  处理支付宝app支付后跳回商户app携带的支付结果Url
 *
 *  @param resultUrl        支付宝app返回的支付结果url
 *  @param completionBlock  支付结果回调
 */
- (void)processOrderWithPaymentResult:(NSURL *)resultUrl
                      standbyCallback:(CompletionBlock)completionBlock;

/**
 *  获取交易token。
 *
 *  @return 交易token，若无则为空。
 */
- (NSString *)fetchTradeToken;


//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////支付宝授权 2.0 相关接口////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

/**
 *  快登授权2.0
 *
 *  @param infoStr          授权请求信息字串
 *  @param schemeStr        调用授权的app注册在info.plist中的scheme
 *  @param completionBlock  授权结果回调，若在授权过程中，调用方应用被系统终止，则此block无效，
                            需要调用方在appDelegate中调用processAuth_V2Result:standbyCallback:方法获取授权结果
 */
- (void)auth_V2WithInfo:(NSString *)infoStr
             fromScheme:(NSString *)schemeStr
               callback:(CompletionBlock)completionBlock;

/**
 *  处理支付宝app授权后跳回商户app携带的授权结果Url
 *
 *  @param resultUrl        支付宝app返回的授权结果url
 *  @param completionBlock  授权结果回调
 */
- (void)processAuth_V2Result:(NSURL *)resultUrl
             standbyCallback:(CompletionBlock)completionBlock;


//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////支付宝授权 1.0 相关接口////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

/**
 *  快登授权
 *  @param authInfo         授权相关信息
 *  @param completionBlock  授权结果回调，若在授权过程中，调用方应用被系统终止，则此block无效，
                            需要调用方在appDelegate中调用processAuth_V2Result:standbyCallback:方法获取授权结果
 */
- (void)authWithInfo:(APayAuthInfo *)authInfo
            callback:(CompletionBlock)completionBlock;

/**
 *  处理支付宝app授权后跳回商户app携带的授权结果Url
 *
 *  @param resultUrl        支付宝app返回的授权结果url
 *  @param completionBlock  授权结果回调
 */
- (void)processAuthResult:(NSURL *)resultUrl
          standbyCallback:(CompletionBlock)completionBlock;


//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////支付宝 h5 支付转 native 支付接口////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

/**
 *  从各种 h5 链接中拦截 h5 支付链接接口
 *
 *  @param urlStr           需要被拦截解析的 h5 链接
 *
 *  @return                 从url中获取到的支付订单信息字串 (若返回空，则该 h5 链接非 h5 支付链接)
 */
- (NSString*)fetchOrderInfoFromH5PayUrl:(NSString*)urlStr;

/**
 *  h5链接获取到的订单串支付接口
 *
 *  @param orderStr       支付订单信息字串
 *  @param schemeStr      调用支付的app注册在info.plist中的scheme
 *  @param compltionBlock 支付结果回调Block，用于wap支付结果回调（非跳转钱包支付）
 */
- (void)payUrlOrder:(NSString *)orderStr
         fromScheme:(NSString *)schemeStr
           callback:(CompletionBlock)completionBlock;


//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////支付宝 tid 相关信息获取接口/////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

/**
 *  获取当前tid相关信息
 *
 *  @return tid相关信息
 */
- (NSString*)queryTidFactor:(AlipayTidFactor)factor;


//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////支付宝支付环境相关信息接口//////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

/**
 *  是否已经使用过
 *
 *  @return YES为已经使用过，NO反之
 */
- (BOOL)isLogined;

/**
 *  获取当前版本号
 *
 *  @return 当前版本字符串
 */
- (NSString *)currentVersion;

/**
 *  測試所用，realse包无效
 *
 *  @param url  测试环境
 */
- (void)setUrl:(NSString *)url;

/**
 *  设置视图展示环境UIWindow(如果没有自行创建window无需设置此接口)
 *
 *  @param payWindow  支付视图展示环境
 */
- (void)setPayWindow:(UIWindow *)payWindow;

@end
