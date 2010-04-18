//
//  MidiEventOutput.m
//  WiiToMidi
//
//  Created by Mike Verdone on 13/02/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MidiEventOutput.h"


@implementation MidiEventOutput

-(id) init
{
	_list = (MIDIPacketList*) malloc(MIDI_LIST_SIZE * sizeof(char));
	[self clearList];
	[self setChannel:1];
	return self;
}

-(void) dealloc
{
	free(_list);
	[super dealloc];
}

-(id) pushControl:(unsigned char)controlId value:(unsigned char)value
{
	unsigned char data[3];
	unsigned char *d = data;
	
	*d++ = 0xB0 | _channel;  // Code 0xB0, low nibble MIDI channel
	*d++ = controlId;        // Controller ID
	*d++ = value;            // Controller value
	
	_cur = MIDIPacketListAdd(_list, MIDI_LIST_SIZE, _cur, MIDI_TIME_NOW, 3, data);
	return self;
}

-(id) pushControl:(unsigned char)controlId value:(unsigned char)value channel:(int)channel
{
	unsigned char data[3];
	unsigned char *d = data;
	
	*d++ = 0xB0 | channel;  // Code 0xB0, low nibble MIDI channel
	*d++ = controlId;        // Controller ID
	*d++ = value;            // Controller value
	
	_cur = MIDIPacketListAdd(_list, MIDI_LIST_SIZE, _cur, MIDI_TIME_NOW, 3, data);
	return self;
}

-(id) pushNoteOn:(unsigned char)noteId velocity:(unsigned char)velocity
{
	unsigned char data[3];
	unsigned char *d = data;
	
	*d++ = 0x90 | _channel;  // Code 0x90, low nibble MIDI channel
	*d++ = noteId;           // Note ID
	*d++ = velocity;         // Velocity
	
	_cur = MIDIPacketListAdd(_list, MIDI_LIST_SIZE, _cur, MIDI_TIME_NOW, 3, data);
	return self;
}

-(id) pushNoteOn:(unsigned char)noteId velocity:(unsigned char)velocity channel:(int)channel
{
	unsigned char data[3];
	unsigned char *d = data;
	
	*d++ = 0x90 | channel;  // Code 0x90, low nibble MIDI channel
	*d++ = noteId;           // Note ID
	*d++ = velocity;         // Velocity
	
	_cur = MIDIPacketListAdd(_list, MIDI_LIST_SIZE, _cur, MIDI_TIME_NOW, 3, data);
	return self;
}

-(id) pushNoteOff:(unsigned char)noteId velocity:(unsigned char)velocity
{
	unsigned char data[3];
	unsigned char *d = data;
	
	*d++ = 0x80 | _channel;  // Code 0x80, low nibble MIDI channel
	*d++ = noteId;           // Note ID
	*d++ = velocity;         // Velocity
	
	_cur = MIDIPacketListAdd(_list, MIDI_LIST_SIZE, _cur, MIDI_TIME_NOW, 3, data);
	return self;
}

-(id) setChannel:(int)channel
{
	_channel = channel;
	return self;
}

-(id) clearList
{
	_cur = MIDIPacketListInit(_list);
	return self;
}

-(MIDIPacketList*) list
{
	return _list;
}

-(int) channel
{
	return _channel;
}

@end
