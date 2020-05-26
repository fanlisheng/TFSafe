//
//  NSDictionary+Safe.m
//  KVOTest
//
//  Created by 范力升 on 2020/5/26.
//

#import "NSDictionary+Safe.h"
#import <objc/runtime.h>
#import "NSObject+ImpChangeTool.h"

@implementation NSDictionary (Safe)
+ (void)load{
    [self SwizzlingMethod:@"initWithObjects:forKeys:count:" systemClassString:@"__NSPlaceholderDictionary" toSafeMethodString:@"initWithObjects_st:forKeys:count:" targetClassString:@"NSDictionary"];
}
-(instancetype)initWithObjects_st:(id *)objects forKeys:(id<NSCopying> *)keys count:(NSUInteger)count {
    id safeObjects[count];
    id safeKeys[count];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < count; i++) {
        id key = keys[i];
        id obj = objects[i];
        //如果key或value有为空的情况，就跳过去
        if (!key || !obj) {
            /*
             break是结束整个循环，而continue是结束本次循环（跳过下一步），
             为了循环的继续，我们就必须选择continue.
             */
            continue;
        }
        //每一个value对应一个key，这个是相互对应的，详见demo。
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    self = [self initWithObjects_st:objects forKeys:keys count:j];
    return self;
}
@end
