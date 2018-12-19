//
//  CAPTrackerViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPTrackerViewController.h"
#import "CAPDeviceListView.h"
#import "CAPTrackerView.h"
@import GoogleMaps;

@interface CAPTrackerViewController () <CAPDeviceListViewDelegate, CAPTrackerViewDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet CAPDeviceListView *deviceListView;

@property (weak, nonatomic) IBOutlet CAPTrackerView *trackerView;

@end

@implementation CAPTrackerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightBarImageButton:@"bar_add" action:@selector(onAddButtonClicked:)];
    self.mapView.camera = [GMSCameraPosition cameraWithLatitude:22.290664 longitude:114.195304 zoom:16];
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(22.290664, 114.195304);
    marker.title = @"香港";
    marker.snippet = @"Hong Kong";
    marker.map = self.mapView;
    
    CGRect rect = self.deviceListView.frame;
    rect.size.width = self.view.frame.size.width;
    self.deviceListView.frame = rect;
    self.deviceListView.devices = @[@"1", @"2", @"3"];
    self.deviceListView.delegate = self;
    
    self.trackerView.frame = self.view.frame;
    self.trackerView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)refreshLocalizedString {
    
}

- (void)onAddButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"pair.segue" sender:nil];
}

-(void)didSelectDeviceAtIndex:(NSUInteger)index {
    NSLog(@"didSelectDeviceAtIndex: %lu", (unsigned long)index);
}

-(void)onTrackerViewActionPerformed:(CAPTrackerViewAction)action {
    switch (action) {
        case CAPTrackerViewActionFence:
            [self performSegueWithIdentifier:@"fence.list.segue" sender:nil];
            break;
        case CCAPTrackerViewActionFootprint:
            [self performSegueWithIdentifier:@"footprint.segue" sender:nil];
            break;
        case CAPTrackerViewActionPhotograph:
            [self performSegueWithIdentifier:@"photograph.segue" sender:nil];
            break;
        case CAPTrackerViewActionNavigation:
            break;
        case CAPTrackerViewActionSetting:
            [self performSegueWithIdentifier:@"master.setting.segue" sender:nil];
            break;
        default:
            break;
    }
}

@end
