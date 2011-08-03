//
//  MTLogicHelper.m
//  MatchTwo
//
//  Created by  on 11-8-1.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTLogicHelper.h"

@implementation MTLogicHelper

static int** g;
static int row;
static int col;

//        //Original Graph
//        00000000
//        01000000
//        09999000
//        00990090
//        00000020
//        00000000
//
//
//        //Step 1
//        03000000
//        31333333
//        09999900
//        00990090
//        33333323
//        00000030
//
//
//        //Step 2
//        03000000
//        31333333
//        09999903
//        00990093
//        33333323
//        00000030

+ (NSArray*)lineFromTileGraph:(int**)graph numberOfRows:(int)rownum andColumns:(int)colnum{
    g = graph;
    row = rownum;
    col = colnum;
    // Step 0: Check if they're on the same Row/Colmn
    
    NSLog(@"%d, %d, %d", g[2][2], g[2][3], g[4][6]);
    
	// Step 1: Replace adjucent 0 with 3
	
	// Step 1.1: Check if there are any corners
	
	// Step 2: for each 3, see if each 3 can be connected
    
    return nil;
}

+ (int*)firstGridInGraph{
    return nil;
}

@end
