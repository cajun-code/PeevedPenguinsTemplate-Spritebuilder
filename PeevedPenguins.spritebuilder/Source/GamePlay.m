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
    CCNode *_levelNode;
    CCNode *_contentNode;
    CCNode *_pullbackNode;
    CCNode *_mouseJointNode;
    CCPhysicsJoint *_mouseJoint;
    CCNode *_currentPenguin;
    CCPhysicsJoint *_penguinCatapultJoint;
}

-(void) didLoadFromCCB{
    self.userInteractionEnabled = YES;
    CCScene *level = [CCBReader loadAsScene:@"Levels/Level1"];
    [_levelNode addChild:level];
    _physicsNode.debugDraw = YES;
    _pullbackNode.physicsBody.collisionMask = @[];
    _mouseJointNode.physicsBody.collisionMask = @[];
    _physicsNode.collisionDelegate = self;
    
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    if (CGRectContainsPoint([_catapultArm boundingBox], touchLocation)) {
        _mouseJointNode.position = touchLocation;
        _mouseJoint = [CCPhysicsJoint connectedSpringJointWithBodyA:_mouseJointNode.physicsBody bodyB:_catapultArm.physicsBody anchorA:ccp(0, 0) anchorB:ccp(34, 138) restLength:0.f stiffness:3000.f damping:150.f];
        [self loadPenguinOnCatapult];
    }
}

-(void) touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    _mouseJointNode.position = touchLocation;
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    [self releaseCatapult];
}
-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
    [self releaseCatapult];
}

-(void)releaseCatapult{
    if (_mouseJoint != nil) {
        [_mouseJoint invalidate];
        _mouseJoint = nil;
        [self launchPeguin];
    }
}

-(void) loadPenguinOnCatapult{
    _currentPenguin = [CCBReader load:@"Penguin"];
    CGPoint penguinPosition = [_catapultArm convertToWorldSpace:ccp(34, 138)];
    _currentPenguin.position = [_physicsNode convertToNodeSpace:penguinPosition];
    [_physicsNode addChild:_currentPenguin];
    _currentPenguin.physicsBody.allowsRotation = NO;
    _penguinCatapultJoint = [CCPhysicsJoint connectedPivotJointWithBodyA:_currentPenguin.physicsBody bodyB:_catapultArm.physicsBody anchorA:_currentPenguin.anchorPointInPoints];
}

-(void) launchPeguin{
    [_penguinCatapultJoint invalidate];
    _penguinCatapultJoint = nil;
    
    _currentPenguin.physicsBody.allowsRotation = YES;
    
    CCActionFollow *follow = [CCActionFollow actionWithTarget:_currentPenguin worldBoundary:self.boundingBox];
    [_contentNode runAction:follow];
}

-(void) retry{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"GamePlay"]];
}

-(void) ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair seal:(CCNode *)nodeA wildcard:(CCNode *)nodeB{
    CCLOG(@"Something colided with a seal");
}
@end
