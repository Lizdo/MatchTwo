//
//  MTTransition.m
//  MatchTwo
//
//  Created by  on 11-10-19.
//  Copyright (c) 2011年 StupidTent co. All rights reserved.
//

#import "MTTransition.h"
#import "MTSharedManager.h"
#import "MTGame.h"


@implementation MTTransitionCurtain


const uint32_t kSceneCurtain = 0xC697A141;

- (MTTransitionCurtain *)initWithDuration:(float)duration scene:(GameScene *)theScene{
    self = [super initWithDuration:duration scene:theScene];
    if (self) {
        gameScene = theScene;
    }
    return self;
}

+ (id)transitionWithDuration:(float)duration scene:(GameScene *)theScene{
   return [[[MTTransitionCurtain alloc]initWithDuration:duration scene:theScene] autorelease];
}


- (void) onEnter
{
	[super onEnter];
	CGSize s = [[CCDirector sharedDirector] winSize];
    
    [inScene_ setVisible: NO];
    
    // Create Curtain
    //curtain = [CCLayerColor layerWithColor:ccc4(ccORANGE.r, ccORANGE.g, ccORANGE.b, 255)];
    curtain = [CCSprite spriteWithFile:@"Curtain.png"];
    
	[self addChild:curtain z:2 tag:kSceneCurtain];
    
    CGPoint top = ccp(s.width/2, s.height*1.5);
    CGPoint bottom = ccp(s.width/2, s.height/2);
    
    curtain.position = top;
    
    // Add Level Stats
    MTGame * game = [gameScene game];
    NSDictionary * settings = [[MTSharedManager instance] settingsForLevelID:[game levelID]];
    
    NSString * time = [NSString stringWithFormat:@"时间限制: %3.0f秒", [[settings objectForKey:kMTSInitialTime] floatValue]];
    CCLabelTTF * timeLabel = [CCLabelTTF labelWithString:time
                                                fontName:kMTFont
                                                fontSize:kMTFontSizeLarge];
    [curtain addChild:timeLabel];
    timeLabel.position = ccp(s.width/2, s.height/2 + 100);
    
    NSString * difficulty = [NSString stringWithFormat:@"难度: %d", [game levelID]/100];
    CCLabelTTF * difficultyLabel = [CCLabelTTF labelWithString:difficulty
                                                fontName:kMTFont
                                                fontSize:kMTFontSizeLarge];
    [curtain addChild:difficultyLabel];
    difficultyLabel.position = ccp(s.width/2, s.height/2);    
    
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
