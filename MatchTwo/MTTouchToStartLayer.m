//
//  MTTouchToStartLayer.m
//  MatchTwo
//
//  Created by  on 11-10-23.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTTouchToStartLayer.h"
#import "GameConfig.h"

@implementation MTTouchToStartLayer

@synthesize delegate;

- (id) initWithColor:(ccColor4B)color width:(GLfloat)w  height:(GLfloat) h
{
    self = [super initWithColor:color width:w height:h];
	if(self) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];       
        
        // Add custom text
        CCLabelTTF * tapToStartText = [CCLabelTTF labelWithString:@"点击屏幕任意位置开始" 
                                                         fontName:kMTFont
                                                         fontSize:kMTFontSizeNormal];
        tapToStartText.color = ccWHITE;
        tapToStartText.anchorPoint = ccp(0.5, 0.5);
        tapToStartText.position = ccp(winSize.width/2, 80);
        [self addChild:tapToStartText];
        
        self.isTouchEnabled = YES;
	}
	return self;
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                     priority:0
                                              swallowsTouches:YES];
}


- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}


- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    [delegate start];
}




@end
