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


@interface MTGame : CCNode{
    // Gameplay Related
    int score;
    float initialTime;
    float remainingTime;
        
    MTBoard * board;
    MTTimeLine * timeLine;
}

- (void)drawLinesWithPoints:(NSArray *)points;


@end
