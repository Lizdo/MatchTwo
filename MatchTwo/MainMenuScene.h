//
//  MainMenuScene.h
//  MatchTwo
//
//  Created by  on 11-8-14.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MTScoreDisplay.h"
#import "MTScoreDetailDisplay.h"
#import "MTMenuItem.h"

@interface MainMenuScene : CCLayer {
    CCSprite * logo;
    CCMenu * menu;
    MTScoreDisplay * scoreDisplay;
    MTScoreDetailDisplay * scoreDetailDisplay;
}

+ (CCScene *) scene;

@end
