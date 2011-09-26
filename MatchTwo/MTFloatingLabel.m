//
//  MTFloatingLabel.m
//  MatchTwo
//
//  Created by  on 11-8-30.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTFloatingLabel.h"
#import "GameConfig.h"

@implementation MTFloatingLabelManager

- (id)init{
    self = [super init];
    if (self) {
        labels = [[NSMutableArray alloc]initWithCapacity:1];
    }
    return self;
}

- (void)dealloc{
    [labels release];
    [super dealloc];
}

- (MTFloatingLabel *)addLabelWithString:(NSString *)t{
    MTFloatingLabel * l = [MTFloatingLabel labelWithString:t];
    
    // Fade out all 
    for (MTFloatingLabel * l in labels) {
        [l fadeOut];
    }
    
    [labels removeAllObjects];
    [labels addObject:l];
    
    return l;
}

@end


@interface MTFloatingLabel()
- (ccColor3B)colorByParsingText;
@end

const uint32_t	kMTFloatingLabelFadeActionTag = 0xe0c06001;


@implementation MTFloatingLabel


+ (id)labelWithString:(NSString *)t{
    return [[[MTFloatingLabel alloc] initWithString:t] autorelease];
}

- (MTFloatingLabel *)initWithString:(NSString *)t{
    self = [super initWithString:t fontName:kMTFont fontSize:kMTFontSizeNormal];
    
    if (self) {
        
        self.position = ccp(600,850);
        self.color = [self colorByParsingText];
        self.opacity = 0;
        
        //Animation Sequence
        [self fadeIn];
    }
    
    return self;
}

- (ccColor3B)colorByParsingText{
    return ccORANGE;
}

- (void)fadeIn{
    id fadein = [CCFadeTo actionWithDuration:0.1f opacity:255];
    id wait = [CCDelayTime actionWithDuration:2.0f];
    id fadeout = [CCCallBlock actionWithBlock:^{[self fadeOut];}];
    CCSequence * fade = [CCSequence actions:fadein, wait, fadeout, nil];  
    fade.tag = kMTFloatingLabelFadeActionTag;
    [self runAction:fade];    
    CCLOG(@"Fading In");
}

- (void)fadeOut{
    [self stopActionByTag:kMTFloatingLabelFadeActionTag];
    id fadeout = [CCFadeTo actionWithDuration:0.5f opacity:0];
    id remove = [CCCallBlock actionWithBlock:^{[self removeFromParentAndCleanup:YES];}];
    CCSequence * fade = [CCSequence actions:fadeout, remove, nil];
    fade.tag = kMTFloatingLabelFadeActionTag;
    [self runAction:fade];
    CCLOG(@"Fading Out");    
}

@end


@implementation MTFloatingScore

- (MTFloatingScore *)initWithScore:(int)score{
    NSString * s = [NSString stringWithFormat:@"+%d",score];
    self = [super initWithString:s fntFile:@"Numbers.fnt"];
    if (self) {
        [self fadeIn];
    }
    return self;
}

+ (id)labelWithScore:(int)score{
    return [[[self alloc]initWithScore:score] autorelease];
}

- (void)fadeIn{
    id fadeOut = [CCSequence actions:
                  [CCDelayTime actionWithDuration:0.5],
                  [CCFadeOut actionWithDuration:0.5],
                  nil];
    [self runAction:fadeOut];
    id moveUp = [CCMoveBy actionWithDuration:1 position:ccp(0, 40)];
    id callFadeOut = [CCCallBlock actionWithBlock:^{[self fadeOut];}];    
    CCSequence * sequence = [CCSequence actions:moveUp,callFadeOut, nil];
    [self runAction:sequence];
}

- (void)fadeOut{
    id remove = [CCCallBlock actionWithBlock:^{[self removeFromParentAndCleanup:YES];}];
    CCSequence * sequence = [CCSequence actions:remove, nil];
    [self runAction:sequence];
}
@end

