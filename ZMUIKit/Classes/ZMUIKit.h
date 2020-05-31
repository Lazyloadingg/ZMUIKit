//
//  ZMKit.h
//  Pods
//
//  Created by 德一智慧城市 on 2019/7/3.
//

#ifndef ZMUIKit_h
#define ZMUIKit_h


#pragma mark -
#pragma mark -- 👉 Global 👈

#import "ZMDevice.h"                                   //获取设备信息
#import "ZMUtilities.h"                                //常用宏和内联函数
#import "ZMProtocolWebViewController.h"                //web协议控制器
#import "ZMBrightness.h"                               //屏幕亮度调节
#import "ZMApplication.h"
#import "ZMScreenDirection.h"
#import "ZMUIKitDefine.h"

#pragma mark -
#pragma mark -- 🐷 Extension 🐷

#import "UIView+ZMExtension.h"                         //UIView      分类
#import "UIFont+ZMExtension.h"                         //UIFont      分类 主要定义常用字号和字体
#import "CALayer+ZMExtension.h"
#import "UIColor+ZMExtension.h"                        //UIColor     分类 主要定义常用颜色
#import "UIImage+ZMExtension.h"                        //UIImagef    分类
#import "UITableView+ZMExtension.h"                    //UITableView 分类
#import "UIViewController+ZMExtension.h"               //控制器       分类
#import "UIButton+ZMExtension.h"                       //UIButton    分类
#import "UITextField+ZMExtension.h"                    //输入框       分类
#import "UITextView+ZMExtension.h"                     //输入框       分类
#import "ZMHud+ZMExtension.h"                          //ZMHud统一文案
#import "UITableViewCell+SectionCorner.h"
#import "UINavigationController+ZMExtension.h"
#import "UIImageView+ZMExtension.h"
#import "UITableView+ZMIndexView.h"                    //列表索引
#import "UISearchBar+ZMExtension.h"

#pragma mark -
#pragma mark -- 🐷 Base 🐷
#import "ZMTabBarController.h"                          //base TabBarController
#import "ZMNavigationController.h"                      //base NavigationController
#import "ZMPopupViewController.h"                       //base 弹出控制器
#import "ZMTableViewCell.h"                             //base TableViewCell

#pragma mark -
#pragma mark -- 🐷 Controller 🐷
#import "ZMCameraController.h"
#import "ZMCameraBaseController.h"                     //自定义相机基类
#import "ZMCameraCardController.h"                     //拍照模板相机（身份证正反面、银行卡...）
#import "ZMImageEditorViewController.h"                //裁剪图片控制器

#pragma mark -
#pragma mark -- 🐷 View 🐷

#import "ZMHud.h"                                       //hud
#import "ZMAlert.h"                                     //alert
#import "ZMSheet.h"                                     //sheet
#import "ZMSwitch.h"                                    //开关
#import "ZMLabel.h"                                     //自定义label
#import "ZMCycleScrollView.h"                           //自定义轮播图+
#import "ZMTextField.h"                                 //自定义输入框
#import "ZMAuthCodeInputView.h"                         //
#import "ZMDotPassNumberView.h"                         //
#import "ZMNumberStepper.h"                             //自定义数字加减器
#import "ZMKeyboardView.h"
#import "ZMPopoverView.h"                               //气泡弹出框
#import "ZMDownMenuView.h"                              //弹出下拉菜单
#import "ZMAlertController.h"                           //各种alert弹出框
#import "ZMDownScreeningMenuView.h"
#import "ZMIndexView.h"                                 //索引视图
#import "ZMIndexItemView.h"
 
#import "ZMRefreshGifHeader.h"                         //动画下拉刷新
#import "ZMRefreshNormalHeader.h"                      //普通下拉刷新
#import "ZMRefreshBackNormalFooter.h"                  //普通上拉加载
#import "ZMRingChartView.h"
#import "ZMCyclePageView.h"                            //轮播图
#import "ZMCyclePageCell.h"                            //轮播图cell
#import "ZMPageControl.h"                              //轮播图 指示器
#import "ZMNavigationView.h"
#import "ZMCountDownView.h"
#import "ZMStarRatingView.h"
#import "ZMPopupView.h"                                //popup弹出视图
#pragma mark -
#pragma mark -- 🐷 ZMViewControllerIntercepter 🐷
#import "ZMViewControllerIntercepter.h"                 //拦截器

#pragma mark -
#pragma mark -- 🐷 ZMViewControllerSceneProtocol 🐷
#import "ZMViewControllerSceneProtocol.h"               //控制器场景配置协议


#pragma mark -
#pragma mark -- 🐷 Interaction 🐷
#import "ZMNavigationManager.h"
#import "ZMImpactFeedBack.h"                            //触感反馈


#pragma mark -- 🐷 Common 🐷
#import "ZMUIKitTools.h"

#endif /* ZMKit_h */
