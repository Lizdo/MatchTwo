//
//  MTAbilityButton.m
//  MatchTwo
//
//  Created by  on 11-8-17.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTAbilityButton.h"
#import "MTGame.h"

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

- (int)idForButtonName:(NSString *)buttonName;
- (CCSprite *)spriteForButtonName:(NSString *)buttonName;

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
        
        CCSprite * sprite = [self spriteForButtonName:name];
        sprite.position = ccp(kMTAbilityButtonSize/2, kMTAbilityButtonSize/2);    
        sprite.scale = kMTAbilityButtonSize/kMTAbilityButtonSpriteSize;
        
        [self addChild:sprite];

    }
    return self;
}

- (void)draw{
    glColor4f(0.1, 0.1, 0.1, 0.6); 
    glLineWidth(1.0);
    glEnable(GL_LINE_SMOOTH);
    CGPoint points[4] = {
        ccp(0, kMTAbilityButtonSize * cooldownPercentage),
        ccp(kMTAbilityButtonSize, kMTAbilityButtonSize * cooldownPercentage),
        ccp(kMTAbilityButtonSize, kMTAbilityButtonSize),
        ccp(0, kMTAbilityButtonSize)
    };
    ccDrawPolyFill(points, 4, YES);
    [super draw];
}

- (void)update:(ccTime)dt{
    cooldownPercentage = [game abilityNamed:name].cooldownPercentage;
    if ([game isAbilityReady:name]) {
        self.isEnabled = YES;
    }else{
        self.isEnabled = NO;
    }
}



- (int)idForButtonName:(NSString *)buttonName{
    NSArray * nameArray = [NSArray arrayWithObjects:@"Freeze",
                           @"Hint",
                           @"Highlight",
                           nil];
    return [nameArray indexOfObject:buttonName];
}


- (CCSprite *)spriteForButtonName:(NSString *)buttonName{
    int index = [self idForButtonName:buttonName];
    CCSprite * sprite = [CCSprite spriteWithFile:@"Abilities.png" 
                                            rect:rectForIndex(index)
                         ];
    return sprite;
}

@end


