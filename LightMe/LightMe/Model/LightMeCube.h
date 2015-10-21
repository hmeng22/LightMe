//
//  LightMeCube.h
//  LightMe
//
//  Created by MengHua on 1/11/14.
//  Copyright (c) 2014 MengHua. All rights reserved.
//

#import <Foundation/Foundation.h>

// 方格类型
typedef enum{
    SPACE = 0,
    LIGHT = 1,
    BRIGHT = -1,
    BRICK = 9,
    ZERO = 10,
    ONE = 11,
    TWO = 12,
    THREE = 13,
    FOUR = 14,
}LightMeCubeType;

@interface LightMeCube : NSObject

@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger number;
@property (nonatomic) BOOL statusChanged;

@end
