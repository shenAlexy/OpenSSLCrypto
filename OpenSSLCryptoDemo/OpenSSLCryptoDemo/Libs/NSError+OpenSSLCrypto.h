//
//  NSError+OpenSSLCrypto.h
//  squidVPN
//
//  Created by shenAlexy on 17/1/8.
//  Copyright © 2016年 shenAlexy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (OpenSSLCrypto)

/**
 (容错处理)error descriptions from OpenSSL

 @return Instance
 */
+ (instancetype)errorFromOpenSSL;

@end

@interface NSException (OpenSSLCrypto)

+ (instancetype)openSSLException;

+ (instancetype)outOfMemoryException;

@end
