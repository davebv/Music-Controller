//
//  MidiDevice.m
//  WiiToMidi
//
//  Created by Mike Verdone on 30/01/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MidiDevice.h"

static CFStringRef ConnectedEndpointName(MIDIEndpointRef endpoint);
static CFStringRef EndpointName(MIDIEndpointRef endpoint, bool isExternal);

@implementation MidiDevice

-(id) initWithEndpoint:(MIDIEndpointRef)endpoint
		deviceName:(NSString*)deviceName
{
	_midiEndpoint = endpoint;
	_midiDeviceName = [deviceName retain];
	return self;
}

-(MIDIEndpointRef) midiEndpoint { return _midiEndpoint; }
-(NSString*) midiDeviceName { return _midiDeviceName; }

-(void) dealloc
{
	[_midiDeviceName autorelease];
	[super dealloc];
}

+(NSArray*) getAllMidiDevices
{
	NSMutableArray* devices = [[NSMutableArray alloc] init];
	int n = MIDIGetNumberOfDestinations();
	int i = 0;
	for (i = 0; i < n; i++)
	{
		MIDIEndpointRef endpoint = MIDIGetDestination(i);
		CFStringRef nameCStr = ConnectedEndpointName(endpoint);
		
		[devices addObject:[[[MidiDevice alloc] initWithEndpoint:endpoint deviceName:(NSString*)nameCStr] autorelease]];
	}
	
	return [devices autorelease];
}

@end

// The following is copied from: http://developer.apple.com/qa/qa2004/qa1374.html

// Obtain the name of an endpoint, following connections.
// The result should be released by the caller.
static CFStringRef ConnectedEndpointName(MIDIEndpointRef endpoint)
{
  CFMutableStringRef result = CFStringCreateMutable(NULL, 0);
  CFStringRef str;
  OSStatus err;
  int i = 0;

  // Does the endpoint have connections?
  CFDataRef connections = NULL;
  int nConnected = 0;
  bool anyStrings = false;
  err = MIDIObjectGetDataProperty(endpoint, kMIDIPropertyConnectionUniqueID, &connections);
  if (connections != NULL) {
    // It has connections, follow them
    // Concatenate the names of all connected devices
    nConnected = CFDataGetLength(connections) / sizeof(MIDIUniqueID);
    if (nConnected) {
        const SInt32 *pid = (SInt32*) CFDataGetBytePtr(connections);
      for (i = 0; i < nConnected; ++i, ++pid) {
         MIDIUniqueID id = EndianS32_BtoN(*pid);
         MIDIObjectRef connObject;
         MIDIObjectType connObjectType;
         err = MIDIObjectFindByUniqueID(id, &connObject, &connObjectType);
         if (err == noErr) {
        if (connObjectType == kMIDIObjectType_ExternalSource  ||
                                                      connObjectType == kMIDIObjectType_ExternalDestination) {
           // Connected to an external device's endpoint (10.3 and later).
           str = EndpointName((connObject), true);
        } else {
             // Connected to an external device (10.2) (or something else, catch-all)
          str = NULL;
          MIDIObjectGetStringProperty(connObject, kMIDIPropertyName, &str);
        }
        if (str != NULL) {
          if (anyStrings)
            CFStringAppend(result, CFSTR(", "));
          else anyStrings = true;
          CFStringAppend(result, str);
          CFRelease(str);
        }
         }
      }
    }
    CFRelease(connections);
  }
  if (anyStrings)
    return result;

  // Here, either the endpoint had no connections, or we failed to obtain names for any of them.
  return EndpointName(endpoint, false);
}

//////////////////////////////////////
// Obtain the name of an endpoint without regard for whether it has connections.
// The result should be released by the caller.
static CFStringRef EndpointName(MIDIEndpointRef endpoint, bool isExternal)
{
  CFMutableStringRef result = CFStringCreateMutable(NULL, 0);
  CFStringRef str;

  // begin with the endpoint's name
  str = NULL;
  MIDIObjectGetStringProperty(endpoint, kMIDIPropertyName, &str);
  if (str != NULL) {
    CFStringAppend(result, str);
    CFRelease(str);
  }

  MIDIEntityRef entity = NULL;
  MIDIEndpointGetEntity(endpoint, &entity);
  if (entity == NULL)
    // probably virtual
    return result;

  if (CFStringGetLength(result) == 0) {
    // endpoint name has zero length -- try the entity
    str = NULL;
    MIDIObjectGetStringProperty(entity, kMIDIPropertyName, &str);
    if (str != NULL) {
      CFStringAppend(result, str);
      CFRelease(str);
    }
  }
  // now consider the device's name
  MIDIDeviceRef device = NULL;
  MIDIEntityGetDevice(entity, &device);
  if (device == NULL)
    return result;

  str = NULL;
  MIDIObjectGetStringProperty(device, kMIDIPropertyName, &str);
  if (str != NULL) {
    // if an external device has only one entity, throw away
                // the endpoint name and just use the device name
    if (isExternal && MIDIDeviceGetNumberOfEntities(device) < 2) {
      CFRelease(result);
      return str;
    } else {
      // does the entity name already start with the device name?
                        // (some drivers do this though they shouldn't)
      // if so, do not prepend
      if (CFStringCompareWithOptions(str /* device name */,
                                    result /* endpoint name */,
                                         CFRangeMake(0, CFStringGetLength(str)), 0) != kCFCompareEqualTo) {
        // prepend the device name to the entity name
        if (CFStringGetLength(result) > 0)
          CFStringInsert(result, 0, CFSTR(" "));
        CFStringInsert(result, 0, str);
      }
      CFRelease(str);
    }
  }
  return result;
}
