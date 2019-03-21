//
//  RCTTimeRuler.h
//  RCTTimeRuler
//
//  Created by shenhuniurou on 2018/5/11.
//  Copyright © 2018年 shenhuniurou. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import <React/UIView+React.h>
#import <React/RCTComponent.h>

@class RCTTimeRuler;
@protocol RCTTimeRulerDelegate <NSObject>

/*
 *  游标卡尺滑动，对应value回调
 *  滑动视图
 *  当前滑动的值
 */
-(void)trTimeRulerView:(RCTTimeRuler *)rulerView valueChange:(float)value;
-(void)trTimeRulerView:(RCTTimeRuler *)rulerView finalValue:(float)value;
@end
@interface RCTTimeRuler : UIView

@property (nonatomic, copy) RCTBubblingEventBlock onScrollling;
@property (nonatomic, copy) RCTBubblingEventBlock onScrollEnd;

@property(nonatomic,weak)id<RCTTimeRulerDelegate> delegate;

//滑动时是否改变textfield值
@property(nonatomic, assign)BOOL scrollByHand;

//背景颜色
@property(nonatomic,strong)UIColor *bgColor;

-(instancetype)initWithValues:(float)minValue theMaxValue:(float)maxValue theStep:(float)step theNum:(NSInteger)betweenNum theUnit:unit;

-(instancetype)initWithFrame:(CGRect)frame theMinValue:(float)minValue theMaxValue:(float)maxValue theStep:(float)step theNum:(NSInteger)betweenNum theUnit:unit;

-(void)setRealValue:(float)realValue animated:(BOOL)animated;

+(CGFloat)rulerViewHeight;

@end

