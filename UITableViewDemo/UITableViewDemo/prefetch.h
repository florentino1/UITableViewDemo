//
//  prefetch.h
//  UITableViewDemo
//
//  Created by 莫玄 on 2021/9/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface prefetch: NSObject<UITableViewDataSourcePrefetching>
-(void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
-(void)tableView:(UITableView *)tableView cancelPrefetchingForRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
@end

NS_ASSUME_NONNULL_END
