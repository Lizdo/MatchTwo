//
//  CCDrawingPrimitives+MT.m
//  MatchTwo
//
//  Created by  on 11-8-10.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <math.h>
#import <stdlib.h>
#import <string.h>

#import "CCDrawingPrimitives.h"
#import "CCDrawingPrimitives+MT.h"
#import "ccTypes.h"
#import "ccMacros.h"
//#import "Platforms/CCGL.h"


void ccDrawPolyFill( const CGPoint *poli, NSUInteger numberOfPoints, BOOL closePolygon )
{
	ccVertex2F newPoint[numberOfPoints];
    
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states: GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_TEXTURE_COORD_ARRAY, GL_COLOR_ARRAY	
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
    
	
	// iPhone and 32-bit machines
	if( sizeof(CGPoint) == sizeof(ccVertex2F) ) {
        
		// convert to pixels ?
		if( CC_CONTENT_SCALE_FACTOR() != 1 ) {
			memcpy( newPoint, poli, numberOfPoints * sizeof(ccVertex2F) );
			for( NSUInteger i=0; i<numberOfPoints;i++)
				newPoint[i] = (ccVertex2F) { poli[i].x * CC_CONTENT_SCALE_FACTOR(), poli[i].y * CC_CONTENT_SCALE_FACTOR() };
            
			glVertexPointer(2, GL_FLOAT, 0, newPoint);
            
		} else
			glVertexPointer(2, GL_FLOAT, 0, poli);
        
		
	} else {
		// 64-bit machines (Mac)
		
		for( NSUInteger i=0; i<numberOfPoints;i++)
			newPoint[i] = (ccVertex2F) { poli[i].x, poli[i].y };
        
		glVertexPointer(2, GL_FLOAT, 0, newPoint );
        
	}
    
	if( closePolygon )
		//glDrawArrays(GL_LINE_LOOP, 0, (GLsizei) numberOfPoints);
        glDrawArrays(GL_TRIANGLE_FAN, 0, (GLsizei) numberOfPoints);
	else
		glDrawArrays(GL_LINE_STRIP, 0, (GLsizei) numberOfPoints);
	
	// restore default state
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);	
}


void ccDrawCircleSegment( CGPoint center, float r, float a, NSUInteger segs, BOOL drawLineToCenter)
{
	int additionalSegment = 1;
	if (drawLineToCenter)
		additionalSegment++;
    
	const float coef = a/segs;
	
	GLfloat *vertices = calloc( sizeof(GLfloat)*2*(segs+2), 1);
	if( ! vertices )
		return;
    
	for(NSUInteger i=0;i<=segs;i++)
	{
		float rads = i*coef;
        // Start from top and clockwise
		GLfloat j = r * cosf(rads-M_PI_2) + center.x;
		GLfloat k = - r * sinf(rads-M_PI_2) + center.y;
		
		vertices[i*2] = j * CC_CONTENT_SCALE_FACTOR();
		vertices[i*2+1] =k * CC_CONTENT_SCALE_FACTOR();
	}
	vertices[(segs+1)*2] = center.x * CC_CONTENT_SCALE_FACTOR();
	vertices[(segs+1)*2+1] = center.y * CC_CONTENT_SCALE_FACTOR();
	
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states: GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_TEXTURE_COORD_ARRAY, GL_COLOR_ARRAY	
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	
	glVertexPointer(2, GL_FLOAT, 0, vertices);	
	glDrawArrays(GL_LINE_STRIP, 0, (GLsizei) segs+additionalSegment);
	
	// restore default state
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);	
	
	free( vertices );
}

// Stroke with Anti-Alias, Add an extra transparent vertex on the other side of the stroke.
void ccDrawCircleSegmentAA( CGPoint center, float r, float a, float lineWidth, NSUInteger segs)
{
    GLubyte color[4] = {102,102,102,255};
    
	const float coef = a/segs;
	
	GLfloat *vertices = calloc( sizeof(GLfloat)*4*(segs+2), 1);
    GLubyte *colors = calloc(sizeof(GLubyte)*8*(segs+2), 1);
	if( ! vertices )
		return;
    
	for(NSUInteger i=0;i<=segs;i++)
	{
		float rads = i*coef;
        // Start from top and clockwise
		GLfloat j = r * cosf(rads-M_PI_2) + center.x;
		GLfloat k = - r * sinf(rads-M_PI_2) + center.y;
		
		vertices[i*4] = j * CC_CONTENT_SCALE_FACTOR();
		vertices[i*4+1] =k * CC_CONTENT_SCALE_FACTOR();
        
        colors[i*8] = color[0];
        colors[i*8+1] = color[1];
        colors[i*8+2] = color[2];
        colors[i*8+3] = color[3];
        
        j = (r+lineWidth) * cosf(rads-M_PI_2) + center.x;
        k = - (r+lineWidth) * sinf(rads-M_PI_2) + center.y;
		
		vertices[i*4+2] = j * CC_CONTENT_SCALE_FACTOR();
		vertices[i*4+3] =k * CC_CONTENT_SCALE_FACTOR();
        
        colors[i*8+4] = 0;
        colors[i*8+5] = 0;
        colors[i*8+6] = 0;
        colors[i*8+7] = 0;        // Alpha set to 0 for outside lines
	}
	
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states: GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_TEXTURE_COORD_ARRAY, GL_COLOR_ARRAY	
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	//glDisableClientState(GL_COLOR_ARRAY);
	
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, colors);
	glVertexPointer(2, GL_FLOAT, 0, vertices);	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, ((GLsizei) segs)*2);
	
	// restore default state
	//glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);	
	
    free(colors);
	free( vertices );
}

void ccDrawCircleSegmentFill( CGPoint center, float r, float a, NSUInteger segs)
{
    BOOL drawLineToCenter = YES;
	int additionalSegment = 1;
	if (drawLineToCenter)
		additionalSegment++;
    
	const float coef = a/segs;
	
	GLfloat *vertices = calloc( sizeof(GLfloat)*2*(segs+2), 1);
	if( ! vertices )
		return;
    
	for(NSUInteger i=0;i<=segs;i++)
	{
		float rads = i*coef;
        // Start from top and clockwise
		GLfloat j = r * cosf(rads-M_PI_2) + center.x;
		GLfloat k = - r * sinf(rads-M_PI_2) + center.y;
		
		vertices[i*2] = j * CC_CONTENT_SCALE_FACTOR();
		vertices[i*2+1] =k * CC_CONTENT_SCALE_FACTOR();
	}
	vertices[(segs+1)*2] = center.x * CC_CONTENT_SCALE_FACTOR();
	vertices[(segs+1)*2+1] = center.y * CC_CONTENT_SCALE_FACTOR();
	
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states: GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_TEXTURE_COORD_ARRAY, GL_COLOR_ARRAY	
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	
	glVertexPointer(2, GL_FLOAT, 0, vertices);	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei) segs+additionalSegment);
	
	// restore default state
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);	
	
	free( vertices );
}

