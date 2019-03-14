//
//  KYViewController.m
//  KYFreeOTP
//
//  Created by kingly09 on 04/26/2018.
//  Copyright (c) 2018 kingly09. All rights reserved.
//

#import "KYViewController.h"
#import "KYFreeOTP.h"

#define  OTPKEY @"SK6VEUXUMPG3YNXL"

@interface KYViewController ()
@property (weak, nonatomic) IBOutlet UILabel *optLabel;
@property (nonatomic,strong) NSTimer *dynamictimer; //定时器
@property (nonatomic,strong)  TokenCode *tokenCode; //otp密码

@end

@implementation KYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  [self setupOtp:OTPKEY];
  [self setupTokenCode];
  
}

//otp
- (void)setupOtp:(NSString *)optkey
{
  
  KYFreeOTP *freeOTP = [[KYFreeOTP  alloc] init];
  
  KYOTPModel *oTPModel = [[KYOTPModel alloc] init];
  oTPModel.algorithm = KYFreeOTPSHA1Algorithm;
  oTPModel.tokenType = KYFreeOTPTokenTypeTotp;
  oTPModel.issuer    = @"123";
  oTPModel.uid       = @"123";
  oTPModel.secret    = optkey;
  oTPModel.digits    = 6;
  oTPModel.interval  = 30;
  
  [freeOTP addToken:oTPModel];
  
}


-(void)setupTokenCode {
  
  _tokenCode = nil;
  
  KYFreeOTP *freeOTP = [[KYFreeOTP alloc] init];
  _tokenCode = [freeOTP getTokenCode];
  [self showNumOnSixLabWithStr:_tokenCode.currentCode];
  
  //定时器
  [self invalidateDynamictimer];
  _dynamictimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setupDynamictimer) userInfo:nil repeats:YES];
  [_dynamictimer fire];
  [[NSRunLoop mainRunLoop] addTimer:_dynamictimer forMode:NSDefaultRunLoopMode];
  
}


-(void)setupDynamictimer {
  
  NSUInteger period = _tokenCode.period;
  NSUInteger countDown = period - (1.0f - _tokenCode.currentProgress) * period;
  
  KYFreeOTP *freeOTP = [[KYFreeOTP alloc] init];
  TokenCode *toenCode = [freeOTP getTokenCode];
  
  NSUInteger csountDown = toenCode.period - (1.0f - toenCode.currentProgress) * toenCode.period;
  
  NSLog(@"ss:%0.0f",(toenCode.currentProgress * 30) * 1000);
  
  //当跑完一次的时候再拿一次
 // if (countDown == 0) {
//    KYFreeOTP *freeOTP = [[KYFreeOTP alloc] init];
//    _tokenCode = [freeOTP getTokenCode];
 // }
  
  //赋值6个蓝色框框
  [self showNumOnSixLabWithStr:toenCode.currentCode];
  
  
}


//将6个数字显示到蓝色框框
- (void)showNumOnSixLabWithStr:(NSString *)string
{
  if (string.length == 0) {
    string = @"000000";
  }
  NSMutableArray *tempArr = [NSMutableArray array];
  for (int i = 0; i<string.length; i++) {
    NSString *tempStr = [string substringWithRange:NSMakeRange(i, 1)];
    [tempArr addObject:tempStr];
  }
 
  //显示到蓝色框框里面
  if (tempArr.count >= 6) {
    
    self.optLabel.text = string;
    [self changeWordSpaceForLabel:self.optLabel WithSpace:5];
  }
}

- (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space {
  
  NSString *labelText = label.text;
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
  paragraphStyle.alignment = NSTextAlignmentCenter;
  label.attributedText = attributedString;
  [label sizeToFit];
  
}


/**
 注销定时器
 */
- (void)invalidateDynamictimer {
  
  if ([_dynamictimer isValid]) {
    [_dynamictimer invalidate];
    _dynamictimer = nil;
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onAddToken:(id)sender {


  [self setupOtp:OTPKEY];
  [self setupTokenCode];
  
  
}

- (IBAction)onDelToken:(id)sender {
  
  if ([_dynamictimer isValid]) {
    [_dynamictimer invalidate];
    _dynamictimer = nil;
  }
  
  KYFreeOTP *freeOTP = [[KYFreeOTP  alloc] init];
  [freeOTP delToken:0];

 [self showNumOnSixLabWithStr:nil];
}


@end
