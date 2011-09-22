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
#import "MTTimeDisplay.h"
#import "MTBoard.h"
#import "GameConfig.h"
#import "MTSFX.h"
#import "MTSharedManager.h"
#import "MTBackground.h"
#import "MTAbility.h"
#import "MTAbilityButton.h"
#import "MTFloatingLabel.h"
#import "MTScoreDisplay.h"
#import "MTLevelCompletePage.h"
#import "MTLevelFailPage.h"
#import "MTPausePage.h"
#import "MTObjectiveHelper.h"


@interface MTGame : CCNode{
    // Gameplay Related
    BOOL paused;
    
    int score;
    float initialTime;
    float remainingTime;
    int scoreAtLevelStart;

    BOOL needShuffleCheck;
    
    // Score Related
    int timeBonus;
    int objBonus; 
    int completeBonus;
    
    // CCNodes
    MTBackground * background;
    MTBoard * board;
    MTTimeDisplay * timeDisplay;
    MTPausePage * pauseMenu;    
    
    //MTTimeLine * timeLine;

    CCNode * menuBackground; 
    CCMenu * menu;
    CCMenu * buttons;
    MTScoreDisplay * scoreDisplay;
    MTFloatingLabelManager * floatingLabels;
    
    // Level Configs
    int numberOfTypes;
    int levelID;
    MTObjective obj;
    BOOL objFailed;
    
    // Helper Array
    NSMutableArray * abilities;
    NSMutableArray * abilityButtons;    
    
    
    
}

@property (retain) CCMenu * menu;
@property (retain) CCNode * menuBackground;
@property int levelID;
@property (readonly) float remainingTime;
@property MTObjective obj;
@property BOOL objFailed;

@property int timeBonus;
@property int objBonus;
@property int completeBonus;

- (id)initWithLevelID:(int)levelID;

// Draw linked lines and pop SFX
- (void)drawLinesWithPoints:(NSArray *)points;

// Restart Current Game
- (void)restart;
- (void)pause;
- (void)resume;
- (void)restartFromPauseMenu;
- (void)resumeFromPauseMenu;

- (void)levelUp;

- (void)linkDissolved;

// Display Related
- (NSString *)remainingTimeString;
- (NSString *)objectiveString;

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
