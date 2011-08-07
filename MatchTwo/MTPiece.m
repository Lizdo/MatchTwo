//
//  MTPiece.m
//  MatchTwo
//
//  Created by  on 11-8-1.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTPiece.h"
#import "CCTouchDispatcher.h"


// Tile is a 512 x 512 texture, each grid is 64 * 64

CGRect rectFromType(int type){
    int idX = type % 8;
    int idY = type / 8;
    return CGRectMake(idX * 64, idY * 64, 64, 64);
}


@implementation MTPiece

@synthesize row,column,type,enabled;

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
    self = [super initWithFile:@"Tile.png" rect:rectFromType(theType)];
    if (self) {
        self.contentSize = CGSizeMake(kMTPieceSize, kMTPieceSize);
        self.anchorPoint = ccp(0.5, 0.5); 
        self.enabled = YES;
        self.type = theType;
    }
    return self;
}


- (void)draw{
    if (!self.enabled) {
        return;
    }
    
    
    glColor4f((type+1.0)/5.0, 1.0, 0.0, 0.1);  
    glLineWidth(1.0);
    glEnable(GL_LINE_SMOOTH);
    CGPoint points[4] = {
        ccp(kMTPieceMargin, kMTPieceMargin),
        ccp(kMTPieceMargin, kMTPieceSize - kMTPieceMargin),
        ccp(kMTPieceSize-kMTPieceMargin, kMTPieceSize-kMTPieceMargin),
        ccp(kMTPieceSize-kMTPieceMargin, kMTPieceMargin)
    };
    ccDrawPoly(points, 4, YES);
    
    [super draw];

}

- (NSString *)description{
    return [NSString stringWithFormat:@"Piece at Row: %d, Column: %d",row,column];
}


- (void)disappear{
    // TODO: Spawn a particle
    self.enabled = NO;
    [self runAction:[CCScaleTo actionWithDuration:kMTPieceDisappearTime scale:0]];
}




@end
