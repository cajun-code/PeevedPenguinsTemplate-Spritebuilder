//
//  GamePlay.m
//  PeevedPenguins
//
//  Created by Allan Davis on 11/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GamePlay.h"
#import <cocos2d.h>


@implementation GamePlay{
    CCPhysicsNode *_physicsNode;
    CCNode *_catapultArm;
}

-(void) didLoadFromCCB{
    self.userInteractionEnabled = YES;
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    [self launchPeguin];
}


-(void) launchPeguin{
    CCNode *penguin = [CCBReader load: @"Penguin"];
    penguin.position = ccpAdd(_catapultArm.position, ccp(16, 50));
    [_physicsNode addChild:penguin];
    CGPoint launchDirection = ccp(1,0);
    CGPoint force = ccpMult(launchDirection, 8000);
    [penguin.physicsBody applyForce:force];
}
@end
