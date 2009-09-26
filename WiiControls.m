//
//  WiiControls.m
//  MusicController
//
//  Created by David Becerril Valle on 6/21/08.
//  Copyright 2008 DaveBV.es. All rights reserved.
//

#import "WiiControls.h"


@implementation WiiControls

/*WiiRemoteAButton,
WiiRemoteBButton,
WiiRemoteOneButton,
WiiRemoteTwoButton,
WiiRemoteMinusButton,
WiiRemoteHomeButton,
WiiRemotePlusButton,
WiiRemoteUpButton,
WiiRemoteDownButton,
WiiRemoteLeftButton,
WiiRemoteRightButton,

WiiNunchukZButton,
WiiNunchukCButton,

WiiClassicControllerXButton,
WiiClassicControllerYButton,
WiiClassicControllerAButton,
WiiClassicControllerBButton,
WiiClassicControllerLButton,
WiiClassicControllerRButton,
WiiClassicControllerZLButton,
WiiClassicControllerZRButton,
WiiClassicControllerUpButton,
WiiClassicControllerDownButton,
WiiClassicControllerLeftButton,
WiiClassicControllerRightButton,
WiiClassicControllerMinusButton,
WiiClassicControllerHomeButton,
WiiClassicControllerPlusButton*/

@synthesize AButton;
@synthesize BButton;
@synthesize OneButton;
@synthesize TwoButton;
@synthesize MinusButton;
@synthesize HomeButton;
@synthesize PlusButton;
@synthesize UpButton;
@synthesize DownButton;
@synthesize LeftButton;
@synthesize RightButton;
@synthesize aceleracionx;
@synthesize aceleraciony;
@synthesize aceleracionz;
@synthesize roll;
@synthesize pitch;
// Datos de calibracion
@synthesize manualCalib;
@synthesize accX_zero;
@synthesize accY_zero;
@synthesize accZ_zero;
@synthesize accX_1g;
@synthesize accY_1g;
@synthesize accZ_1g;

@end
