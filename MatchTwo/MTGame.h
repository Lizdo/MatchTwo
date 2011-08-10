//
//  MTGame.h
//  MatchTwo
//
//  Created by  on 11-8-1.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MTPiece.h"
#import "MTLine.h"
#import "MTTimeLine.h"
#import "MTBoard.h"
#import "GameConfig.h"
#import "MTSFX.h"
#import "MTSharedManager.h"
#import "MTBackground.h"


@interface MTGame : CCNode{
    // Gameplay Related
    BOOL paused;
    
    int score;
    float initialTime;
    float remainingTime;
        
    MTBackground * background;
    MTBoard * board;
    MTTimeLine * timeLine;
    
    int numberOfTypes;
    
    CCLabelTTF * scoreLabel;
}

// Draw linked lines and pop SFX
- (void)drawLinesWithPoints:(NSArray *)points;

// Rester Current Game
- (void)restart;


@end
