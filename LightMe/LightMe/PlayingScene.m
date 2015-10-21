//
//  PlayingScene.m
//  LightMe
//
//  Created by MengHua on 1/13/14.
//  Copyright (c) 2014 MengHua. All rights reserved.
//

#import "PlayingScene.h"
#import "LevelsScene.h"
#import "LightMeGame.h"

@interface PlayingScene()
@property BOOL contentCreated;
@property (nonatomic, strong) LightMeGame *game;
@end

@implementation PlayingScene

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor lightGrayColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    self.game = [[LightMeGame alloc] initWithLevelNumber:self.level];
    [self initScene];
}

- (void)initScene
{
    int width = [self.game getWidth];
    int height = [self.game getHeight];
    for (int row = 0; row < height; row++) {
        for (int column = 0; column < width; column++) {
            [self addCubeAtRow:row Column:column];
        }
    }
    
    SKLabelNode *backLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    backLabel.name = @"back";
    backLabel.text = @"back";
    backLabel.fontSize = 21;
    backLabel.position = CGPointMake(60, 30);
    [self addChild:backLabel];
    
    SKLabelNode *pauseLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    pauseLabel.name = @"pause";
    pauseLabel.text = @"Pause";
    pauseLabel.fontSize = 21;
    pauseLabel.position = CGPointMake(508, 30);
    [self addChild:pauseLabel];
    
    SKLabelNode *resetLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    resetLabel.name = @"reset";
    resetLabel.text = @"Reset";
    resetLabel.fontSize = 21;
    resetLabel.position = CGPointMake(508, 260);
    [self addChild:resetLabel];
    
}

- (void)addCubeAtRow:(NSInteger)row Column:(NSInteger)column
{
    NSString *imageName;
    switch ([self.game getCubeTypeAtRow:row Column:column]) {
        case SPACE:
            imageName = @"space";
            break;
        case LIGHT:
            imageName = @"light";
            break;
        case BRIGHT:
            imageName = @"bright";
            break;
        case BRICK:
            imageName = @"brick";
            break;
        case ZERO:
            imageName = @"brick0";
            break;
        case ONE:
            imageName = @"brick1";
            break;
        case TWO:
            imageName = @"brick2";
            break;
        case THREE:
            imageName = @"brick3";
            break;
        case FOUR:
            imageName = @"brick4";
        default:
            break;
    }
    //SKSpriteNode *cubeNode = [SKSpriteNode spriteNodeWithColor:spriteColor size:CGSizeMake(30, 30)];
    SKSpriteNode *cubeNode = [SKSpriteNode spriteNodeWithImageNamed:imageName];
    cubeNode.name = [NSString stringWithFormat:@"cubes%d", row * 10 + column];
    cubeNode.position = CGPointMake( 149 + column * 30, 320 - 25 - row * 30);
    [self addChild:cubeNode];
}

- (void)refreshFromIndex:(NSInteger)index
{
    int width = [self.game getWidth];
    int height = [self.game getHeight];
    
    int row = index / width;
    int column = index % width;
    
    for (int j = 0; j < width; j++) {
        [[self childNodeWithName:[NSString stringWithFormat:@"cubes%d",row * width + j]] removeFromParent];
        [self addCubeAtRow:row Column:j];
    }
    
    for (int i = 0; i < height; i++) {
        [[self childNodeWithName:[NSString stringWithFormat:@"cubes%d",i * width + column]] removeFromParent];
        [self addCubeAtRow:i Column:column];
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    SKNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:positionInScene];
    
    SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
    
    if ([touchedNode.name hasPrefix:@"cubes"]) {
        int index = [[touchedNode.name substringFromIndex:5] intValue];
        
        [self.game hitCube:index];
        
        //[self removeAllChildren];
        //[self initScene];
        [self refreshFromIndex:index];        
        
        if ([self.game checkResult]) {
            SKLabelNode *resetLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            resetLabel.name = @"Complete";
            resetLabel.text = @"Complete";
            resetLabel.fontSize = 21;
            resetLabel.position = CGPointMake(60, 260);
            [self addChild:resetLabel];
        }
        
    } else if ([touchedNode.name isEqualToString:@"back"]) {
        
        SKScene *levelScene = [[LevelsScene alloc] initWithSize:self.size];
        [self.view presentScene:levelScene transition:doors];
        
    } else if ([touchedNode.name isEqualToString:@"pause"]) {
        
        SKLabelNode *pauseLabel = (SKLabelNode *)touchedNode;
        if ([pauseLabel.text isEqualToString:@"Pause"]) {
            pauseLabel.text = @"Resume";
            [self.game pause];
        } else {
            pauseLabel.text = @"Pause";
            [self.game resume];
        }
        
    } else if ([touchedNode.name isEqualToString:@"reset"]) {
        
        self.game = [[LightMeGame alloc] initWithLevelNumber:self.level];
        [self removeAllChildren];
        [self initScene];
        
    }
}

@end
