//
//  MTGame.m
//  MatchTwo
//
//  Created by  on 11-8-1.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTGame.h"

@implementation MTGame

#define DefaultColomnNumber 10
#define DefaultRowNumber 10
#define DefaultGameTime 100.0f

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        colomnNumber = DefaultColomnNumber;
        rowNumber = DefaultRowNumber;
        initialTime = DefaultGameTime;
        remainingTime = initialTime;
        
        // TODO: Add Background Layer
        
        board = [[CCNode alloc]init];
        [self addChild:board];
        
        for (int i=0; i<colomnNumber; i++) {
            for (int j=0; j<rowNumber; j++) {
                // Add initial pieces
                MTPiece * piece = [MTPiece pieceWithRow:i andColumn:j];
                piece.position = ccp(64 + i* MTPieceSize, 300 + j* MTPieceSize);
                piece.type = arc4random() % 4;
                [board addChild:piece];
                [MTPieces addObject:piece];
            }
        }
        
        // Line should be on top of the Pieces
        line = [[MTLine alloc] init];
        [self addChild:line];
        
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
    
    for (MTPiece * piece in board.children) {
        if ([piece class] == [MTPiece class] && piece.selected) {
            [board reorderChild:piece z:100];
        }
    }
}

@end
