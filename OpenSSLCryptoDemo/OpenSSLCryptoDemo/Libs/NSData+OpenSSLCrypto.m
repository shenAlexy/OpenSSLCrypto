//
//  NSData+OpenSSLCrypto.m
//  squidVPN
//
//  Created by shenAlexy on 17/1/8.
//  Copyright © 2016年 shenAlexy. All rights reserved.
//

#import "NSData+OpenSSLCrypto.h"
#import <openssl/evp.h>
#import <openssl/aes.h>
#import <openssl/err.h>
#import "NSError+OpenSSLCrypto.h"

@implementation NSData (OpenSSLCrypto)

//加密
- (NSData *)AES256EncryptedDataUsingKey:(NSData *)keyData IVData:(NSData *)IVData error:(NSError *)error {
    
    const EVP_CIPHER *evpCipher = EVP_aes_256_cfb();
    
    size_t blockLength = 0;
    size_t cipherBytesLength = 0;
    
    unsigned char *cipherBytes = (unsigned char *)malloc(self.length + AES_BLOCK_SIZE);
    
    memset(cipherBytes, 0, self.length + AES_BLOCK_SIZE);
    
    if (cipherBytes == NULL) {
        @throw [NSException outOfMemoryException];
    }
    
    EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
    
    if(!EVP_EncryptInit_ex(ctx, evpCipher, NULL, keyData.bytes, IVData.bytes)) {
        free(cipherBytes);
        if (error) {
            error = [NSError errorFromOpenSSL];
            return nil;
        }
    }
    
    if(!EVP_EncryptUpdate(ctx, cipherBytes, (int *) &blockLength, self.bytes, (int)self.length)) {
        free(cipherBytes);
        if (error) {
            error = [NSError errorFromOpenSSL];
        }
        return nil;
    }

    cipherBytesLength += blockLength;
    
    if(!EVP_EncryptFinal_ex(ctx, cipherBytes + cipherBytesLength, (int *) &blockLength)) {
        free(cipherBytes);
        if (error) {
            error = [NSError errorFromOpenSSL];
            return nil;
        }
    }
    
    cipherBytesLength += blockLength;
    
    EVP_CIPHER_CTX_cleanup(ctx);
    
    return [NSData dataWithBytes:cipherBytes length:cipherBytesLength];
}

//解密
- (NSData *)decryptedAES256DataUsingKey:(NSData *)keyData IVData:(NSData *)IVData error:(NSError *)error {
    
    size_t messageBytesLength = 0;
    size_t blockLength = 0;
    
    unsigned char *messageBytes = (unsigned char *) malloc(self.length);
    
    if (messageBytes == NULL) {
        @throw [NSException outOfMemoryException];
    }
    
    const EVP_CIPHER *evpCipher = EVP_aes_256_cfb();
    
    EVP_CIPHER_CTX *decryptCtx = EVP_CIPHER_CTX_new();
    
    if (!EVP_DecryptInit(decryptCtx, evpCipher, keyData.bytes, IVData.bytes)) {
        free(messageBytes);
        if (error) {
            error = [NSError errorFromOpenSSL];
            return nil;
        }
    }
    
    if (!EVP_DecryptUpdate(decryptCtx, messageBytes, (int *) &blockLength, self.bytes, (int) self.length)) {
        free(messageBytes);
        if (error) {
            error = [NSError errorFromOpenSSL];
            return nil;
        }
    }
    
    messageBytesLength += blockLength;

    if (!EVP_DecryptFinal(decryptCtx, messageBytes + messageBytesLength, (int *) &blockLength)) {
        free(messageBytes);
        if (error) {
            error = [NSError errorFromOpenSSL];
        }
        return nil;
    }
    
    messageBytesLength += blockLength;
    
    EVP_CIPHER_CTX_cleanup(decryptCtx);
    
    return [NSData dataWithBytes:messageBytes length:messageBytesLength];
}

@end
