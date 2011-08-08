//
//  MTGame.m
//  MatchTwo
//
//  Created by  on 11-8-1.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTGame.h"

@interface MTGame ()
- (NSArray *)randomizeType;
@end

@implementation MTGame

#define DefaultcolumnNumber 10
#define DefaultRowNumber 10
#define DefaultGameTime 100.0f
#define DefaultTypeNumber 9

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        initialTime = DefaultGameTime;
        remainingTime = initialTime;
        numberOfTypes = DefaultTypeNumber;
        
        // TODO: Add Background Layer
        
        board = [[MTBoard alloc]initWithRowNumber:DefaultRowNumber 
                                  andColumnNumber:DefaultcolumnNumber];
        board.game = self;
        [self addChild:board];

        // Randomize
        NSArray * randomTypes = [self randomizeType];
        
        for (int i=1; i<=board.columnNumber; i++) {
            for (int j=1; j<=board.rowNumber; j++) {
                // Add initial pieces
                int type = [[randomTypes objectAtIndex:(i-1)*board.columnNumber + j - 1] intValue];
                MTPiece * piece = [[[MTPiece alloc] 
                                    initWithType:type] autorelease];
                piece.row = i;
                piece.column = j;
                // Add 0.5 * kMTPieceSize because the anchor is in the middle;
                piece.position = ccp(kMTBoardStartingX+(i-0.5)* kMTPieceSize,
                                     kMTBoardStartingY+(j-0.5)* kMTPieceSize);
                [board addChild:piece];
            }
        }

        // Line should be on top of the Pieces
//        lines = [[MTLine alloc] init];
//        [self addChild:lines];
        
        timeLine = [[MTTimeLine alloc] init];
        timeLine.position = ccp(kMTTimeLineStartingX, kMTTimeLineStartingY);        
        [self addChild:timeLine];

//        
        // TODO: Add SFX Layer        
        
        [self scheduleUpdateWithPriority:0];
    }
    return self;
}


- (NSArray *)randomizeType{
    int totalCount = board.columnNumber*board.rowNumber;
    NSAssert(totalCount % 2 == 0, @"Total count must be an even number!");
    
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:totalCount];
    for (int i = 0; i < totalCount ; i += 2) {
        int randomType = arc4random() % numberOfTypes;
        [array addObject:[NSNumber numberWithInt:randomType]];
        [array addObject:[NSNumber numberWithInt:randomType]];
    }
    
    for (int i = 0; i < totalCount; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = totalCount - i;
        int n = (arc4random() % nElements) + i;
        [array exchangeObjectAtIndex:i withObjectAtIndex:n];
    }

    return array;
}


- (void)update:(ccTime)dt{
    remainingTime -= dt;
    if (remainingTime <= 0) {
        remainingTime = 0;
        // End Game Here.
        board.isTouchEnabled = NO;
    }
    
    // Selected pieces should be in the front
    for (MTPiece * piece in board.children) {
        if ([piece class] == [MTPiece class] && piece.selected) {
            [board reorderChild:piece z:100];
        }
    }
    
    timeLine.percentage = remainingTime/initialTime;
    [timeLine visit];
    
}

- (void)drawLinesWithPoints:(NSArray *)points{
    MTLine * line = [MTLine lineWithPoints:points];
    [self addChild:line];
    
    MTParticleDisappear * p = [[[MTParticleDisappear alloc]initWithTotalParticles:150]autorelease];
    [self addChild:p];
    p.position = [[points objectAtIndex:0] CGPointValue];    
    
    p = [[[MTParticleDisappear alloc]initWithTotalParticles:150]autorelease];
    [self addChild:p];
    p.position = [[points lastObject] CGPointValue];

    
}


@end
