//
//  ViewController.m
//  bluetoothy
//
//  Created by Chase Roberts on 9/15/20.
//

#import "ViewController.h"
#import "DataController.h"

@interface ViewController () <DataControllerBluetoothDelegate>
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;

@property (weak, nonatomic) IBOutlet UISlider *baseSlider;
@property (weak, nonatomic) IBOutlet UILabel *baseLabel;
@property (weak, nonatomic) IBOutlet UIButton *forwardBtn;
@property (weak, nonatomic) IBOutlet UIButton *burnBtn;


@property NSTimer *timer;
@end

@implementation ViewController {
    bool has_updates;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [DataController sharedInstance].bluetoothDelegate = self;
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    self.burnBtn.layer.cornerRadius = self.burnBtn.frame.size.width / 2;
}

- (IBAction)scanBtnPressed:(id)sender {
    [[DataController sharedInstance] scanHMSoftDevices:2000];
}

- (IBAction)sliderValueChanged:(UISlider *)slider {
    self.baseLabel.text = [NSString stringWithFormat:@"%i", (int)self.baseSlider.value];
}

- (void)didUpdateStatus:(NSString *)status {
    self.statusLabel.text = status;
}

- (IBAction)burnDown:(id)sender {
    [self addPressed:sender];
}

- (IBAction)burnUpInside:(id)sender {
    [self subtractPressed:self];
}

- (IBAction)burnUpOutside:(id)sender {
    [self subtractPressed:self];
}

- (IBAction)addPressed:(id)sender {
    char a = (int)self.baseSlider.value;
    [[DataController sharedInstance] writeData:[NSData dataWithBytes:&a length:sizeof(a)]];
}

- (IBAction)subtractPressed:(id)sender {
    char a = 100+(int)self.baseSlider.value;
    [[DataController sharedInstance] writeData:[NSData dataWithBytes:&a length:sizeof(a)]];
}

@end
