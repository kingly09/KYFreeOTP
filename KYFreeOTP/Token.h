//
// FreeOTP
//
// Authors: Nathaniel McCallum <npmccallum@redhat.com>
//
// Copyright (C) 2013  Nathaniel McCallum, Red Hat
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#include "TokenCode.h"

@interface Token : NSObject
@property (nonatomic,copy) NSString* issuer;  //颁发者
@property (nonatomic,copy) NSString* label;   //标记者
@property (nonatomic,strong) NSURL* image;
@property (nonatomic, readonly) NSString* issuerDefault;
@property (nonatomic, readonly) NSString* labelDefault;
@property (nonatomic, readonly) NSURL* imageDefault;
@property (nonatomic, readonly) NSString* type;     //令牌类型（时间同步、事件同步、挑战/应答。）
@property (nonatomic, readonly) NSUInteger digits;  //otp的位数
@property (nonatomic, readonly) NSString* uid;      //用户id
@property (nonatomic, readonly) TokenCode* code;
- (id)initWithURL:(NSURL*)url;
- (id)initWithURL:(NSURL*)url internal:(BOOL)internal;
- (id)initWithString:(NSString*)string;
- (id)initWithString:(NSString*)string internal:(BOOL)internal;
@end
