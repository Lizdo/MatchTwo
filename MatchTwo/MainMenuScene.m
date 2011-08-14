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

- (void) challengeMode;
- (void) dailyChallenge;
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
        CCMenu * menu = [CCMenu menuWithItems:[CCMenuItemFont itemFromString:@"每日挑战" block:^(id sender){[self dailyChallenge];}],
                         [CCMenuItemFont itemFromString:@"关卡模式" block:^(id sender){[self challengeMode];}],
                         [CCMenuItemFont itemFromString:@"设置菜单" block:^(id sender){[self settingMenu];}],
                         nil];
        [menu alignItemsVerticallyWithPadding: 40.0f];        
        [self addChild:menu];
	}
	return self;
}

- (void) challengeMode{

}

- (void) dailyChallenge{
    [[MTSharedManager instance] replaceSceneWithID:101];
}

- (void) settingMenu{
    
}
                         
                         
                                               


@end
