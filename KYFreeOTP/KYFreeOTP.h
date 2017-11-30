//
//  KYFreeOTP.h
//  KYFreeOTPDemo
//
//  Created by kingly on 2017/11/25.
//  Copyright © 2017年 kingly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Token.h"

extern NSString *const KYFreeOTPSHA1Algorithm;
extern NSString *const KYFreeOTPSHA256Algorithm;
extern NSString *const KYFreeOTPSHA512Algorithm;
extern NSString *const KYFreeOTPSHAMD5Algorithm;

extern NSString *const KYFreeOTPTokenTypeTotp; //totp算法，时间同步
extern NSString *const KYFreeOTPTokenTypeHotp; //hotp算法，事件同步



@interface KYOTPModel : NSObject

@property (nonatomic,copy) NSString* issuer;     //颁发者
@property (nonatomic,copy) NSString* uid;        //用户ID
@property (nonatomic,copy) NSString *secret;     //密钥（base32加密字符串）

@property (nonatomic,copy) NSString* algorithm;  //加密方式
@property (nonatomic,copy) NSString* tokenType;  //算法方式

@property (nonatomic, assign) NSInteger digits;  //otp的位数
@property (nonatomic, assign) NSInteger interval; //时间间隔（秒）

@end

@class TokenCode;
@class TokenStore;

@interface KYFreeOTP : NSObject


/**
 添加addToken
 
 @param OTPModel otp对象
 */
-(void)addToken:(KYOTPModel *)OTPModel;
/**
 获得TokenCode
 */
-(TokenCode *)getTokenCode;
/**
 获得TokenCode
 @param index key键值
 */
-(TokenCode *)getTokenCodeWith:(NSUInteger)index;

/**
 删除一个指定位置的Token
 @param index  key键值
 */
- (void)delToken:(NSUInteger)index;

@end

