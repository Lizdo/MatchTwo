//
//  ChallengeMenuScene.h
//  MatchTwo
//
//  Created by  on 11-8-14.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCScrollLayer.h"

@interface ChallengeMenuItem : CCMenuItemImage {
    BOOL completed;
    BOOL objCompleted;
    int index;
    
    CCSprite * completeIcon;
    CCSprite * objCompleteIcon;

}

+ (ChallengeMenuItem *)itemWithIndex:(int)index block:(void(^)(id sender))block;
- (id)initWithIndex:(int)theIndex block:(void(^)(id sender))block;

@property BOOL completed;
@property BOOL objCompleted;

@end

@interface ChallengeMenuScene : CCScene {
    CCScrollLayer * scrollLayer;
}

+ (CCScene *) scene;

@end
