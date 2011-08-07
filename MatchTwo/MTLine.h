//
//  MTLine.h
//  MatchTwo
//
//  Created by  on 11-8-1.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"


// MTLine is drawn everytime a match is found.
// It will remove it self from parent once the timer hits.

@interface MTLine : CCSprite {
    NSArray * points;
}


- (MTLine *)initWithPoints:(NSArray *)thePoints;
+ (id)lineWithPoints:(NSArray *)thePoints;



@end
