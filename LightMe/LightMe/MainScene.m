//
//  MainScene.m
//  LightMe
//
//  Created by MengHua on 1/11/14.
//  Copyright (c) 2014 MengHua. All rights reserved.
//

#import "MainScene.h"
#import "LevelsScene.h"
#import "SettingScene.h"

@interface MainScene()
@property BOOL contentCreated;
@end

@implementation MainScene

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blueColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    [self initScene];
}

- (void)initScene
{
    SKLabelNode *startLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    startLabel.name = @"startlabel";
    startLabel.text = @"Start";
    startLabel.fontSize = 42;
    startLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:startLabel];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    SKNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:positionInScene];
    
    SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
    
    if ([touchedNode.name isEqualToString:@"startlabel"]) {
        SKScene *levelScene = [[LevelsScene alloc] initWithSize:self.size];
        [self.view presentScene:levelScene transition:doors];
    } else {
        NSLog(@"other touchs.");
        NSLog(@"%f,%f", positionInScene.x,positionInScene.y);
    }
}

@end
