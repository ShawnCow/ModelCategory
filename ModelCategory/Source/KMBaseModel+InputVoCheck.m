//
//  KMBaseModel+InputVoCheck.m
//  
//
//  Created by Shawn on 2019/5/23.
//  Copyright © 2019 Shawn. All rights reserved.
//

#import "KMBaseModel+InputVoCheck.h"
#import <objc/runtime.h>

@implementation KMBaseModel (InputVoCheck)

- (BOOL)validateWithError:(NSError *__autoreleasing *)error
{
    NSString *checkProtocolString = @"<KMBaseModelInputVoRequired>";
    __block BOOL returnResult = YES;
    u_int count;
    objc_property_t *properties  = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count ; i++)
    {
        __block BOOL needBreak = NO;
        const char *attr = property_getAttributes(properties[i]);
        NSString *string = [NSString stringWithUTF8String:attr];
        NSString *match = @"\\<(.+?)\\>";
        NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:match options:NSRegularExpressionCaseInsensitive error:nil];
        [reg enumerateMatchesInString:string options:kNilOptions range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            NSString *protocolString = [string substringWithRange:result.range];
            if ([protocolString isEqualToString:checkProtocolString]) {
                NSString *propertyName = [NSString stringWithUTF8String:property_getName(properties[i])];
                id value = [self valueForKey:propertyName];
                if (value == nil) {
                    if (error) {
                        *error = [NSError errorWithDomain:@"KMBaseModelErrorDomain" code:10086 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@不能为空",propertyName]}];
                    }
                    returnResult = NO;
                    needBreak = YES;
                    *stop = YES;
                }
            }
        }];
        if (needBreak) {
            break;
        }
    }
    free(properties);
    return returnResult;
}

@end

@implementation NSObject (InputVoCheck)

@end
