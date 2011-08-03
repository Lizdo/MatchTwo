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

@synthesize row,column,type;

static ccTime ScaleTime = 0.1;

- (void)setSelected:(BOOL)toBeSelected{
    if (toBeSelected != selected) {
        selected = toBeSelected;
        if (selected) {
            [self runAction:[CCScaleTo actionWithDuration:ScaleTime scale:1.2]];
        }else{
//            self.scale = 1.0;
            [self runAction:[CCScaleTo actionWithDuration:ScaleTime scale:1.0]];            
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
        self.contentSize = CGSizeMake(MTPieceSize, MTPieceSize);
        self.anchorPoint = ccp(0.5, 0.5);        
    }
    return self;
}

+ (MTPiece *)pieceWithRow:(int)theRow andColumn:(int)theColumn{
    return [[MTPiece alloc] initWithRow:theRow andColumn:theColumn];    
}


- (void)draw{
    glColor4f(type/4.0, 1.0, 0.0, 1.0);  
    glLineWidth(2.0);
    glEnable(GL_LINE_SMOOTH);
    CGPoint points[4] = {
        ccp(MTPieceMargin, MTPieceMargin),
        ccp(MTPieceMargin, MTPieceSize - MTPieceMargin),
        ccp(MTPieceSize-MTPieceMargin, MTPieceSize-MTPieceMargin),
        ccp(MTPieceSize-MTPieceMargin, MTPieceMargin)
    };
    ccDrawPoly(points, 4, YES);
}

- (NSString *)description{
    return [NSString stringWithFormat:@"Piece at Row: %d, Column: %d",row,column];
}


- (void)disappear{
    // TODO: Spawn a particle
    self.visible = NO;
}


@end
