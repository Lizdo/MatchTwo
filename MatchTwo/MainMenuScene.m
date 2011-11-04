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

- (void)addBackground;
- (void)addMenu;
- (void)addScoreDisplay;
- (void)addScoreDetailDisplay;

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
        // Set the theme color for the main menu
        [MTTheme setTheme:kMTThemeMainMenu];
        [self addBackground];
        [self addMenu];
        [self addScoreDisplay];
        [self addScoreDetailDisplay];
        self.isTouchEnabled = YES;
	}
	return self;
}

- (void)addBackground{
    CGSize winSize = [[CCDirector sharedDirector] winSize];        
    CCSprite * image = [CCSprite spriteWithFile:@"Background_Left.png"];
    image.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:image z:-2];
    
    logo = [CCSprite spriteWithFile:@"Game_Logo.png"];
    logo.position = ccp(winSize.width/2, 1024-361);
    [self addChild:logo];
    logo.opacity = 0.0f;

}

- (void)addMenu{
    [CCMenuItemFont setFontName:kMTFont];
    [CCMenuItemFont setFontSize:kMTFontSizeNormal];
    menu = [CCMenu menuWithItems:[CCMenuItemFont itemFromString:@"每日挑战" target:self selector:@selector(dailyChallenge)],
            [CCMenuItemFont itemFromString:@"关卡模式" target:self selector:@selector(challengeMenu)],
            [CCMenuItemFont itemFromString:@"设置菜单" target:self selector:@selector(settingMenu)],
            nil];
    [menu alignItemsVerticallyWithPadding: 20.0f];        
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];        
    menu.position = ccp(winSize.width/2, 300);
    
    [self addChild:menu];
    
    for (CCMenuItemFont * child in menu.children) {
        child.color = kMTColorActive;
    }
    
    [menu setOpacity:0.0f];    
}


#define ScoreDisplayInitialPosition ccp(kMTScoreDisplayStartingX, -100)
#define ScoreDisplayFinalPosition ccp(kMTScoreDisplayStartingX, 10)

- (void)addScoreDisplay{
    scoreDisplay = [MTScoreDisplay node];
    [self addChild:scoreDisplay];
    scoreDisplay.position = ScoreDisplayInitialPosition;
}

- (void)addScoreDetailDisplay{
    scoreDetailDisplay = [MTScoreDetailDisplay node];
    [self addChild:scoreDetailDisplay];
    scoreDetailDisplay.visible = NO;
}

#define kMTMainMenuFadeInTime 1.0f

- (void)onEnterTransitionDidFinish{
    // Fade in title image
    CCActionInterval * logoFadeIn = [CCFadeIn actionWithDuration:kMTMainMenuFadeInTime];
    CCActionInterval * showMenu = [CCCallBlock actionWithBlock:^{
        [menu runAction:[CCFadeIn actionWithDuration:kMTMainMenuFadeInTime]];
        [scoreDisplay runAction:[CCMoveTo actionWithDuration:kMTMainMenuFadeInTime position:ScoreDisplayFinalPosition]];
    }];
    
    [logo runAction:[CCSequence actions:logoFadeIn, showMenu, nil]];
    
    CCParticleSystemQuad * bkgParticle = [CCParticleSystemQuad particleWithFile:@"Particle_Star.plist"];
    [self addChild:bkgParticle z:-1];    
}

- (void) challengeMenu{
    [[MTSharedManager instance] replaceSceneWithID:2];    
}

- (void) dailyChallenge{
    [[MTSharedManager instance] replaceSceneWithID:101];
}

- (void) settingMenu{
}


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];    
    if (scoreDetailDisplay.visible == NO) {
        // Show the details when touched on the score display
        if (CGRectContainsPoint([scoreDisplay boundingBox], location)) {
            scoreDetailDisplay.visible = YES;
            scoreDisplay.visible = NO;
            [scoreDetailDisplay runAction:[CCFadeIn actionWithDuration:0.5]];
        }
    }else{
        // Dismiss the detail display when touched outside
        if (!CGRectContainsPoint([scoreDetailDisplay boundingBox], location)) {        
            scoreDetailDisplay.visible = NO;
            scoreDisplay.visible = YES;
        }
    }

}
                         
                                               


@end
