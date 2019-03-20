//
//  RCTTimeRulerManager.m
//  RCTTimeRuler
//
//  Created by Daniel on 2018/5/15.
//  Copyright © 2018年 Daniel. All rights reserved.
//

#import "RCTTimeRulerManager.h"
#import "RCTTimeRuler.h"
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import <React/UIView+React.h>

#define ScreenWidth  ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight  ([[UIScreen mainScreen] bounds].size.height)

@interface RCTTimeRulerManager() <RCTTimeRulerDelegate>

@property(nonatomic,strong)RCTTimeRuler *noneZeroRullerView;

@end

@implementation RCTTimeRulerManager

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(minValue, int);

RCT_EXPORT_VIEW_PROPERTY(maxValue, int);

RCT_EXPORT_VIEW_PROPERTY(step, float);

RCT_EXPORT_VIEW_PROPERTY(defaultValue, int);

RCT_EXPORT_VIEW_PROPERTY(num, int);

RCT_EXPORT_VIEW_PROPERTY(unit, NSString);

RCT_EXPORT_VIEW_PROPERTY(onSelect, RCTBubblingEventBlock)

- (UIView *)view
{
    
    CGFloat rullerHeight = [RCTTimeRuler rulerViewHeight];
    _noneZeroRullerView = [[RCTTimeRuler alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth-20, rullerHeight) theMinValue:0 theMaxValue:0  theStep:1.0 theNum:10 theUnit:@""];
    _noneZeroRullerView.bgColor = [UIColor whiteColor];
    _noneZeroRullerView.delegate        = self;
    _noneZeroRullerView.scrollByHand    = YES;
    
    return _noneZeroRullerView;
}

#pragma RCTTimeRulerDelegate
-(void)trTimeRulerView:(RCTTimeRuler *)rulerView valueChange:(float)value{
    rulerView.onSelect(@{@"value": @((int)value)});
}

@end
