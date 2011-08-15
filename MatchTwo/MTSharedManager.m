//
//  MTSharedManager.m
//  MatchTwo
//
//  Created by  on 11-8-8.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTSharedManager.h"
#import "MainMenuScene.h"
#import "ChallengeMenuScene.h"
#import "GameScene.h"
#import "MTGame.h"

@implementation MTSharedManager

@synthesize noMusic, noSoundEffect, totalScore;

static MTSharedManager * _instance = nil;


+ (id)alloc {
    @synchronized ([MTSharedManager class])
    {
        NSAssert(_instance == nil, @"Attempted to allocate a second instance of the Game Manager singleton");
        _instance = [super alloc];
        return _instance;
    }
    return nil; 
}

- (id)init
{
    self = [super init];
    if (self) {
        // Load from user defalts
        noMusic = [[NSUserDefaults standardUserDefaults] boolForKey:@"noMusic"];
        noSoundEffect = [[NSUserDefaults standardUserDefaults] boolForKey:@"noSoundEffect"];
        totalScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"totalScore"];
    }
    return self;
}

+ (MTSharedManager *)instance{
    @synchronized([MTSharedManager class])
    {
        if(!_instance)
            [[self alloc] init];
        return _instance;
    }
    return nil;
}

- (void)save{
    [[NSUserDefaults standardUserDefaults] setBool:noMusic forKey:@"noMusic"];
    [[NSUserDefaults standardUserDefaults] setBool:noSoundEffect forKey:@"noSoundEffect"];
    [[NSUserDefaults standardUserDefaults] setInteger:totalScore forKey:@"totalScore"];
}

- (void)pause{
    if (currentSceneID > 100) {
        // Game Scene
        CCScene * scene = [CCDirector sharedDirector].runningScene;
        GameScene * gameScene = (GameScene *)([scene.children lastObject]);
        MTGame * game = [gameScene game];
        [game pause];
    }
}

// Level ID: 10X, 101, 102, 103
//      Time = 100
//      Number of Piece = 9 + 2 * x


- (NSDictionary *)settingsForLevelID:(int)LevelID{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:3];
    [dic setObject:[NSNumber numberWithFloat:kMTDefaultGameTime] forKey:@"initialTime"];
    [dic setObject:[NSNumber numberWithInt:9 + (LevelID % 100 - 1) * 2] forKey:@"numberOfTypes"];    
    return dic;
}

- (int)nextLevelID:(int)currentID{
    int nextLevelID = 0;
    if (currentID % 100 + 1 < 12) {
        nextLevelID = currentID++;
    }else{
        nextLevelID = currentID/100*100 + 101;
    }
    if (nextLevelID >= 200) {
        nextLevelID = 0;
    }
    return nextLevelID;
}

- (void)gotoNextLevel:(int)currentID{
    int nextLevelID = [self nextLevelID:currentID];
    [self replaceSceneWithID:nextLevelID];
}

- (void)replaceSceneWithID:(int)sceneID{
    CCScene * scene;
    if (sceneID < 100) {
        switch (sceneID) {
            case 0:
            case 1:                
                // Main Menu
                scene = [MainMenuScene scene];
                break;
            case 2:
                scene = [ChallengeMenuScene scene];
                break;                
            default:
                scene = [MainMenuScene scene];                
                break;
        }
    }else{
        scene = [GameScene sceneWithID:sceneID];
    }
    
    currentSceneID = sceneID;
    
    [[CCDirector sharedDirector] replaceScene: 
        [CCTransitionFade transitionWithDuration:0.5f scene:scene]];
}

@end
