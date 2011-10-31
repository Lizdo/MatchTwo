//
//  MTAbility.m
//  MatchTwo
//
//  Created by  on 11-8-16.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTAbility.h"
#import "MTSharedManager.h"

#pragma mark -
#pragma mark MTAbility Base Class

@implementation MTAbility

@synthesize type;

- (void)setState:(MTAbilityState)newState{
    if (newState == state) {
        return;
    }
    tickingTime = 0;
    state = newState;
}

- (MTAbilityState)state{
    return state;
}

- (NSString *)name{
    return name;
}


- (id)init
{
    self = [super init];
    if (self) {
        state = MTAbilityState_Ready;
        type = MTAbilityType_Button;
    }
    return self;
}


- (void)update:(ccTime)dt{
    tickingTime += dt;
    switch (state) {
        case MTAbilityState_Ready:
            self.state = MTAbilityState_Assigned;
            break;
        case MTAbilityState_Assigned:
            // Do nothing
            break;
        case MTAbilityState_Active:
            if (tickingTime >= activeTime) {
                self.state = MTAbilityState_CoolDown;
            }
            break;
        case MTAbilityState_CoolDown:
            if (tickingTime >= cooldownTime) {
                self.state = MTAbilityState_Ready;
            }
            break;            
        default:
            break;
    }
}

- (float)cooldownPercentage{
    if ([self ready]) {
        return 1.0f;
    }
    if (state == MTAbilityState_Active) {
        return 0.0f;
    }
    float percentage = tickingTime/cooldownTime;
    percentage = percentage > 1 ? 1 : percentage;
    return percentage;
}

- (void)activate{
    if ([self ready]) {
        self.state = MTAbilityState_Active;
    }
}

- (BOOL)ready{
    return state == MTAbilityState_Ready || state == MTAbilityState_Assigned;
}
- (BOOL)active{
    return state == MTAbilityState_Active;
}

- (BOOL)available{
    if (type == MTAbilityType_Activate) {
        return YES;
    }

    if (level == 0) {
        return NO;
    }
    
    return YES;
}

+ (NSString *)descriptionForAbility:(NSString *)ability{
    NSMutableDictionary * descriptions = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          @"自动提示", kMTAbilityHint,
                                          @"冰冻时间", kMTAbilityFreeze,
                                          @"魔术高亮", kMTAbilityHighlight,
                                          @"重新排列", kMTAbilityShuffle,
                                          nil];
    return [descriptions objectForKey:ability];
}

@end


#pragma mark -
#pragma mark MTAbilities

@implementation MTAbilityFreeze

- (id)init
{
    self = [super init];
    if (self) {
        // Possible to query SharedManager for Player Info
        name = kMTAbilityFreeze;
        level = [[MTSharedManager instance] levelForAbility:name];        
        activeTime = 10.0f * level;
        cooldownTime = 30.0f;
    }
    return self;
}

@end


@implementation MTAbilityHint

- (id)init
{
    self = [super init];
    if (self) {
        // Possible to query SharedManager for Player Info
        name = kMTAbilityHint;        
        level = [[MTSharedManager instance] levelForAbility:name];        
        activeTime = 0.1f;
        cooldownTime = 200.0f - (level * 20);

    }
    return self;
}

@end

@implementation MTAbilityHighlight

- (id)init
{
    self = [super init];
    if (self) {
        // Possible to query SharedManager for Player Info
        name = kMTAbilityHighlight;        
        level = [[MTSharedManager instance] levelForAbility:name];                
        activeTime = 10.0f * level;
        cooldownTime = 60.0f;

    }
    return self;
}

@end

@implementation MTAbilityShuffle

- (id)init
{
    self = [super init];
    if (self) {
        // Possible to query SharedManager for Player Info
        name = kMTAbilityShuffle;
        level = [[MTSharedManager instance] levelForAbility:name];            
        activeTime = 0.01f;
        cooldownTime = 60.0f - 5.0f*(level-1);
    }
    return self;
}

@end


@implementation MTAbilityDoubleScore

- (id)init
{
    self = [super init];
    if (self) {
        // Possible to query SharedManager for Player Info
        activeTime = 10.0f;
        cooldownTime = 20.0f;
        name = kMTAbilityDoubleScore;
        type = MTAbilityType_Activate;
        state = MTAbilityState_CoolDown;
    }
    return self;
}

@end

@implementation MTAbilityExtraTime

- (id)init
{
    self = [super init];
    if (self) {
        // Possible to query SharedManager for Player Info
        activeTime = 1.0f;
        cooldownTime = 10.0f;
        name = kMTAbilityExtraTime;
        type = MTAbilityType_Activate;
        state = MTAbilityState_CoolDown;        
    }
    return self;
}

@end