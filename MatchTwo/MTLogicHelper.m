//
//  MTLogicHelper.m
//  MatchTwo
//
//  Created by  on 11-8-1.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTLogicHelper.h"
#import "MTPiece.h"

@implementation MTTile
@synthesize x,y,state,lastConnectedTile,isSource,isDestination;

+ (MTTile *)tileWithX:(int)idx andY:(int)idy{
    MTTile * t = [[MTTile alloc]init];
    t.x = idx;
    t.y = idy;
    return [t autorelease];
}

// Source/Destination Tile are considered Empty, 
// because we want to handle case like xxxSDxxxx

- (BOOL)isEmpty{
    if (state == TileState_Empty) {
        return YES;
    }
    if (isSource) {
        return YES;
    }
    if (isDestination) {
        return YES;
    }    
    return NO;
}

@end


@implementation MTLogicHelper

- (id)initWithRows:(int)row andColumns:(int)col{
    self = [super init];
    if (self) {
        rowNumber = row + 2;
        columnNumber = col + 2;
        tiles = [[NSMutableArray alloc] initWithCapacity:rowNumber*columnNumber];
        for (int i = 0; i < rowNumber; i++) {
            for (int j = 0; j < columnNumber; j++) {
                [tiles insertObject:[MTTile tileWithX:i andY:j] atIndex:i*columnNumber+j];
            }
        }
    }
    return self;
}


- (MTTile *)tileWithRow:(int)row andColumn:(int)column{
    return [tiles objectAtIndex:row*columnNumber+column];
}

- (NSArray *)adjucentEmptyTilesFrom:(MTTile*)sourceTile{
    NSMutableArray * returnArray = [NSMutableArray arrayWithCapacity:0];
    MTTile * t;
    
    // Go Up
    for (int i = sourceTile.x - 1; i >= 0; i--) {
        t = [self tileWithRow:i andColumn:sourceTile.y];
        if ([t isEmpty]) {
            [returnArray addObject:t];
        }else{
            break;
        }
    }

    // Go Down
    for (int i = sourceTile.x + 1; i < rowNumber; i++) {
        t = [self tileWithRow:i andColumn:sourceTile.y];
        if ([t isEmpty]) {
            [returnArray addObject:t];
        }else{
            break;
        }
    }
    
    // Go Left
    for (int j = sourceTile.y - 1; j >= 0; j--) {
        t = [self tileWithRow:sourceTile.x andColumn:j];
        if ([t isEmpty]) {
            [returnArray addObject:t];
        }else{
            break;
        }
    }
    
    // Go Right
    for (int j = sourceTile.y + 1; j < columnNumber; j++) {
        t = [self tileWithRow:sourceTile.x andColumn:j];
        if ([t isEmpty]) {
            [returnArray addObject:t];
        }else{
            break;
        }
    }
    
    return returnArray;
}


- (void)setSourceRow:(int)row andColumn:(int)column{
    if (source) {
        source.isSource = NO;
    }
    source = [self tileWithRow:row andColumn:column];
    source.isSource = YES;
}

- (void)setDestinationRow:(int)row andColumn:(int)column{
    if (destination) {
        destination.isDestination = NO;
    }
    destination = [self tileWithRow:row andColumn:column];
    destination.isDestination = YES;
}

- (void)reset{
    for (MTTile * t in tiles) {
        t.state = TileState_Empty;
    }
}

- (NSArray *)check{
    // Step.1 Start from S, mark all adjucent 0 to 1
    NSArray * adjucentTiles = [self adjucentEmptyTilesFrom:source];
    
    for (MTTile * t in adjucentTiles) {
        if (t == destination) {
            return [self GLLocationForTiles:[NSArray arrayWithObjects:source,destination, nil]];
        }
        t.state = TileState_FirstStep;
        t.lastConnectedTile = source;
    }
    //NSLog(@"%@", [self description]);

    // Step.2 Start from 1, mark all adjucent 0 to 2, remember the 1
    for (MTTile * tile in tiles) {
        if (tile.state == TileState_FirstStep) {
            adjucentTiles = [self adjucentEmptyTilesFrom:tile];
            for (MTTile * t in adjucentTiles){
                if (t == destination) {
                    return [self GLLocationForTiles:[NSArray arrayWithObjects:source,tile,destination, nil]];
                }
                t.state = TileState_SecondStep;
                t.lastConnectedTile = tile;
            }
        }
    }
    // Step.3 Start from 2, try to find destination tile
    for (MTTile * tile in tiles) {
        if (tile.state == TileState_SecondStep) {
            adjucentTiles = [self adjucentEmptyTilesFrom:tile];
            for (MTTile * t in adjucentTiles){
                if (t == destination) {
                    return [self GLLocationForTiles:[NSArray arrayWithObjects:source,tile.lastConnectedTile,tile,destination, nil]];
                }
            }
        }
    }
    // Still not found, bye bye
    return nil;
}

- (CGPoint)GLLocationForTile:(MTTile *)t{
    CCLOGINFO(@"%@", [self description]);
    
    CGPoint p = ccp(kMTBoardStartingX+(t.y-0.5)* kMTPieceSize,
                    kMTBoardStartingY+(t.x-0.5)* kMTPieceSize);
    return p;
}

- (NSArray *)GLLocationForTiles:(NSArray *)array{
    if (array == nil) {
        return nil;
    }
    
    NSMutableArray * returnArray = [NSMutableArray arrayWithCapacity:0];
    for (MTTile * t in array){
        [returnArray addObject:[NSValue valueWithCGPoint:[self GLLocationForTile:t]]];
    }
    return returnArray;
}


- (NSString *)description{
    NSString * returnString = @"\n";
    NSString * s;
    for (int i = rowNumber - 1; i>=0; i--) {
        for (int j = 0; j<columnNumber; j++) {
            MTTile * t = [self tileWithRow:i andColumn:j];
            switch (t.state) {
                case TileState_Empty:
                    s = @"0";
                    break;                    
                case TileState_FirstStep:
                    s = @"1";
                    break;
                case TileState_SecondStep:
                    s = @"2";                    
                    break;                   
                default:
                    s = @"X";
                    break;
            }
            if (t.isSource) {
                s = @"S";
            }
            else if (t.isDestination) {
                s = @"D";
            }
            returnString = [returnString stringByAppendingString:s];
        }
        returnString = [returnString stringByAppendingString:@"\n"];
    }
    return returnString;
}



@end
