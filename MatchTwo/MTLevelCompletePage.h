//
//  MTLevelCompletePage.h
//  MatchTwo
//
//  Created by  on 11-9-6.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"

// Menu page shown after level complete.
//     Need to show:
//          - Level Progression
//          - Unlocks
//          - Next level unlock
//          - Optional objective complete?
//          - Remaining Time bonus
//          - 
// Notes:
//      Node will drop from above
//      Reuse ScoreDisplay for updating 
// 


@class MTGame;

@interface MTLevelCompletePage : CCNode {
    MTGame * game;
    CCMenu * menu;
    CCLabelTTF * scoreDetails;
}

@property (assign) MTGame * game;

// After assigning pointer to 'game', allow animation to tick...
- (void)show;

@end
