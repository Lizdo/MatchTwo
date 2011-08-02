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

@interface MTGame : CCNode{
    // Gameplay Related
    int score;
    float initialTime;
    float remainingTime;

    // Initial Value
    int rowNumber;
    int colomnNumber;
    
    NSMutableArray * MTPieces;
    
    CCNode * board;
    MTLine * line;
}


@end
