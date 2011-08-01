//
//  MainSceneLayer.h
//  MatchTwo
//
//  Created by  on 11-8-1.
//  Copyright StupidTent co. 2011年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "MTGame.h"

// MainSceneLayer
@interface MainSceneLayer : CCLayer
{
    MTGame * game;
}

@property (nonatomic, retain) MTGame * game;

// returns a CCScene that contains the MainSceneLayer as the only child
+(CCScene *) scene;

@end
