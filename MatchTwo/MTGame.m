//
//  MTGame.m
//  MatchTwo
//
//  Created by  on 11-8-1.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTGame.h"

@implementation MTGame

#define DefaultcolumnNumber 10
#define DefaultRowNumber 10
#define DefaultGameTime 100.0f

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        initialTime = DefaultGameTime;
        remainingTime = initialTime;
        
        // TODO: Add Background Layer
        
        board = [[MTBoard alloc]initWithRowNumber:DefaultRowNumber 
                                  andColumnNumber:DefaultcolumnNumber];
        board.game = self;
        [self addChild:board];
   

        for (int i=1; i<=board.columnNumber; i++) {
            for (int j=1; j<=board.rowNumber; j++) {
                // Add initial pieces
                MTPiece * piece = [MTPiece pieceWithRow:i andColumn:j];
                // Add 0.5 * kMTPieceSize because the anchor is in the middle;
                piece.position = ccp(64+(i-0.5)* kMTPieceSize,200+(j-0.5)* kMTPieceSize);
                piece.type = arc4random() % 4;
                [board addChild:piece];
            }
        }
        
        // Line should be on top of the Pieces
//        lines = [[MTLine alloc] init];
//        [self addChild:lines];
//        
        // TODO: Add SFX Layer        
        
        [self scheduleUpdateWithPriority:0];
    }
    return self;
}


- (void)update:(ccTime)dt{
    remainingTime -= dt;
    if (remainingTime <= 0) {
        remainingTime = 0;
    }
    
    // Selected pieces should be in the front
    for (MTPiece * piece in board.children) {
        if ([piece class] == [MTPiece class] && piece.selected) {
            [board reorderChild:piece z:100];
        }
    }
    
}

- (void)drawLinesWithPoints:(NSArray *)points{
    line = [MTLine lineWithPoints:points];
    [self addChild:line];
}


@end
