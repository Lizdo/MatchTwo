//
//  ChallengeMenuScene.m
//  MatchTwo
//
//  Created by  on 11-8-14.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "ChallengeMenuScene.h"
#import "MTSharedManager.h"

@interface ChallengeMenuScene()

- (void)prepare;

@end

@implementation ChallengeMenuScene

+ (CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ChallengeMenuScene *layer = [ChallengeMenuScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


- (id)init{
    self = [super init];
    if (self) {
        [self prepare];
    }
    return self;
}


// From 101 to 112, 3 x 4 items
// 

- (void)prepare{
    CCMenu * menu = [CCMenu menuWithItems:nil];
    for (int i = 101; i <= 112; i++) {
        NSString * s = [NSString stringWithFormat:@"%d", i];
        CCMenuItem * item = [CCMenuItemFont itemFromString:s block:^(id sender){
            [[MTSharedManager instance] replaceSceneWithID:i];
        }];
        item.contentSize = CGSizeMake(100, 100);
        //item.anchorPoint = ccp(0.5, 0.5);
        [menu addChild:item];
    }
    
    [menu alignItemsInColumns:[NSNumber numberWithInt:3],
     [NSNumber numberWithInt:3],
     [NSNumber numberWithInt:3],
     [NSNumber numberWithInt:3],
     nil];
    
    [self addChild:menu];
    
}


@end
