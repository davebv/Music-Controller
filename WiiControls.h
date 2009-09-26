//
//  WiiControls.h
//  MusicController
//
//  Created by David Becerril Valle on 6/21/08.
//  Copyright 2008 DaveBV.es. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface WiiControls : NSObject {
	BOOL AButton;
	BOOL BButton;
	BOOL OneButton;
	BOOL TwoButton;
	BOOL MinusButton;
	BOOL HomeButton;
	BOOL PlusButton;
	BOOL UpButton;
	BOOL DownButton;
	BOOL LeftButton;
	BOOL RightButton;
	double aceleracionx;
	double aceleraciony;
	double aceleracionz;
	double roll;
	double pitch;
	
	// Calibracion
	BOOL manualCalib;
	int accX_zero;
	int accY_zero;
	int accZ_zero;
	int accX_1g;
	int accY_1g;
	int accZ_1g;
}

@property (readwrite,assign) BOOL AButton;
@property (readwrite,assign) BOOL BButton;
@property (readwrite,assign) BOOL OneButton;
@property (readwrite,assign) BOOL TwoButton;
@property (readwrite,assign) BOOL MinusButton;
@property (readwrite,assign) BOOL HomeButton;
@property (readwrite,assign) BOOL PlusButton;
@property (readwrite,assign) BOOL UpButton;
@property (readwrite,assign) BOOL DownButton;
@property (readwrite,assign) BOOL LeftButton;
@property (readwrite,assign) BOOL RightButton;
@property (readwrite,assign) double aceleracionx;
@property (readwrite,assign) double aceleraciony;
@property (readwrite,assign) double aceleracionz;
@property (readwrite,assign) double roll;
@property (readwrite,assign) double pitch;
// Datos de calibración.
@property (readwrite,assign) BOOL manualCalib;
@property (readwrite,assign) int accX_zero;
@property (readwrite,assign) int accY_zero;
@property (readwrite,assign) int accZ_zero;
@property (readwrite,assign) int accX_1g;
@property (readwrite,assign) int accY_1g;
@property (readwrite,assign) int accZ_1g;


@end
