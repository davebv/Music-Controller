//
//  AppController.m
//  MusicController
//
//  Created by David Becerril Valle on 6/20/08.
//  Copyright 2008 DaveBV.es. All rights reserved.
//

#import "AppController.h"


@implementation AppController

-(void) awakeFromNib
{
	// WiiMote
	discovery = [[WiiRemoteDiscovery alloc] init];
	[discovery setDelegate:self];
	[textStatusWii setStringValue:@"Press \"Discover\" to find a Wiimote"];
	[bDiscovery setEnabled:YES];
  
  // OSC
  [remoteOSCAddress setStringValue:@"127.0.0.1"] ;
  [OSCport setIntValue:30200];
  [OSCdestinationPath setStringValue:[OSCobjeto OSCdestinationPath]] ;

}

-(id) init {
	
	[super init];
	
	// Iniciamos los eventos midi
	_midiEvts = [[MidiEventOutput alloc] init];
	[_midiEvts setChannel:15-1];

	NSLog(@"Init");
	midiDevicesArray = [[MidiDevice getAllMidiDevices] retain];
	NSLog(@"Array iniciado");
	if (0 == [midiDevicesArray count])
	{
		// No MIDI devices. Blarg im ded!
		[[NSAlert alertWithMessageText:@"No MIDI endpoints available" defaultButton:nil
					   alternateButton:nil otherButton:nil 
			 informativeTextWithFormat:@"Enable some MIDI devices in Audio MIDI Setup and relaunch WiiToMidi."]
		 runModal];
		[NSApp terminate:self];
	}
	
	_midiTimer = nil;
	
	// Escoger el "destino" midi
	_midiDest = [[midiDevicesArray objectAtIndex:0] midiEndpoint];
	// Creamos el Cliente y el puerto
	MIDIClientCreate(CFSTR("MusicController"), NULL, NULL, &_midi);
	MIDIOutputPortCreate(_midi, CFSTR("Output"), &_midiOut);
	
	// WiiControls
	_WiiControls = [[WiiControls alloc] init];
	
	// Logica
	_generadorEv = [[GeneradorEv alloc] init];
  
  // OSC
  OSCobjeto = [[OSCEventClass alloc] init] ;

	return self;
	
}

- (void) dealloc
{
	[wii release];
	[discovery release];
	[super dealloc];
}

- (IBAction)doDiscovery:(id)sender
{
	//	CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, NO);
	
	[discovery start];
	[textStatusWii setStringValue:@"Please press 1 button and 2 button simultaneously"];
	[discoverySpinner startAnimation:self];
	[bDiscovery setEnabled:NO];
}

- (void) wiiRemoteDisconnected:(IOBluetoothDevice*)device {
	[wii release];
	wii = nil;
	
	[textStatusWii setStringValue:@"Wiimote Lost"];
	[bDiscovery setEnabled:YES];
	
	// Desactivamos el Timer
	[self setMidiTimer:nil];
}

- (IBAction)doCalibration:(id)sender{
	
	//id config = [mappingController selection];
	
	
	if ([sender tag] == 0){
		x1 = tmpAccX;
		y1 = tmpAccY;
		z1 = tmpAccZ;
		NSLog(@"Calibrando A");
	}
	
	if ([sender tag] == 1){
		x2 = tmpAccX;
		y2 = tmpAccY;
		z2 = tmpAccZ;
		NSLog(@"Calibrando Exp port");
	}
	if ([sender tag] == 2){
		x3 = tmpAccX;
		y3 = tmpAccY;
		z3 = tmpAccZ;
		NSLog(@"Calibrando Left Side");

	}
	x0 = (x1 + x2) / 2.0;
	y0 = (y1 + y3) / 2.0;
	z0 = (z2 + z3) / 2.0;
	
	[_WiiControls setAccX_zero:x0];
	[_WiiControls setAccY_zero:y0];
	[_WiiControls setAccZ_zero:z0];
	
	[_WiiControls setAccX_1g:x3];
	[_WiiControls setAccY_1g:y2];
	[_WiiControls setAccZ_1g:z1];
	
}

//#pragma mark -
//#pragma mark WiiRemoteDiscovery delegates

- (void) WiiRemoteDiscoveryError:(int)code {
	[discoverySpinner stopAnimation:self];
	[textStatusWii setStringValue:@"WiiRemoteDiscovery error"];
	[bDiscovery setEnabled:YES];
	// Desactivamos el Timer
	[self setMidiTimer:nil];
}

- (void) willStartWiimoteConnections {
	[textStatusWii setStringValue:@"WiiRemote discovered."];
	[bDiscovery setEnabled:NO];
}

- (void) WiiRemoteDiscovered:(WiiRemote*)wiimote {
	
	//	[discovery stop];
	
	// the wiimote must be retained because the discovery provides us with an autoreleased object
	wii = [wiimote retain];
	[wiimote setDelegate:self];
	
	[textStatusWii setStringValue:@"Connected to WiiRemote"];
	[discoverySpinner stopAnimation:self];
	// Desacivo el botón de "discover"
	[bDiscovery setEnabled:NO];
	
	[wiimote setLEDEnabled1:YES enabled2:NO enabled3:NO enabled4:YES];
	
	[wiimote setMotionSensorEnabled:YES];
	//	[wiimote setIRSensorEnabled:YES];
	
	// Activamos el timer para mandar midi
	[self setMidiTimer:[NSTimer scheduledTimerWithTimeInterval:0.016666
														target:self
													  selector:@selector(sendMidi:)
													  userInfo:nil
													   repeats:TRUE]];
}


// Botones Wii
- (void) buttonChanged:(WiiButtonType)type isPressed:(BOOL)isPressed{
	
	switch (type) {
		case WiiRemoteAButton:
			[_WiiControls setAButton:isPressed];
			[_generadorEv manipular:_WiiControls
                    mandarloA:_midiEvts
                    tipoBoton:type
                    mandarOSC: OSCobjeto];

			break;
		case WiiRemoteBButton:
			[_WiiControls setBButton:isPressed];
			[_generadorEv manipular: _WiiControls
                    mandarloA: _midiEvts
                    tipoBoton: type
                    mandarOSC: OSCobjeto];

			break;
		case WiiRemoteOneButton:
			[_WiiControls setOneButton:isPressed];
			[_generadorEv manipular:_WiiControls
                    mandarloA:_midiEvts
                    tipoBoton:type
                    mandarOSC: OSCobjeto];

			break;
		case WiiRemoteTwoButton:
			[_WiiControls setTwoButton:isPressed];
			[_generadorEv manipular:_WiiControls
                    mandarloA:_midiEvts
                    tipoBoton:type
                    mandarOSC:OSCobjeto];

			break;
		case WiiRemoteMinusButton:
			[_WiiControls setMinusButton:isPressed];
			[_generadorEv cambiaModo:_WiiControls
						  conWiimote:wii
						   isPressed:isPressed];
			[_generadorEv manipular:_WiiControls
                    mandarloA:_midiEvts
                    tipoBoton:type
                    mandarOSC: OSCobjeto];

			break;
		case WiiRemoteHomeButton:
			[_WiiControls setHomeButton:isPressed];
			[_generadorEv manipular:_WiiControls
						  mandarloA:_midiEvts
						  tipoBoton:type
                    mandarOSC: OSCobjeto];

			break;
		case WiiRemotePlusButton: 
			[_WiiControls setPlusButton:isPressed];
			[_generadorEv cambiaModo:_WiiControls 
						  conWiimote:wii
						   isPressed:isPressed];
			[_generadorEv manipular:_WiiControls
                    mandarloA:_midiEvts
                    tipoBoton:type 
                    mandarOSC: OSCobjeto];

			break;
		case WiiRemoteUpButton:
			[_WiiControls setUpButton:isPressed];
			[_generadorEv manipular:_WiiControls
                    mandarloA:_midiEvts
                    tipoBoton:type
                    mandarOSC: OSCobjeto];
			break;
		case WiiRemoteDownButton:
			[_WiiControls setDownButton:isPressed];
			[_generadorEv manipular:_WiiControls
                    mandarloA:_midiEvts
                    tipoBoton:type
                    mandarOSC: OSCobjeto];

			break;
		case WiiRemoteLeftButton:
			[_WiiControls setLeftButton:isPressed];
			[_generadorEv manipular:_WiiControls
                    mandarloA:_midiEvts
                    tipoBoton:type
                    mandarOSC: OSCobjeto];

			break;
		case WiiRemoteRightButton:
			[_WiiControls setRightButton:isPressed];
			[_generadorEv manipular:_WiiControls
                    mandarloA:_midiEvts
                    tipoBoton:type
                    mandarOSC: OSCobjeto];

			break;			
		default:
			break;
	}
	
}

- (void) accelerationChanged:(WiiAccelerationSensorType)type accX:(unsigned short)accX accY:(unsigned short)accY accZ:(unsigned short)accZ{

	tmpAccX = accX;
	tmpAccY = accY;
	tmpAccZ = accZ;
	if ([_WiiControls manualCalib]) {
		x0 = [_WiiControls accX_zero];
		x3 = [_WiiControls accX_1g];
		y0 = [_WiiControls accY_zero];
		y2 = [_WiiControls accY_1g];
		z0 = [_WiiControls accZ_zero];
		z1 = [_WiiControls accZ_1g];
	}
	else {
		WiiAccCalibData data = [wii accCalibData:WiiRemoteAccelerationSensor];
		x0 = data.accX_zero;
		x3 = data.accX_1g;
		y0 = data.accY_zero;
		y2 = data.accY_1g;
		z0 = data.accZ_zero;
		z1 = data.accZ_1g;
	}		

	double ax = (double)(accX - x0) / (x3 - x0);
	double ay = (double)(accY - y0) / (y2 - y0);
	double az = (double)(accZ - z0) / (z1 - z0) * (-1.0);
	
	double roll;
	if (az < 0) {
		roll = atan(ax) * 180.0 / 3.14 * 2;
	}
	else if(ax > 0) {
		roll = 180 - atan(ax) * 180.0 / 3.14 * 2;
	}
	else {
		roll = - 180 - atan(ax) * 180.0 / 3.14 * 2;
	}
	
	double pitch = atan(ay) * 180.0 / 3.14 * 2;
	
	[_WiiControls setAceleracionx:ax];
	[_WiiControls setAceleraciony:ay];
	[_WiiControls setAceleracionz:az];
	[_WiiControls setRoll:roll];
	[_WiiControls setPitch:pitch];
	
	[_generadorEv manipularAcc:_WiiControls
                   mandarloA:_midiEvts
                   mandarOSC:OSCobjeto];
}


- (NSApplicationTerminateReply) applicationShouldTerminate:(NSApplication *) sender
{
	NSLog(@"Se terminó");
	
	[wii closeConnection];
	
	return NSTerminateNow;
}


// MIDI
-(IBAction) midiDeviceChanged:(NSPopUpButton*)button {
	NSLog(@"Se ha seleccionado %@",
		  [[midiDevicesArray objectAtIndex:[button indexOfSelectedItem]] midiDeviceName]);
	_midiDest = [[midiDevicesArray objectAtIndex:[button indexOfSelectedItem]] midiEndpoint];
}

-(id) setMidiTimer:(NSTimer*)timer
{
	[_midiTimer invalidate];
	[_midiTimer autorelease];
	_midiTimer = [timer retain];
	return self;
}

-(void) sendMidi:(NSTimer*)timer{
	if (timer != _midiTimer) return;
	//NSLog(@"Entra en sendMidi");
	MIDISend(_midiOut, _midiDest, [_midiEvts list]);
	[_midiEvts clearList];

}


// OSC
-(IBAction)connectOSC:(id)sender
{
  if (wii == nil) {
    NSLog(@"No Wiimote detected\n") ;
    return;
  }
  [OSCobjeto init_mod_OSCsettings:[remoteOSCAddress stringValue] atPort:[OSCport intValue]] ;

}
-(IBAction)setupField:(id)sender
{
  switch ([sender tag]){
    case 0:
      [OSCobjeto change_OSCsettings:[sender stringValue] atPort:(int) -1] ;
      break;
    case 1:
      [OSCobjeto change_OSCsettings:nil atPort:[sender intValue]] ;
      break;
    case 3:
      [OSCobjeto setOSCdestinationPath:[sender stringValue]] ;
      break;
  }
}

-(IBAction)testOSC:(id)sender
{
  [OSCobjeto sendOSCPacket_float:[NSArray arrayWithObjects: [NSNumber numberWithFloat:16], [NSNumber numberWithFloat:146], nil]
                         typeOSC:[NSString stringWithFormat:@"tipoOSC"]];
}


// Mode override
-(IBAction)overrideMode:(id)sender
{
  
  if (wii == nil){
    [sender setState:NSOffState] ;
    NSLog(@"No Wiimote detected\n") ;
    return;
  }

  NSLog(@"%d",[sender state]);
  //[sender setState:NSOnState];
  //
  switch ([sender state]) {
    case NSOnState:
      [_generadorEv setModo_ant:[_generadorEv modo]] ;
      [_generadorEv cambiaModo:5 conWiimote:wii] ;
      break;
    case NSOffState:
      [_generadorEv cambiaModo:[_generadorEv modo_ant] conWiimote:wii] ;
      break;
  }
  
}

// Link to my web
-(IBAction) abrirEnlace:(id)sender{
	if ([sender tag] == 0){
		NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://davebv.com"]] ;
		[[NSWorkspace sharedWorkspace] openURL:url];
	}
	if ([sender tag] == 1){
		NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://www.davebv.com/music-controller-midi-and-osc-wiimote"]];
		[[NSWorkspace sharedWorkspace] openURL:url];
	}
	if ([sender tag] == 2){
		NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://davebv.com"]];
		[[NSWorkspace sharedWorkspace] openURL:url];
	}
}


// Close last window
-(BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
  return YES;
}

@end
