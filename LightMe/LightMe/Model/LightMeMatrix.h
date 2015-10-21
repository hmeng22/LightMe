//
//  LightMeMatrix.h
//  LightMe
//
//  Created by MengHua on 1/11/14.
//  Copyright (c) 2014 MengHua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LightMeCube.h"

@interface LightMeMatrix : NSObject

@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger height;
@property (nonatomic, strong) NSMutableArray *cubes;
@property (nonatomic) BOOL isCompleted;

- (instancetype)initMatrixwithLevel:(NSInteger)level;

- (NSInteger)cubeIndexInRow:(NSInteger)row Column:(NSInteger)column;
- (LightMeCube *)getCubeatRow:(NSInteger)row Column:(NSInteger)column;

- (void)hitCubeAtIndex:(NSInteger)index;

- (void)printMatrix;

@end
