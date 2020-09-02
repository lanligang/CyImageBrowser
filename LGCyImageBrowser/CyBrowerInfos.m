//
//  CyBrowerInfos.m
//  manager
//
//  Created by ios2 on 2020/8/27.
//  Copyright © 2020 CY. All rights reserved.
//

#import "CyBrowerInfos.h"

@implementation CyBrowerInfo

- (BOOL)isWeb
{
    if ([_image isKindOfClass:[NSString class]]) {
        if (_image != nil && ([_image hasPrefix:@"http://"] || [_image hasPrefix:@"https://"])) return YES;
    }
    return NO;
}

@end

@implementation CyBrowerInfos

- (instancetype)init {
    self = [super init];
    if (self) {
        self.currentIndex = 0;
    }
    return self;
}

@end
