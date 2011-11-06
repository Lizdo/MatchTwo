//
//  MTAbilityDetailDisplay.m
//  MatchTwo
//
//  Created by  on 11-11-6.
//  Copyright (c) 2011年 StupidTent co. All rights reserved.
//

#import "MTAbilityDetailDisplay.h"
#import "MTTheme.h"
#import "GameConfig.h"

@interface MTAbilityDetailDisplay ()
- (void)addBackground;
- (void)addIcon;
- (void)addDescription;
@end

@implementation MTAbilityDetailDisplay

- (MTAbilityDetailDisplay *)initWithAbility:(MTAbility *)theAbility{
    self = [super init];
    if (self) {
        ability = theAbility;
        [self addBackground];
        [self addIcon];
        [self addDescription];
    }
    return self;
}

+ (id)detailDisplayForAbility:(MTAbility *)theAbility{
    return [[[MTAbilityDetailDisplay alloc] 
             initWithAbility:theAbility] 
            autorelease];
}

- (void)addBackground{
    CCSprite * backgorund = [CCSprite spriteWithFile:@"AbilityDetailDisplayBackground.png"];
    backgorund.anchorPoint = ccp(0,0);
    backgorund.position = ccp(0,0); 
    [self addChild:backgorund];
}

- (void)addIcon{
    CCSprite * icon = [MTAbility spriteForAbility:ability.name];
    icon.position = ccp(57, 170);
    [self addChild:icon];
}

- (void)addDescription{
    CCLabelTTF * description = [CCLabelTTF labelWithString:[MTAbility descriptionForAbility:ability.name]
                                                  fontName:kMTFont
                                                  fontSize:kMTFontSizeSmall];
    description.color = [MTTheme backgroundColor];
    description.anchorPoint = ccp(0,0);
    description.position = ccp(93, 153);
    [self addChild:description];
    
    CCLabelTTF * longDescription = [CCLabelTTF labelWithString:[MTAbility longDescriptionForAbility:ability.name]
                                                    dimensions:CGSizeMake(208, 96)
                                                     alignment:CCTextAlignmentLeft
                                                 lineBreakMode:CCLineBreakModeCharacterWrap
                                                      fontName:kMTFont
                                                      fontSize:kMTFontSizeSmall];
//    CCLabelTTF * longDescription = [CCLabelTTF labelWithString:[MTAbility longDescriptionForAbility:ability.name]
//                                                  fontName:kMTFont
//                                                  fontSize:kMTFontSizeSmall];
    longDescription.color = [MTTheme backgroundColor];    
    longDescription.anchorPoint = ccp(0,1);    
    longDescription.position = ccp(34, 132);
    [self addChild:longDescription];    
}



@end
