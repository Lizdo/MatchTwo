//
//  MTAbilityButton.h
//  MatchTwo
//
//  Created by  on 11-8-17.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "cocos2d.h"
#import "GameConfig.h"
#import "CCDrawingPrimitives+MT.h"

@class MTGame;

@interface MTAbilityButton : CCMenuItem{
    NSString * name;
    MTGame * game;
    
    float cooldownPercentage;
    
    CCSprite * sprite;
    CCSprite * disabledSprite;
    
    float originalScale_;
}

@property (readonly) NSString * name;
@property (assign) MTGame * game;

+ (MTAbilityButton *) abilityButtonWithName:(NSString *)name target:(MTGame *)g selector:(SEL)s;
- (id) initWithName:(NSString *)n target:(MTGame *)g selector:(SEL)s;

+ (int)idForButtonName:(NSString *)buttonName;
+ (CGRect)rectForIndex:(int)index;

- (void)update:(ccTime)dt;

+ (CCSprite *)spriteForAbilityName:(NSString *)buttonName;
+ (CCSprite *)disabledSpriteForAbilityName:(NSString *)buttonName;

@end
