//
//  MTBoard.m
//  MatchTwo
//
//  Created by  on 11-8-3.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTBoard.h"
#import "MTPiece.h"
#import "MTLogicHelper.h"
#import "MTGame.h"

@interface MTBoard (private)
- (MTPiece *)pieceOnLocation:(CGPoint)location;

- (void)selectPiece:(MTPiece *)piece;
- (void)deselectPiece:(MTPiece *)piece;
- (void)deselectAllPieces;

- (void)checkConnection;

- (void)resetHelper;

@end

@implementation MTBoard

@synthesize rowNumber, columnNumber, game;


- (id)init{
    //self = [super initWithFile:@"Tile.png" capacity:100];
    self = [super init];
    if (self) {
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    }
    return self;
}

- (id)initWithRowNumber:(int)row andColumnNumber:(int)col{
    self = [self init];
    if (self) {
        rowNumber = row;
        columnNumber = col;
        helper = [[MTLogicHelper alloc]initWithRows:rowNumber andColumns:columnNumber];
    }
    return self;
}

// To select a piece, we can
//  1.  Start a Touch
//  2.  Move a Touch to an unselected piece
// But NOT move a touch to an selected piece

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:[touch view]];
    CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
    
    if (CGRectContainsPoint(self.boundingBox, convertedLocation)) 
    {
        MTPiece * piece = [self pieceOnLocation:convertedLocation];
        if (piece != nil && piece.enabled) {
            piece.selected ? [self deselectPiece:piece]:[self selectPiece:piece];
        }
        return YES;
    }
    
    // Not in Rect, not hit.
    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:[touch view]];
    CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
    
    if (CGRectContainsPoint(self.boundingBox, convertedLocation)) 
    {
        MTPiece * piece = [self pieceOnLocation:convertedLocation];
        if (piece != nil && piece.selected == NO) {
            [self selectPiece:piece];
        }
    }    
}


- (MTPiece *)pieceOnLocation:(CGPoint)location{
    for (MTPiece * piece in self.children) {
        if (CGRectContainsPoint(piece.boundingBox, location)) 
        {
            return piece;
        }
    }
    return nil;
}


- (void)selectPiece:(MTPiece *)piece{
    
    if (!piece.enabled) {
        return;
    }
    
    if (piece == selectedPiece1 || piece == selectedPiece2) {
        return;
    }
    
    piece.selected = YES;
    
    if (selectedPiece1 == nil) {
        selectedPiece1 = piece;
        return;
    }
    
    if (selectedPiece2 == nil) {
        selectedPiece2 = piece;
        [self checkConnection];
        return;
    }
    
    // Rotate piece 1/2/current selection
    [self deselectAllPieces];
    selectedPiece1 = piece;
    return;
}


- (void)deselectPiece:(MTPiece *)piece{
    piece.selected = NO;
    
    if (piece == selectedPiece1) {
        selectedPiece1 = selectedPiece2;
        selectedPiece2 = nil;
    }
    
    if (piece == selectedPiece2) {
        selectedPiece2 = nil;
    }
}

- (void)deselectAllPieces{
    if (selectedPiece1) {
        selectedPiece1.selected = NO;
    }
    if (selectedPiece2) {
        selectedPiece2.selected = NO;
    }
    
    if (selectedPiece1 && selectedPiece2) {
        [selectedPiece1 shake];
        [selectedPiece2 shake];
    }
    
    selectedPiece1 = nil;
    selectedPiece2 = nil;
}

- (void)checkConnection{
   
    if (selectedPiece1 == nil || selectedPiece2 == nil) {
        return;
    }
    
    if (selectedPiece1.type != selectedPiece2.type) {
        [self deselectAllPieces];
        return;
    }
    
    checkingInProgress = YES;
    
    // Reset the MTLogicHelper
    [helper reset];
    
    // Set Occupied Tiles
    for (MTPiece * piece in self.children) {
        if (piece == selectedPiece1) {
            [helper setSourceRow:piece.row andColumn:piece.column];
        }else if (piece == selectedPiece2) {
            [helper setDestinationRow:piece.row andColumn:piece.column];
        }
        else if (piece.enabled) {
            [helper tileWithRow:piece.row andColumn:piece.column].state = TileState_Occupied;            
        }
    }
    
    NSArray * result = [helper check];
    
    if (result == nil) {       
        [self deselectAllPieces];
    }else{
        // Dissolve Link before remove the tile, allow the score to popup
        [game linkDissolved:result];
        [selectedPiece1 disappear];
        [selectedPiece2 disappear];        
    }
    
    checkingInProgress = NO;
    
}

// Find available links on the board.

- (BOOL)findLink{
    
    // Reset original hints
    for (MTPiece * piece in self.children) {
        if (piece.hinted) {
            piece.hinted = NO;
        }
    }    
    
    // Populate the helper
    [self resetHelper];
    
    // Find all types and tiles;
    NSMutableArray * currentTypes = [NSMutableArray arrayWithCapacity:10];
    NSMutableDictionary * tileForTypes = [NSMutableDictionary dictionaryWithCapacity:10];
    for (MTPiece * piece in self.children) {
        if (!piece.enabled) {
            continue;
        }
        NSNumber * type = [NSNumber numberWithInt:piece.type];
        if ([currentTypes indexOfObject:type] == NSNotFound) {
            [currentTypes addObject:type];
            NSMutableArray * array = [NSMutableArray arrayWithObject:piece];
            [tileForTypes setObject:array forKey:type];
        }else{
            NSMutableArray * array = [tileForTypes objectForKey:type];
            [array addObject:piece];
        }
    }
    
    // Search in each type
    for (NSNumber * type in currentTypes) {
        NSMutableArray * pieces = [tileForTypes objectForKey:type];
        for (int i = 0; i < [pieces count] - 1; i++) {
            MTPiece * piece1 = [pieces objectAtIndex:i];
            [helper setSourceRow:piece1.row andColumn:piece1.column];
            for (int j = i + 1; j<[pieces count]; j++) {
                MTPiece * piece2 = [pieces objectAtIndex:j];
                [helper setDestinationRow:piece2.row andColumn:piece2.column];
                NSArray * result = [helper check];
                if (result != nil) {
                    // Connection Found!
                    if ([game isAbilityActive:kMTAbilityHint]) {
                        piece1.hinted = YES;
                        piece2.hinted = YES;
                        // AI will just select these pieces...
                        if (kMTAIPlay) {
                            [self selectPiece:piece1];
                            [self selectPiece:piece2];
                        }
                    }
                    return YES;
                }else{
                    [self resetHelper];
                }
            }
        }
    }
    
    return NO;

}

- (void)shuffle{
    
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:20];
    for (MTPiece * p in self.children) {
        if (p.enabled) {
            [array addObject:p];
            // Reset Hint/Selection            
            p.selected = NO;
            p.hinted = NO;
        }
    }
    
    if ([array count] == 0) {
        // Stop shuffle if no tile remains.
        return;
    }
    
    // Shuffle the array
    int numberOfShuffle = 2;
    int totalCount = [array count];
    
    while (numberOfShuffle > 0) {
        for (int i = 0; i < totalCount; ++i) {
            // Select a random element between i and end of array to swap with.
            int nElements = totalCount - i;
            int n = (arc4random() % nElements) + i;
            [array exchangeObjectAtIndex:i withObjectAtIndex:n];
        }
        numberOfShuffle--;
    }
    
    // Assign pointer to shufflePiece
    for (int i = 0; i < totalCount-1; ++i) {
        MTPiece * piece1 = [array objectAtIndex:i];
        MTPiece * piece2 = [array objectAtIndex:i+1];
        piece1.shufflePiece = piece2;
    }
    
    MTPiece * piece = [array lastObject];
    piece.shufflePiece = [array objectAtIndex:0];
    
    for (MTPiece * p in array) {
        [p shuffle];
    }
}

- (void)resetHelper{
    [helper reset];
    for (MTPiece * piece in self.children) {
        if (piece.enabled) {
            [helper tileWithRow:piece.row andColumn:piece.column].state = TileState_Occupied;            
        }
    } 
}

- (MTPiece *)randomPiece{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:10];
    for (MTPiece * p in self.children) {
        if (p.enabled && p.ability == @"") {
            [array addObject:p];
        }
    }
    return [array objectAtIndex:arc4random()%[array count]];
}

- (void)pause{
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
}

- (void)resume{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

@end
