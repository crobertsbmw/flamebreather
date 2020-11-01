//
//  DataController.m
//  HMSoft
//
//  Created by croberts on 1/27/15.
//
//

#import "DataController.h"
#import <AVFoundation/AVFoundation.h>

#define ACC_SENSITIVITY 16.0
#define DATA_WIDTH 16.0

#define ACC_RISING_EDGE_THRESHOLD 1.5
#define ACC_RISING_EDGE_THRESHOLD_DRY 1.5
#define RELATIVE_STILLNESS_THRESHOLD .8
#define RELATIVE_STILLNESS_THRESHOLD_DRY 0.3

#define STILLNESS_THRESHOLD 0.4 //This is to make sure the gun is sitting on the table...

@implementation DataController{
    NSTimer *scanTimer;
}

+(DataController*)sharedInstance{
    static dispatch_once_t pred;
    static DataController *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[DataController alloc] init];
        sharedInstance.sensor = [[SerialGATT alloc] init];
        [sharedInstance.sensor setup];
        sharedInstance.sensor.delegate = sharedInstance;
    });
    return sharedInstance;
}


- (void)scanHMSoftDevices:(float)timeout{
    [self.sensor stopScan];
    if ([self.sensor activePeripheral]) {
        if (self.sensor.activePeripheral.state == CBPeripheralStateConnected) {
            [self.sensor.manager cancelPeripheralConnection:self.sensor.activePeripheral];
            self.sensor.activePeripheral = nil;
        }
    }
    self.sensor.delegate = self;
    self.sensor.peripherals = [NSMutableArray new];
    [self.bluetoothDelegate didUpdateStatus:@"SCANNING"];
    printf("now we are searching device...\n");
    [scanTimer invalidate];
    scanTimer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
    [self.sensor findHMSoftPeripherals:timeout];
}

- (void)scanTimer:(NSTimer *)timer{
    [self.bluetoothDelegate didUpdateStatus:@"Failed to Connect"];
}

-(void)peripheralFound:(CBPeripheral *)peripheral{
    NSLog(@"*********");
    NSLog(@"name: %@", peripheral.name);
    NSLog(@"name: %@", peripheral.identifier);
    NSLog(@"name: %@", peripheral.description);
    if ([[peripheral.name lowercaseString] rangeOfString:@"bt05"].location == NSNotFound){
        peripheral = nil;
        return;
    }
    NSLog(@"FOUND THE PERIPHERAL");
    [self.sensor.manager stopScan];
    [self.bluetoothDelegate didUpdateStatus:@"Found Peripheral"];
    if (self.sensor.activePeripheral && self.sensor.activePeripheral != peripheral) {
        [self.sensor disconnect:self.sensor.activePeripheral];
    }
    [scanTimer invalidate];
    scanTimer = nil;
    [self connectToPeripheral: peripheral];
}

-(void)connectToPeripheral:(CBPeripheral*)peripheral{
    NSLog(@"connect to periphearl");
    self.sensor.activePeripheral = peripheral;
    [self.sensor connect:self.sensor.activePeripheral];
    [self.bluetoothDelegate didUpdateStatus:@"Connecting"];
}

-(void) writeString:(NSString*) value{
    [self.sensor.activePeripheral writeValue:[value dataUsingEncoding:NSASCIIStringEncoding] forCharacteristic:self.sensor.characteristic type:CBCharacteristicWriteWithResponse];
}

-(void) writeData:(NSData*) data{
    [self.sensor.activePeripheral writeValue:data forCharacteristic:self.sensor.characteristic type:CBCharacteristicWriteWithResponse];
}



-(void)receivedData:(NSData *)nsdata{
//    uint8_t* words = (uint8_t*)[nsdata bytes];
    NSLog(@"RECEIVED DATA %@", nsdata);
}


-(void)disconnectBluetooth{
    NSLog(@"someone called disconnecting");
    [self.sensor disconnect:self.sensor.activePeripheral];
}

-(void)setDisconnect{
    NSLog(@"Set Disconnect");
    self.peripheral = nil;
    self.sensor.activePeripheral = nil;
    [self.bluetoothDelegate didUpdateStatus:@"DISCONNECTED"];
}

-(void)updateStatus:(NSString *)status {
    [self.bluetoothDelegate didUpdateStatus:status];
}
@end
