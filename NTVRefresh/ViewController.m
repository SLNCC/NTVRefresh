//
//  ViewController.m
//  NTVRefresh
//
//  Created by 乔冬 on 17/5/26.
//  Copyright © 2017年 XinHuaTV. All rights reserved.
//

#import "ViewController.h"
#import "NTVCollectionViewCell.h"
#import "UIScrollView+NTVRefresh.h"

#ifndef kScreenWidth
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#endif

#ifndef kScreenHeight
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#endif

static NSString *const kCellId = @"reUse";

@interface ViewController () <UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"ViewController";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.dataArray = [NSMutableArray arrayWithObjects:@0, @0, @0, nil];
    
    CGFloat padding = 40;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWidth - padding * 2, kScreenHeight - padding * 4);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(padding * 2, padding, padding * 2, padding);
    layout.minimumLineSpacing = padding * 2;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[NTVCollectionViewCell class] forCellWithReuseIdentifier:kCellId];
      [self normalDemo];
 }

#pragma mark -
#pragma mark - refresh control Using Example
- (void)normalDemo {
    WeakSelf(self)
   [ _collectionView addRefreshHeaderWithClosure:^{
        [weakSelf refreshData];
   }];
    [_collectionView addRefreshFooterWithClosure:^{
         [weakSelf loadingData];
    }];
}


#pragma mark -
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
      NTVCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    cell.backgroundColor = [self randomColor];
    return cell;
}

- (UIColor *)randomColor {
    CGFloat hue = arc4random() % 256 / 256.0;
    CGFloat saturation = arc4random() % 128 / 256.0 + 0.5;
    CGFloat brightness = arc4random() % 128 / 256.0 + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

#pragma mark -
#pragma mark - refresh and loading
- (void)refreshData {
    self.dataArray = [NSMutableArray arrayWithObjects:@1, @2, @3, nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.collectionView.isLastPage = NO;
        [self.collectionView endRefreshing];
        [self.collectionView reloadData];
    });
}

- (void)loadingData {
    for (int i = 0; i < 3; i ++) {
        [self.dataArray addObject:@0];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView endRefreshing];
        if (self.dataArray.count > 7) {
            self.collectionView.isLastPage = YES;
        }
        [self.collectionView reloadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
