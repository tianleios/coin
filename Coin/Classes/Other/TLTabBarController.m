//
//  ZHTabBarController.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLTabBarController.h"

#import "TLNavigationController.h"
#import "TLUserLoginVC.h"

#import "UIColor+theme.h"

@interface TLTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation TLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;

    NSArray *titles = @[@"交易",@"订单",@"行情",@"钱包",@"我的"];
    NSArray *VCNames = @[@"TLTransactionVC",@"TLOrderVC",@"TLHangQingVC",@"TLWalletVC",@"TLMineVC"];
    
    NSArray *imageNames = @[@"交易00",@"订单00",@"行情00",@"钱包00",@"我的00"];
    NSArray *selectedImageNames = @[@"交易01",@"订单01",@"行情01",@"钱包01",@"我的01"];
    
    
    for (int i = 0; i < imageNames.count; i++) {
        
        [self addChildVCWithTitle:titles[i]
                       controller:VCNames[i]
                      normalImage:imageNames[i]
                    selectedImage:selectedImageNames[i]];
    }
    
    self.selectedIndex = 0;
    
}

- (void)usrLoginOut {

    self.tabBar.items[3].badgeValue =  nil;
   [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}


- (UIImage *)changImageColorWithImage:(UIImage *)image  color:(UIColor *)targetColor blendModel:(CGBlendMode)mode
{
    //获取画布
    UIGraphicsBeginImageContext(image.size);
    //画笔沾取颜色
    [targetColor setFill];
    
    CGRect drawRect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIRectFill(drawRect);
    [image drawInRect:drawRect blendMode:mode alpha:1];
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



- (void)addChildVCWithTitle:(NSString *)title
                 controller:(NSString *)controllerName
                normalImage:(NSString *)normalImageName
              selectedImage:(NSString *)selectedImageName
{
    Class vcClass = NSClassFromString(controllerName);
    UIViewController *vc = [[vcClass alloc] init];
//    vc.title = title;
    
    //获得原始图片
    UIImage *normalImage = [self getOrgImage:[UIImage imageNamed:normalImageName]];
    UIImage *selectedImage = [self getOrgImage:[UIImage imageNamed:selectedImageName]];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                             image:normalImage
                                                     selectedImage:selectedImage];
//    tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
//    tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 100);
    
    //title颜色
    [tabBarItem setTitleTextAttributes:@{
                                         NSForegroundColorAttributeName : [UIColor themeColor]
                                         } forState:UIControlStateSelected];
    [tabBarItem setTitleTextAttributes:@{
                                         NSForegroundColorAttributeName : [UIColor textColor]
                                         } forState:UIControlStateNormal];
    vc.tabBarItem =tabBarItem;
    TLNavigationController *navigationController = [[TLNavigationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:navigationController];
    
}

- (UIImage *)getOrgImage:(UIImage *)image
{
//    return image;
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

#pragma mark 判断是否登录若没登录跳转到登录页面
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(nonnull UIViewController *)viewController {
    //赋值更改前的index
    self.currentIndex = tabBarController.selectedIndex;
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    NSInteger idx = tabBarController.selectedIndex;
    
    //判断点击的Controller是不是需要登录，如果是，那就登录
    if((idx == 1 || idx == 3 || idx == 4) && ![TLUser user].isLogin){
        
        TLUserLoginVC *loginVC = [TLUserLoginVC new];
        
        loginVC.loginSuccess = ^{
            
            self.selectedIndex = idx;

        };
        
        TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:nav animated:YES completion:nil];
        
        self.selectedIndex = _currentIndex;
        
    }
    
}
@end
