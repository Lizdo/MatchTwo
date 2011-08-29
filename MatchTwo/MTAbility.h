//
//  MTAbility.h
//  MatchTwo
//
//  Created by  on 11-8-16.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


#pragma mark Type Defines

// Ready -> Active -> Cooldown

typedef enum {
    MTAbilityState_Ready,
    MTAbilityState_Active,
    MTAbilityState_CoolDown,
}MTAbilityState;

// Active Abilities are triggered by player input by using a user button

typedef enum {
    MTAbilityType_Active,
    MTAbilityType_Passive,    
}MTAbilityType;


#pragma mark -
#pragma mark MTAbility Base Class

@interface MTAbility : NSObject{
    float tickingTime;
    float activeTime;
    float cooldownTime;
    
    MTAbilityState state;
    MTAbilityType type;
    NSString * name;
}

@property MTAbilityState state;
@property (readonly) MTAbilityType type;
@property (readonly, retain) NSString * name;

- (void)update:(ccTime)dt;

- (float)cooldownPercentage;
- (void)activate;
- (BOOL)ready;
- (BOOL)active;

@end

#pragma mark -
#pragma mark MTAbilities

@interface MTAbilityFreeze : MTAbility
@end

@interface MTAbilityHint : MTAbility
@end

@interface MTAbilityHighlight : MTAbility
@end

@interface MTAbilityShuffle : MTAbility
@end
