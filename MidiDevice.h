//
//  MidiDevice.h
//  WiiToMidi
//
//  Created by Mike Verdone on 30/01/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreMIDI/MIDIServices.h>


@interface MidiDevice : NSObject {
	MIDIEndpointRef _midiEndpoint;
	NSString *_midiDeviceName;
}

-(void) dealloc;

-(MIDIEndpointRef) midiEndpoint;
-(NSString*) midiDeviceName;

-(id) initWithEndpoint:(MIDIEndpointRef)endpoint
		deviceName:(NSString*)deviceName;

+(NSArray*) getAllMidiDevices;

@end
