//
//  LevelsScene.m
//  LightMe
//
//  Created by MengHua on 1/13/14.
//  Copyright (c) 2014 MengHua. All rights reserved.
//

#import "LevelsScene.h"
#import "MainScene.h"
#import "PlayingScene.h"


@interface LevelsScene()
@property BOOL contentCreated;
@property NSUInteger levelsNumber;
@property NSUInteger pageNumber;
@end

@implementation LevelsScene
- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated) {
        
        self.pageNumber = 0;
        self.levelsNumber = 31;
        
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor grayColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    [self initSceneWithPageNumber:self.pageNumber];
}

const int lineNumber = 4;

- (void)initSceneWithPageNumber:(NSInteger)pageNumber
{
    for (int i = 0; i < lineNumber; i++) {
        for (int j = 0; j < lineNumber; j++) {
            if (pageNumber * lineNumber * lineNumber + i * lineNumber + j + 1 > self.levelsNumber) {
                break;
            }
            SKSpriteNode *levelOutterNode = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(80, 40)];
            SKLabelNode *levelNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            levelNode.name = @"text";
            levelNode.text = [NSString stringWithFormat:@"%ld", pageNumber * lineNumber * lineNumber + i * lineNumber + j + 1];
            levelNode.fontSize = 21;
            levelNode.position = CGPointMake(0, 0);
            levelOutterNode.name = @"levels";
            levelOutterNode.position = CGPointMake( 120 + j * 100, 320 - 60 - i * 60);
            [levelOutterNode addChild:levelNode];
            [self addChild:levelOutterNode];
        }
    }
    
    SKLabelNode *backLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    backLabel.name = @"back";
    backLabel.text = @"Back";
    backLabel.fontSize = 21;
    backLabel.position = CGPointMake(35, 22);
    [self addChild:backLabel];
    
    SKLabelNode *nextLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    nextLabel.name = @"next";
    nextLabel.text = @"Next";
    nextLabel.fontSize = 21;
    nextLabel.position = CGPointMake(533, 22);
    [self addChild:nextLabel];
    
    SKLabelNode *previousLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    previousLabel.name = @"previous";
    previousLabel.text = @"Previous";
    previousLabel.fontSize = 21;
    previousLabel.position = CGPointMake(440, 22);
    [self addChild:previousLabel];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    SKLabelNode *touchedNode = (SKLabelNode *)[self nodeAtPoint:positionInScene];
    
    SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
    
    if ([touchedNode.name isEqualToString:@"levels"]) {
        
        PlayingScene *playingScene = [[PlayingScene alloc] initWithSize:self.size];
        SKLabelNode *levelNode = (SKLabelNode *)[touchedNode childNodeWithName:@"text"];
        playingScene.level = [levelNode.text intValue];
        [self.view presentScene:playingScene transition:doors];
        
    } else if ([touchedNode.name isEqualToString:@"next"]) {
        
        [self removeAllChildren];
        if (self.levelsNumber > (self.pageNumber + 1) * 5 * 5)self.pageNumber++;
        [self initSceneWithPageNumber:self.pageNumber];
        
    } else if ([touchedNode.name isEqualToString:@"previous"]) {
        
        [self removeAllChildren];
        if (self.pageNumber>0)self.pageNumber--;
        [self initSceneWithPageNumber:self.pageNumber];
        
    } else if ([touchedNode.name isEqualToString:@"back"]) {
        
        MainScene *mainScene = [[MainScene alloc] initWithSize:self.view.bounds.size];
        [self.view presentScene:mainScene transition:doors];
        
    }
}

@end
