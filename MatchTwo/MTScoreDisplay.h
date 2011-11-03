//
//  MTScoreDisplay.h
//  MatchTwo
//
//  Created by  on 11-8-31.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"

@class MTGame;
@class MTSharedManager;

// Will have the following components:
// EXP Bar 
// Current Level in Big Font
// Current Score/Next Level Score
// 13   -----======
//      12222/23444

@interface MTScoreDisplay : CCLayer {
    CCLabelTTF * level;
    CCLabelTTF * score;
    MTGame * game;
    MTSharedManager * manager;
    
    float percentage;
}

@property (assign) MTGame * game;

- (void)update:(ccTime)dt;

@end
