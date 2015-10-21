//
//  LightMeGame.m
//  LightMe
//
//  Created by MengHua on 1/11/14.
//  Copyright (c) 2014 MengHua. All rights reserved.
//

#import "LightMeGame.h"

@interface LightMeGame()
@property (nonatomic, strong) LightMeMatrix *matrix;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, readwrite) NSUInteger steps;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic, readwrite) NSString *times;
@end

@implementation LightMeGame

- (instancetype)initWithLevelNumber:(NSUInteger)level
{
    self = [super init];
    
    if (self) {
        self.matrix = [[LightMeMatrix alloc] initMatrixwithLevel:level];
        
        self.startTime = [[NSDate date] timeIntervalSince1970];
        //self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimes:) userInfo:Nil repeats:YES];
        self.steps = 0;
        
    }
    
    return self;
}

- (NSInteger)getWidth
{
    return self.matrix.width;
}

- (NSInteger)getHeight
{
    return self.matrix.height;
}

- (LightMeCubeType)getCubeTypeAtRow:(NSInteger)row Column:(NSInteger)column
{
    return [self.matrix getCubeatRow:row Column:column].type;
}

- (void)hitCube:(NSUInteger)index
{
    [self.matrix hitCubeAtIndex:index];
}

- (BOOL)checkResult
{
    return self.matrix.isCompleted;
}

- (void)updateTimes:(NSTimer *)timer
{
    self.times = [NSString stringWithFormat:@"%.2f",[[NSDate date] timeIntervalSince1970] - self.startTime];
    NSLog(@"%@",self.times);
}

- (void)pause
{
    
}

- (void)resume
{
    
}

@end
