//
//  MidiEventOutput.h
//  WiiToMidi
//
//  Created by Mike Verdone on 13/02/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreMIDI/MIDIServices.h>

#define MIDI_LIST_SIZE 1024
#define MIDI_TIME_NOW 0
#define MIDI_DEFAULT_VELOCITY 100

@interface MidiEventOutput : NSObject 
{
	MIDIPacketList *_list;
	MIDIPacket *_cur;
	int _channel;
}

-(id) init;
-(void) dealloc;

-(id) pushControl:(unsigned char)controlId value:(unsigned char)value;
-(id) pushControl:(unsigned char)controlId value:(unsigned char)value channel:(int)channel;
-(id) pushNoteOn:(unsigned char)noteId velocity:(unsigned char)velocity;
-(id) pushNoteOn:(unsigned char)noteId velocity:(unsigned char)velocity channel:(int)channel;
-(id) pushNoteOff:(unsigned char)noteId velocity:(unsigned char)velocity;

-(id) setChannel:(int)channel;

-(id) clearList;

-(MIDIPacketList*) list;
-(int) channel;

@end
