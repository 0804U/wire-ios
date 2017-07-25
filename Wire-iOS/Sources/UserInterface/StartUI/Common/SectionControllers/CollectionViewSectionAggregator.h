// 
// Wire
// Copyright (C) 2016 Wire Swiss GmbH
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
// 


#import <Foundation/Foundation.h>
#import "CollectionViewSectionAggregator.h"
#import "CollectionViewSectionController.h"

// the aggregator is the collection view's delegate, so this
// protocol can be used to pass delegate methods externally
@protocol CollectionViewSectionAggregatorDelegate <NSObject>
@optional
- (void)scrollViewDidScroll:(UIScrollView *_Nonnull)scrollView;
@end

@interface CollectionViewSectionAggregator : NSObject <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, nullable)   NSArray<id<CollectionViewSectionController>> *sectionControllers;
@property (nonatomic, readonly, nonnull) NSArray<id<CollectionViewSectionController>> *visibleSectionControllers;
@property (nonatomic, weak, nullable) UICollectionView *collectionView;
@property (nonatomic, weak, nullable) id <CollectionViewSectionAggregatorDelegate> delegate;

- (void)reloadData;

@end
