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

// Tile is a 512 x 512 texture, each grid is 64 * 64

CGRect rectForType(int type){
    int idX = type % 8;
    int idY = type / 8;
    return CGRectMake(idX * 64, idY * 64, 64, 64);
}


@implementation MTPiece

@synthesize row,column,type,enabled,hinted,pairedPiece;

- (void)setSelected:(BOOL)toBeSelected{
    if (!enabled) {
        return;
    }
    if (toBeSelected != selected) {
        selected = toBeSelected;
        if (selected) {
            [self runAction:[CCScaleTo actionWithDuration:kMTPieceScaleTime scale:1.2]];
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
        self.contentSize = CGSizeMake(kMTPieceSize, kMTPieceSize);
        self.anchorPoint = ccp(0.5, 0.5); 
        self.enabled = YES;
        self.type = theType;
    }
    return self;
}


- (void)draw{
    
    if (hinted) {
        glColor4f((type+1.0)/9.0, 1.0, 0.0, 0.1); 
        glLineWidth(1.0);
        glEnable(GL_LINE_SMOOTH);
        CGPoint points[4] = {
            ccp(kMTPieceMargin, kMTPieceMargin),
            ccp(kMTPieceMargin, kMTPieceSize - kMTPieceMargin),
            ccp(kMTPieceSize-kMTPieceMargin, kMTPieceSize-kMTPieceMargin),
            ccp(kMTPieceSize-kMTPieceMargin, kMTPieceMargin)
        };
        ccDrawPolyFill(points, 4, YES);
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




@end
