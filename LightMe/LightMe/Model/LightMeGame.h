//
//  LightMeGame.h
//  LightMe
//
//  Created by MengHua on 1/11/14.
//  Copyright (c) 2014 MengHua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LightMeMatrix.h"

@interface LightMeGame : NSObject

@property (nonatomic) NSUInteger level;
@property (nonatomic, readonly) NSUInteger steps;
@property (nonatomic, readonly) NSString *times;

- (instancetype)initWithLevelNumber:(NSUInteger)level;
- (NSInteger)getWidth;
- (NSInteger)getHeight;


- (LightMeCubeType)getCubeTypeAtRow:(NSInteger)row Column:(NSInteger)column;
- (void)hitCube:(NSUInteger)index;
- (BOOL)checkResult;

- (void)pause;
- (void)resume;
@end
