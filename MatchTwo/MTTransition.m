//
//  MTTransition.m
//  MatchTwo
//
//  Created by  on 11-10-19.
//  Copyright (c) 2011年 StupidTent co. All rights reserved.
//

#import "MTTransition.h"

@implementation MTTransitionCurtain


const uint32_t kSceneCurtain = 0xC697A141;

-(void) onEnter
{
	[super onEnter];
	CGSize s = [[CCDirector sharedDirector] winSize];
    
    [inScene_ setVisible: NO];
    
    // Create Curtain
    //curtain = [CCLayerColor layerWithColor:ccc4(ccORANGE.r, ccORANGE.g, ccORANGE.b, 255)];
    curtain = [CCSprite spriteWithFile:@"Background_Left.png"];
    
	[self addChild:curtain z:2 tag:kSceneCurtain];
    
    CGPoint top = ccp(s.width/2, s.height*1.5);
    CGPoint bottom = ccp(s.width/2, s.height/2);
    
    curtain.position = top;
    
    // Curtain Down
    CCActionInterval *curtainDown = [CCMoveTo actionWithDuration:duration_/4 
                                                         position:bottom];
    CCActionInterval *delay = [CCDelayTime actionWithDuration:duration_/2];
    CCActionInterval *curtainUp = [CCMoveTo actionWithDuration:duration_/4
                                                        position:top];
    
    CCSequence * actions = [CCSequence actions:curtainDown,
                            delay,
                            [CCCallFunc actionWithTarget:self selector:@selector(hideOutShowIn)],
                            curtainUp,
                            [CCCallFunc actionWithTarget:self selector:@selector(finish)],                             
                            nil];
    [curtain runAction:actions];
}


-(void) onExit
{
	[super onExit];
	[self removeChildByTag:kSceneCurtain cleanup:NO];
}

@end
