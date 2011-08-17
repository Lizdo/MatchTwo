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

+ (id) MTAbilityButtonWithName:(NSString *)name{
    MTAbilityButton * button = [[MTAbilityButton alloc] initWithTarget:self selector:@selector(clicked)];
    button.normalImage = [CCSprite spriteWithFile:@"Tile.png" 
                                             rect:CGRectMake(0, 0, kMTAbilityButtonSize, kMTAbilityButtonSize)
                          ];
    button.selectedImage = [CCSprite spriteWithFile:@"Tile.png" 
                                               rect:CGRectMake(0, 0, kMTAbilityButtonSize, kMTAbilityButtonSize)
                            ];
}

- (void)draw{
    glColor4f(0.6, 0.6, 0.6, 0.6); 
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
    if ([game isAbilityReady:name]) {
        self.isEnabled = YES;
    }else{
        self.isEnabled = NO;
    }
}

- (void)clicked{
    [game abilityButtonClicked:name];
}

@end


