//
//  MTGame.m
//  MatchTwo
//
//  Created by  on 11-8-1.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTGame.h"
#import "GameConfig.h"

@interface MTGame ()
- (void)prepare;
- (NSArray *)randomizeType;
- (void)gameFailMenu;
- (void)gameSuccessMenu;
- (void)pauseMenu;
@end

@implementation MTGame

#define DefaultcolumnNumber 10
#define DefaultRowNumber 10
#define DefaultGameTime 10.0f
#define DefaultTypeNumber 9


- (id)initWithLevelID:(int)theLevelID{
    self = [super init];
    if (self){
        levelID = theLevelID;
        [self prepare];
    }
    return self;
}

- (id)init
{
    NSAssert(1==1, @"Cannot initialize this directly, use initWithLevelID instead");
    return nil;
}

- (void) prepare{
    paused = NO;
    
    // Initialization code here.
    NSDictionary * dic = [[MTSharedManager instance] settingsForLevelID:levelID];
    
    initialTime = [[dic objectForKey:@"initialTime"] floatValue];
    numberOfTypes = [[dic objectForKey:@"numberOfTypes"] intValue];
    
    remainingTime = initialTime;
    
    // TODO: Add Background Layer
    
    background  = [[[MTBackground alloc] init] autorelease];
    [self addChild:background];
    
    
    board = [[MTBoard alloc]initWithRowNumber:DefaultRowNumber 
                              andColumnNumber:DefaultcolumnNumber];
    [board autorelease];
    board.game = self;
    [self addChild:board];
    
    // Randomize
    NSArray * randomTypes = [self randomizeType];
    
    for (int i=1; i<=board.rowNumber; i++) {
        for (int j=1; j<=board.columnNumber; j++) {
            // Add initial pieces
            int type = [[randomTypes objectAtIndex:(i-1)*board.columnNumber + j - 1] intValue];
            MTPiece * piece = [[[MTPiece alloc] 
                                initWithType:type] autorelease];
            piece.row = i;
            piece.column = j;
            // Add 0.5 * kMTPieceSize because the anchor is in the middle;
            piece.position = ccp(kMTBoardStartingX+(j-0.5)* kMTPieceSize,
                                 kMTBoardStartingY+(i-0.5)* kMTPieceSize);
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
    
    // Add Score Display
    CGSize dimension = CGSizeMake(600, 50);
    
    scoreLabel = [CCLabelTTF labelWithString:@"分数:0"
                                  dimensions:dimension
                                   alignment:UITextAlignmentLeft
                                    fontName:kMTFont
                                    fontSize:30];
    
    scoreLabel.position = ccp(350, 950);
    [self addChild:scoreLabel];
    
    // Add Pause Button
    
    CCMenuItemFont * pauseButton = [CCMenuItemFont itemFromString:@"暂停" target:self selector:@selector(pause)];
    pauseButton.position = ccp(700, 50);
    
    buttons = [CCMenu menuWithItems:pauseButton, nil];
    buttons.position = ccp(0,0);
    
    [self addChild:buttons];
    
    [self scheduleUpdateWithPriority:0];
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
    
    int numberOfShuffle = 6;
    
    while (numberOfShuffle > 0) {
        for (int i = 0; i < totalCount; ++i) {
            // Select a random element between i and end of array to swap with.
            int nElements = totalCount - i;
            int n = (arc4random() % nElements) + i;
            [array exchangeObjectAtIndex:i withObjectAtIndex:n];
        }
        numberOfShuffle--;
    }
    
    
    return array;
}


- (void)update:(ccTime)dt{
    if (paused) {
        return;
    }
    
    remainingTime -= dt;
    if (remainingTime <= 0) {
        remainingTime = 0;
        // End Game Here.
        paused = YES;
        [board pause];
        [self gameFailMenu];
    }
    
    // Selected pieces should be in the front
    for (MTPiece * piece in board.children) {
        if ([piece class] == [MTPiece class] && piece.selected) {
            [board reorderChild:piece z:100];
        }
    }
    
    BOOL allPiecesDisabled = YES;
    
    for (MTPiece * piece in board.children) {
        if (piece.enabled == YES) {
            allPiecesDisabled = NO;
            break;
        }
    }
    
    if (allPiecesDisabled) {
        paused = YES;
        [board pause];
        [self gameSuccessMenu];
    }
    
    timeLine.percentage = remainingTime/initialTime;
    [timeLine visit];
    
    scoreLabel.string = [NSString stringWithFormat:@"分数: %d", 
                         [MTSharedManager instance].totalScore];
    
}

- (void)drawLinesWithPoints:(NSArray *)points{
    MTLine * line = [MTLine lineWithPoints:points];
    [self addChild:line];
    
    MTParticleDisappear * p = [[[MTParticleDisappear alloc]init]autorelease];
    [self addChild:p];
    p.position = [[points objectAtIndex:0] CGPointValue];    
    
    p = [[[MTParticleDisappear alloc]initWithTotalParticles:150]autorelease];
    [self addChild:p];
    p.position = [[points lastObject] CGPointValue];
    
    
}


#pragma -
#pragma Menus

- (void)gameFailMenu{
    menuBackground = [CCNode node];
    [self addChild:menuBackground];
    
    CCLayerColor * overlay = [CCLayerColor layerWithColor:ccc4(20, 20, 20, 120)];
    [menuBackground addChild:overlay];
    
    CCLabelTTF * timeUpLabel = [CCLabelTTF labelWithString:@"时间到了..."
                                                  fontName:kMTFont
                                                  fontSize:80];
    CGSize winSize = [[CCDirector sharedDirector] winSize];    
    timeUpLabel.position = ccp(winSize.width/2, 700);
    [menuBackground addChild:timeUpLabel];
    
    menu = [CCMenu menuWithItems:[CCMenuItemFont itemFromString:@"重新开始"
                                                                   block:^(id sender){[self restart];}],
                     [CCMenuItemFont itemFromString:@"主菜单"
                                              block:^(id sender){
                                                  [[MTSharedManager instance] replaceSceneWithID:0];}],                         
                     nil];
    [menu alignItemsVerticallyWithPadding:kMTMenuPadding];
    [self addChild:menu];
    
}

- (void)pauseMenu{
    menuBackground = [CCNode node];
    [self addChild:menuBackground];    
    
    CCLayerColor * overlay = [CCLayerColor layerWithColor:ccc4(20, 20, 20, 120)];
    [menuBackground addChild:overlay];
    
    CCLabelTTF * timeUpLabel = [CCLabelTTF labelWithString:@"游戏暂停"
                                                  fontName:kMTFont
                                                  fontSize:80];
    CGSize winSize = [[CCDirector sharedDirector] winSize];    
    timeUpLabel.position = ccp(winSize.width/2, 700);
    [menuBackground addChild:timeUpLabel];
    
    menu = [CCMenu menuWithItems:
                     [CCMenuItemFont itemFromString:@"继续"
                                            block:^(id sender){[self resume];}],
                     [CCMenuItemFont itemFromString:@"重新开始"
                                              block:^(id sender){[self restart];}],                     
                     [CCMenuItemFont itemFromString:@"主菜单"
                                              block:^(id sender){
                                                  [[MTSharedManager instance] replaceSceneWithID:0];}],                         
                     nil];
    [menu alignItemsVerticallyWithPadding:kMTMenuPadding];
    [self addChild:menu];
}


- (void)gameSuccessMenu{
    menuBackground = [CCNode node];
    [self addChild:menuBackground];    
    
    CCLayerColor * overlay = [CCLayerColor layerWithColor:ccc4(20, 20, 20, 120)];
    [menuBackground addChild:overlay];
    
    CCLabelTTF * levelSuccessLabel = [CCLabelTTF labelWithString:@"恭喜过关..."
                                                        fontName:kMTFont
                                                        fontSize:80];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    levelSuccessLabel.position = ccp(winSize.width/2, 700);
    [menuBackground addChild:levelSuccessLabel];    
    
    menu = [CCMenu menuWithItems:[CCMenuItemFont itemFromString:@"下一关"
                                                                   block:^(id sender){
                                                                       [[MTSharedManager instance] gotoNextLevel:levelID];}],
                     [CCMenuItemFont itemFromString:@"主菜单"
                                              block:^(id sender){
                                                  [[MTSharedManager instance] replaceSceneWithID:0];}],                     
                     nil];
    
    [menu alignItemsVerticallyWithPadding:kMTMenuPadding];
    [self addChild:menu];
    
}

- (void)pause{
    paused = YES;
    [self pauseMenu];
}

- (void)resume{
    [menuBackground removeFromParentAndCleanup:YES];
    [menu removeFromParentAndCleanup:YES];
    paused = NO;    
}

- (void)restart{
    // Stop all schedule & timer
    [self cleanup];
    [self removeAllChildrenWithCleanup:YES];
    [self prepare];
}

@end
