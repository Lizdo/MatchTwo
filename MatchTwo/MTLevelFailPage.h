//
//  MTLevelFailPage.h
//  MatchTwo
//
//  Created by  on 11-9-6.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"

@class MTGame;

@interface MTLevelFailPage : CCNode {
    MTGame * game;
    CCMenu * menu;    
}

@property (assign) MTGame * game;

// After assigning pointer to 'game', allow animation to tick...
- (void)show;

@end