//
//  ChallengeMenuScene.m
//  MatchTwo
//
//  Created by  on 11-8-14.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "ChallengeMenuScene.h"
#import "MTSharedManager.h"
#import "GameConfig.h"


@implementation ChallengeMenuItem

- (void)setCompleted:(BOOL)newBool{
    // Add Complete Icon
    completed = newBool;
    if (completed) {
        [self setString:@"Completed"];
    }
}

- (BOOL)completed{
    return completed;
}

- (void)setObjCompleted:(BOOL)newBool{
    objCompleted = newBool;
    // Add obj complete icon
    if (objCompleted) {
        [self setString:@"Obj Completed"];
    }

}

- (BOOL)objCompleted{
    return objCompleted;
}

- (void)setLocked:(BOOL)newBool{
    // Add Lock icon
    locked = newBool; 
    if (locked) {
        self.isEnabled = NO;       
    }else{
        self.isEnabled = YES;
    }
}

- (BOOL)locked{
    return locked;
}

- (id)initFromString:(NSString *)value target:(id)r selector:(SEL)s{
    self = [super initFromString:value target:r selector:s];
    if (self) {
        // Add the icons
    }
    return self;
}

@end

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
    [CCMenuItemFont setFontSize:kMTFontSizeNormal];
    for (int i = 101; i <= 112; i++) {
        NSString * s = [NSString stringWithFormat:@"%d", i];
        ChallengeMenuItem * item = [ChallengeMenuItem itemFromString:s block:^(id sender){
            [[MTSharedManager instance] replaceSceneWithID:i];
        }];
        item.contentSize = CGSizeMake(150, 150);
        item.anchorPoint = ccp(0.5,0.5);
        [menu addChild:item];
        
        item.locked = [[MTSharedManager instance] locked:i];
        item.completed = [[MTSharedManager instance] completed:i];
        item.objCompleted = [[MTSharedManager instance] objCompleted:i];        
    }
    
    [menu alignItemsInColumns:[NSNumber numberWithInt:3],
     [NSNumber numberWithInt:3],
     [NSNumber numberWithInt:3],
     [NSNumber numberWithInt:3],
     nil];
    
    [self addChild:menu];
    
}


@end
