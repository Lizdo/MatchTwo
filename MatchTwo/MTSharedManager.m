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

@interface MTSharedManager ()
- (void)calculateLevel;
- (MTGame *)game;
@end

@implementation MTSharedManager

@synthesize noMusic, noSoundEffect, level;

static MTSharedManager * _instance = nil;

#pragma mark -
#pragma mark Init/Save/Load

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
        [self calculateLevel];
        
        // Load Level Design from plist
        NSString *plistPath;
        NSString *rootPath =
        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,        
                                             NSUserDomainMask, YES) objectAtIndex:0];
        plistPath = [rootPath stringByAppendingPathComponent:@"levels.plist"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
            plistPath = [[NSBundle mainBundle]
                         pathForResource:@"levels" ofType:@"plist"];
        }
        levels = [[NSMutableDictionary dictionaryWithContentsOfFile:plistPath]retain];
        
        // Load Progress from plist
        plistPath = [rootPath stringByAppendingPathComponent:@"progress.plist"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
            plistPath = [[NSBundle mainBundle]
                         pathForResource:@"progress" ofType:@"plist"];
        }
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
            // Need to create an empty dictionary
            progress = [[NSMutableDictionary dictionaryWithCapacity:10]retain];
        }else{
            // Read the file directly
            progress = [[NSMutableDictionary dictionaryWithContentsOfFile:plistPath]retain];
        }
        
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


- (MTGame *)game{
    // Game Scene
    CCScene * scene = [CCDirector sharedDirector].runningScene;
    GameScene * gameScene = (GameScene *)([scene.children lastObject]);
    MTGame * game = [gameScene game];
    return game;
}

- (void)save{
    [[NSUserDefaults standardUserDefaults] setBool:noMusic forKey:@"noMusic"];
    [[NSUserDefaults standardUserDefaults] setBool:noSoundEffect forKey:@"noSoundEffect"];
    [[NSUserDefaults standardUserDefaults] setInteger:totalScore forKey:@"totalScore"];
    
    
    // Save the level progress
    NSString *plistPath;
    NSString *rootPath =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,        
                                         NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"progress.plist"];
    [progress writeToFile:plistPath atomically:YES];
}

- (void)pause{
    if (currentSceneID > 100) {
        [[self game] pause];
    }
}

#pragma mark -
#pragma mark Score Management

- (void)setTotalScore:(int)s{
    if (s == totalScore) {
        return;
    }
    int currentLevel = level;
    totalScore = s;
    [self calculateLevel];
    
    // Trigger Level Up feedback
    if (level > currentLevel) {
        [[self game] levelUp];
    }
    return;
}

- (int)totalScore{
    return totalScore;
}

- (void)calculateLevel{
    for (int i = 1; i <= 100; i++) {
        if (totalScore < [self scoreForLevel:i+1]) {
            level = i;
            return;
        }
    }
    level = 100;
}
                           
- (int)scoreForNextLevel{
    return [self scoreForLevel:[self level]+1];
}



- (int)scoreForLevel:(int)l{
    float k2 = 0.001477744;
    float k1 = 0.572678;
    float k0 = 0.493872;
    float s = kMTTotalScorePerGame*(k2*l*l+k1*l+k0);
    return round(s/100)*100;
    //return (newLevel - 1) * 20000;
}




#pragma mark -
#pragma mark Level Management

// Level ID: 10X, 101, 102, 103
//      Time = 100
//      Number of Piece = 9 + 2 * x
//
//      initialTime
//      numberOfTypes
//      powerUpPercentage

- (NSDictionary *)settingsForLevelID:(int)LevelID{
//    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:3];
//    [dic setObject:[NSNumber numberWithFloat:kMTDefaultGameTime] forKey:@"initialTime"];
//    [dic setObject:[NSNumber numberWithInt:9 + (LevelID % 100 - 1) * 2] forKey:@"numberOfTypes"];    
//    return dic;
    return [levels objectForKey:[NSString stringWithFormat:@"%d",LevelID]];
}

- (int)nextLevelID:(int)currentID{
    int nextID = 0;
    if (currentID < 112) {
        nextID = currentID + 1;
    }
    return nextID;
}

- (void)gotoNextLevel:(int)currentID{
    int nextLevelID;
    nextLevelID = [self nextLevelID:currentID];
    [self replaceSceneWithID:nextLevelID];
}


# define kMTProgressComplete @"complete"
# define kMTProgressObjComplete @"objectiveComplete"

- (void)completeLevel:(int)levelID andObjective:(BOOL)completeObj{
    NSMutableDictionary * levelProgress = [self progressForLevel:levelID];
    if (levelProgress == nil) {
        // Need to create a new progress
        levelProgress = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], 
                         kMTProgressComplete,                         
                         [NSNumber numberWithBool:completeObj],
                         kMTProgressObjComplete,
                         nil];
        [progress setObject:levelProgress forKey:[NSNumber numberWithInt:levelID]];
    }else{
        // Need to update the info
        if ([[levelProgress objectForKey:kMTProgressComplete] boolValue] == NO) {
            // Level has not been completed before
            [levelProgress setObject:[NSNumber numberWithBool:YES] forKey:kMTProgressComplete] ;
            [levelProgress setObject:[NSNumber numberWithBool:completeObj] forKey:kMTProgressObjComplete];
        }else{
            // Level has been completed, just update the objective status
            if ([[levelProgress objectForKey:kMTProgressObjComplete] boolValue] == NO) {
                [levelProgress setObject:[NSNumber numberWithBool:completeObj] forKey:kMTProgressObjComplete];
            }
        }
    }
    [self save];
}

- (NSMutableDictionary *)progressForLevel:(int)levelID{
    return [progress objectForKey:[NSNumber numberWithInt:levelID]];
}

- (BOOL)locked:(int)levelID{
    if (levelID == 101)
        return NO;
    
    NSDictionary * previousLevelProgress = [self progressForLevel:levelID - 1];
    if ([[previousLevelProgress objectForKey:kMTProgressComplete] boolValue]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)completed:(int)levelID{
    return [[[self progressForLevel:levelID] objectForKey:kMTProgressComplete] boolValue];
}

- (BOOL)objCompleted:(int)levelID{
    return [[[self progressForLevel:levelID] objectForKey:kMTProgressObjComplete] boolValue];    
}


#pragma mark -
#pragma mark Scene Management

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
