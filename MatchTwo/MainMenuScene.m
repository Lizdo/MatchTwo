//
//  MainMenuScene.m
//  MatchTwo
//
//  Created by  on 11-8-14.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MainMenuScene.h"
#import "MTSharedManager.h"
#import "GameConfig.h"

@interface MainMenuScene()

- (void) dailyChallenge;
- (void) challengeMenu;
- (void) settingMenu;

@end

@implementation MainMenuScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenuScene *layer = [MainMenuScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// Main Menu
//  - Menu
//      - Daily Challenge
//      - Challenge Mode
//      - Settings
//  - BKG

-(id) init
{
	if( (self=[super init])) {
        [CCMenuItemFont setFontName:kMTFont];
        [CCMenuItemFont setFontSize:40];
        CCMenu * menu = [CCMenu menuWithItems:[CCMenuItemFont itemFromString:@"每日挑战" target:self selector:@selector(dailyChallenge)],
                         [CCMenuItemFont itemFromString:@"关卡模式" target:self selector:@selector(challengeMenu)],
                         [CCMenuItemFont itemFromString:@"设置菜单" target:self selector:@selector(settingMenu)],
                         nil];
        [menu alignItemsVerticallyWithPadding: 40.0f];        
        [self addChild:menu];
	}
	return self;
}

- (void) challengeMenu{
    [[MTSharedManager instance] replaceSceneWithID:2];    
}

- (void) dailyChallenge{
    [[MTSharedManager instance] replaceSceneWithID:101];
}

- (void) settingMenu{
    
}


                         
                         
                                               


@end
