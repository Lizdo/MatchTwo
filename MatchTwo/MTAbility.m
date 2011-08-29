//
//  MTAbility.m
//  MatchTwo
//
//  Created by  on 11-8-16.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTAbility.h"

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
        self.state = MTAbilityState_Ready;
    }
    return self;
}


- (void)update:(ccTime)dt{
    tickingTime += dt;
    switch (state) {
        case MTAbilityState_Ready:
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
    if (state == MTAbilityState_Ready) {
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
    if (state == MTAbilityState_Ready) {
        self.state = MTAbilityState_Active;
    }
}

- (BOOL)ready{
    return state == MTAbilityState_Ready;
}
- (BOOL)active{
    return state == MTAbilityState_Active;
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
        activeTime = 10.0f;
        cooldownTime = 30.0f;
        name = @"Freeze";
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
        activeTime = 5.0f;
        cooldownTime = 20.0f;
        name = @"Hint";
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
        activeTime = 10.0f;
        cooldownTime = 60.0f;
        name = @"Highlight";
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
        activeTime = 0.01f;
        cooldownTime = 10.0;
        name = @"Shuffle";
    }
    return self;
}

@end
