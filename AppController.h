//
//  AppController.h
//  MusicController
//
//  Created by David Becerril Valle on 6/20/08.
//  Copyright 2008 DaveBV.es. All rights reserved.
//

#import <Cocoa/Cocoa.h>


#import <WiiRemote/WiiRemoteDiscovery.h>

#import "MidiDevice.h"

#import "WiiControls.h"
#import "MidiEventOutput.h"

#import "GeneradorEv.h"
#import "OSCEventClass.h"


@interface AppController : NSObject {
  
  // OSC
  IBOutlet NSTextField * remoteOSCAddress ;
  IBOutlet NSTextField * OSCport ;
  IBOutlet NSTextField * OSCdestinationPath ;
  
  OSCEventClass * OSCobjeto ;
  
	
	// MIDI
	IBOutlet NSPopUpButton *midiDevice;
	
	IBOutlet NSButton *startButton;
	IBOutlet NSButton *stopButton;
	
	NSMutableArray *midiDevicesArray;

	// Objetos dispositivo midi
	MIDIClientRef _midi;
	MIDIPortRef _midiOut;
	MIDIEndpointRef _midiDest;
	int _midiChannel;
	NSTimer *_midiTimer;
	
	MidiEventOutput *_midiEvts;
	
	// WiiMote
	WiiRemoteDiscovery *discovery;
	WiiRemote *wii;
	
	//WiiJoyStickCalibData nunchukJsCalib;
	WiiAccCalibData wiiAccCalib;
	//WiiAccCalibData nunchukAccCalib;
	
	//WiiControls
	WiiControls *_WiiControls;
	
	IBOutlet NSButton *bDiscovery;
	IBOutlet NSProgressIndicator *discoverySpinner;
	IBOutlet NSTextField *textStatusWii;
	
	int x1, x2, x3, y1, y2, y3, z1, z2, z3;
	int x0, y0, z0;
	unsigned short tmpAccX, tmpAccY, tmpAccZ;
	
	//debug
	// IBOutlet NSTextView *textoPruebas;
	// IBOutlet NSTextField *textaccx;
	// IBOutlet NSTextField *textaccy;
	// IBOutlet NSTextField *textaccz;
	
	// Logic
	IBOutlet NSTextField *textModo;
	GeneradorEv *_generadorEv ;
	
	//URL
	NSString *cadenaURL ;

}
// WiiMote
- (IBAction) doDiscovery:(id)sender;
- (IBAction) doCalibration:(id)sender;

// MIDI
-(IBAction) midiDeviceChanged:(NSPopUpButton*)button;
-(id) setMidiTimer:(NSTimer*)timer;

// OSC
-(IBAction)connectOSC:(id)sender;
-(IBAction)disconnectOSC:(id)sender;
-(IBAction)setupField:(id)sender;
-(IBAction)testOSC:(id)sender;

// Mode override
-(IBAction)overrideMode:(id)sender;

// Link to my web
-(IBAction) abrirEnlace:(id)sender;

// De DarwiinRemote
#pragma mark -
#pragma mark WiiRemoteDiscovery delegates

- (void) willStartWiimoteConnections;

// CLose last window
//-(BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication ;


@end
