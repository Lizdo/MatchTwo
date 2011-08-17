//
//  MTAbilityButton.h
//  MatchTwo
//
//  Created by  on 11-8-17.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "cocos2d.h"
#import "GameConfig.h"
@class MTGame;

@interface MTAbilityButton : CCMenuItemImage{
    NSString * name;
    MTGame * game;
    
    float cooldownPercentage;
}

@property (readonly) NSString * name;
@property (assign) MTGame * game;

+ (id) MTAbilityButtonWithName:(NSString *)name;
- (void)clicked;

@end
