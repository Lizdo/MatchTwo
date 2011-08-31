//
//  GameConfig.h
//  MatchTwo
//
//  Created by  on 11-8-1.
//  Copyright StupidTent co. 2011年. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

//
// Define here the type of autorotation that you want for your game
//

// 3rd generation and newer devices: Rotate using UIViewController. Rotation should be supported on iPad apps.
// TIP:
// To improve the performance, you should set this value to "kGameAutorotationNone" or "kGameAutorotationCCDirector"
#if defined(__ARM_NEON__) || TARGET_IPHONE_SIMULATOR
#define GAME_AUTOROTATION kGameAutorotationUIViewController

// ARMv6 (1st and 2nd generation devices): Don't rotate. It is very expensive
#elif __arm__
#define GAME_AUTOROTATION kGameAutorotationNone


// Ignore this value on Mac
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)

#else
#error(unknown architecture)
#endif

#endif // __GAME_CONFIG_H

// Match Two Specific Settings

#define kMTDefaultUIPadding 16.0f

#define kMTDefaultColumnNumber 10
#define kMTDefaultRowNumber 10
#define kMTDefaultGameTime 200.0f
#define kMTDefaultTypeNumber 9

#define kMTPieceSize 64.0f
#define kMTPieceMargin 4.0f
#define kMTPieceScaleTime 0.2f
#define kMTPieceDisappearTime 0.2f

#define kMTAbilityButtonTextureSize 512.0f
#define kMTAbilityButtonSpriteSize 128.0f
#define kMTAbilityButtonSize 96.0f
#define kMTAbilityButtonPadding kMTDefaultUIPadding
#define kMTAbilityBadgeSize 32.0f
#define kMTAbilityBadgePadding 12.0f

#define kMTBoardStartingX 64.0f
#define kMTBoardStartingY 200.0f

#define kMTBoardShuffleWarningTime 2.0f
#define kMTBoardShuffleTime 1.0f

#define kMTTimeLineWidth 768.0f
#define kMTTimeLineHeight 30.0f
#define kMTTimeLineStartingX 0.0f
#define kMTTimeLineStartingY (1024.0 - kMTTimeLineHeight)

#define kMTScoreDisplayWidth 300.0f
#define kMTScoreDisplayHeight 50.0f
#define kMTScoreDisplayStartingX 0.0f
#define kMTScoreDisplayStartingY (kMTTimeLineStartingY - kMTScoreDisplayHeight - kMTDefaultUIPadding)

#define kMTMenuPadding 10.0f

#define kMTFont @"FZLanTingHei-R-GBK"
#define kMTFontSizeCaption 80.0f
#define kMTFontSizeNormal 40.0f
#define kMTFontSizeSmall 20.0f

#define kMTFloatingLabelDefaultPosition (ccp(700.0f, 900.0f))
#define kMTFloatingLabelOnScreenTime 3.0f

#define kMTBadgeWaitingTime 0.3f
#define kMTBadgeFloatingTime 1.0f


#pragma mark -
#pragma mark Game Balancing

#define kMTScorePerGame 4000.0f
#define kMTScorePerPiece 12.0f

