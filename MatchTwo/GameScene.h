//
//  GameScene.h
//  MatchTwo
//
//  Created by  on 11-8-1.
//  Copyright StupidTent co. 2011年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "MTGame.h"


// CCScene -> GameScene -> MTGame
@interface GameScene : CCScene
{
    MTGame * game;
}

@property (nonatomic, retain) MTGame * game;

// returns a CCScene that contains the GameScene as the only child
+(id) sceneWithID:(int)theID;
-(GameScene *) initWithID:(int)theID;

@end
