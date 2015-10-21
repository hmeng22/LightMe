//
//  ViewController.m
//  LightMe
//
//  Created by MengHua on 1/11/14.
//  Copyright (c) 2014 MengHua. All rights reserved.
//

#import "ViewController.h"
#import "MainScene.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    SKView *skView = (SKView *)self.view;
    skView.showsDrawCount = YES;
    skView.showsNodeCount = YES;
    skView.showsFPS = YES;

}

- (void)viewWillLayoutSubviews
{
    MainScene *mainScene = [[MainScene alloc] initWithSize:self.view.bounds.size];
    SKView *skView = (SKView *)self.view;
    [skView presentScene:mainScene];
}

@end
