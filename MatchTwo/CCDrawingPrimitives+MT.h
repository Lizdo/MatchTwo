//
//  CCDrawingPrimitives+MT.h
//  MatchTwo
//
//  Created by  on 11-8-10.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#ifndef MatchTwo_CCDrawingPrimitives_MT_h
#define MatchTwo_CCDrawingPrimitives_MT_h


void ccDrawPolyFill( const CGPoint *poli, NSUInteger numberOfPoints, BOOL closePolygon );
void ccDrawCircleSegment( CGPoint center, float r, float a, NSUInteger segs, BOOL drawLineToCenter);
void ccDrawCircleSegmentFill( CGPoint center, float r, float a, NSUInteger segs);
#endif
