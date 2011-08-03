//
//  MTPiece.h
//  MatchTwo
//
//  Created by  on 11-8-1.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

static float MTPieceSize = 64.0;
static float MTPieceMargin = 2.0;


@interface MTPiece : CCNode {
    int row;
    int column;
    
    int type;
    
    BOOL selected;
}

@property int row;
@property int column;
@property int type;
@property BOOL selected;


- (id)initWithRow:(int)theRow andColumn:(int)theColumn;
+ (MTPiece *)pieceWithRow:(int)theRow andColumn:(int)theColumn;

- (void)disappear;

@end
