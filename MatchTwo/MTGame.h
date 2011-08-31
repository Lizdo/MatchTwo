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
#import "MTAbility.h"
#import "MTAbilityButton.h"
#import "MTFloatingLabel.h"
#import "MTScoreDisplay.h"

@interface MTGame : CCNode{
    // Gameplay Related
    BOOL paused;
    
    int score;
    float initialTime;
    float remainingTime;

    BOOL needShuffleCheck;
        
    MTBackground * background;
    MTBoard * board;
    MTTimeLine * timeLine;

    CCNode * menuBackground; 
    CCMenu * menu;
    CCMenu * buttons;

    
    int numberOfTypes;
    int levelID;
    
    NSMutableArray * abilities;
    NSMutableArray * abilityButtons;    
    
    MTScoreDisplay * scoreDisplay;
}

@property (retain) CCMenu * menu;
@property (retain) CCNode * menuBackground;

- (id)initWithLevelID:(int)levelID;

// Draw linked lines and pop SFX
- (void)drawLinesWithPoints:(NSArray *)points;

// Restart Current Game
- (void)restart;
- (void)pause;
- (void)resume;

- (void)linkDissolved;

// Shuffle the board, when no move is available
- (void)shuffle;
- (CGPoint)positionForPiece:(MTPiece *)piece;

// Ability Related Internal Method
- (MTAbility *)abilityNamed:(NSString *)name;
- (BOOL)isAbilityActive:(NSString *)name;
- (BOOL)isAbilityReady:(NSString *)name;

- (void)abilityButtonClicked:(MTAbilityButton *)button;
- (void)activateAbility:(NSString *)n;

- (void)flyBadge:(CCSprite *)badge forAbility:(NSString *)abilityName;

@end
