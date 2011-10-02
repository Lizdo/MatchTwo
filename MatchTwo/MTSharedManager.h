//
//  MTSharedManager.h
//  MatchTwo
//
//  Created by  on 11-8-8.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MTUnlockManager;
@class CCSprite;

@interface MTSharedManager : NSObject{
    BOOL noMusic;
    BOOL noSoundEffect;
    
    int totalScore;
    int level;
    int currentSceneID;
    
    // Level Design File
    NSMutableDictionary * levels;
    
    // Record the Level Progress
    NSMutableDictionary * progress;
    
    MTUnlockManager * unlockManager;
}

@property BOOL noMusic;
@property BOOL noSoundEffect;
@property int totalScore;
@property (readonly) int level;
@property (retain) MTUnlockManager * unlockManager;

+ (MTSharedManager *)instance;
- (void)save;
- (void)pause;
- (void)reset;

- (NSString *)nextLevelUnlockDescription;
- (CCSprite *)nextLevelUnlockBadge;

// Score Management
- (int)scoreForNextLevel;
- (int)scoreForLevel:(int)newLevel;

// Level Management
- (NSDictionary *)settingsForLevelID:(int)LevelID;
- (NSDictionary *)bonusSettings;
- (int)nextLevelID:(int)currentID;
- (int)levelForAbility:(NSString *)abilityName;

- (void)gotoNextLevel:(int)currentID;

- (NSMutableDictionary *)progressForLevel:(int)levelID;
- (void)completeLevel:(int)levelID andObjective:(BOOL)completeObj;

// Check Level Status
- (BOOL)locked:(int)levelID;
- (BOOL)completed:(int)levelID;
- (BOOL)objCompleted:(int)levelID;

// Scene Management
- (void)replaceSceneWithID:(int)sceneID;




@end
