//
//  MTPiece.m
//  MatchTwo
//
//  Created by  on 11-8-1.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTPiece.h"
#import "CCTouchDispatcher.h"
#import "CCDrawingPrimitives+MT.h"
#import "MTGame.h"
#import "MTAbilityButton.h"
#import "SimpleAudioEngine.h"
// Tile is a 512 x 512 texture, each grid is 64 * 64

CGRect rectForType(int type){
    int idX = type % 8;
    int idY = type / 8;
    return CGRectMake(idX * 64, idY * 64, 64, 64);
}

void HSVtoRGB( float *r, float *g, float *b, float h, float s, float v )
{
	int i;
	float f, p, q, t;
	if( s == 0 ) {
		// achromatic (grey)
		*r = *g = *b = v;
		return;
	}
	h /= 60;			// sector 0 to 5
	i = floor( h );
	f = h - i;			// factorial part of h
	p = v * ( 1 - s );
	q = v * ( 1 - s * f );
	t = v * ( 1 - s * ( 1 - f ) );
	switch( i ) {
		case 0:
			*r = v;
			*g = t;
			*b = p;
			break;
		case 1:
			*r = q;
			*g = v;
			*b = p;
			break;
		case 2:
			*r = p;
			*g = v;
			*b = t;
			break;
		case 3:
			*r = p;
			*g = q;
			*b = v;
			break;
		case 4:
			*r = t;
			*g = p;
			*b = v;
			break;
		default:		// case 5:
			*r = v;
			*g = p;
			*b = q;
			break;
	}
}

@interface MTPiece()
- (void)playSound;
@end


@implementation MTPiece

@synthesize row,column,type,enabled,hinted,pairedPiece,shufflePiece,game,ability;

- (void)setSelected:(BOOL)toBeSelected{
    if (!enabled) {
        return;
    }
    if (toBeSelected != selected) {
        selected = toBeSelected;
        if (selected) {
            [self runAction:[CCScaleTo actionWithDuration:kMTPieceScaleTime scale:1.25]];
        }else{
            [self runAction:[CCScaleTo actionWithDuration:kMTPieceScaleTime scale:1.0]];            
        }
    }
}

- (BOOL)selected{
    return selected;
}


- (id)initWithType:(int)theType{
    self = [super initWithFile:@"Tile.png" rect:rectForType(theType)];
    if (self) {
//        self.scale = kMTPieceSize/64;
        self.enabled = YES;
        self.type = theType;
        self.contentSize = CGSizeMake(kMTPieceSize, kMTPieceSize);        
        self.anchorPoint = ccp(0.5, 0.5);         
//        self.color = [MTTheme foregroundColor];
    }
    return self;
}

#define kBadgeBlinkTag 0xBAD9EB17
#define kMTPieceDrawBorder NO

- (void)update{
    if (ability && ability.state == MTAbilityState_Disappearing) {
        NSAssert(badge, @"Must have a badge!");
        CCAction * action = [badge getActionByTag:kBadgeBlinkTag];
        if (action == nil || [action isDone]) {
            CCActionInterval * blink = [CCBlink actionWithDuration:1.0 blinks:5];
            blink.tag = kBadgeBlinkTag;
            [badge runAction:blink];
        }
    }
    if (ability && ![ability isReady]) {
        ability = nil;
        [badge removeFromParentAndCleanup:YES];
        badge = nil;
    }
}

- (void)draw{

    CGPoint points[4] = {
        ccp(kMTPieceMargin, kMTPieceMargin),
        ccp(kMTPieceMargin, kMTPieceSize - kMTPieceMargin),
        ccp(kMTPieceSize-kMTPieceMargin, kMTPieceSize-kMTPieceMargin),
        ccp(kMTPieceSize-kMTPieceMargin, kMTPieceMargin)
    };    
    
    if (hinted || [game isAbilityActive:kMTAbilityHighlight]) {
        float r,g,b;
        HSVtoRGB(&r, &g, &b, type*30, 0.2, 0.5);
        glColor4f(r,g,b,0.5);
        ccDrawPolyFill(points, 4, YES);
    }else if (kMTPieceDrawBorder){
        glColor4f([MTTheme backgroundColor].r/255.0,
                  [MTTheme backgroundColor].g/255.0,
                  [MTTheme backgroundColor].b/255.0,
                  1.0);
        glLineWidth(1.0);
        ccDrawPoly(points, 4, YES);        
    }    
    [super draw];

}

- (NSString *)description{
    return [NSString stringWithFormat:@"Piece at Row: %d, Column: %d",row,column];
}


- (void)disappear{
    if (pairedPiece) {
        pairedPiece.hinted = NO;
    }
    self.enabled = NO;
    [self runAction:[CCScaleTo actionWithDuration:kMTPieceDisappearTime scale:0]];
    // Fly the badge to the upside, then ability will be activated
    [game flyBadge:badge forAbility:ability.name];
    [self playSound];
}

- (void)assignAbility:(MTAbility *)newAbility{
    NSAssert(self.ability == nil, @"Already Assigned Ability!");
    self.ability = newAbility;
    // Add a badge according to the ability name.
    badge = [MTAbilityButton spriteForAbilityName:ability.name];
    badge.scale = kMTAbilityBadgeSize/kMTAbilityButtonSpriteSize;
    badge.anchorPoint = ccp(0.5,0.5);
    badge.position = ccp(kMTPieceSize - kMTAbilityBadgePadding,
                         kMTPieceSize - kMTAbilityBadgePadding);
    [self addChild:badge z:2];
}

- (void)shake{
    if (shaking) {
        return;
    }
    shaking = YES;
    id delay = [CCDelayTime actionWithDuration:kMTPieceDisappearTime/2];
    id rotate1 = [CCRotateBy actionWithDuration:kMTPieceDisappearTime/4 angle:5.0f];
    id rotate2 = [CCRotateBy actionWithDuration:kMTPieceDisappearTime/2 angle:-10.0f];
    id rotate3 = [CCRotateBy actionWithDuration:kMTPieceDisappearTime/4 angle:5.0f];    
    id resetShakingFlag = [CCCallBlock actionWithBlock:^{shaking = NO;}];
    [self runAction:[CCSequence actions:delay,
                     rotate1,
                     rotate2,
                     rotate3,
                     resetShakingFlag,
                     nil]];
}

- (void)shuffle{
    newRow = shufflePiece.row;
    newColomn = shufflePiece.column;
    id delay = [CCDelayTime actionWithDuration:kMTBoardShuffleWarningTime];   
    id move = [CCMoveTo actionWithDuration:kMTBoardShuffleTime
                                  position:[MTGame positionForPiece:shufflePiece]
               ];
    id assignID = [CCCallBlock actionWithBlock:^(void){
        self.row = newRow;
        self.column = newColomn;           
    }];    
    [self runAction:[CCSequence actions:delay,
                     assignID, move,
                     nil]];    
    
}

- (void)moveToRow:(int)nextRow andColumn:(int)nextColumn{
    self.row = nextRow;
    self.column = nextColumn;
    
    id move = [CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:kMTCollapseTime
                                  position:[MTGame positionForRow:nextRow andColumn:nextColumn]
               ] rate:0.5];
    [self runAction:move];
}

- (void)playSound{
    int rand = arc4random()%3;
    switch (rand) {
        case 0:
            [[SimpleAudioEngine sharedEngine] playEffect:@"papershort.caf"];
            break;
        case 1:
            [[SimpleAudioEngine sharedEngine] playEffect:@"papershort2.caf"];
            break;
        case 2:
        default:
            [[SimpleAudioEngine sharedEngine] playEffect:@"papershort3.caf"];            
            break;
    }
}



@end
