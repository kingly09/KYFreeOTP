# KYFreeOTP 是一个免费的otp算法生成类库
OTP全称叫One-time Password,也称动态口令，是根据专门的算法每隔60秒生成一个与时间相关的、不可预测的随机数字组合，每个口令只能使用一次，每天可以产生43200个密码。

# 名词解释

OTP 是 One-Time Password的简写，表示一次性密码。

HOTP 是HMAC-based One-Time Password的简写，表示基于HMAC算法加密的一次性密码。

TOTP 是Time-based One-Time Password的简写，表示基于时间戳算法的一次性密码。

# 简介

动态口令是一种安全便捷的帐号防盗技术，可以有效保护交易和登录的认证安全，采用动态口令就无需定期更换密码，安全省心，这是这项技术的一个额外价值，对企事业内部应用尤其有用。
动态令牌即是用来生成动态口令终端。

# 类型

OTP从技术来分有三种形式，（TOTP）时间同步、（HOTP）事件同步、（OCRA OTP ）挑战/应答。

（1）TOTP 时间同步

原理是基于动态令牌和动态口令验证服务器的时间比对，基于时间同步的令牌，一般每60秒产生一个新口令，要求服务器能够十分精确的保持正确的时钟，同时对其令牌的晶振频率有严格的要求，这种技术对应的终端是硬件令牌。

（2）HOTP 事件同步

基于事件同步的令牌，其原理是通过某一特定的事件次序及相同的种子值作为输入，通过HASH算法中运算出一致的密码。

（3）OCRA OTP 挑战/应答

常用于的网上业务，在网站/应答上输入服务端下发的挑战码，动态令牌输入该挑战码，通过内置的算法上生成一个6/8位的随机数字，口令一次有效，这种技术目前应用最为普遍，包括刮刮卡、短信密码、动态令牌也有挑战/应答形式。

主流的动态令牌技术是时间同步和挑战/应答两种形式。

OTP生成终端主流的有短信密码、动态令牌从终端来分类包含硬件令牌和手机令牌两种，手机令牌是安装在手机上的客户端软件。


# 原理介绍

### OTP基本原理

计算OTP串的公式

```
OTP(K,C) = Truncate(HMAC-SHA-1(K,C))
```


其中，

K表示秘钥串；

C是一个数字，表示随机数；

HMAC-SHA-1表示使用SHA-1做HMAC；

Truncate是一个函数，就是怎么截取加密后的串，并取加密后串的哪些字段组成一个数字。

对HMAC-SHA-1方式加密来说，Truncate实现如下。

* HMAC-SHA-1加密后的长度得到一个20字节的密串；
* 取这个20字节的密串的最后一个字节，取这字节的低4位，作为截取加密串的下标偏移量；
* 按照下标偏移量开始，获取4个字节，按照大端方式组成一个整数；
* 截取这个整数的后6位或者8位转成字符串返回。

Java代码实现，如下：


```
public static String generateOTP(String K,
                                      String C,
                                      String returnDigits,
                                      String crypto){
        int codeDigits = Integer.decode(returnDigits).intValue();
        String result = null;

        // K是密码
        // C是产生的随机数
        // crypto是加密算法 HMAC-SHA-1
        byte[] hash = hmac_sha(crypto, K, C);
        // hash为20字节的字符串

        // put selected bytes into result int
        // 获取hash最后一个字节的低4位，作为选择结果的开始下标偏移
        int offset = hash[hash.length - 1] & 0xf;

        // 获取4个字节组成一个整数，其中第一个字节最高位为符号位，不获取，使用0x7f
        int binary =
                ((hash[offset] & 0x7f) << 24) |
                ((hash[offset + 1] & 0xff) << 16) |
                ((hash[offset + 2] & 0xff) << 8) |
                (hash[offset + 3] & 0xff);
        // 获取这个整数的后6位（可以根据需要取后8位）
        int otp = binary % 1000000;
        // 将数字转成字符串，不够6位前面补0
        result = Integer.toString(otp);
        while (result.length() < codeDigits) {
            result = "0" + result;
        }
        return result;
    }

```

返回的结果就是看到一个数字的动态密码。


### HOTP基本原理

知道了OTP的基本原理，HOTP只是将其中的参数C变成了随机数

公式修改一下

```
HOTP(K,C) = Truncate(HMAC-SHA-1(K,C))
```

HOTP： Generates the OTP for the given count

即：C作为一个参数，获取动态密码。

HOTP的python代码片段：


```
lass HOTP(OTP):
    def at(self, count):
        """
        Generates the OTP for the given count
        @param [Integer] count counter
        @returns [Integer] OTP
        """
        return self.generate_otp(count)


```


 一般规定HOTP的散列函数使用SHA2，即：基于SHA-256 or SHA-512 [SHA2] 的散列函数做事件同步验证；


### TOTP基本原理


TOTP只是将其中的参数C变成了由时间戳产生的数字。

```
TOTP(K,C) = HOTP(K,C) = Truncate(HMAC-SHA-1(K,C))
```

不同点是TOTP中的C是时间戳计算得出。

```
C = (T - T0) / X;
```

T 表示当前Unix时间戳

技术分享

T0一般取值为 0.

X 表示时间步数，也就是说多长时间产生一个动态密码，这个时间间隔就是时间步数X，系统默认是30秒；

例如:

T0 = 0;

X = 30;

T = 30 ~ 59, C = 1; 表示30 ~ 59 这30秒内的动态密码一致。

T = 60 ~ 89, C = 2; 表示30 ~ 59 这30秒内的动态密码一致。

不同厂家使用的时间步数不同；

* 阿里巴巴的身份宝使用的时间步数是60秒；
* 宁盾令牌使用的时间步数是60秒；
* Google的 身份验证器的时间步数是30秒；
* 腾讯的Token时间步数是60秒；

TOTP的python代码片段：

```
class TOTP(OTP):
    def __init__(self, *args, **kwargs):
        """
        @option options [Integer] interval (30) the time interval in seconds
            for OTP This defaults to 30 which is standard.
        """
        self.interval = kwargs.pop(‘interval‘, 30)
        super(TOTP, self).__init__(*args, **kwargs)
    def now(self):
        """
        Generate the current time OTP
        @return [Integer] the OTP as an integer
        """
        return self.generate_otp(self.timecode(datetime.datetime.now()))

    def timecode(self, for_time):
        i = time.mktime(for_time.timetuple())
        return int(i / self.interval)
```

代码说明

self.interval 是时间步数X

datetime.datetime.now()为当前的Unix时间戳

timecode表示(T - T0) / X，即获取获取动态密码计算的随机数。

 
 

> TOTP 的实现可以使用HMAC-SHA-256或者HMAC-SHA-512散列函数；

# 系统

动态口令认证系统由动态口令认证服务器集群、动态口令令牌以及动态口令管理服务站点组成。

### 动态口令认证服务器群

包含动态口令认证服务器与备份动态口令认证服务器，其是动态口令认证系统的核心部分，安装在机房内，与业务系统服务器通过局域网相连，为内外部用户提供强身份认证，根据业务系统的授权，访问系统资源。动态口令认证服务器具有自身数据安全保护功能，所用户数据经加密后存储在数据库中，动态口令认证服务器与动态口令管理工作站的数据交换也是将数额变换后，以加密方式在网上传输。备份认证服务器是动态口令认证服务器的完全备份，它能够在动态口令认证服务器发生故障或检修时及时接管认证工作。


###  动态口令管理服务站点

包括管理员服务以及用户自助服务。

管理员服务：网络管理员可以进行网络配置、动态口令令牌的绑定、激活、用户信息修改、服务统计和用户查询等操作。

用户自助服务：终端用户可以对动态口令令牌的状态进行修改，包括挂失、停用等。

###  动态口令令牌

#### 软件令牌：

动态口令软件令牌是一种基于挑战/应答方式的手机客户端软件，在该软件上输入服务端下发的挑战码，客户端上生成一个6位的随机数字，这个口令只能使用一次，可以保证登录认证的安全，作为一个单机版的动态口令生成软件，在生成口令的过程中，不产生任何通信，保证口令不会在网络传输中被截取。


#### 硬件令牌：

动态口令硬件令牌是基于时间同步的硬件令牌，它每60秒变换一次OTP口令，口令一次有效，可以支持HMAC-SHA1算法，它产生6位/8位动态数字进行一次一密的方式认证，采用加密算法基于OATH标准算法(TOTP) ，采用大LCD显示屏、显示清晰，与其它相比较时间偏移量小，具有超大容量电池，可以保证产品防水、防拆、防摔，适应在特殊场合使用。 

##### 手机令牌：

动态口令手机令牌是推出了最新的身份认证终端，DKEY动态口令手机令牌是一种基于挑战/应答方式的手机客户端软件，在该软件上输入服务端下发的挑战码，手机软件上生成一个6位的随机数字，这个口令只能使用一次，可以充分的保证登录认证的安全，在生成口令的过程中，不会产生任何通信，保证密码不会在通信信道中被截取，也不会产生任何通信费用，手机作为动态口令生成的载体，欠费和无信号对其不产生任何影响，目前可以支持大部分主流的手机，如Symbian、Windows Phone、iPhone、Android等。

# 特点

（1）无需记忆

密码遗忘是令许多人头疼的问题。随着网络应用的普及，需要人们记忆的密码越来越多。动态口令卡使用户无需记忆多个密码。

（3）双重保险

动态口令认证系统采用双因素认证机制。用户即使将动态口令卡、账户同时丢失，也不会造成损失。

（4）迅速知情

在传统的认证机制下，用户密码往往是在不知情时丢失、被盗，危害发生后才有所察觉，只能亡羊补牢。动态口令令牌一旦丢失，用户会马上发现并及时挂失，防患未然。

（5）内外兼“固”

在信息系统的入侵者中，内部入侵者占80%以上。就电子商务站点而论，信息安全最薄弱环节是对内防范，如网管人员也能通过正常授权获得用户保密资料，对用户信息安全无疑是一种威胁。而动态口令认证系统把密钥生成和管理完全交给系统自动完成，最大限度地减少了人为因素，有效地防止了内部人员作案，使系统安全防范对内对外同样坚固。

（6）简单易行

IC卡认证、CA认证、指纹认证都需要专用终端认证设备的配合，应用范围受到很大限制，目前较多使用的USB KEY，也需要插入到电脑上，目前拥有大量使用者的电话交易就无法使用。动态口令令牌凡是在可以输入十进制数码的设备上都可以实现，简单使用。

 (7) 无缝兼容

该系统相对独立，接口简单，易与现有的电子商务站点认证系统对接，采用专用动态口令认证服务器进行认证，保障现有应用系统的完整性，保护系统资源。

# 使用场景


* 服务器登录动态密码验证（如阿里云ECS登录，腾讯机房服务器登录等）；
* 公司VPN登录双因素验证；
* 网络接入radius动态密码；
* 银行转账动态密码；
* 网银、网络游戏的实体动态口令牌；
* 等动态密码验证的应用场景。


# 参考资料

python的otp实现

https://pypi.python.org/pypi/pyotp

[https://github.com/pyotp/pyotp](https://github.com/pyotp/pyotp)

Google基于TOTP的开源实现 [https://github.com/google/google-authenticator](https://github.com/google/google-authenticator)

RFC6238中TOTP基于java代码的实现[https://github.com/gityf/java_demo/blob/master/demo/src/main/java/org/wyf/otp/TOTP.java](https://github.com/gityf/java_demo/blob/master/demo/src/main/java/org/wyf/otp/TOTP.java)


golang的一个otp做的不错的实现[https://github.com/gitchs/gootp](https://github.com/gitchs/gootp)


### RFC参考

RFC 4226 One-Time Password and HMAC-based One-Time Password.

RFC 6238 Time-based One-Time Password.

RFC 2104 HMAC Keyed-Hashing for Message Authentication.



