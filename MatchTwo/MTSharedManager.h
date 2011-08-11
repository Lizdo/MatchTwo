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
    BOOL isSoundEffectOn;
    
    int totalScore;
}

@property BOOL noMusic;
@property BOOL noSoundEffect;
@property int totalScore;

+ (MTSharedManager *)instance;
- (void)save;

- (NSDictionary *)settingsForLevelID:(int)LevelID;
- (int)nextLevelID:(int)currentID;

@end
