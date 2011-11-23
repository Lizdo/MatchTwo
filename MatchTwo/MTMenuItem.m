//
//  MTMenuItem.m
//  MatchTwo
//
//  Created by  on 11-11-23.
//  Copyright (c) 2011年 StupidTent co. All rights reserved.
//

#import "MTMenuItem.h"

@interface MTMenuItem ()
- (void)addBackground;
@end

@implementation MTMenuItem

- (void)addBackground{
    CGPoint center = ccp(self.contentSize.width/2, 
                         self.contentSize.height/2);
    
    // Add Background
    backgroundNormal = [CCSprite spriteWithFile:@"MenuItemBackground_Normal.png"];
    backgroundNormal.color = [MTTheme primaryColor];
    backgroundNormal.position = center;
    [self addChild:backgroundNormal];
    
    backgroundSelected = [CCSprite spriteWithFile:@"MenuItemBackground_Selected.png"];
    backgroundSelected.color = [MTTheme primaryColor];             
    backgroundSelected.position = center;        
    [self addChild:backgroundSelected];        
    backgroundSelected.visible = NO;   
}


- (MTMenuItem *)initWithString:(NSString *)str target:(id)r selector:(SEL)s{
    CCLabelTTF * label = [CCLabelTTF labelWithString:str
                                            fontName:kMTFont
                                            fontSize:kMTFontSizeNormal];
    self = [super initWithLabel:label target:r selector:s];
    if (self) {
        [self addBackground];
    }
    return self;
}


+ (id)itemFromString:(NSString *)str target:(id)r selector:(SEL)s{
    return [[[MTMenuItem alloc] initWithString:str target:r selector:s] autorelease];
}

- (MTMenuItem *)initWithString:(NSString *)str block:(void (^)(id))block{
    CCLabelTTF * label = [CCLabelTTF labelWithString:str
                                            fontName:kMTFont
                                            fontSize:kMTFontSizeNormal];
    self = [super initWithLabel:label block:block];
    if (self) {
        [self addBackground];
    }
    return self;
    
}

+ (id)itemFromString:(NSString *)str block:(void (^)(id))block{
    return [[[MTMenuItem alloc]initWithString:str block:block]autorelease];
}
                      
-(void) selected
{
	isSelected_ = YES;
    backgroundNormal.visible = NO;
    backgroundSelected.visible = YES;
}

-(void) unselected
{
	isSelected_ = NO;
    backgroundNormal.visible = YES;
    backgroundSelected.visible = NO;    
}

#pragma mark -
#pragma mark CCRGBAProtocol

- (void) setOpacity: (GLubyte)opacity
{
    [backgroundNormal setOpacity:opacity];
    [backgroundSelected setOpacity:opacity];    
    [super setOpacity:opacity];
}

-(GLubyte) opacity
{
	return [label_ opacity];
}


                      

@end
