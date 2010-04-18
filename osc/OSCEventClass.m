//
//  OSCEventClass.m
//  MusicController
//
//  Created by David Becerril Valle on 12/27/08.
//  Copyright 2008 David Becerril (davebv.es). All rights reserved.
//

#import "OSCEventClass.h"


@implementation OSCEventClass

@synthesize OSCdestinationPath ;

- (id) init {
  self = [super init] ;
  
  manager = [[OSCManager alloc] init] ;
  [manager setDelegate:self] ;
  [self setOSCdestinationPath: [NSString stringWithFormat:@"all"]] ;
  
  return self;
}

/*-(void) dealloc {
}
*/

-(void) init_mod_OSCsettings: (NSString *)toAddress
                      atPort: (int)port
{
  if (outPort == nil) {
    outPort = [manager createNewOutputToAddress: toAddress atPort:port] ;
  }
  if (outPort == nil)
    NSLog(@"\t\tError creating OSC output") ;
  else
    NSLog(@"Created to Address: %@ and port %d",toAddress, port) ;
}

-(void) disconnect_OSC
{
  [manager deleteAllOutputs] ;
  NSLog(@"Deleted all OSC outputs") ;
}

-(void) change_OSCsettings: (NSString *)toAddress
                      atPort: (int)port
{
  if (toAddress != nil)
  {
    [outPort setAddressString: toAddress] ;
    NSLog(@"Adress changed to %@", toAddress) ;
  }
  if (port != -1)
  {
    [outPort setPort:port] ;
    NSLog(@"Port changed to %d", port) ;
  }
}


-(void) sendOSCPacket_float:(NSArray *)value_array
                  typeOSC: (NSString *)type
{
  OSCMessage		*msg = nil;
	OSCBundle		*bundle = nil;
	OSCPacket		*packet = nil;
  
  int i ;
	(OSCBundle*) bundle ;
	
	//	make a message to the specified address
	//msg = [OSCMessage createMessageToAddress: [NSString stringWithFormat:@"/wiimote/%@/%@", [self OSCdestinationPath],type]] ;
	msg = [OSCMessage createWithAddress: [NSString stringWithFormat:@"/wiimote/%@/%@", [self OSCdestinationPath],type]] ;
  for (i = 0; i < [value_array count]; i++) {
    [msg addFloat:[[value_array objectAtIndex:i] floatValue]] ;
  }
  
  packet = [OSCPacket createWithContent:msg];
  [outPort sendThisPacket:packet] ;
}

@end
