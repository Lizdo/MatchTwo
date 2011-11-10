//
//  MTAbility.m
//  MatchTwo
//
//  Created by  on 11-8-16.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTAbility.h"
#import "MTAbilityButton.h"
#import "MTSharedManager.h"
#import "MTTheme.h"

#pragma mark -
#pragma mark MTAbility Base Class

@implementation MTAbility

@synthesize type,fx;

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
            if (type == MTAbilityType_Activate
                && tickingTime >= availableTime * 3/4) {
                // Don't reset the ticking time here, continue to tick
                state = MTAbilityState_Disappearing;
            }
            break;
        case MTAbilityState_Disappearing:
            // Do nothing
            if (type == MTAbilityType_Activate
                && tickingTime >= availableTime) {
                self.state = MTAbilityState_CoolDown;
            }            
            break;
        case MTAbilityState_Active:
            if (tickingTime >= activeTime) {
                self.state = MTAbilityState_CoolDown;
                // Hide Activation FX When deactivated
                [[NSNotificationCenter defaultCenter]postNotificationName:kMTAbilityWillDeactivateNotification object:self];                
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
    if ([self isReady]) {
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
    if ([self isReady]) {
        self.state = MTAbilityState_Active;
    }
    // Show Activation FX When activated
    [[NSNotificationCenter defaultCenter]postNotificationName:kMTAbilityDidActivateNotification object:self];
}

- (BOOL)isReady{
    return state == MTAbilityState_Ready 
    || state == MTAbilityState_Assigned 
    || state == MTAbilityState_Disappearing;
}
- (BOOL)isActive{
    return state == MTAbilityState_Active;
}

- (BOOL)isAvailable{
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

+ (NSString *)longDescriptionForAbility:(NSString *)ability{
    // To Be Filled
    return @"很长很长很长的能力简介";
}

+ (NSMutableArray *)abilities{
    return [NSMutableArray arrayWithObjects:
            [[[MTAbilityFreeze alloc]init]autorelease],
            [[[MTAbilityHint alloc]init]autorelease],
            [[[MTAbilityHighlight alloc]init]autorelease],
            [[[MTAbilityShuffle alloc]init]autorelease], 
            [[[MTAbilityDoubleScore alloc]init]autorelease],                   
            [[[MTAbilityExtraTime alloc]init]autorelease],                                     
            nil];
}

+ (CCSprite *)spriteForAbility:(NSString *)ability{
    CCSprite * s = [MTAbilityButton spriteForAbilityName:ability];
    [s setColor:[MTTheme primaryColor]]; 
    return s;
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
        ccColor4B startColor = ccc4(143, 190, 221, 250);
        ccColor4B endColor = ccc4(186, 214, 233, 150);        
        self.fx = [CCLayerGradient layerWithColor:startColor fadingTo:endColor];
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
        ccColor4B startColor = ccc4(231, 210, 52, 150);        
        ccColor4B endColor = ccc4(241, 234, 175, 250);
        self.fx = [CCLayerGradient layerWithColor:startColor fadingTo:endColor];
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
        availableTime = 20.0f;
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
        availableTime = 20.0f;        
        activeTime = 1.0f;
        cooldownTime = 10.0f;
        name = kMTAbilityExtraTime;
        type = MTAbilityType_Activate;
        state = MTAbilityState_CoolDown;        
    }
    return self;
}

@end