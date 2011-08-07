//
//  MTSFX.m
//  MatchTwo
//
//  Created by  on 11-8-7.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTSFX.h"

@implementation MTParticleDisappear
-(id) init
{
	return [self initWithTotalParticles:1500];
}

-(id) initWithTotalParticles:(NSUInteger)p
{
	if( (self=[super initWithTotalParticles:p]) ) {
		// duration
		duration = 0.01;
        
		// Gravity Mode
		self.emitterMode = kCCParticleModeGravity;
        
		// Gravity Mode: gravity
		self.gravity = ccp(1.15,1.58);
		
		// Gravity Mode:  radial
		self.radialAccel = 0;
		self.radialAccelVar = 0;
        
		//  Gravity Mode: speed of particles
		self.speed = 130;
		self.speedVar = 1;
		
		// emitter position
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		self.position = ccp(winSize.width/2, winSize.height/2);
		
		// angle
		angle = 360;
		angleVar = 360;
        
		// life of particles
		life = 0.0f;
		lifeVar = 1.118f;
        
		// emits per frame
		emissionRate = totalParticles/life;
		
		// color of particles
		startColor.r = 0.5f;
		startColor.g = 0.5f;
		startColor.b = 0.0f;
		startColor.a = 0.6f;
		startColorVar.r = 0.1f;
		startColorVar.g = 0.1f;
		startColorVar.b = 0.0f;
		startColorVar.a = 0.1f;
		endColor.r = 0.5f;
		endColor.g = 0.5f;
		endColor.b = 0.0f;
		endColor.a = 0.2f;
		endColorVar.r = 0.1f;
		endColorVar.g = 0.1f;
		endColorVar.b = 0.0f;
		endColorVar.a = 0.2f;
		
		// size, in pixels
		startSize = 34.0f;
		startSizeVar = 38.0f;
		endSize = 14.0f;
        
		self.texture = [[CCTextureCache sharedTextureCache] addImage: @"Particle.png"];
        
		// additive
		self.blendAdditive = NO;
	}
	
	return self;
}
@end
