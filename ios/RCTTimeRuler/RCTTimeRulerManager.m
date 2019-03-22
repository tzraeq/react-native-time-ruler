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

RCT_EXPORT_VIEW_PROPERTY(startTime, NSDate);
RCT_EXPORT_VIEW_PROPERTY(endTime, NSDate);

RCT_EXPORT_VIEW_PROPERTY(time, double);
RCT_EXPORT_VIEW_PROPERTY(bgColor, UIColor);

//RCT_EXPORT_VIEW_PROPERTY(rulerStyle,NSDictionary);
RCT_EXPORT_VIEW_PROPERTY(rangeData,NSArray);

RCT_EXPORT_VIEW_PROPERTY(indicatorColor, UIColor);
RCT_EXPORT_VIEW_PROPERTY(indicatorWidth, float);
RCT_EXPORT_VIEW_PROPERTY(indicatorHeight, float);

RCT_EXPORT_VIEW_PROPERTY(tickColor, UIColor);
RCT_EXPORT_VIEW_PROPERTY(tickWidth, float);

RCT_EXPORT_VIEW_PROPERTY(longTickHeight, float);
RCT_EXPORT_VIEW_PROPERTY(mediumTickHeight, float);
RCT_EXPORT_VIEW_PROPERTY(shortTickHeight, float);

RCT_EXPORT_VIEW_PROPERTY(unitWidth, float);

RCT_EXPORT_VIEW_PROPERTY(onScrolling, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onScrollEnd, RCTBubblingEventBlock);

- (UIView *)view
{
    
    _noneZeroRullerView = [[RCTTimeRuler alloc]init];
    _noneZeroRullerView.delegate        = self;
    _noneZeroRullerView.scrollByHand    = YES;
    
    return _noneZeroRullerView;
}

#pragma RCTTimeRulerDelegate
-(void)trTimeRulerView:(RCTTimeRuler *)rulerView valueChange:(float)value{
    rulerView.onScrolling(@{@"value": @((int)value)});
}

-(void)trTimeRulerView:(RCTTimeRuler *)rulerView finalValue:(float)value{
    rulerView.onScrollEnd(@{@"value": @((int)value)});
}

@end
