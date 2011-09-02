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
        objCompleteIcon.visible = NO;
        completeIcon.visible = YES;
        lockIcon.visible = NO;
    }
}

- (BOOL)completed{
    return completed;
}

- (void)setObjCompleted:(BOOL)newBool{
    objCompleted = newBool;
    // Add obj complete icon
    if (objCompleted) {
        objCompleteIcon.visible = YES;
        completeIcon.visible = NO;
        lockIcon.visible = NO;
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
        lockIcon.visible = YES;
        completeIcon.visible = NO;
        objCompleteIcon.visible = NO;
        levelIconLocked.visible = YES;
        levelIcon.visible = NO;
    }else{
        self.isEnabled = YES;
        lockIcon.visible = NO;
        completeIcon.visible = NO;
        objCompleteIcon.visible = NO;        
        levelIconLocked.visible = NO;
        levelIcon.visible = YES;        
    }
}

- (BOOL)locked{
    return locked;
}

#define kMTChallengeMenuIconSize 64.0f
#define kMTChallengeMenuIconOffset 32.0f

- (id)initFromString:(NSString *)value target:(id)r selector:(SEL)s{
    self = [super initFromString:value target:r selector:s];
    if (self) {
        // Add the icons
        levelIconLocked = [CCSprite spriteWithFile:@"Menu.png" rect:CGRectMake(0, 0, kMTChallengeMenuIconSize, kMTChallengeMenuIconSize)];
        [self addChild:levelIconLocked];
        
        levelIcon = [CCSprite spriteWithFile:@"Menu.png" rect:CGRectMake(0, kMTChallengeMenuIconSize, kMTChallengeMenuIconSize, kMTChallengeMenuIconSize)];
        [self addChild:levelIcon];        
        
        lockIcon = [CCSprite spriteWithFile:@"Menu.png" rect:CGRectMake(kMTChallengeMenuIconSize, 0, kMTChallengeMenuIconSize, kMTChallengeMenuIconSize)];
        lockIcon.position = ccp(kMTChallengeMenuIconOffset, -kMTChallengeMenuIconOffset);        
        [self addChild:lockIcon];

        completeIcon = [CCSprite spriteWithFile:@"Menu.png" rect:CGRectMake(kMTChallengeMenuIconSize*2,
                                                                            0,
                                                                            kMTChallengeMenuIconSize,
                                                                            kMTChallengeMenuIconSize)];
        completeIcon.position = ccp(kMTChallengeMenuIconOffset, -kMTChallengeMenuIconOffset);
        [self addChild:completeIcon];

        
        objCompleteIcon = [CCSprite spriteWithFile:@"Menu.png" rect:CGRectMake(kMTChallengeMenuIconSize*3,
                                                                        0, 
                                                                        kMTChallengeMenuIconSize,
                                                                        kMTChallengeMenuIconSize)];
        objCompleteIcon.position = ccp(kMTChallengeMenuIconOffset, -kMTChallengeMenuIconOffset);        
        [self addChild:objCompleteIcon];
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
        item.label.position = ccp(30.0,0);
        item.contentSize = CGSizeMake(90, 160);
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
