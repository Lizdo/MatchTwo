//
//  MTSharedManager.h
//  MatchTwo
//
//  Created by  on 11-8-8.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>

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
}

@property BOOL noMusic;
@property BOOL noSoundEffect;
@property int totalScore;
@property (readonly) int level;

+ (MTSharedManager *)instance;
- (void)save;
- (void)pause;
- (void)reset;

// Score Management
- (int)scoreForNextLevel;
- (int)scoreForLevel:(int)newLevel;

// Level Management
- (NSDictionary *)settingsForLevelID:(int)LevelID;
- (int)nextLevelID:(int)currentID;

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
