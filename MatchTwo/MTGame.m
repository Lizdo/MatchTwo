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
- (void)flyBadge:(CCSprite *)b to:(CGPoint)p ability:(NSString *)abilityName;
@end

@implementation MTGame

@synthesize menu, menuBackground;

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
    needShuffleCheck = YES;
    
    // TODO: Add Background Layer
    
    background  = [[[MTBackground alloc] init] autorelease];
    [self addChild:background];
    
    
    board = [[MTBoard alloc]initWithRowNumber:kMTDefaultRowNumber 
                              andColumnNumber:kMTDefaultColumnNumber];
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
            piece.position = [self positionForPiece:piece];
            piece.game = self;
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
                                    fontSize:kMTFontSizeNormal];
    
    scoreLabel.position = ccp(350, 950);
    [self addChild:scoreLabel];
    
    // Add Pause Button
    
    CCMenuItemFont * pauseButton = [CCMenuItemFont itemFromString:@"暂停" target:self selector:@selector(pause)];
    pauseButton.position = ccp(700, 50);
    
    buttons = [CCMenu menuWithItems:pauseButton, nil];
    buttons.position = ccp(0,0);
    
    // TEMP: Now we just add ability here, later should move to Level/SharedManager
    abilities = [[NSMutableArray arrayWithObjects:
                  [[[MTAbilityFreeze alloc]init]autorelease],
                  [[[MTAbilityHint alloc]init]autorelease],
                  [[[MTAbilityHighlight alloc]init]autorelease],
                  [[[MTAbilityShuffle alloc]init]autorelease], 
                  [[[MTAbilityDoubleScore alloc]init]autorelease],                   
                  [[[MTAbilityExtraTime alloc]init]autorelease],                                     
                nil] retain];
        
    abilityButtons = [[NSMutableArray arrayWithObjects:
                       [MTAbilityButton abilityButtonWithName:kMTAbilityHint target:self selector:@selector(abilityButtonClicked:)], 
                       [MTAbilityButton abilityButtonWithName:kMTAbilityFreeze target:self selector:@selector(abilityButtonClicked:)], 
                       [MTAbilityButton abilityButtonWithName:kMTAbilityHighlight target:self selector:@selector(abilityButtonClicked:)],
                       [MTAbilityButton abilityButtonWithName:kMTAbilityShuffle target:self selector:@selector(abilityButtonClicked:)],
                       nil]
                      retain];
    
    CGPoint p = ccp(kMTAbilityButtonPadding + kMTAbilityButtonSize/2,
                    kMTAbilityButtonPadding + kMTAbilityButtonSize/2);
    
    for (MTAbilityButton * b in abilityButtons) {
        b.position = p;
        p = ccpAdd(p, ccp(kMTAbilityButtonPadding + kMTAbilityButtonSize, 0));
        [buttons addChild:b];        
    }
    
    [self addChild:buttons];
    
    
    // Schedule the Update: function
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

- (void)shuffle{
    paused = YES;
    [board pause];
    // Add a text explaining the shuffle...
    [self addChild:[MTFloatingLabel labelWithString:@"重新排列"]];
    [board shuffle];
    // Remove the text after the animation...
    id delay = [CCDelayTime actionWithDuration:kMTBoardShuffleWarningTime+kMTBoardShuffleTime];   
    id callResume = [CCCallBlock actionWithBlock:^{
        paused = NO;
        [board resume];
    }];
    [self runAction:[CCSequence actions:delay,
                     callResume,
                     nil]];
}


- (void)update:(ccTime)dt{
    if (paused) {
        return;
    }
    
    // Update Abilities
    for (MTAbility * a in abilities){
        [a update:dt];
    }
    
    // Update Ability Buttons
    for (MTAbilityButton * b in abilityButtons) {
        [b update:dt];
    }
    
    // Passive Abilities needs to be managed manually
    for (MTAbility * a in abilities) {
        if (a.type == MTAbilityType_Activate 
            && a.state == MTAbilityState_Ready) {
            [[board randomPiece] assignAbility:a.name];
        }
    }

    // Update DT
    if ([self isAbilityActive:kMTAbilityFreeze]) {
        timeLine.frozen = YES;
    }else{
        timeLine.frozen = NO;
        remainingTime -= dt;
    }
    
    if ([self isAbilityActive:kMTAbilityExtraTime]) {
        timeLine.highlight = YES;
    }else{
        timeLine.highlight = NO;
    }
    
    if (remainingTime <= 0) {
        remainingTime = 0;
        // End Game Here.
        paused = YES;
        [board pause];
        [self gameFailMenu];
    }
    
    if (needShuffleCheck) {
        BOOL linkFound = [board findLink];
        if (!linkFound) {
            // Shuffle Board Here.
            CCLOG(@"No Link Found, Reshuffle needed...");
            [self shuffle];
            return;
        }
        needShuffleCheck = NO;
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
    
    if ([self isAbilityActive:kMTAbilityDoubleScore]) {
        scoreLabel.color = ccORANGE;
    }else{
        scoreLabel.color = ccWHITE;
    }
    
    scoreLabel.string = [NSString stringWithFormat:@"%d", 
                         [MTSharedManager instance].totalScore];
    
}

#pragma mark -
#pragma mark Menus

- (void)gameFailMenu{
    self.menuBackground = [CCNode node];
    [self addChild:menuBackground];
    
    CCLayerColor * overlay = [CCLayerColor layerWithColor:ccc4(20, 20, 20, 120)];
    [menuBackground addChild:overlay];
    
    CCLabelTTF * timeUpLabel = [CCLabelTTF labelWithString:@"时间到了..."
                                                  fontName:kMTFont
                                                  fontSize:kMTFontSizeCaption];
    CGSize winSize = [[CCDirector sharedDirector] winSize];    
    timeUpLabel.position = ccp(winSize.width/2, 700);
    [menuBackground addChild:timeUpLabel];
    
    self.menu = [CCMenu menuWithItems:[CCMenuItemFont itemFromString:@"重新开始"
                                                                   block:^(id sender){[self restart];}],
                     [CCMenuItemFont itemFromString:@"主菜单"
                                              block:^(id sender){
                                                  [[MTSharedManager instance] replaceSceneWithID:0];}],                         
                     nil];
    [menu alignItemsVerticallyWithPadding:kMTMenuPadding];
    [self addChild:menu];
    
}

- (void)pauseMenu{
    
    self.menuBackground = [CCNode node];
    [self addChild:menuBackground];    
    
    CCLayerColor * overlay = [CCLayerColor layerWithColor:ccc4(20, 20, 20, 120)];
    [menuBackground addChild:overlay];
    
    CCLabelTTF * timeUpLabel = [CCLabelTTF labelWithString:@"游戏暂停"
                                                  fontName:kMTFont
                                                  fontSize:kMTFontSizeCaption];
    CGSize winSize = [[CCDirector sharedDirector] winSize];    
    timeUpLabel.position = ccp(winSize.width/2, 700);
    [menuBackground addChild:timeUpLabel];
    
    self.menu = [CCMenu menuWithItems:
                     [CCMenuItemFont itemFromString:@"继续"
                                            block:^(id sender){[self resume];}],
                     [CCMenuItemFont itemFromString:@"重新开始"
                                              block:^(id sender){[self restart];}],
                    [CCMenuItemToggle itemWithBlock:^(id sender){[self restart];}],
                     [CCMenuItemFont itemFromString:@"主菜单"
                                              block:^(id sender){
                                                  [[MTSharedManager instance] replaceSceneWithID:0];}],                         
                     nil];
    [menu alignItemsVerticallyWithPadding:kMTMenuPadding];
    [self addChild:menu];
}


- (void)gameSuccessMenu{
    self.menuBackground = [CCNode node];
    [self addChild:menuBackground];    
    
    CCLayerColor * overlay = [CCLayerColor layerWithColor:ccc4(20, 20, 20, 120)];
    [menuBackground addChild:overlay];
    
    CCLabelTTF * levelSuccessLabel = [CCLabelTTF labelWithString:@"恭喜过关..."
                                                        fontName:kMTFont
                                                        fontSize:kMTFontSizeCaption];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    levelSuccessLabel.position = ccp(winSize.width/2, 700);
    [menuBackground addChild:levelSuccessLabel];    
    
    self.menu = [CCMenu menuWithItems:[CCMenuItemFont itemFromString:@"下一关"
                                                                   block:^(id sender){
                                                                       [[MTSharedManager instance] gotoNextLevel:levelID];}],
                     [CCMenuItemFont itemFromString:@"主菜单"
                                              block:^(id sender){
                                                  [[MTSharedManager instance] replaceSceneWithID:0];}],                     
                     nil];
    
    [menu alignItemsVerticallyWithPadding:kMTMenuPadding];
    [self addChild:menu];
    
}

#pragma mark -
#pragma mark Game Logic


- (void)drawLinesWithPoints:(NSArray *)points{
    needShuffleCheck = YES;
    
    MTLine * line = [MTLine lineWithPoints:points];
    [self addChild:line];
    
    MTParticleDisappear * p = [[[MTParticleDisappear alloc]init]autorelease];
    [self addChild:p];
    p.position = [[points objectAtIndex:0] CGPointValue];    
    
    p = [[[MTParticleDisappear alloc]initWithTotalParticles:150]autorelease];
    [self addChild:p];
    p.position = [[points lastObject] CGPointValue];
    
    
}


- (void)linkDissolved{
    if ([self isAbilityActive:kMTAbilityDoubleScore]) {
        [MTSharedManager instance].totalScore += 400;
    }else{
        [MTSharedManager instance].totalScore += 200;
    }
}

- (void)pause{
    if (paused) {
        return;
    }
    paused = YES;
    [board pause];
    buttons.isTouchEnabled = NO;
    [self pauseMenu];
}

- (void)resume{
    [menuBackground removeFromParentAndCleanup:YES];
    [menu removeFromParentAndCleanup:YES];
    buttons.isTouchEnabled = YES;    
    [board resume];
    paused = NO;    
}

- (void)restart{
    // Stop all schedule & timer
    [self cleanup];
    [self removeAllChildrenWithCleanup:YES];
    [self prepare];
}

- (CGPoint)positionForPiece:(MTPiece *)piece{
    // Add 0.5 * kMTPieceSize because the anchor is in the middle;
    CGPoint p = ccp(kMTBoardStartingX+(piece.column-0.5)* kMTPieceSize,
                         kMTBoardStartingY+(piece.row-0.5)* kMTPieceSize);  
    return p;
}


#pragma mark -
#pragma mark Ability Helper Functions
                                     

- (MTAbility *)abilityNamed:(NSString *)name{
    for (MTAbility * a in abilities) {
        if (a.name == name) {
            return a;
        }
    }
    return nil;
}


- (BOOL)isAbilityActive:(NSString *)name{
    MTAbility * a = [self abilityNamed:name];
    if (a != nil && a.active) {
        return YES;
    }
    return NO;
}

- (BOOL)isAbilityReady:(NSString *)name{
    MTAbility * a = [self abilityNamed:name];
    if (a != nil && a.ready) {
        return YES;
    }
    return NO;    
}




- (void)abilityButtonClicked:(MTAbilityButton *)button{
    [self activateAbility:button.name];
}

- (void)activateAbility:(NSString *)n{
    [[self abilityNamed:n] activate];
    
    // On Trigger Ability Activate Here
    if (n == kMTAbilityHint) {
        needShuffleCheck = YES;
    }
    
    // On Trigger Ability Activate Here
    if (n == kMTAbilityShuffle) {
        [self shuffle];
    }
    
    if (n == kMTAbilityExtraTime) {
        remainingTime += 10.0f;
    }
    
    // Update Abilities Once Here to update the UI
    for (MTAbility * a in abilities){
        [a update:0.05];
    }
    
    // Update Ability Buttons
    for (MTAbilityButton * b in abilityButtons) {
        [b update:0.05];
    }    
}

#pragma mark -
#pragma mark Floating Ability Badge

- (void)flyBadge:(CCSprite *)badge forAbility:(NSString *)abilityName{
    if (abilityName == kMTAbilityExtraTime){
        float percentage = [timeLine percentage];
        CGSize winSize = [[CCDirector sharedDirector] winSize];    
        CGPoint p = ccp(winSize.width * percentage, timeLine.position.y);
        [self flyBadge:badge to:p ability:abilityName];        
        return;
    }
    if (abilityName == kMTAbilityDoubleScore){    
        [self flyBadge:badge
                    to:ccp(200,scoreLabel.position.y + 15)
                    ability:abilityName
         ];
        return;
    }
}

- (void)flyBadge:(CCSprite *)b to:(CGPoint)p ability:(NSString *)abilityName{
    // When b is removed from parent, it will be de-allocated, thus retain here
    [b retain];
    
    // Need to record the position here
    CGPoint positionInWorld = [b convertToWorldSpace:b.position];
    [b.parent removeChild:b cleanup:NO];
    [self addChild:b z:100];
    b.position = positionInWorld;
    
    
    // Setup the Bezier
    CGPoint startingPosition = b.position;
    CGPoint midPoint = ccpMidpoint(startingPosition, p);
    CGPoint controlPoint1 = ccpAdd(ccpMidpoint(midPoint, startingPosition),
                                   ccp(50,0));
    CGPoint controlPoint2 = ccpAdd(ccpMidpoint(p, midPoint),
                                   ccp(100,0));
    ccBezierConfig c = {
        p,
        controlPoint1,
        controlPoint2,
    };    
    
    [b runAction:[CCSequence actions:
                        [CCDelayTime actionWithDuration:kMTBadgeWaitingTime],
                        [CCBezierTo actionWithDuration:kMTBadgeFloatingTime bezier:c],
                        [CCDelayTime actionWithDuration:kMTBadgeWaitingTime],
                        [CCCallBlock actionWithBlock:^{
        [b removeFromParentAndCleanup:YES];
        [self activateAbility:abilityName];
    }],
     nil]];
    [b autorelease];
}

@end
