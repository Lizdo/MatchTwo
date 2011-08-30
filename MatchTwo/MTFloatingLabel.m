//
//  MTFloatingLabel.m
//  MatchTwo
//
//  Created by  on 11-8-30.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTFloatingLabel.h"
#import "GameConfig.h"

@interface MTFloatingLabel()
- (ccColor3B)colorByParsingText;
@end

static NSMutableArray * currentFloatingLabels = nil;

const uint32_t	kMTFloatingLabelFadeActionTag = 0xe0c06001;


@implementation MTFloatingLabel


+ (id)labelWithString:(NSString *)t{
    return [[[MTFloatingLabel alloc] initWithString:t] autorelease];
}

- (MTFloatingLabel *)initWithString:(NSString *)t{
    self = [super initWithString:t fontName:kMTFont fontSize:kMTFontSizeNormal];
    
    if (self) {
        // Initial label Pool
        if (currentFloatingLabels == nil) {
            currentFloatingLabels = [NSMutableArray arrayWithCapacity:2];
        }
        
        self.position = ccp(600,900);
        self.color = [self colorByParsingText];
        self.opacity = 0;
        
        //Animation Sequence
        // Fade out all 
        for (MTFloatingLabel * l in currentFloatingLabels) {
            [l fadeOut];
        }
        
        [currentFloatingLabels removeAllObjects];
        [currentFloatingLabels addObject:self];
        [self fadeIn];
    }
    
    return self;
}

- (ccColor3B)colorByParsingText{
    return ccORANGE;
}

- (void)fadeIn{
    id fadein = [CCFadeTo actionWithDuration:0.1f opacity:255];
    id wait = [CCDelayTime actionWithDuration:3.0f];
    id fadeout = [CCCallBlock actionWithBlock:^{[self fadeOut];}];
    CCSequence * fade = [CCSequence actions:fadein, wait, fadeout, nil];  
    fade.tag = kMTFloatingLabelFadeActionTag;
    [self runAction:fade];    
    CCLOG(@"Fading In");
}

- (void)fadeOut{
    [self stopActionByTag:kMTFloatingLabelFadeActionTag];
    id fadeout = [CCFadeTo actionWithDuration:0.2f opacity:0];
    id remove = [CCCallBlock actionWithBlock:^{[self removeFromParentAndCleanup:YES];}];
    CCSequence * fade = [CCSequence actions:fadeout, remove, nil];
    fade.tag = kMTFloatingLabelFadeActionTag;
    [self runAction:fade];
    CCLOG(@"Fading Out");    
}

@end
