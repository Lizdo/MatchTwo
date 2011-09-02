//
//  ChallengeMenuScene.h
//  MatchTwo
//
//  Created by  on 11-8-14.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ChallengeMenuItem : CCMenuItemFont {
    BOOL completed;
    BOOL objCompleted;
    BOOL locked;
    
    CCSprite * levelIconLocked;
    CCSprite * levelIcon;
    CCSprite * lockIcon;
    CCSprite * completeIcon;
    CCSprite * objCompleteIcon;
}

@property BOOL completed;
@property BOOL objCompleted;
@property BOOL locked;

@end

@interface ChallengeMenuScene : CCScene {
    
}

+ (CCScene *) scene;

@end
