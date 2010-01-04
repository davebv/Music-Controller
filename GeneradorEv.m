//
//  GeneradorEv.m
//  MusicController
//
//  Created by David Becerril Valle on 6/20/08.
//  Copyright 2008 DaveBV.es. All rights reserved.
//

#import "GeneradorEv.h"

@implementation GeneradorEv
-(id)init {
	[super init];
	
	[self setValue:[NSString stringWithFormat:@"Learn Mode"]
			forKey:@"modoSTR"] ;
	[self setValue:[NSNumber numberWithInt:0]
          forKey:@"modo"] ;
	[self setValue:[NSNumber numberWithInt:0]
          forKey:@"modo_ant"] ;
	variableA = NO ;
	valorrotANT1 = 127 ;
	valorincANT1 = 127 ;
	valorrotANT2 = 127 ;
	valorincANT2 = 127 ;
	valorrotANT3 = 127 ;
	valorincANT3 = 127 ;
	valorrotANT4 = 127 ;
	valorincANT4 = 127 ;
	
	// Threshold for scene Acceleration
	umbral = 1.8;
	
	contador = 0;
	
	//init buffers
	for (int i = 0 ; i < LONG_BUF ; i++) {
		acelex[i] = 0 ;
		aceley[i] = 0 ;
		acelez[i] = -1.0 ;
		rollb[i] = 0 ;
		pitchb[i] = 0 ;
	}
	return self;
}

@synthesize modoSTR;
@synthesize modo;
@synthesize modo_ant;

-(void)cambiaModo:(WiiControls *) _wiicontrols
	   conWiimote:(WiiRemote *)wiimote
		 isPressed:(BOOL)apretado
{
  
  if (modo == 5)
    return;

	if (apretado == FALSE)
		return;
  
	
	if ([_wiicontrols MinusButton] && [_wiicontrols PlusButton]) {
		modo = 0 ;
		[self setModoSTR:[NSString stringWithFormat:@"Learn Mode"]];
		[wiimote setLEDEnabled1:YES
					   enabled2:NO
					   enabled3:NO
					   enabled4:YES];
		return;
	}
  
	if ([_wiicontrols MinusButton]) {
		if (modo == 0 || modo == 1) {
			modo = 4 ;			
		} else {
			modo-- ;
		}
	}
	if ([_wiicontrols PlusButton]) {
		if (modo == 0 || modo == 4) {
			modo = 1 ;			
		} else {
			modo++ ;
		}
	}
	switch (modo) {
		case 1: [self setModoSTR:[NSString stringWithFormat:@"Beats"]];
			[wiimote setLEDEnabled1:YES
					   enabled2:NO
					   enabled3:NO
					   enabled4:NO];
			break;
		case 2: [self setModoSTR:[NSString stringWithFormat:@"Filters"]];
			[wiimote setLEDEnabled1:NO
					   enabled2:YES
					   enabled3:NO
					   enabled4:NO];
			break;
		case 3: [self setModoSTR:[NSString stringWithFormat:@"Scratch"]];
			[wiimote setLEDEnabled1:NO
					   enabled2:NO
					   enabled3:YES
					   enabled4:NO];
			break;
		case 4: [self setModoSTR:[NSString stringWithFormat:@"Sable Laser"]];
			[wiimote setLEDEnabled1:NO
					   enabled2:NO
					   enabled3:NO
					   enabled4:YES];
			break;
		default:
			break;
	}
}

-(void)cambiaModo:(unsigned short)manualMode
       conWiimote:(WiiRemote *)wiimote
{
  modo = manualMode ;
  
	switch (modo) {
    case 0:
      [self setModoSTR:[NSString stringWithFormat:@"Learn Mode"]];
      [wiimote setLEDEnabled1:YES
                     enabled2:NO
                     enabled3:NO
                     enabled4:YES];
      break;
		case 1: [self setModoSTR:[NSString stringWithFormat:@"Beats"]];
			[wiimote setLEDEnabled1:YES
                     enabled2:NO
                     enabled3:NO
                     enabled4:NO];
			break;
		case 2: [self setModoSTR:[NSString stringWithFormat:@"Filters"]];
			[wiimote setLEDEnabled1:NO
                     enabled2:YES
                     enabled3:NO
                     enabled4:NO];
			break;
		case 3: [self setModoSTR:[NSString stringWithFormat:@"Scratch"]];
			[wiimote setLEDEnabled1:NO
                     enabled2:NO
                     enabled3:YES
                     enabled4:NO];
			break;
		case 4: [self setModoSTR:[NSString stringWithFormat:@"Sable Laser"]];
			[wiimote setLEDEnabled1:NO
                     enabled2:NO
                     enabled3:NO
                     enabled4:YES];
			break;
		case 5: [self setModoSTR:[NSString stringWithFormat:@"1 on 1"]];
			[wiimote setLEDEnabled1:YES
                     enabled2:YES
                     enabled3:YES
                     enabled4:YES];
			break;
		default:
			break;
	}
}

-(void) manipular:(WiiControls *)_wiicontrols 
        mandarloA:(MidiEventOutput*)evts 
        tipoBoton:(WiiButtonType)boton
        mandarOSC: (OSCEventClass*)oscObj
{
  float cc_note = -1, value_cc_note = -1;
	switch (modo) {
		case 0:
      switch (boton) {
        case WiiRemoteOneButton:
          cc_note = 32; value_cc_note = 64 ;
          break;
        case WiiRemoteTwoButton:
          cc_note = 33; value_cc_note = 64 ;
          break;
        case WiiRemoteLeftButton:
          cc_note = 34; value_cc_note = 64 ;
          break;
        case WiiRemoteUpButton:
          cc_note = 35; value_cc_note = 64 ;
          break;
        case WiiRemoteRightButton:
          cc_note = 6; value_cc_note = 64 ;
          break;
        default:
          break;
      }
      [evts pushControl:cc_note value: value_cc_note]; // Roll mode 1
      [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:value_cc_note], nil]
                          typeOSC:[NSString stringWithFormat:@"ctrl"]] ;
      break;
		case 1:
			switch (boton) {
				case WiiRemoteAButton:
          cc_note = 7; value_cc_note = 127 ;
					[evts pushNoteOn:cc_note // Nota: G2
                  velocity:value_cc_note];
          [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:value_cc_note], nil]
                              typeOSC:[NSString stringWithFormat:@"note"]] ;
					[evts pushNoteOff:cc_note // Nota: G2
                   velocity:value_cc_note];					
          [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:0], nil]
                              typeOSC:[NSString stringWithFormat:@"note"]] ;
					break;
				case WiiRemoteOneButton:
          cc_note = 33; value_cc_note = 0 ;
					[evts pushControl:cc_note value:value_cc_note];
          [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:value_cc_note], nil]
                              typeOSC:[NSString stringWithFormat:@"ctrl"]] ;
					break;
				/*case WiiRemoteTwoButton:
					[evts pushControl:81 value:127];
					break;	*/				
				/*
				case WiiRemoteOneButton:
					if ([_wiicontrols OneButton]) {
						[evts pushNoteOn:9 // Nota: A2
								velocity:127];	
					} else {
						[evts pushNoteOff:9 // Nota: A2
								 velocity:127];	
					}
					break;
				*/
				// Mix Repeat
				case WiiRemoteLeftButton:
          cc_note = 84; value_cc_note = 0 ;
					[evts pushControl:cc_note value:value_cc_note];
          [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:value_cc_note], nil]
                              typeOSC:[NSString stringWithFormat:@"ctrl"]] ;
					break;
				case WiiRemoteRightButton:
          cc_note = 84; value_cc_note = 64 ;
					[evts pushControl:cc_note value:value_cc_note];
          [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:value_cc_note], nil]
                              typeOSC:[NSString stringWithFormat:@"ctrl"]] ;
					break;					
				case WiiRemoteUpButton:
          cc_note = 0; value_cc_note = 127; // Nota: C2
					if ([_wiicontrols UpButton]) {
						[evts pushNoteOn:cc_note 
                    velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:value_cc_note], nil]
                                typeOSC:[NSString stringWithFormat:@"note"]] ;
					} else {
						[evts pushNoteOff:cc_note
								 velocity:value_cc_note];	
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:0], nil]
                                typeOSC:[NSString stringWithFormat:@"note"]] ;
					}
					break;
				case WiiRemoteDownButton:
          cc_note = 5; value_cc_note = 127 ; // Nota: F2
					if ([_wiicontrols DownButton]) {
						[evts pushNoteOn:cc_note 
                    velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:value_cc_note], nil]
                                typeOSC:[NSString stringWithFormat:@"note"]] ;
					}else{
						[evts pushNoteOff:cc_note
                     velocity:value_cc_note];	
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:0], nil]
                                typeOSC:[NSString stringWithFormat:@"note"]] ;
					}
					break;
				default: break;
			}
			break;
		case 2:
			switch (boton) {
				case WiiRemoteUpButton:
					if ([_wiicontrols UpButton]) {
            cc_note = 0; value_cc_note = 127 ;
						[evts pushNoteOn:cc_note // Nota: C2
								velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:value_cc_note], nil]
                                typeOSC:[NSString stringWithFormat:@"note"]] ;
					} else {
						[evts pushNoteOff:cc_note // Nota: C2
								 velocity:value_cc_note];	
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:0], nil]
                                typeOSC:[NSString stringWithFormat:@"note"]] ;
					}
					break;
				case WiiRemoteLeftButton:
          cc_note= 2; value_cc_note = 127 ;
					if ([_wiicontrols LeftButton]) {
						[evts pushNoteOn:cc_note // Nota: D2
                    velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:value_cc_note], nil]
                                typeOSC:[NSString stringWithFormat:@"note"]  ] ;
					} else {
						[evts pushNoteOff:cc_note // Nota: D2
								 velocity:value_cc_note];	
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:0], nil]
                                typeOSC:[NSString stringWithFormat:@"note"]  ] ;
					}
					break;
				case WiiRemoteRightButton:
          cc_note = 4; value_cc_note = 127 ; // Nota: E2
					if ([_wiicontrols RightButton]) {
						[evts pushNoteOn:cc_note
                    velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:value_cc_note], nil]
                                typeOSC:[NSString stringWithFormat:@"note"]  ] ;
					}else {
						[evts pushNoteOff:cc_note
                     velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:0], nil]
                                typeOSC:[NSString stringWithFormat:@"note"]  ] ;
					}
					break;
				case WiiRemoteDownButton:
          cc_note = 5; value_cc_note = 127 ; // Nota: F2
					if ([_wiicontrols DownButton]) {
						[evts pushNoteOn:cc_note
                    velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:value_cc_note], nil]
                                typeOSC:[NSString stringWithFormat:@"note"]  ] ;
					}else {
						[evts pushNoteOff:cc_note
                     velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:0], nil]
                                typeOSC:[NSString stringWithFormat:@"note"]  ] ;
					}
					break;
        case WiiRemoteOneButton:
          if ([_wiicontrols OneButton]) {
            cc_note = 34; value_cc_note = 0 ;
            [evts pushControl:cc_note value:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:value_cc_note], nil]
                                typeOSC:[NSString stringWithFormat:@"ctrl"]] ;

            cc_note = 35; value_cc_note = 0 ;
            [evts pushControl:35 value:0];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:value_cc_note], nil]
                                typeOSC:[NSString stringWithFormat:@"ctrl"]] ;
          }
          break;
				default: break;
			}
			break;

		case 3:
			switch (boton) {
        case WiiRemoteUpButton:
					if ([_wiicontrols UpButton]) {
            cc_note = 0; value_cc_note = 127 ;
						[evts pushNoteOn:cc_note // Nota: C2
                    velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:value_cc_note], nil]
                                typeOSC:[NSString stringWithFormat:@"note"]] ;
					} else {
						[evts pushNoteOff:cc_note // Nota: C2
                     velocity:value_cc_note];	
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:0], nil]
                                typeOSC:[NSString stringWithFormat:@"note"]] ;
					}
					break;
				case WiiRemoteLeftButton:
          cc_note= 2; value_cc_note = 127 ;
					if ([_wiicontrols LeftButton]) {
						[evts pushNoteOn:cc_note // Nota: D2
                    velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:value_cc_note], nil]
                                typeOSC:[NSString stringWithFormat:@"note"]  ] ;
					} else {
						[evts pushNoteOff:cc_note // Nota: D2
                     velocity:value_cc_note];	
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:0], nil]
                                typeOSC:[NSString stringWithFormat:@"note"]  ] ;
					}
					break;
				case WiiRemoteRightButton:
          cc_note = 4; value_cc_note = 127 ; // Nota: E2
					if ([_wiicontrols RightButton]) {
						[evts pushNoteOn:cc_note
                    velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:value_cc_note], nil]
                                typeOSC:[NSString stringWithFormat:@"note"]  ] ;
					}else {
						[evts pushNoteOff:cc_note
                     velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:0], nil]
                                typeOSC:[NSString stringWithFormat:@"note"]  ] ;
					}
					break;
				case WiiRemoteDownButton:
          cc_note = 5; value_cc_note = 127 ; // Nota: F2
					if ([_wiicontrols DownButton]) {
						[evts pushNoteOn:cc_note
                    velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:value_cc_note], nil]
                                typeOSC:[NSString stringWithFormat:@"note"]  ] ;
					}else {
						[evts pushNoteOff:cc_note
                     velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:cc_note], [NSNumber numberWithFloat:0], nil]
                                typeOSC:[NSString stringWithFormat:@"note"]  ] ;
					}
					break;
				default: break;
			}
      break;
		case 4:
			switch (boton) {
				case WiiRemoteUpButton:
          cc_note = 35; value_cc_note = 0 ;
					if ([_wiicontrols UpButton]) {
						[evts pushNoteOn:0 // Nota: C2
                    velocity:127];	
					} else {
						[evts pushNoteOn:0 // Nota: C2
                     velocity:0];	
					}
					break;
				case WiiRemoteLeftButton:
          cc_note = 35; value_cc_note = 0 ;
					if ([_wiicontrols LeftButton]) {
						[evts pushNoteOn:2 // Nota: D2
                    velocity:127];
					} else {
						[evts pushNoteOn:2 // Nota: D2
                     velocity:0
                      channel:14];	
					}
					break;
				case WiiRemoteRightButton:
          cc_note = 35; value_cc_note = 0 ;
					if ([_wiicontrols RightButton]) {
						[evts pushNoteOn:4 // Nota: E2
                    velocity:127
                     channel:14];
					}else {
						[evts pushNoteOn:4 // Nota: E2
                     velocity:0
                     channel:14];
					}
					break;
				case WiiRemoteDownButton:
          cc_note = 35; value_cc_note = 0 ;
					if ([_wiicontrols DownButton]) {
						[evts pushNoteOn:5 // Nota: F2
                    velocity:127];
					}else{
						[evts pushNoteOff:5 // Nota: F2
                     velocity:127];
					}
        case WiiRemoteAButton:
          cc_note = 35; value_cc_note = 0 ;
					if ([_wiicontrols AButton]) {
						[evts pushNoteOn:2 // Nota: C -2
                    velocity:127
                     channel:14];
					}else {
						[evts pushNoteOn:2 // Nota: C -2
                    velocity:0
                     channel:14];
					}
				default: break;
			}
      break;
    case 5: // 1 button, 1 note
			switch (boton) {
				case WiiRemoteUpButton:
					if ([_wiicontrols UpButton]) {
            cc_note = 0; value_cc_note = 127 ;
						[evts pushNoteOn:cc_note // Nota: C2
                    velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects:[NSNumber numberWithFloat:1], nil]
                                typeOSC:[NSString stringWithFormat:@"Button/Up"]] ;
					} else {
						[evts pushNoteOff:cc_note // Nota: C2
                     velocity:value_cc_note];	
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:0], nil]
                                typeOSC:[NSString stringWithFormat:@"Button/Up"]] ;
					}
					break;
				case WiiRemoteLeftButton:
          cc_note= 2; value_cc_note = 127 ;
					if ([_wiicontrols LeftButton]) {
						[evts pushNoteOn:cc_note // Nota: D2
                    velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:1], nil]
                                typeOSC:[NSString stringWithFormat:@"Button/Left"]  ] ;
					} else {
						[evts pushNoteOff:cc_note // Nota: D2
                     velocity:value_cc_note];	
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:0], nil]
                                typeOSC:[NSString stringWithFormat:@"Button/Left"]  ] ;
					}
					break;
				case WiiRemoteRightButton:
          cc_note = 4; value_cc_note = 127 ; // Nota: E2
					if ([_wiicontrols RightButton]) {
						[evts pushNoteOn:cc_note
                    velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:1], nil]
                                typeOSC:[NSString stringWithFormat:@"Button/Right"]  ] ;
					}else {
						[evts pushNoteOff:cc_note
                     velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:0], nil]
                                typeOSC:[NSString stringWithFormat:@"Button/Right"]  ] ;
					}
					break;
				case WiiRemoteDownButton:
          cc_note = 5; value_cc_note = 127 ; // Nota: F2
					if ([_wiicontrols DownButton]) {
						[evts pushNoteOn:cc_note
                    velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:1], nil]
                                typeOSC:[NSString stringWithFormat:@"Button/Down"]  ] ;
					}else {
						[evts pushNoteOff:cc_note
                     velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:0], nil]
                                typeOSC:[NSString stringWithFormat:@"Button/Down"]  ] ;
					}
					break;
        case WiiRemoteOneButton:
          cc_note = 7; value_cc_note = 127 ; // Nota: G2
					if ([_wiicontrols OneButton]) {
						[evts pushNoteOn:cc_note
                    velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:1], nil]
                                typeOSC:[NSString stringWithFormat:@"Button/One"]  ] ;
					}else {
						[evts pushNoteOff:cc_note
                     velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:0], nil]
                                typeOSC:[NSString stringWithFormat:@"Button/One"]  ] ;
					}
					break;
        case WiiRemoteTwoButton:
          cc_note = 9; value_cc_note = 127 ; // Nota: G2
					if ([_wiicontrols TwoButton]) {
						[evts pushNoteOn:cc_note
                    velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:1], nil]
                                typeOSC:[NSString stringWithFormat:@"Button/Two"]  ] ;
					}else {
						[evts pushNoteOff:cc_note
                     velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:0], nil]
                                typeOSC:[NSString stringWithFormat:@"Button/Two"]  ] ;
					}
					break;
        case WiiRemotePlusButton:
          cc_note = 11; value_cc_note = 127 ; // Nota: A2
					if ([_wiicontrols PlusButton]) {
						[evts pushNoteOn:cc_note
                    velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:1], nil]
                                typeOSC:[NSString stringWithFormat:@"Button/Plus"]  ] ;
					}else {
						[evts pushNoteOff:cc_note
                     velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:0], nil]
                                typeOSC:[NSString stringWithFormat:@"Button/Plus"]  ] ;
					}
					break;
        case WiiRemoteMinusButton:
          cc_note = 13; value_cc_note = 127 ; // Nota: B2
					if ([_wiicontrols MinusButton]) {
						[evts pushNoteOn:cc_note
                    velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:1], nil]
                                typeOSC:[NSString stringWithFormat:@"Button/Minus"]  ] ;
					}else {
						[evts pushNoteOff:cc_note
                     velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:0], nil]
                                typeOSC:[NSString stringWithFormat:@"Button/Minus"]  ] ;
					}
					break;
        case WiiRemoteHomeButton:
          cc_note = 14; value_cc_note = 127 ; // Nota: C3
					if ([_wiicontrols HomeButton]) {
						[evts pushNoteOn:cc_note
                    velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:1], nil]
                                typeOSC:[NSString stringWithFormat:@"Button/Home"]  ] ;
					}else {
						[evts pushNoteOff:cc_note
                     velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:0], nil]
                                typeOSC:[NSString stringWithFormat:@"Button/Home"]  ] ;
					}
					break;
        case WiiRemoteAButton:
          cc_note = 16; value_cc_note = 127 ; // Nota: D3
					if ([_wiicontrols AButton]) {
						[evts pushNoteOn:cc_note
                    velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:1], nil]
                                typeOSC:[NSString stringWithFormat:@"Button/A"]  ] ;
					}else {
						[evts pushNoteOff:cc_note
                     velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:0], nil]
                                typeOSC:[NSString stringWithFormat:@"Button/A"]  ] ;
					}
					break;
        case WiiRemoteBButton:
          cc_note = 18; value_cc_note = 127 ; // Nota: E3
					if ([_wiicontrols BButton]) {
						[evts pushNoteOn:cc_note
                    velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:1], nil]
                                typeOSC:[NSString stringWithFormat:@"Button/B"]  ] ;
					}else {
						[evts pushNoteOff:cc_note
                     velocity:value_cc_note];
            [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:0], nil]
                                typeOSC:[NSString stringWithFormat:@"Button/B"]  ] ;
					}
					break;
				default: break;
			}
			break ;
		default: NSLog(@"Manipulacion, modo incorrecto"); break;
	}
}

//@synthesize acelex;
@synthesize mediaacelx;
//@synthesize aceley;
@synthesize mediaacely;
//@synthesize acelez;
@synthesize mediaacelz;
//@synthesize rollb;
@synthesize mediarollb;
//@synthesize pitchb;
@synthesize mediapitchb;

-(void) manipularAcc:(WiiControls *)_wiicontrols 
           mandarloA:(MidiEventOutput*)evts
           mandarOSC: (OSCEventClass*)oscObj
{

	//Desplazamos los valores	
	memmove(acelex,(acelex-1),(LONG_BUF+1)*sizeof(double));
	acelex[0] = [_wiicontrols aceleracionx] ;
	mediaacelx = acelex[0];
	memmove(aceley,(aceley-1),(LONG_BUF+1)*sizeof(double));
	aceley[0] = [_wiicontrols aceleraciony] ;
	mediaacely = aceley[0];
	memmove(acelez,(acelez-1),(LONG_BUF+1)*sizeof(double));
	acelez[0] = [_wiicontrols aceleracionz] ;
	mediaacelz = acelez[0];
	
	//NSLog(@"%f",acelex[LONG_BUF-1]);
	//NSLog(@"%f",acelex[0]);

	// Rounding
	memmove(rollb,(rollb-1),(LONG_BUF+1)*sizeof(double));
	rollb[0] = [_wiicontrols roll] ;
	mediarollb = rollb[0];
	memmove(pitchb,(pitchb-1),(LONG_BUF+1)*sizeof(double));
	pitchb[0] = [_wiicontrols pitch] ;
	mediapitchb = pitchb[0];
	
	// Mean calculation for smoothing
	for (int i = 1 ; i < LONG_BUF ; i++){
		mediaacelx += acelex[i] ;
		mediaacely += aceley[i] ;
		mediaacelz += acelez[i] ;

		mediarollb += rollb[i] ;
		mediapitchb += pitchb[i];		
	}
  
	[self setMediaacelx:(mediaacelx / LONG_BUF)];
	[self setMediaacely:(mediaacely / LONG_BUF)];
	[self setMediaacelz:(mediaacelz / LONG_BUF)];

	[self setMediarollb:round([self mediarollb] / LONG_BUF)];
	[self setMediapitchb:round([self mediapitchb] / LONG_BUF)];
	
	contador++;
	unsigned char valor ;
	//unsigned char valorInc ;
	//double minimoRot = -150;
	//double maximoRot = 150;
	double minimoRot = -90;
	double maximoRot = 90;
	double minimoInc = 0 ;
	double maximoInc = -75 ;
	if (contador == LONG_BUF-1){
		contador = 0;
		// se procede a mandar los controles correspondientes
		switch (modo) {
			case 0: break;
			case 1:
				// Scene Launch
				if (mediaacely > umbral && [_wiicontrols BButton]) {
					//NSLog(@"Prueba superada");
					[evts pushControl:41 value:127];
					[evts pushControl:41 value:0];
				}
				if ([_wiicontrols AButton]) {
					// Rotacion
					if ([self mediarollb] < minimoRot)
						valor = 0;
					else if ([self mediarollb] > maximoRot)
						valor = 127 ;
					else
						valor =  [self mediarollb] * ( 127.0 / (-minimoRot + maximoRot) ) + ( 127.0 * (-minimoRot) ) / (-minimoRot + maximoRot);
					//NSLog(@"%d",valor);
					if (valor <= 0)
						valor = 0;
					else if (valor >= 127)
						valor = 127;
					if (! (valor == valorrotANT1)) {
						//NSLog(@"Entra en mandar control");
						[evts pushControl:32 value:valor];
						valorrotANT1 = valor;
					}
					// Inclinacion
					if ([self mediapitchb] <= 0)
						valor =  [self mediapitchb] * ( 127.0 / (-minimoInc + maximoInc) ) + ( 127.0 * (-minimoInc) ) / (-minimoInc + maximoInc);
					else valor = 0;
					//NSLog(@"%d",valor);
					if (valor <= 0)
						valor = 0;
					else if (valor >= 127)
						valor = 127;
					if (! (valor == valorincANT1)) {
						//NSLog(@"Entra en mandar control Inc");
						[evts pushControl:33 value:valor];
						valorincANT1 = valor;
					}					
				}
				if ([_wiicontrols BButton])	{
				}
				break;
			case 2:
				// Scene Launch
				if (mediaacely > umbral && [_wiicontrols BButton]) {
					//NSLog(@"Prueba superada");
					[evts pushControl:41 value:127];
					[evts pushControl:41 value:0];
				}
				// Filtros Efectos Master
				if ([_wiicontrols AButton]) {
					// Rotacion
					if ([self mediarollb] < minimoRot)
						valor = 0;
					else if ([self mediarollb] > maximoRot)
						valor = 127 ;
					else
						valor =  [self mediarollb] * ( 127.0 / (-minimoRot + maximoRot) ) + ( 127.0 * (-minimoRot) ) / (-minimoRot + maximoRot);
					//NSLog(@"%d",valor);
					if (valor <= 0)
						valor = 0;
					else if (valor >= 127)
						valor = 127;
					if (! (valor == valorrotANT2)) {
						//NSLog(@"Entra en mandar control");
						[evts pushControl:34 value:valor];
						valorrotANT2 = valor;
					}
					// Inclinacion
					if ([self mediapitchb] <= 0)
						valor =  [self mediapitchb] * ( 127.0 / (-minimoInc + maximoInc) ) + ( 127.0 * (-minimoInc) ) / (-minimoInc + maximoInc);
					else valor = 0;
					//NSLog(@"%d",valor);
					if (valor <= 0)
						valor = 0;
					else if (valor >= 127)
						valor = 127;
					if (! (valor == valorincANT2)) {
						//NSLog(@"Entra en mandar control Inc");
						[evts pushControl:35 value:valor];
						valorincANT2 = valor;
					}					
				}
				else if ([_wiicontrols OneButton]) {
					[evts pushControl:34 value:0];
					[evts pushControl:35 value:0];
				}
				break;
			case 3:
				// Scene Launch
				if (mediaacely > umbral && [_wiicontrols BButton]) {
					//NSLog(@"Prueba superada");
					[evts pushControl:41 value:127];
					[evts pushControl:41 value:0];
				}
				// Delay Sends
				if ([_wiicontrols AButton]) {
					// Rotacion
					if ([self mediarollb] < minimoRot)
						valor = 0;
					else if ([self mediarollb] > maximoRot)
						valor = 127 ;
					else
						valor =  [self mediarollb] * ( 127.0 / (-minimoRot + maximoRot) ) + ( 127.0 * (-minimoRot) ) / (-minimoRot + maximoRot);
					//NSLog(@"%d",valor);
					if (valor <= 0)
						valor = 0;
					else if (valor >= 127)
						valor = 127;
					if (! (valor == valorrotANT3)) {
						//NSLog(@"Entra en mandar control");
						[evts pushControl:6 value:valor];
						valorrotANT3 = valor;
					}
					/*
					// Inclinacion
					if ([self mediapitchb] <= 0)
						valor =  [self mediapitchb] * ( 127.0 / (-minimoInc + maximoInc) ) + ( 127.0 * (-minimoInc) ) / (-minimoInc + maximoInc);
					else valor = 0;
					//NSLog(@"%d",valor);
					if (valor <= 0)
						valor = 0;
					else if (valor >= 127)
						valor = 127;
					if (! (valor == valorincANT3)) {
						//NSLog(@"Entra en mandar control Inc");
						[evts pushControl:35 value:valor];
						valorincANT3 = valor;
					}*/					
				}
				else if ([_wiicontrols OneButton]) {
					[evts pushControl:6 value:0];
					//[evts pushControl:35 value:0];
				}
				break;
			case 4:
        // Filtros Efectos Master
				if ([_wiicontrols AButton]) {
					// Rotacion
					if ([self mediarollb] < minimoRot)
						valor = 0;
					else if ([self mediarollb] > maximoRot)
						valor = 127 ;
					else
						valor =  [self mediarollb] * ( 127.0 / (-minimoRot + maximoRot) ) + ( 127.0 * (-minimoRot) ) / (-minimoRot + maximoRot);
					//NSLog(@"%d",valor);
					if (valor <= 0)
						valor = 0;
					else if (valor >= 127)
						valor = 127;
					if (! (valor == valorrotANT4)) {
						//NSLog(@"Entra en mandar control");
						[evts pushControl:35 value:valor channel:14];
						valorrotANT4 = valor;
					}
					// Inclinacion
          /* if ([self mediapitchb] <= 0)
            valor =  [self mediapitchb] * ( 127.0 / (-minimoInc + maximoInc) ) + ( 127.0 * (-minimoInc) ) / (-minimoInc + maximoInc);
          else valor = 0;
          //NSLog(@"%d",valor);
          if (valor <= 0)
            valor = 0;
          else if (valor >= 127)
            valor = 127;
          if (! (valor == valorincANT2)) {
            //NSLog(@"Entra en mandar control Inc");
            [evts pushControl:35 value:valor];
            valorincANT2 = valor;
          }					
           */			}
				else if ([_wiicontrols OneButton]) {
					[evts pushControl:34 value:0 channel:14];
					//[evts pushControl:35 value:0];
				}
        break;
      case 5:
        [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:(float)[self mediaacelx]], nil]
                            typeOSC:[NSString stringWithFormat:@"Acc/X"]  ] ;
        [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:(float)[self mediaacely]], nil]
                            typeOSC:[NSString stringWithFormat:@"Acc/Y"]  ] ;
        [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:(float)[self mediaacelz]], nil]
                            typeOSC:[NSString stringWithFormat:@"Acc/Z"]  ] ;
        [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:(float)[self mediarollb]], nil]
                            typeOSC:[NSString stringWithFormat:@"Acc/Roll"]  ] ;
        [oscObj sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:(float)[self mediapitchb]], nil]
                            typeOSC:[NSString stringWithFormat:@"Acc/Pitch"]  ] ;
        // Rotacion
        if ([self mediarollb] < minimoRot)
          valor = 0;
        else if ([self mediarollb] > maximoRot)
          valor = 127 ;
        else
          valor =  [self mediarollb] * ( 127.0 / (-minimoRot + maximoRot) ) + ( 127.0 * (-minimoRot) ) / (-minimoRot + maximoRot);
        //NSLog(@"%d",valor);
        if (valor <= 0)
          valor = 0;
        else if (valor >= 127)
          valor = 127;
        if (! (valor == valorrotANT1)) {
          //NSLog(@"Entra en mandar control");
          [evts pushControl:32 value:valor];
          valorrotANT1 = valor;
        }
        // Inclinacion
        if ([self mediapitchb] <= 0)
          valor =  [self mediapitchb] * ( 127.0 / (-minimoInc + maximoInc) ) + ( 127.0 * (-minimoInc) ) / (-minimoInc + maximoInc);
        else valor = 0;
        //NSLog(@"%d",valor);
        if (valor <= 0)
          valor = 0;
        else if (valor >= 127)
          valor = 127;
        if (! (valor == valorincANT1)) {
          //NSLog(@"Entra en mandar control Inc");
          [evts pushControl:33 value:valor];
          valorincANT1 = valor;
        }					
        
        break;
			default: NSLog(@"Algo ha ido mal con los controles de aceleracion"); break;
		}
		
	}
		
}




@end