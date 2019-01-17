//
//  CAPFenceDetailViewController.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/14.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPFenceDetailViewController.h"
#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GoogleMaps.h>
@interface CAPFenceDetailViewController ()
@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) GMSMarker *marker;
@end

@implementation CAPFenceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"围栏范围";
    self.mapView = [[GMSMapView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.listItem.lat longitude:self.listItem.lng zoom:15];
    self.mapView.camera = camera;
//    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    //大头针
    self.marker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(self.listItem.lat,self.listItem.lng)];
    [self.marker setIcon:[UIImage imageNamed:@"map_drop_blue"]];
    self.marker.map = self.mapView;
    for (NSInteger i = 0; i < 3; i++) {
        CGFloat radius = self.listItem.range / 3 * (i+1);
        GMSCircle *circ = [GMSCircle circleWithPosition:self.marker.position
                                                 radius:radius];
        
         circ.fillColor = [UIColor colorWithRed:193.0f/255.0f green:43.0f/255.0f blue:30.0f/255.0f alpha:0.4 - i * 0.1];
        // 圆边的颜色
        if (i == 2) {
            circ.strokeColor = [UIColor greenColor];
        }else{
            circ.strokeColor = [UIColor clearColor];
        }
        // 圆边的宽度
        circ.strokeWidth = 5;
        circ.map = self.mapView;
    }
}



@end
