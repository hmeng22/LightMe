//
//  LightMeMatrix.m
//  LightMe
//
//  Created by MengHua on 1/11/14.
//  Copyright (c) 2014 MengHua. All rights reserved.
//

#import "LightMeMatrix.h"
#import "LightMeCube.h"
#import "GDataXMLNode.h"

@implementation LightMeMatrix

- (NSMutableArray *)cubes
{
    if (!_cubes) _cubes = [[NSMutableArray alloc] init];
    return _cubes;
}

- (instancetype)initMatrixwithLevel:(NSInteger)level
{
    self = [super init];
    
    if (self) {
        // 读取文件, 设定Matrix
        NSString *xmlPath = [[NSBundle mainBundle] pathForResource:@"map" ofType:@"xml"];
        NSString *xmlString = [NSString stringWithContentsOfFile:xmlPath encoding:NSUTF8StringEncoding error:nil];
        GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil];
        GDataXMLElement *rootElement = [xmlDoc rootElement];
        NSArray *levelElements = [rootElement children];
        
        //NSLog(@"level count : %d", [levelElements count]);
        
        for (int levelNum = 0; levelNum < [levelElements count]; levelNum++) {
            GDataXMLElement *levelElement = [levelElements objectAtIndex:levelNum];
            
            if ([[levelElement name] isEqualToString:@"level"] && [[[levelElement attributeForName:@"id"] stringValue] intValue] == level) {
                NSLog(@"level is : %ld.", (long)level);
                self.width = [[[levelElement attributeForName:@"width"] stringValue] intValue];
                self.height = [[[levelElement attributeForName:@"height"] stringValue] intValue];
                self.isCompleted = FALSE;
                //NSLog(@"width is : %d. height is %d. Completed? %d", self.width,self.height,self.isCompleted);
                
                for (int row = 0; row < self.height; row++) {
                    for (int column = 0; column < self.width; column++) {
                        LightMeCube *cube = [[LightMeCube alloc] init];
                        cube.type = SPACE;
                        cube.number = 0;
                        [self.cubes insertObject:cube atIndex:[self cubeIndexInRow:row Column:column]];
                    }
                }
                
                NSArray *cubeElements = [levelElement children];
                
                //NSLog(@"cube count : %d", [cubeElements count]);
                
                for (int cubeNum = 0; cubeNum < [cubeElements count]; cubeNum++) {
                    GDataXMLElement *cubeElement = [cubeElements objectAtIndex:cubeNum];
                    int row = [[[cubeElement attributeForName:@"row"] stringValue] intValue];
                    int column = [[[cubeElement attributeForName:@"column"] stringValue] intValue];
                    
                    NSArray *valueElements = [cubeElement children];
                    
                    for (int valueNum = 0; valueNum < [valueElements count]; valueNum++) {
                        GDataXMLElement *valueElement = [valueElements objectAtIndex:valueNum];
                        
                        if ([[valueElement name] isEqualToString:@"type"]) {
                            int type = [[valueElement stringValue] intValue];
                            [self getCubeatRow:row Column:column].type = type;
                        }
                        
                    }
                }
                break;
            }
            
        }
    }
    
    return self;
}

#pragma mark - helper
- (NSInteger)cubeIndexInRow:(NSInteger)row Column:(NSInteger)column
{
    return row * self.width + column;
}

- (LightMeCube *)getCubeatRow:(NSInteger)row Column:(NSInteger)column
{
    return [self.cubes count] > [self cubeIndexInRow:row Column:column] ? [self.cubes objectAtIndex:[self cubeIndexInRow:row Column:column]] : Nil;
}

- (void)printMatrix
{
    NSLog(@"Printing Matrix:");
    for (int row = 0; row < self.height; row++) {
        for (int column = 0; column < self.width; column++) {
            LightMeCube *cube = self.cubes[[self cubeIndexInRow:row Column:column]];
            if (cube.type == SPACE) {
                printf("口 ");
            }
            else if (cube.type == LIGHT) {
                printf("灯 ");
            }
            else if (cube.type == BRICK) {
                printf("砖 ");
            }
            else if (cube.type == BRIGHT) {
                printf("亮 ");
            }
            else if (cube.type == ZERO) {
                printf("零 ");
            }else if (cube.type == ONE) {
                printf("一 ");
            }else if (cube.type == TWO) {
                printf("二 ");
            }else if (cube.type == THREE) {
                printf("三 ");
            }else if (cube.type == FOUR) {
                printf("四 ");
            }else {
                printf("啥 ");
            }
        }
        NSLog(@" ");
    }
    NSLog(@"Printing Matrix End.");
}

#pragma mark - Logical
- (void)hitCubeAtIndex:(NSInteger)index
{
    //NSLog(@"Cube %d is hitted!",index);
    if ([self.cubes count] > index) {
        LightMeCube *cube = self.cubes[index];
        
        if (cube.type == SPACE) {
            cube.type = LIGHT;
        } else if (cube.type == LIGHT){
            cube.type = SPACE;
        }
        
        // 清空BRIGHT
        for (int row = 0; row < self.height; row++) {
            for (int column = 0; column < self.width; column++) {
                LightMeCube *cube = self.cubes[[self cubeIndexInRow:row Column:column]];
                if (cube.type == BRIGHT) {
                    cube.type = SPACE;
                }
            }
        }
        
        // 点亮BRIGHT
        for (int row = 0; row < self.height; row++) {
            for (int column = 0; column < self.width; column++) {
                LightMeCube *cube = self.cubes[[self cubeIndexInRow:row Column:column]];
                if (cube.type == LIGHT) {
                    [self lightAllFromRow:row Column:column];
                }
            }
        }
        
        // 检查结果
        self.isCompleted = [self checkMatrix];
        
    } else
        NSLog(@"没有 %ld 节点.", (long)index);
   
}

static const int direction[4][4] = {{0,-1},{-1,0},{0,1},{1,0}};
- (void)lightAllFromRow:(NSInteger)row Column:(NSInteger)column
{
    for (int dir = 0; dir < 4; dir++) {
        if ([self lightLineAtRow:row Column:column Direction:dir]) {
            //NSLog(@"Switch %d Success.",dir);
        } else {
            //NSLog(@"Swithc %d Failure. Brick or Boundary?",dir);
        }
    }
}

- (BOOL)lightLineAtRow:(NSInteger)row Column:(NSInteger)column Direction:(NSInteger)dir
{
    int nextRow = (int)row + direction[dir][0];
    int nextColumn = (int)column + direction[dir][1];
    //NSLog(@"Row:%d, Column:%d. Type:%d",nextRow,nextColumn,[self getCubeatRow:nextRow Column:nextColumn].type);
    if (nextRow >= 0 && nextRow < self.height && nextColumn >= 0 && nextColumn < self.width) {
        if ([self getCubeatRow:nextRow Column:nextColumn].type == SPACE || [self getCubeatRow:nextRow Column:nextColumn].type == BRIGHT ) {
            [self getCubeatRow:nextRow Column:nextColumn].type = BRIGHT;
            [self lightLineAtRow:nextRow Column:nextColumn Direction:dir];
        }
    } else {
        return FALSE;
    }
    return TRUE;
}

- (BOOL)checkMatrix
{
    for (int row = 0; row < self.height; row++) {
        for (int column = 0; column < self.width; column++) {
            LightMeCube *cube = self.cubes[[self cubeIndexInRow:row Column:column]];
            if (cube.type == SPACE) {
                NSLog(@"Row:%d Column:%d is SPACE.",row,column);
                return FALSE;
            }
            
            if (cube.type == ZERO || cube.type == ONE || cube.type == TWO || cube.type == THREE || cube.type == FOUR) {
                int lightNum = ZERO;
                for (int dir = 0; dir < 4; dir++) {
                    int nextRow = row + direction[dir][0];
                    int nextColumn = column + direction[dir][1];
                    if ([self getCubeatRow:nextRow Column:nextColumn].type == LIGHT) {
                        lightNum++;
                    }
                }
                
                if (cube.type != lightNum) {
                    NSLog(@"Row:%d Column:%d is LIGHT FALSE.",row,column);
                    return FALSE;
                }
            }
            
        }
    }
    return TRUE;
}

@end
