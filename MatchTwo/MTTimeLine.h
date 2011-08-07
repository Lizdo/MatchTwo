//
//  MTTimeLine.h
//  MatchTwo
//
//  Created by  on 11-8-7.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// MTTimeLine displays RemainingTime/TotalTime.
// Also should update all timeline related special effects.


@interface MTTimeLine : CCSprite {
    float percentage;
}

@property float percentage;

@end
