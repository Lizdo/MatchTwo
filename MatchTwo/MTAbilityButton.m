//
//  MTAbilityButton.m
//  MatchTwo
//
//  Created by  on 11-8-17.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTAbilityButton.h"
#import "MTGame.h"

@implementation MTAbilityButton

@synthesize name,game;

+ (MTAbilityButton *) abilityButtonWithName:(NSString *)n game:(id)t selector:(SEL)s{
    return [[[self alloc]initWithName:n game:t selector:s] autorelease];
}

- (id) initWithName:(NSString *)n game:(MTGame *)g selector:(SEL)s{
    CCSprite * sprite = [CCSprite spriteWithFile:@"Abilities.png" 
        rect:CGRectMake(0, 0, kMTAbilityButtonSize, kMTAbilityButtonSize)
    ];
    self = [super initWithTarget:g selector:s];
    if (self) {
        name = n;
        game = g;    
        self.contentSize = CGSizeMake(kMTAbilityButtonSize, kMTAbilityButtonSize);
        [self addChild:sprite];
        sprite.position = ccp(kMTAbilityButtonSize/2, kMTAbilityButtonSize/2);        
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

@end


