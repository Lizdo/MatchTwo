//
//  MTUnlockManager.h
//  MatchTwo
//
//  Created by  on 11-9-30.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"
#import "MTSharedManager.h"

@interface MTUnlockManager : NSObject{
    NSMutableArray * unlocks;   // Array for unlocks
}

// Interface for UI/Description
- (NSString *)descriptionForLevel:(int)level;
- (CCSprite *)badgeForLevel:(int)level;

- (int)leveForAbility:(NSString *)abilityName;
- (NSDictionary *)bonusUnlocks;

@end

#pragma mark -
#pragma mark Unlock Item Definition

@interface MTUnlockItem : NSObject {
}

+ (id)item;
- (CCSprite *)badge;

@end

@interface MTUnlockAbility : MTUnlockItem{
    NSString * ability;
    int level;
}

@property (retain) NSString * ability;
@property int level;

+ (id)itemWithAbility:(NSString *)n level:(int)l;

@end


@interface MTUnlockExtraTime : MTUnlockItem

@end

@interface MTUnlockExtraScore : MTUnlockItem
    
@end

@interface MTUnlockExtraBonus : MTUnlockItem

@end