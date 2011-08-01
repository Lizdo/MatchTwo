//
//  MTPiece.m
//  MatchTwo
//
//  Created by  on 11-8-1.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTPiece.h"


@implementation MTPiece

- (id)initWithRow:(int)theRow andColumn:(int)theColumn{
    if (self = [super init]) {
        row = theRow;
        column = theColumn;
    }
    return self;
}

+ (MTPiece *)pieceWithRow:(int)theRow andColumn:(int)theColumn{
    return [[MTPiece alloc] initWithRow:theRow andColumn:theColumn];    
}

@end
