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

- (void)setSelected:(BOOL)toBeSelected{
    if (toBeSelected != selected) {
        selected = toBeSelected;
        if (selected) {
            self.anchorPoint = ccp(-0.5, 0.5);            
            [self runAction:[CCScaleTo actionWithDuration:ScaleTime scale:1.2]];
        }else{
            self.scale = 1.0;
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
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
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

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:[touch view]];
    CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
    
    CGSize size = CGSizeMake(MTPieceSize, MTPieceSize);
    CGPoint point = [self position];
    CGRect rect = CGRectMake(point.x, point.y, size.width, size.height); 
    
    if (CGRectContainsPoint(rect, convertedLocation)) 
    {
        self.selected = !self.selected;
        return YES;
    }
    
    // Not in Rect, not hit.
    return NO;
}




@end
