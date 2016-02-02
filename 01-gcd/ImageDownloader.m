//
//  ImageDownloader.m
//  01-gcd
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 xiaofeng. All rights reserved.
//

#import "ImageDownloader.h"

@implementation ImageDownloader
-(void)download{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"--------download picture---------");
    });
}
@end
