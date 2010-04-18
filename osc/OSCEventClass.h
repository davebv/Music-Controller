//
//  OSCEventClass.h
//  MusicController
//
//  Created by David Becerril Valle on 12/27/08.
//  Copyright 2008 David Becerril (davebv.es). All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <VVOSC/VVOSC.h>


@interface OSCEventClass : NSObject {
  
  OSCManager * manager ;
  OSCOutPort * outPort ;
  NSString * OSCdestinationPath ;

}

@property (readwrite,assign) NSString *OSCdestinationPath;


-(void) init_mod_OSCsettings: (NSString *)toAddress
                      atPort: (int)port ;

-(void) disconnect_OSC ;

-(void) change_OSCsettings: (NSString *)toAddress
                    atPort: (int)port ;

-(void) sendOSCPacket_float:(NSArray *)value_array
                    typeOSC: (NSString *)type ;

//-(void) sendOSCPacket_int:(NSString *)value
//                  typeOSC: (NSString *)type
//          destinationPath: (NSString *)destinationPath ;
//-(void) sendOSCPacket_int:(float)value
//                  typeOSC: (NSString *)type
//          destinationPath: (NSString *)destinationPath ;


@end
