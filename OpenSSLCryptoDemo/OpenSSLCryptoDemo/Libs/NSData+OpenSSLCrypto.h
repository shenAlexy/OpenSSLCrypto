//
//  NSData+OpenSSLCrypto.h
//  squidVPN
//
//  Created by shenAlexy on 17/1/8.
//  Copyright © 2016年 shenAlexy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (OpenSSLCrypto)

#pragma mark - AES-256-cfd
/**
 AES-256-cfd加密

 @param keyData key data
 @param IVData IV data
 @param error error
 @return 加密后的数据
 */
- (NSData *)AES256EncryptedDataUsingKey:(NSData *)keyData IVData:(NSData *)IVData error:(NSError *)error;

/**
 AES-256-cfd解密

 @param keyData key data
 @param IVData IV data
 @param error error
 @return 解密后的数据
 */
- (NSData *)decryptedAES256DataUsingKey:(NSData *)keyData IVData:(NSData *)IVData error:(NSError *)error;

@end
