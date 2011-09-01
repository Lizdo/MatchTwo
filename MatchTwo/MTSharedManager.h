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
    
    NSMutableDictionary * levels;
}

@property BOOL noMusic;
@property BOOL noSoundEffect;
@property int totalScore;
@property (readonly) int level;

+ (MTSharedManager *)instance;
- (void)save;
- (void)pause;

// Score Management
- (int)scoreForNextLevel;
- (int)scoreForLevel:(int)newLevel;

// Scene Management
- (NSDictionary *)settingsForLevelID:(int)LevelID;
- (int)nextLevelID:(int)currentID;
- (void)gotoNextLevel:(int)currentID;

- (void)replaceSceneWithID:(int)sceneID;


@end
