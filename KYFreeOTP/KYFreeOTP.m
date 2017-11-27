//
//  KYFreeOTP.m
//  KYFreeOTPDemo
//
//  Created by kingly on 2017/11/25.
//  Copyright © 2017年 kingly. All rights reserved.
//

#import "KYFreeOTP.h"
#import "TokenStore.h"

NSString *const KYFreeOTPSHA1Algorithm = @"sha1";
NSString *const KYFreeOTPSHA256Algorithm = @"sha256";
NSString *const KYFreeOTPSHA512Algorithm = @"sha512";
NSString *const KYFreeOTPSHAMD5Algorithm = @"md5";


NSString *const KYFreeOTPTokenTypeTotp = @"totp";
NSString *const KYFreeOTPTokenTypeHotp = @"hotp";

@implementation KYOTPModel

@end


@implementation KYFreeOTP

/**
 添加addToken
 
 @param OTPModel otp对象
 */
-(void)addToken:(KYOTPModel *)OTPModel{
    
    // Get algorithm
    const char *algo = "sha1";       //sha1 算法
    if ( OTPModel.algorithm == KYFreeOTPSHA1Algorithm) {
        algo = "sha1";
    }else if ( OTPModel.algorithm == KYFreeOTPSHA256Algorithm) {
        algo = "sha256";
    }else if ( OTPModel.algorithm == KYFreeOTPSHA512Algorithm) {
        algo = "sha512";
    }else if ( OTPModel.algorithm == KYFreeOTPSHAMD5Algorithm) {
        algo = "md5";
    }
 
    // Built URI
    NSURLComponents* urlc = [[NSURLComponents alloc] init];
    urlc.scheme = @"otpauth";
    urlc.host = [OTPModel.tokenType isEqualToString:KYFreeOTPTokenTypeTotp] ? KYFreeOTPTokenTypeTotp : KYFreeOTPTokenTypeHotp;
    urlc.path = [NSString stringWithFormat:@"/%@:%@", OTPModel.issuer, OTPModel.uid];
    urlc.query = [NSString stringWithFormat:@"algorithm=%s&digits=%lu&secret=%@&%s=%lu",
                  algo, (long)OTPModel.digits, OTPModel.secret,
                  [OTPModel.tokenType isEqualToString:KYFreeOTPTokenTypeTotp]?"period" : "counter",OTPModel.interval];

    // Make token
    Token* token = [[Token alloc] initWithURL:[urlc URL]];
    if (token != nil)
        [[[TokenStore alloc] init] add:token];
    
}

@end
