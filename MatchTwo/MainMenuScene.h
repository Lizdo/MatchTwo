//
//  MainMenuScene.h
//  MatchTwo
//
//  Created by  on 11-8-14.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MainMenuScene : CCLayer {
    CCSprite * logo;
    CCMenu * menu;
    
}

+(CCScene *) scene;

@end
