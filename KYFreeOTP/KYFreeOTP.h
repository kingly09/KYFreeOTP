//
//  KYFreeOTP.h
//  KYFreeOTPDemo
//
//  Created by kingly on 2017/11/25.
//  Copyright © 2017年 kingly. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const KYFreeOTPSHA1Algorithm;
extern NSString *const KYFreeOTPSHA256Algorithm;
extern NSString *const KYFreeOTPSHA512Algorithm;
extern NSString *const KYFreeOTPSHAMD5Algorithm;

extern NSString *const KYFreeOTPTokenTypeTotp; //totp算法，时间同步
extern NSString *const KYFreeOTPTokenTypeHotp; //hotp算法，事件同步

@interface KYFreeOTP : NSObject

@end
