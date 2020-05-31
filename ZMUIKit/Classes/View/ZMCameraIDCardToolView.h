//
//  ZMCameraIDCardToolView.h
//  AFNetworking
//
//  Created by 德一智慧城市 on 2020/2/28.
//

#import <UIKit/UIKit.h>
#import "ZMCameraToolView.h"

NS_ASSUME_NONNULL_BEGIN

/// 自定义相机证件tool
@interface ZMCameraIDCardToolView : UIView

@property (nonatomic, weak) id<ZMCameraToolViewDelegate> delegate;

@property (nonatomic, strong) UIImageView * boxImg;
@property (nonatomic, strong) UIImageView * preImg;
@property (nonatomic, strong) UIButton * dismissBtn;
@property (nonatomic, strong) UIButton * takePhotoBtn;



@end

NS_ASSUME_NONNULL_END
