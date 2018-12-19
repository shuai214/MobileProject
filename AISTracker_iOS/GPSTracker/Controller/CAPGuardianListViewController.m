//
//  CAPGuardianListViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPGuardianListViewController.h"

@interface CAPGuardianListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CAPGuardianListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)refreshLocalizedString {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
//    static NSString * const cellIdentifier = @"media_group_cell";
//    CAPCheckableTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
//    CAPMediaGroup *group = self.category.mediaGroups[indexPath.row];
//    cell.nameLabel.text = group.displayName;
//    PHAsset *asset = (PHAsset *)((CAPMedia *)group.firstAsset).asset;
//    cell.representedIdentifier = asset.localIdentifier;
//
//    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
//    option.resizeMode = PHImageRequestOptionsResizeModeFast;
//    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
//        if (downloadFinined && result && [cell.representedIdentifier isEqualToString:asset.localIdentifier]) {
//            cell.iconImageView.image = result;
//        }
//    }];
//
//    cell.countLabel.text = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)[self selectedAssetsCountAtGroup:indexPath.row], (unsigned long)group.allAssets.count];
//    cell.checkButton.selected = [self isSelectedGroupAt:indexPath.row];
//    cell.tag = indexPath.row;
//    cell.delegate = self;
//
//    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
