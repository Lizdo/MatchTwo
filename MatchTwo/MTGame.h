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
#import "MTTouchToStartLayer.h"


#define kMTSInitialTime @"initialTime"
#define kMTSNumberOfTypes @"numberOfTypes"
#define kMTSObjective @"objective"
#define kMTNumberOfRows @"rows"
#define kMTNumberOfColumns @"columns"

@interface MTGame : CCNode <MTTouchToStartProtocol>{
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
    
    CCLayer * gameLayer;
    CCLayer * menuLayer;
    CCLayer * backgroundLayer;
    
    MTTouchToStartLayer * tapToStart;
    
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
    MTObjectiveState objState;
    
    float scoreMultiplier;
    float bonusMultiplier;    
    
    //BOOL objFailed;
    
    // Helper Array
    NSMutableArray * abilities;
    NSMutableArray * abilityButtons;    
    
    // Particles
    CCParticleSystemQuad * dissolveParticle1;
    CCParticleSystemQuad * dissolveParticle2;    
    
}

@property (retain) CCMenu * menu;
@property (retain) CCNode * menuBackground;
@property int levelID;
@property (readonly) float remainingTime;
@property MTObjective obj;
@property MTObjectiveState objState;

@property int timeBonus;
@property int objBonus;
@property int completeBonus;

- (id)initWithLevelID:(int)levelID;


// Restart Current Game
- (void)restart;
- (void)pause;
- (void)resume;
- (void)restartFromPauseMenu;
- (void)resumeFromPauseMenu;

- (void)levelUp;

// Draw linked lines and pop SFX
- (void)linkDissolved:(NSArray *)points;

// Display Related
- (NSString *)remainingTimeString;
- (NSString *)objectiveString;

// Shuffle the board, when no move is available
- (void)shuffle;
+ (CGPoint)positionForPiece:(MTPiece *)piece;
+ (CGPoint)positionForRow:(int)row andColumn:(int)column;

// Ability Related Internal Method
- (MTAbility *)abilityNamed:(NSString *)name;
- (BOOL)isAbilityActive:(NSString *)name;
- (BOOL)isAbilityReady:(NSString *)name;

- (void)abilityButtonClicked:(MTAbilityButton *)button;
- (void)activateAbility:(NSString *)n;

- (void)flyBadge:(CCSprite *)badge forAbility:(NSString *)abilityName;

@end
