//
//  DataController.h
//  HMSoft
//
//  Created by croberts on 1/27/15.
//
//

#import <Foundation/Foundation.h>
#import "SerialGATT.h"



@class DataController;             //define class, so protocol can see MyClass
@protocol DataControllerBluetoothDelegate   //define delegate protocol
-(void)didUpdateStatus:(NSString*)status;
@end //end protocol

@interface DataController : NSObject <BTSmartSensorDelegate>

@property (weak, nonatomic) id<DataControllerBluetoothDelegate> bluetoothDelegate;
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) SerialGATT *sensor;

+(DataController*)sharedInstance;
-(void)scanHMSoftDevices:(float)timeout;
-(void)disconnectBluetooth;
-(void) writeString:(NSString*)value;
-(void) writeData:(NSData*) data;

@end
