//
//  MTMenuItem.h
//  MatchTwo
//
//  Created by  on 11-11-23.
//  Copyright (c) 2011年 StupidTent co. All rights reserved.
//

#import "CCMenuItem.h"
#import "cocos2d.h"
#import "GameConfig.h"

@interface MTMenuItem : CCMenuItemLabel <CCRGBAProtocol>{
    CCSprite * backgroundNormal;
    CCSprite * backgroundSelected;    
}

- (MTMenuItem *)initWithString:(NSString *)str target:(id)r selector:(SEL)s;
+ (id)itemFromString:(NSString *)str target:(id)r selector:(SEL)s;

- (MTMenuItem *)initWithString:(NSString *)str block:(void (^)(id))block;
+ (id)itemFromString:(NSString *)str block:(void (^)(id))block;

@end
