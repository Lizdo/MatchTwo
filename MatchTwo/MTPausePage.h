//
//  MTPausePage.h
//  MatchTwo
//
//  Created by  on 11-9-20.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"

@class MTGame;

// Pause Page, base class for
//  Level Pause
//  Level Fail
//  Level Complete

// Features
//  - Transition from game screen
//  - Display stats
//  - Customizable Menu Item

@interface MTPausePage : CCNode {
    MTGame * game;
    CCMenu * menu;
    CCSprite * stamp;
}

@property (assign) MTGame * game;

// After assigning pointer to 'game', allow animation to tick...
- (void)show;

@end
