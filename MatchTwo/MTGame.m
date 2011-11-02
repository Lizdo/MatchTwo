//
//  MTGame.m
//  MatchTwo
//
//  Created by  on 11-8-1.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTGame.h"
#import "GameConfig.h"
#import "MTUnlockManager.h"
#import "SimpleAudioEngine.h"

@interface MTGame ()
- (void)prepare;
- (NSArray *)randomizeType;
- (void)stopRunning;

- (void)gameFailMenu;
- (void)gameSuccessMenu;
- (void)pauseMenu;
- (void)pushPauseMenu;

- (void)flyBadge:(CCSprite *)b to:(CGPoint)p ability:(NSString *)abilityName;
- (void)calculateScore;

- (void)drawLinesWithPoints:(NSArray *)points;

// Updates for GameModes
- (void)updateGameModes;

@end



@implementation MTGame

@synthesize menu, menuBackground, levelID, obj, timeBonus, completeBonus, objBonus;

- (MTObjectiveState)objState{
    return objState;
}

- (void)setObjState:(MTObjectiveState)newState{
    if (objState == newState) {
        return;
    }
    if (newState == kMTObjectiveStateFailed) {
        //Announce the fail
    }
    objState = newState;
}

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

- (float)remainingTime{
    return remainingTime;
}

// Y-Offset to compensate the missing rows.
static float boardOffsetY;

- (void) prepare{
    // Initialize the nodes.
    CGSize winSize = [[CCDirector sharedDirector] winSize];       
    gameLayer = [CCLayer node];
    menuLayer = [CCLayer node];
    menuLayer.position = ccp(-winSize.width,0);
    backgroundLayer = [CCLayer node];
    [self addChild:backgroundLayer];
    [self addChild:gameLayer];
    [self addChild:menuLayer];
    
    paused = NO;
    
    // Set Theme
    [MTTheme setTheme:[MTTheme randomConfig]];
    
    // Initialization code here.
    NSDictionary * dic = [[MTSharedManager instance] settingsForLevelID:levelID];
    
    initialTime = [[dic objectForKey:kMTSInitialTime] floatValue];
    numberOfTypes = [[dic objectForKey:kMTSNumberOfTypes] intValue];
    obj = [[dic objectForKey:kMTSObjective] intValue];
    
    // Add Bonus from player level
    NSDictionary * bonusUnlock = [[MTSharedManager instance] bonusSettings];
    
    initialTime += [[bonusUnlock objectForKey:kMTUnlockExtraTimeCount] intValue] * 5.0f;
    scoreMultiplier = 1 + [[bonusUnlock objectForKey:kMTUnlockExtraScoreCount] intValue] * 0.02f;
    bonusMultiplier = 1 + [[bonusUnlock objectForKey:kMTUnlockExtraBonusCount] intValue] * 0.02f;
    
    remainingTime = initialTime;
    needShuffleCheck = YES;
    
    background  = [[[MTBackground alloc] init] autorelease];
    [backgroundLayer addChild:background];
    
    mode = [[dic objectForKey:kMTGameMode] intValue];
    
    
//    board = [[MTBoard alloc]initWithRowNumber:kMTDefaultRowNumber 
//                              andColumnNumber:kMTDefaultColumnNumber];
    int rows = [[dic objectForKey:kMTNumberOfRows] intValue];
    int columns = [[dic objectForKey:kMTNumberOfColumns] intValue];
    
    NSAssert(rows<=kMTDefaultRowNumber, @"Too Many Rows.");
    NSAssert(columns<=kMTDefaultColumnNumber, @"Too Many Columns.");
    
    // Compensate the missing rows.
    boardOffsetY = (kMTDefaultRowNumber - rows)/2*kMTPieceSize;
    
    board = [[MTBoard alloc]initWithRowNumber:rows andColumnNumber:columns];
    [board autorelease];
    board.game = self;
    [gameLayer addChild:board];
    
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
            piece.position = [MTGame positionForPiece:piece];
            piece.game = self;
            [board addChild:piece];
        }
    }
    
    timeDisplay = [MTTimeDisplay labelWithString:@""
                                     fontName:kMTFontNumbers
                                     fontSize:kMTFontSizeLarge];
    timeDisplay.anchorPoint = ccp(1.0, 0.0);
    timeDisplay.position = ccp(768-30,1024-131);
    timeDisplay.game = self;
    [gameLayer addChild:timeDisplay];
    //        
    // TODO: Add SFX Layer 
    
    // Add Score Display
    scoreDisplay = [[MTScoreDisplay alloc]init];
    scoreDisplay.position = ccp(kMTScoreDisplayStartingX, kMTScoreDisplayStartingY);
    scoreDisplay.game = self;
    [gameLayer addChild:scoreDisplay];
    
    // Add Pause Button
    
    CCMenuItemFont * pauseButton = [CCMenuItemFont itemFromString:@"暂停" target:self selector:@selector(pause)];
    pauseButton.position = ccp(700, 50);
    pauseButton.color = [MTTheme foregroundColor];
    
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
    
    abilityButtons = [[NSMutableArray arrayWithCapacity:6]retain];
    
    for (MTAbility * ability in abilities) {
        if (ability.type == MTAbilityType_Button && [ability available]) {
            MTAbilityButton * button = [MTAbilityButton abilityButtonWithName:ability.name
                                                                       target:self
                                                                     selector:@selector(abilityButtonClicked:)
                                        ];
            [abilityButtons addObject:button];
        }
    }
    
    CGPoint p = ccp(kMTBoardStartingX + kMTAbilityButtonSize/2,
                    kMTAbilityButtonPadding* 2 + kMTAbilityButtonSize/2);
    
    for (MTAbilityButton * b in abilityButtons) {
        b.position = p;
        p = ccpAdd(p, ccp(kMTAbilityButtonPadding + kMTAbilityButtonSize, 0));
        [buttons addChild:b];        
    }
    
    [gameLayer addChild:buttons];
    
    // Add floating label manager
    floatingLabels = [[MTFloatingLabelManager alloc] init];

    
    // Add Particles
    dissolveParticle1 = [CCParticleSystemQuad particleWithFile:@"Particle_Dissolve.plist"];
    [dissolveParticle1 stopSystem];
    [gameLayer addChild:dissolveParticle1];
    dissolveParticle2 = [CCParticleSystemQuad particleWithFile:@"Particle_Dissolve.plist"];
    [dissolveParticle2 stopSystem];    
    [gameLayer addChild:dissolveParticle2];
    
    // Add Tap To Start Layer
    tapToStart = [MTTouchToStartLayer layerWithColor:ccc4(0, 0, 0, 120)];
    [self addChild:tapToStart];
    tapToStart.delegate = self;

}

- (void)dealloc{
    // Need to release all containers, CCNodes will be released automatically.
    [floatingLabels release];
    [abilities release];
    [abilityButtons release];
    [super dealloc];
}

- (void)start{
    [tapToStart removeFromParentAndCleanup:YES];
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
    if (paused) {
        // Shuffle should not be triggering in Menu...etc
        return;
    }
    paused = YES;
    [board pause];
    // Add a text explaining the shuffle...
    [gameLayer addChild:[floatingLabels addLabelWithString:@"重新排列"]];
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
    
    // Check victiory condition First
    
    BOOL allPiecesDisabled = YES;
    
    for (MTPiece * piece in board.children) {
        if (piece.enabled == YES) {
            allPiecesDisabled = NO;
            break;
        }
    }
    
    if (allPiecesDisabled) {
        [self gameSuccessMenu];
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
    if (![self isAbilityActive:kMTAbilityFreeze]) {
        remainingTime -= dt;
        // Check objective
        if (obj == kMTObjectiveFinishFast){
            if (remainingTime*3 < initialTime) {
                self.objState = kMTObjectiveStateFailed;
            }
        }
    }
    [timeDisplay update];
    
    if (remainingTime <= 0) {
        remainingTime = 0;
        // End Game Here.
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
    
    // Update GameMode
    [self updateGameModes];
    
    [scoreDisplay update:dt];
    
    // Update AI
#ifdef kMTAIPlay
        [board findLink];
#endif
    
}

- (void)updateGameModes{
    switch (mode) {
        case kMTGameModeDown:
            [board collapse:kMTCollapseDirectionDown];
            break;
        case kMTGameModeUp:
            [board collapse:kMTCollapseDirectionUp];
            break;
        case kMTGameModeLeft:
            [board collapse:kMTCollapseDirectionLeft];
            break;
        case kMTGameModeRight:
            [board collapse:kMTCollapseDirectionRight];
            break;            
        default:
            break;
    }
}

- (void)calculateScore{
    timeBonus = round(remainingTime) * kMTScorePerSecond;
    completeBonus = kMTScorePerGame;
    if (obj != kMTObjectiveNone
        && objState == kMTObjectiveStateComplete) {
        objBonus = kMTScorePerObj;
    }
    [MTSharedManager instance].totalScore += (timeBonus + completeBonus + objBonus);
}

#pragma mark -
#pragma mark Menus

- (void)gameFailMenu{
    [self stopRunning];

    pauseMenu = [MTLevelFailPage node];
    [self pushPauseMenu];
}

- (void)pauseMenu{
    [self stopRunning];
    pauseMenu = [MTPausePage node];

    [self pushPauseMenu];
}


- (void)gameSuccessMenu{
    // Check objective
    if (obj != kMTObjectiveNone
        && objState != kMTObjectiveStateFailed) {
        self.objState = kMTObjectiveStateComplete;
    }
    
    [self calculateScore];
    [self stopRunning];
    
    // Record the current level status
    [[MTSharedManager instance] completeLevel:levelID andObjective:NO];
    
    pauseMenu = [MTLevelCompletePage node];
    [self pushPauseMenu];
}

#define kMTParallexOffset 40.0f

- (void)pushPauseMenu{
    pauseMenu.game = self;
    [pauseMenu show];    
    [menuLayer addChild:pauseMenu];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];            
    //pauseMenu.position = ccp(0,0);
    
    // Animate In
    [menuLayer runAction:[CCMoveTo actionWithDuration:kMTMenuPageLoadingTime position:ccp(0,0)]];
    [gameLayer runAction:[CCMoveTo actionWithDuration:kMTMenuPageLoadingTime position:ccp(winSize.width,0)]];
    [backgroundLayer runAction:[CCMoveTo actionWithDuration:kMTMenuPageLoadingTime position:ccp(kMTParallexOffset,0)]];
}

#pragma mark -
#pragma mark Display Related

- (NSString *)remainingTimeString{
    return [MTTimeDisplay stringWithSeconds:round(remainingTime)];
}

- (NSString *)objectiveString{
    return [MTObjectiveHelper descriptionForObjective:obj];
}


#pragma mark -
#pragma mark Game Logic


- (void)drawLinesWithPoints:(NSArray *)points{
    needShuffleCheck = YES;
    
    MTLine * line = [MTLine lineWithPoints:points];
    [gameLayer addChild:line];

    dissolveParticle1.position = [[points objectAtIndex:0] CGPointValue];
    [dissolveParticle1 resetSystem];

    dissolveParticle2.position = [[points lastObject] CGPointValue];
    [dissolveParticle2 resetSystem];	
    
    
}


- (void)linkDissolved:(NSArray *)points{
    [self drawLinesWithPoints:points];
    
    int scoreForTile;
    if ([self isAbilityActive:kMTAbilityDoubleScore]) {
        scoreForTile = round(kMTScorePerPiece*2*scoreMultiplier);
    }else{
        scoreForTile = round(kMTScorePerPiece*scoreMultiplier);
    }
    
    // Add popup
    MTFloatingScore * scorePopup = [MTFloatingScore labelWithScore:scoreForTile];
    scorePopup.position = [[points lastObject] CGPointValue];
    [gameLayer addChild:scorePopup];
    
    [MTSharedManager instance].totalScore += scoreForTile;
}

- (void)levelUp{
    [gameLayer addChild:[floatingLabels addLabelWithString:@"升级了！"]];    
}


- (void)pause{
    board.visible = NO;
    [self pauseMenu];
}

- (void)stopRunning{
    if (paused) {
        return;
    }
    paused = YES;
    [board pause];
    buttons.isTouchEnabled = NO;    
}

- (void)resumeFromPauseMenu{
    CGSize winSize = [[CCDirector sharedDirector] winSize];           
    // Animate In
    [menuLayer runAction:[CCMoveTo actionWithDuration:kMTMenuPageLoadingTime position:ccp(-winSize.width,0)]];
    [gameLayer runAction:[CCMoveTo actionWithDuration:kMTMenuPageLoadingTime position:ccp(0,0)]];
    [backgroundLayer runAction:[CCMoveTo actionWithDuration:kMTMenuPageLoadingTime position:ccp(0,0)]];
    
    [self runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:kMTMenuPageLoadingTime],
                     [CCCallBlock actionWithBlock:^
    {
        [pauseMenu removeFromParentAndCleanup:YES];
        [self resume];
    }],nil]];
}

- (void)resume{
    board.visible = YES;    
    [menuBackground removeFromParentAndCleanup:YES];
    [menu removeFromParentAndCleanup:YES];
    buttons.isTouchEnabled = YES;    
    [board resume];
    paused = NO;    
}

- (void)restartFromPauseMenu{
    CGSize winSize = [[CCDirector sharedDirector] winSize];    
    // Animate In
    [menuLayer runAction:[CCMoveTo actionWithDuration:kMTMenuPageLoadingTime position:ccp(-winSize.width,0)]];
    [gameLayer runAction:[CCMoveTo actionWithDuration:kMTMenuPageLoadingTime position:ccp(0,0)]];
    [backgroundLayer runAction:[CCMoveTo actionWithDuration:kMTMenuPageLoadingTime position:ccp(0,0)]];
    
    [self runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:kMTMenuPageLoadingTime],
                     [CCCallBlock actionWithBlock:^
                      {
                          [pauseMenu removeFromParentAndCleanup:YES];
                          [self restart];
                      }],nil]];    
}

- (void)restart{
    // Stop all schedule & timer
    [self cleanup];
    [self removeAllChildrenWithCleanup:YES];
    [self prepare];
}

+ (CGPoint)positionForPiece:(MTPiece *)piece{
    return [MTGame positionForRow:piece.row andColumn:piece.column];
}

+ (CGPoint)positionForRow:(int)row andColumn:(int)column{
    // Add 0.5 * kMTPieceSize because the anchor is in the middle;
    CGPoint p = ccp(kMTBoardStartingX+(column-0.5)* kMTPieceSize,
                    kMTBoardStartingY+(row-0.5)* kMTPieceSize + boardOffsetY);
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
    
    // Check Objective
    if (obj == kMTObjectiveNoAbility) {
        if ([self abilityNamed:n].type == MTAbilityType_Button) {
            self.objState = kMTObjectiveStateFailed;
        }
    }
    
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
        CGPoint p = timeDisplay.position;
        [self flyBadge:badge to:p ability:abilityName];        
        return;
    }
    if (abilityName == kMTAbilityDoubleScore){    
        [self flyBadge:badge
                    to:ccp(kMTScoreDisplayWidth, scoreDisplay.position.y + 15)
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
    [gameLayer addChild:b z:100];
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
                  [CCEaseIn actionWithAction:[CCBezierTo actionWithDuration:kMTBadgeFloatingTime bezier:c] rate:2],
                        [CCDelayTime actionWithDuration:kMTBadgeWaitingTime],
                        [CCCallBlock actionWithBlock:^{
        [b removeFromParentAndCleanup:YES];
        [self activateAbility:abilityName];
    }],
     nil]];
    [b autorelease];
}

@end
