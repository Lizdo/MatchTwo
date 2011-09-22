//
//  MTTimeDisplay.h
//  MatchTwo
//
//  Created by  on 11-9-18.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"
@class MTGame;

@interface MTTimeDisplay : CCLabelTTF {
    MTGame * game;
}

@property (assign) MTGame * game;
@property BOOL frozen;
@property BOOL highlight;

- (void)update;
+ (NSString *)stringWithSeconds:(int)seconds;


@end
