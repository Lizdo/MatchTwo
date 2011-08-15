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
    int currentSceneID;
}

@property BOOL noMusic;
@property BOOL noSoundEffect;
@property int totalScore;

+ (MTSharedManager *)instance;
- (void)save;
- (void)pause;

- (NSDictionary *)settingsForLevelID:(int)LevelID;
- (int)nextLevelID:(int)currentID;
- (void)gotoNextLevel:(int)currentID;

- (void)replaceSceneWithID:(int)sceneID;


@end
