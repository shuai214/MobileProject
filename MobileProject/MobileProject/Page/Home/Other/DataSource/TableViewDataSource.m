//
//  TableViewDataSource.m
//  MobileProject
//
//  Created by capaipai@sina.com on 2018/11/21.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "TableViewDataSource.h"
@interface TableViewDataSource ()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;

@end
@implementation TableViewDataSource
- (id)initWithItems:(NSArray *)aItems cellIdentifier:(NSString *)cellIdentifier cellConfigureBlock:(TableViewCellConfigureBlock)block
{
    self = [super init];
    if (self) {
        self.items = aItems;
        self.cellIdentifier = cellIdentifier;
        self.configureCellBlock = [block copy];
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath{
    return self.items[indexPath.row];
}
#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                            forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell, item);
    return cell;
}

@end
