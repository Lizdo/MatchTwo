//
//  MTTransition.h
//  MatchTwo
//
//  Created by  on 11-10-19.
//  Copyright (c) 2011年 StupidTent co. All rights reserved.
//

#import "cocos2d.h"
#import "GameScene.h"

@interface MTTransitionCurtain : CCTransitionScene{
    CCNode * curtain;
    GameScene * gameScene;
}

+ (id)transitionWithDuration:(float)duration scene:(GameScene *)theScene;          
- (MTTransitionCurtain *)initWithDuration:(float)duration scene:(GameScene *)theScene;

@end
