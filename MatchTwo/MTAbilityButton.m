//
//  MTAbilityButton.m
//  MatchTwo
//
//  Created by  on 11-8-17.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTAbilityButton.h"
#import "MTGame.h"

const uint32_t	kMTAbilityButtonZoomActionTag = 0xe0c05002;

// Tile is a 512 x 512 texture, each grid is 128 * 128

CGRect rectForIndex(int index){
    int rows = kMTAbilityButtonTextureSize/kMTAbilityButtonSpriteSize;
    int idX = index % rows;
    int idY = index / rows;
    return CGRectMake(idX * kMTAbilityButtonSpriteSize, 
                      idY * kMTAbilityButtonSpriteSize, 
                      kMTAbilityButtonSpriteSize, 
                      kMTAbilityButtonSpriteSize);
}


@interface MTAbilityButton()
+ (int)idForButtonName:(NSString *)buttonName;
@end

@implementation MTAbilityButton

@synthesize name,game;

+ (MTAbilityButton *) abilityButtonWithName:(NSString *)n target:(id)t selector:(SEL)s{
    return [[[self alloc]initWithName:n target:t selector:s] autorelease];
}

- (id) initWithName:(NSString *)n target:(MTGame *)g selector:(SEL)s{
    self = [super initWithTarget:g selector:s];
    if (self) {
        name = n;
        game = g;
        self.contentSize = CGSizeMake(kMTAbilityButtonSize, kMTAbilityButtonSize);
        
        sprite = [MTAbilityButton spriteForButtonName:name];
        sprite.position = ccp(kMTAbilityButtonSize/2, kMTAbilityButtonSize/2);    
        sprite.scale = kMTAbilityButtonSize/kMTAbilityButtonSpriteSize;
        [self addChild:sprite z:-1];
        
        disabledSprite = [MTAbilityButton disabledSpriteForButtonName:name];
        disabledSprite.position = ccp(kMTAbilityButtonSize/2, kMTAbilityButtonSize/2);    
        disabledSprite.scale = kMTAbilityButtonSize/kMTAbilityButtonSpriteSize;
        disabledSprite.visible = NO;
        [self addChild:disabledSprite z:-1];        

    }
    return self;
}

-(void) selected
{
	// subclass to change the default action
	if(isEnabled_) {	
		[super selected];
        
		CCAction *action = [self getActionByTag:kMTAbilityButtonZoomActionTag];
		if( action )
			[self stopAction:action];
		else
			originalScale_ = self.scale;
        
		CCAction *zoomAction = [CCScaleTo actionWithDuration:0.1f scale:originalScale_ * 1.2f];
		zoomAction.tag = kMTAbilityButtonZoomActionTag;
		[self runAction:zoomAction];
	}
}

-(void) unselected
{
	// subclass to change the default action
	if(isEnabled_) {
		[super unselected];
		[self stopActionByTag:kMTAbilityButtonZoomActionTag];
		CCAction *zoomAction = [CCScaleTo actionWithDuration:0.1f scale:originalScale_];
		zoomAction.tag = kMTAbilityButtonZoomActionTag;
		[self runAction:zoomAction];
	}
}

- (void)draw{
    [super draw];
    if (cooldownPercentage <= 0 || cooldownPercentage >= 1) {
        return;
    }
    glLineWidth(1.0);
    glColor4f(kMTColorActive.r/255.0,
              kMTColorActive.g/255.0,
              kMTColorActive.b/255.0,
              0.6);
    ccDrawCircleSegment(ccp(kMTAbilityButtonSize/2, kMTAbilityButtonSize/2),
                 26,
                 CC_DEGREES_TO_RADIANS(360*cooldownPercentage),
                 round(cooldownPercentage*20),
                 NO);
    
//    glColor4f(0.2, 0.2, 0.2, 0.8); 
//    glLineWidth(1.0);
//    //glBlendFunc(GL_ONE, GL_ONE);
//    glEnable(GL_LINE_SMOOTH);
//    CGPoint points[4] = {
//        ccp(0, kMTAbilityButtonSize * cooldownPercentage),
//        ccp(kMTAbilityButtonSize, kMTAbilityButtonSize * cooldownPercentage),
//        ccp(kMTAbilityButtonSize, kMTAbilityButtonSize),
//        ccp(0, kMTAbilityButtonSize)
//    };
//    ccDrawPolyFill(points, 4, YES);
    //glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
}

- (void)update:(ccTime)dt{
    cooldownPercentage = [game abilityNamed:name].cooldownPercentage;
    if ([game isAbilityReady:name]) {
        self.isEnabled = YES;
        sprite.visible = YES;
        disabledSprite.visible = NO;
    }else{
        self.isEnabled = NO;
        sprite.visible = NO;
        disabledSprite.visible = YES;
    }
}



+ (int)idForButtonName:(NSString *)buttonName{
    NSArray * nameArray = [NSArray arrayWithObjects:kMTAbilityFreeze,
                           kMTAbilityHint,
                           kMTAbilityHighlight,
                           kMTAbilityShuffle,
                           kMTAbilityExtraTime,
                           kMTAbilityDoubleScore,                           
                           nil];
    return [nameArray indexOfObject:buttonName];
}


+ (CCSprite *)spriteForButtonName:(NSString *)buttonName{
    int index = [MTAbilityButton idForButtonName:buttonName];
    CCSprite * s = [CCSprite spriteWithFile:@"Abilities.png" 
                                            rect:rectForIndex(index)
                         ];
    return s;
}

+ (CCSprite *)disabledSpriteForButtonName:(NSString *)buttonName{
    int index = [MTAbilityButton idForButtonName:buttonName];
    CCSprite * s = [CCSprite spriteWithFile:@"Abilities_Disabled.png" 
                                            rect:rectForIndex(index)
                         ];
    return s;
}

@end


