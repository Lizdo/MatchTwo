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

@interface MTBoard (private)
- (MTPiece *)pieceOnLocation:(CGPoint)location;

- (void)selectPiece:(MTPiece *)piece;
- (void)deselectPiece:(MTPiece *)piece;
- (void)deselectAllPieces;

- (void)checkConnection;

@end

@implementation MTBoard

@synthesize rowNumber, columnNumber;


- (id)init{
    self = [super init];
    if (self) {
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    }
    return self;
}

- (id)initWithRowNumber:(int)row andColumnNumber:(int)col{
    if ([self init]) {
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
        if (piece != nil) {
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
    selectedPiece1.selected = NO;
    selectedPiece2.selected = NO;
    selectedPiece1 = nil;
    selectedPiece2 = nil;
}

- (void)checkConnection{;
   
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
        [selectedPiece1 disappear];
        [selectedPiece2 disappear];        
    }
    
    checkingInProgress = NO;
    
}



@end
