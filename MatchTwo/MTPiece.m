//
//  MTPiece.m
//  MatchTwo
//
//  Created by  on 11-8-1.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTPiece.h"
#import "CCTouchDispatcher.h"

@implementation MTPiece

@synthesize row,column,type,enabled;

- (void)setSelected:(BOOL)toBeSelected{
    if (toBeSelected != selected) {
        selected = toBeSelected;
        if (selected) {
            [self runAction:[CCScaleTo actionWithDuration:kMTPieceScaleTime scale:1.2]];
        }else{
//            self.scale = 1.0;
            [self runAction:[CCScaleTo actionWithDuration:kMTPieceScaleTime scale:1.0]];            
        }
    }
}

- (BOOL)selected{
    return selected;
}

- (id)initWithRow:(int)theRow andColumn:(int)theColumn{
    if (self = [super init]) {
        row = theRow;
        column = theColumn;
        self.contentSize = CGSizeMake(kMTPieceSize, kMTPieceSize);
        self.anchorPoint = ccp(0.5, 0.5); 
        self.enabled = YES;
    }
    return self;
}

+ (MTPiece *)pieceWithRow:(int)theRow andColumn:(int)theColumn{
    return [[MTPiece alloc] initWithRow:theRow andColumn:theColumn];    
}


- (void)draw{
    if (!self.enabled) {
        return;
    }
    glColor4f(type/4.0, 1.0, 0.0, 1.0);  
    glLineWidth(2.0);
    glEnable(GL_LINE_SMOOTH);
    CGPoint points[4] = {
        ccp(kMTPieceMargin, kMTPieceMargin),
        ccp(kMTPieceMargin, kMTPieceSize - kMTPieceMargin),
        ccp(kMTPieceSize-kMTPieceMargin, kMTPieceSize-kMTPieceMargin),
        ccp(kMTPieceSize-kMTPieceMargin, kMTPieceMargin)
    };
    ccDrawPoly(points, 4, YES);
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
