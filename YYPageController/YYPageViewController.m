//
//  YYPageViewController.m
//  YYPageController
//
//  Created by sky　 on 2017/4/28.
//  Copyright © 2017年 yy. All rights reserved.
//
#define TitleHeight 40  //头高度
#define NavBarHeight 64  //nav高度
#define YYScreenH [UIScreen mainScreen].bounds.size.height
#define YYScreenW [UIScreen mainScreen].bounds.size.width
#define SelectedColor [UIColor blueColor]//选中颜色
#define NormoarlColor [UIColor lightGrayColor]//默认颜色




#import "YYPageViewController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "UIView+XJExtension.h"


static NSString * const ID = @"CELL";


@interface YYPageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

/** 顶部控件*/
@property (nonatomic, weak) UIScrollView *topView;
/** 下划线 */
@property (nonatomic, weak) UIView *lineView;
/** 滚动视图 */
@property (nonatomic, weak) UICollectionView *collectionView;
/** 当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectButton;
/** 按钮数组 */
@property (nonatomic, strong) NSMutableArray *titleButtons;


@end

@implementation YYPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航条内容
    [self setupNavgationBar];
    
    // 添加底部内容view
    [self setupBottomContentView];
    
    // 添加所有子控制器
    [self setupAllChildViewController];
    
    [self setupAllTitle];
    
    // 不添加额外滚动区域
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - 添加所有的子控制器
- (void)setupAllChildViewController {
  
    OneViewController *oneVc = [[OneViewController alloc] init];
    oneVc.title = @"控制器一";
    oneVc.view.backgroundColor = [UIColor purpleColor];
    [self addChildViewController:oneVc];
    

    TwoViewController *twoVc = [[TwoViewController alloc] init];
    twoVc.title = @"控制器二";
    twoVc.view.backgroundColor = [UIColor redColor];
    [self addChildViewController:twoVc];
    
    //
    TwoViewController *threeVc = [[TwoViewController alloc] init];
    threeVc.title = @"控制器三";
    threeVc.view.backgroundColor = [UIColor yellowColor];
    [self addChildViewController:threeVc];
}

#pragma mark - 设置导航条内容
- (void)setupNavgationBar {
    UIScrollView *topView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, YYScreenW, TitleHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    _topView = topView;
    [self.view addSubview:topView];
}

#pragma mark - 按钮被点击
- (void)titleClick:(UIButton *)titleButton{
    
    NSInteger i = titleButton.tag;
    // 重复点击标题按钮的时候,刷新当前界面
    if (titleButton == _selectButton) {
    }
    
    [self selButton:titleButton];
    
    //滚动collectionView 修改偏移量
    CGFloat offsetX = i * YYScreenW;
    _collectionView.contentOffset = CGPointMake(offsetX, 0);
}

#pragma mark - 选中标题按钮
- (void)selButton:(UIButton *)titleButton{
    
    _selectButton.selected = NO;
    titleButton.selected = YES;
    _selectButton = titleButton;
    
    // 移动下划线的位置
    [UIView animateWithDuration:0.25 animations:^{
        _lineView.xj_centerX = titleButton.xj_centerX;
    }];
}

#pragma mark - 添加标题
- (void)setupAllTitle{
    
    NSUInteger count = self.childViewControllers.count;
    CGFloat btnX = 0;
    CGFloat btnW = YYScreenW/count;
    CGFloat btnH = _topView.xj_height;
    for (int i = 0; i < count; i++) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        
        UIViewController *vc = self.childViewControllers[i];
        [titleButton setTitle:vc.title forState:UIControlStateNormal];
        // 设置标题颜色
        [titleButton setTitleColor:SelectedColor forState:UIControlStateSelected];
        [titleButton setTitleColor:NormoarlColor forState:UIControlStateNormal];
        
        // 设置标题字体
        titleButton.titleLabel.font = [UIFont systemFontOfSize:18];
        
        btnX = i * btnW;
        
        titleButton.frame = CGRectMake(btnX, 0, btnW, btnH);
        
        // 监听按钮点击
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_topView addSubview:titleButton];
        
        if (i == 0) {
            // 添加下划线
            // 下划线宽度 = 按钮文字宽度
            // 下划线中心点x = 按钮中心点x
            CGFloat h = 2;
            CGFloat y = 38 ;
            UIView *lineView =[[UIView alloc] init];
            // 位置和尺寸
            lineView.xj_height = h;
            // 先计算文字尺寸,在给label去赋值
            [titleButton.titleLabel sizeToFit];
            lineView.xj_width = titleButton.titleLabel.xj_width;
            lineView.xj_centerX = titleButton.xj_centerX;
            lineView.xj_y = y;
            lineView.backgroundColor = SelectedColor;
            _lineView = lineView;
            [_topView addSubview:lineView];
            
            [self titleClick:titleButton];
        }
        [self.titleButtons addObject:titleButton];
    }
}

#pragma mark - 添加底部内容view
- (void)setupBottomContentView
{
    // 创建一个流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(YYScreenW, YYScreenH-TitleHeight-NavBarHeight);
    
    // 设置水平滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    // 创建UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,TitleHeight+NavBarHeight, YYScreenW, YYScreenH-TitleHeight-NavBarHeight) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor redColor];
    [self.view addSubview:collectionView];
    _collectionView = collectionView;
    collectionView.scrollsToTop = NO;
    collectionView.scrollEnabled = YES;
    // 开启分页
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.bounces = YES;
    
    // 展示cell
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    // 注册cell
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
}

#pragma mark - UICollectionViewDelegate
// 滚动完成的时候就会调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 获取角标
    NSInteger i = scrollView.contentOffset.x / YYScreenW;
    
    // 获取选中标题
    UIButton *selButton = self.titleButtons[i];
    
    // 选中标题
    [self selButton:selButton];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.childViewControllers.count;
}

// 只要有新的cell出现的时候才会调用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    // 移除之前子控制器view
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 取出对应的子控制器添加到对应cell上
    UIViewController *vc = self.childViewControllers[indexPath.row];
    
    [cell.contentView addSubview:vc.view];
    
    return cell;
}

#pragma mark - 懒加载
- (NSMutableArray *)titleButtons {
    if (_titleButtons==nil) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}



@end
