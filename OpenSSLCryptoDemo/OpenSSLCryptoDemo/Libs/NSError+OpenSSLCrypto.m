//
//  NSError+OpenSSLCrypto.m
//  squidVPN
//
//  Created by shenAlexy on 17/1/8.
//  Copyright © 2016年 shenAlexy. All rights reserved.
//

#import "NSError+OpenSSLCrypto.h"
#import <openssl/err.h>
#import "OpenSSLError.h"

static dispatch_once_t loadErrorsOnce = 0;

@implementation NSError (OpenSSLCrypto)

+ (instancetype)errorFromOpenSSL {
    dispatch_once(&loadErrorsOnce, ^
                  {
                      ERR_load_crypto_strings();
                  });
    
    unsigned long errorCode = ERR_get_error();
    
    NSString *errorDescription;
    if (errorCode == 67522668) {
        errorDescription = @"";
    } else {
        char *errorMessage = malloc(130);
        if (errorMessage == NULL) {
            @throw [NSException outOfMemoryException];
        }
        ERR_error_string(errorCode, errorMessage);
        errorDescription = [NSString stringWithFormat:@"OpenSSL internal error! (Code=%lu,Description=%s)", errorCode, errorMessage];
        free(errorMessage);
    }
    
    return [NSError errorWithDomain:OpenSSLCryptoException
                               code:(NSUInteger)errorCode
                           userInfo:@{NSLocalizedDescriptionKey : errorDescription}];
}

@end

@implementation NSException (OpenSSLCrypto)

+ (instancetype)openSSLException {
    dispatch_once(&loadErrorsOnce, ^
                  {
                      ERR_load_crypto_strings();
                  });
    
    char *errorMessage = malloc(130);
    if (errorMessage == NULL) {
        @throw [NSException outOfMemoryException];
    }
    
    unsigned long errorCode = ERR_get_error();
    ERR_error_string(errorCode, errorMessage);
    NSString *errorDescription = [NSString stringWithFormat:@"OpenSLL internal error! (Code=%lu,Description=%s)",
                                  errorCode, errorMessage];
    
    NSException *instance =[NSException exceptionWithName:OpenSSLCryptoException
                                                   reason:[NSString stringWithFormat:@"[OpenSSL] ERROR: %s", errorMessage]
                                                 userInfo:@{NSLocalizedDescriptionKey : errorDescription}];
    free(errorMessage);
    return instance;
}

+ (instancetype)outOfMemoryException {
    return [NSException exceptionWithName:OpenSSLCryptoException reason:@"Not enough memory to decrypt." userInfo:nil];
}

@end
