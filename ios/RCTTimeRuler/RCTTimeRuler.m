//
//  RCTTimeRuler.m
//  RCTTimeRuler
//
//  Created by shenhuniurou on 2018/5/11.
//  Copyright © 2018年 shenhuniurou. All rights reserved.
//

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif

#define ScreenWidth  ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight  ([[UIScreen mainScreen] bounds].size.height)

#define TextColorGrayAlpha 1.0 //文字的颜色灰度
#define TextRulerFont  [UIFont systemFontOfSize:11]
#define RulerLineColor [UIColor grayColor]

#define RulerGap        12 //单位距离
#define RulerLong       40
#define RulerShort      30
//#define TrangleWidth    16
#define CollectionHeight 70

#import "RCTTimeRuler.h"

typedef enum
{
    UnitAlignLeft,
    UnitAlignRight,
} UnitAlign;

/**
 *  绘制三角形标示
 */
@interface TRIndicatorView : UIView
@property(nonatomic,strong)UIColor *indicatorColor;

@end
@implementation TRIndicatorView

-(void)drawRect:(CGRect)rect{
    //设置背景颜色
    [[UIColor clearColor]set];
    
    UIRectFill([self bounds]);
    
    //拿到当前视图准备好的画板
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);//设置线的颜色，默认是黑色
    CGContextSetLineWidth(context, 2);//设置线的宽度，
    CGContextSetLineCap(context, kCGLineCapButt);
    
    //利用path路径进行绘制三角形
    //    CGContextBeginPath(context);//标记
    
    CGContextMoveToPoint(context, rect.size.width, 0);
    
    //    CGContextAddLineToPoint(context, TrangleWidth, 0);
    //
    //    CGContextAddLineToPoint(context, TrangleWidth/2.0, TrangleWidth/2.0);
    //    CGContextSetLineCap(context, kCGLineCapButt);//线结束时是否绘制端点，该属性不设置。有方形，圆形，自然结束3中设置
    //    CGContextSetLineJoin(context, kCGLineJoinBevel);//线交叉时设置缺角。有圆角，尖角，缺角3中设置
    //
    //    CGContextClosePath(context);//路径结束标志，不写默认封闭
    //
    //    [_indicatorColor setFill];//设置填充色
    //    [_indicatorColor setStroke];//设置边框色
    //
    //    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path，后属性表示填充
    
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);//开始绘制
}

@end


/***************TR************分************割************线***********/

@interface TRRulerView : UIView

@property (nonatomic,assign)NSInteger betweenNumber;
@property (nonatomic,assign)int minValue;
@property (nonatomic,assign)int maxValue;
@property (nonatomic,assign)float step;

@property (nonatomic,assign)UnitAlign align;
@property(nonatomic,assign)float unitWidth;
@property (nonatomic,assign)int hour;
@property(nonatomic,strong)UIColor *tickColor;
@property(nonatomic,assign)float tickWidth;
@property(nonatomic,assign)float longTickHeight;
@property(nonatomic,assign)float mediumTickHeight;
@property(nonatomic,assign)float shortTickHeight;
@property(nonatomic,assign)UIFont* timeFontSize;
@property(nonatomic,assign)UIColor* timeFontColor;
@property (nonatomic,assign)float level;

@end
@implementation TRRulerView

-(void)drawRect:(CGRect)rect{
    NSLog(@"hour: %d",_hour);
    
    CGFloat startX = 0;
    if(UnitAlignRight == _align){//右对齐
        startX = rect.size.width - _unitWidth;
    }
    int tickNum = 60;
    CGFloat gap = _unitWidth / tickNum;
    CGFloat shortLineY  = (rect.size.height - _shortTickHeight) / 2;
    CGFloat mediumLineY = (rect.size.height - _mediumTickHeight) / 2;
    CGFloat longLineY = (rect.size.height - _longTickHeight) / 2;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBStrokeColor(context, (float)192/255.0, (float)192/255.0, (float)192/255.0, 1.0);//设置线的颜色，默认是黑色
    CGContextSetStrokeColorWithColor(context, _tickColor.CGColor);
    CGContextSetLineWidth(context, _tickWidth);//设置线的宽度，
    CGContextSetLineCap(context, kCGLineCapButt);
    
    for (int i = 0; i <= tickNum; i++){
        float x = startX + gap * i;// - _tickWidth / 2;
        
        if (i%tickNum == 0){//long
            int hour = _hour;
            if(i == tickNum){
                hour = (hour + 1)%24;
            }
            [self drawText:rect :x :[NSString stringWithFormat:@"%02d:00", hour]];
            
            CGContextMoveToPoint(context, x, longLineY);
            CGContextAddLineToPoint(context, x, longLineY + _longTickHeight);
        }else if(i%10 == 0){//10 minutes
            [self drawText:rect :x :[NSString stringWithFormat:@"%02d:%d", _hour, i]];
            
            CGContextMoveToPoint(context, x, mediumLineY);
            CGContextAddLineToPoint(context, x, mediumLineY + _mediumTickHeight);
        }else if(i%5 == 0){//10 minutes
            CGContextMoveToPoint(context, x, mediumLineY);
            CGContextAddLineToPoint(context, x, mediumLineY + _mediumTickHeight);
        }else{
            CGContextMoveToPoint(context, x, shortLineY);
            CGContextAddLineToPoint(context, x, shortLineY + _shortTickHeight);
        }
        CGContextStrokePath(context);
    }
}

-(void)drawText:(CGRect)rect :(float)x :(NSString*)text{

    NSDictionary *attribute = @{NSFontAttributeName:_timeFontSize, NSForegroundColorAttributeName:_timeFontColor};
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size;
    float timeY = rect.size.height / 2 - 22.5 - size.height / 2;//0.45rem;
    [text drawInRect:CGRectMake(x-size.width/2, timeY, size.width, size.height) withAttributes:attribute];
}

@end


/***************TR************分************割************线***********/

@interface TRHeaderRulerView : UIView


@property(nonatomic,assign)float unitWidth;
@property (nonatomic,assign)int hour;
@property(nonatomic,strong)UIColor *tickColor;
@property(nonatomic,assign)float tickWidth;
@property(nonatomic,assign)float longTickHeight;
@property(nonatomic,assign)float mediumTickHeight;
@property(nonatomic,assign)float shortTickHeight;
@property(nonatomic,assign)UIFont* timeFontSize;
@property(nonatomic,assign)UIColor* timeFontColor;
@property (nonatomic,assign)float level;

@end

@implementation TRHeaderRulerView

/*-(void)drawRect:(CGRect)rect{

    CGFloat longLineY = rect.size.height - RulerShort;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, (float)192/255.0, (float)192/255.0,(float)192/255.0, 1.0);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineCap(context, kCGLineCapButt);
    
    CGContextMoveToPoint(context, rect.size.width, 0);
    
    NSString *num = [NSString stringWithFormat:@"%d", _minValue];
    
    NSDictionary *attribute = @{NSFontAttributeName:TextRulerFont,NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    CGFloat width = [num boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size.width;
    [num drawInRect:CGRectMake(rect.size.width-width/2, longLineY+10, width, 16) withAttributes:attribute];
    CGContextAddLineToPoint(context, rect.size.width, longLineY);
    CGContextStrokePath(context);//开始绘制
}*/
-(void)drawRect:(CGRect)rect{
    NSLog(@"hour: %d",_hour);
    
    CGFloat startX = rect.size.width - _unitWidth;
    int tickNum = 60;
    CGFloat gap = _unitWidth / tickNum;
    CGFloat shortLineY  = (rect.size.height - _shortTickHeight) / 2;
    CGFloat mediumLineY = (rect.size.height - _mediumTickHeight) / 2;
    CGFloat longLineY = (rect.size.height - _longTickHeight) / 2;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSetRGBStrokeColor(context, (float)192/255.0, (float)192/255.0, (float)192/255.0, 1.0);//设置线的颜色，默认是黑色
    CGContextSetStrokeColorWithColor(context, _tickColor.CGColor);
    CGContextSetLineWidth(context, _tickWidth);//设置线的宽度，
    CGContextSetLineCap(context, kCGLineCapButt);
    
    for (int i = 0; i <= tickNum; i++){
        float x = startX + gap * i;// - _tickWidth / 2;
        
        if (i%tickNum == 0){//long
            int hour = _hour;
            if(i == tickNum){
                hour = (hour + 1)%24;
            }
            [self drawText:rect :x :[NSString stringWithFormat:@"%02d:00", hour]];
            
            CGContextMoveToPoint(context, x, longLineY);
            CGContextAddLineToPoint(context, x, longLineY + _longTickHeight);
        }else if(i%10 == 0){//10 minutes
            [self drawText:rect :x :[NSString stringWithFormat:@"%02d:%d", _hour, i]];
            
            CGContextMoveToPoint(context, x, mediumLineY);
            CGContextAddLineToPoint(context, x, mediumLineY + _mediumTickHeight);
        }else if(i%5 == 0){//10 minutes
            CGContextMoveToPoint(context, x, mediumLineY);
            CGContextAddLineToPoint(context, x, mediumLineY + _mediumTickHeight);
        }else{
            CGContextMoveToPoint(context, x, shortLineY);
            CGContextAddLineToPoint(context, x, shortLineY + _shortTickHeight);
        }
        CGContextStrokePath(context);
    }
}

-(void)drawText:(CGRect)rect :(float)x :(NSString*)text{
    
    NSDictionary *attribute = @{NSFontAttributeName:_timeFontSize, NSForegroundColorAttributeName:_timeFontColor};
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size;
    float timeY = rect.size.height / 2 - 22.5 - size.height / 2;//0.45rem;
    [text drawInRect:CGRectMake(x-size.width/2, timeY, size.width, size.height) withAttributes:attribute];
}

@end




/***************TR************分************割************线***********/
@interface TRFooterRulerView : UIView

@property(nonatomic,assign)float unitWidth;
@property (nonatomic,assign)int hour;
@property(nonatomic,strong)UIColor *tickColor;
@property(nonatomic,assign)float tickWidth;
@property(nonatomic,assign)float longTickHeight;
@property(nonatomic,assign)float mediumTickHeight;
@property(nonatomic,assign)float shortTickHeight;
@property(nonatomic,assign)UIFont* timeFontSize;
@property(nonatomic,assign)UIColor* timeFontColor;
@property (nonatomic,assign)float level;
@end
@implementation TRFooterRulerView

-(void)drawRect:(CGRect)rect{
    NSLog(@"hour: %d",_hour);
    
    CGFloat startX = 0;
    int tickNum = 60;
    CGFloat gap = _unitWidth / tickNum;
    CGFloat shortLineY  = (rect.size.height - _shortTickHeight) / 2;
    CGFloat mediumLineY = (rect.size.height - _mediumTickHeight) / 2;
    CGFloat longLineY = (rect.size.height - _longTickHeight) / 2;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSetRGBStrokeColor(context, (float)192/255.0, (float)192/255.0, (float)192/255.0, 1.0);//设置线的颜色，默认是黑色
    CGContextSetStrokeColorWithColor(context, _tickColor.CGColor);
    CGContextSetLineWidth(context, _tickWidth);//设置线的宽度，
    CGContextSetLineCap(context, kCGLineCapButt);
    
    for (int i = 0; i <= tickNum; i++){
        float x = startX + gap * i;// - _tickWidth / 2;
        
        if (i%tickNum == 0){//long
            int hour = _hour;
            if(i == tickNum){
                hour = (hour + 1)%24;
            }
            [self drawText:rect :x :[NSString stringWithFormat:@"%02d:00", hour]];
            
            CGContextMoveToPoint(context, x, longLineY);
            CGContextAddLineToPoint(context, x, longLineY + _longTickHeight);
        }else if(i%10 == 0){//10 minutes
            [self drawText:rect :x :[NSString stringWithFormat:@"%02d:%d", _hour, i]];
            
            CGContextMoveToPoint(context, x, mediumLineY);
            CGContextAddLineToPoint(context, x, mediumLineY + _mediumTickHeight);
        }else if(i%5 == 0){//10 minutes
            CGContextMoveToPoint(context, x, mediumLineY);
            CGContextAddLineToPoint(context, x, mediumLineY + _mediumTickHeight);
        }else{
            CGContextMoveToPoint(context, x, shortLineY);
            CGContextAddLineToPoint(context, x, shortLineY + _shortTickHeight);
        }
        CGContextStrokePath(context);
    }
}

-(void)drawText:(CGRect)rect :(float)x :(NSString*)text{
    
    NSDictionary *attribute = @{NSFontAttributeName:_timeFontSize, NSForegroundColorAttributeName:_timeFontColor};
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size;
    float timeY = rect.size.height / 2 - 22.5 - size.height / 2;//0.45rem;
    [text drawInRect:CGRectMake(x-size.width/2, timeY, size.width, size.height) withAttributes:attribute];
}

@end

/***************TR************分************割************线***********/

@interface RCTTimeRuler()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    BOOL hasHeader;
    BOOL hasFooter;
    int hours;
    float headerWidth;
    float footerWidth;
    int startHour;
    float startHourOffset;
    float endHourOffset;
}


@property(nonatomic, strong)UICollectionView*collectionView;
@property(nonatomic, strong)TRIndicatorView  *indicator;
@property(nonatomic, assign)int           realValue;

@property(nonatomic, strong)NSDate*           startTime;
@property(nonatomic, strong)NSDate*           endTime;

@property(nonatomic,assign)int defaultValue;
@property(nonatomic,assign)int num;
@property(nonatomic,strong)UIColor *indicatorColor;
@property(nonatomic,assign)float indicatorHeight;
@property(nonatomic,assign)float indicatorWidth;
@property(nonatomic,strong)UIColor *tickColor;
@property(nonatomic,assign)float tickWidth;
@property(nonatomic,assign)float longTickHeight;
@property(nonatomic,assign)float mediumTickHeight;
@property(nonatomic,assign)float shortTickHeight;
@property(nonatomic,assign)float unitWidth;
@property(nonatomic,assign)UIFont *timeFontSize;
@property(nonatomic,strong)UIColor *timeFontColor;
@property(nonatomic,strong)NSArray *rangeData;
@end

@implementation RCTTimeRuler

- (instancetype)init {
    //1rem = 375/7.5=50;
    self = [super init];
    
    _indicatorColor          = [UIColor redColor];
    _indicatorWidth = 1;
    _indicatorHeight = 40;
    
    _bgColor = [UIColor clearColor];
    _tickColor          = [UIColor blackColor];
    _tickWidth         = 0.5;
    _longTickHeight         = 20; //0.4rem
    _mediumTickHeight       = 12.5; //0.25rem
    _shortTickHeight        = 6.5; //0.13rem
    _unitWidth              = 400; // 8rem
    
    _timeFontSize = [UIFont systemFontOfSize:12];//0.24rem
    _timeFontColor = [UIColor colorWithRed:0x88/255.0 green:0x88/255.0 blue:0x88/255.0 alpha:1];
    return self;
}

- (void)reactSetFrame:(CGRect)frame {
    NSLog(@"改变尺寸");
    [super reactSetFrame: frame];
    [self addSubViews];
}

- (void)addSubViews{
    [self addSubview:self.collectionView];
    [self addSubview:self.indicator];
    [self setDefaultValue:_defaultValue];
}

- (void)setTickColor:(UIColor*)tickColor{
    _tickColor = tickColor;
}

//- (void) setStartTime:(NSDate*)startTime {
//    _startTime = [[NSDate alloc]initWithTimeIntervalSince1970:startTime/1000.0];
//}
//
//- (void) setEndTime:(NSDate*)endTime {
//    _endTime = endTime;//[[NSDate alloc]initWithTimeIntervalSince1970:endTime/1000.0];
//}

- (void)setDefaultValue:(int)defaultValue {
    NSLog(@"设置默认值");
    _defaultValue      = defaultValue;
//    if (_maxValue != 0) {
//        [self setRealValue:defaultValue];
//        [_collectionView setContentOffset:CGPointMake(((defaultValue-_minValue)/(float)_step)*RulerGap, 0) animated:YES];
//    }
    NSLog(@"setDefaultValue被调用了，defaultValue=%d", defaultValue);
}

- (void) setRangeData:(NSArray*) rangeData{
    _rangeData = rangeData;
}

-(TRIndicatorView *)indicator{
    CGRect frame = CGRectMake(self.center.x - _indicatorWidth / 2, (self.bounds.size.height - _indicatorHeight) / 2, _indicatorWidth, _indicatorHeight);
    if (!_indicator) {
        //        _indicator = [[TRIndicatorView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2-0.5-TrangleWidth/2, CGRectGetMaxY(_valueLab.frame), TrangleWidth, TrangleWidth)];
        //        _indicator.backgroundColor   = [UIColor clearColor];
        //        _indicator.indicatorColor     = _indicatorColor;
        _indicator = [[TRIndicatorView alloc]initWithFrame:frame];
        _indicator.backgroundColor   = [UIColor clearColor];
        _indicator.indicatorColor     = _indicatorColor;
    }else{
        [_indicator setFrame:frame];
    }
    
    return _indicator;
}
-(UICollectionView *)collectionView{
    CGRect frame = self.bounds;
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        _collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = _bgColor;
        _collectionView.bounces         = YES;
        _collectionView.showsHorizontalScrollIndicator  = NO;
        _collectionView.showsVerticalScrollIndicator    = NO;
        _collectionView.dataSource      = self;
        _collectionView.delegate        = self;
//        _collectionView.contentInset    = UIEdgeInsetsMake(0, CGRectGetWidth(self.frame)/2.0, 0, CGRectGetWidth(self.frame)/2.0);
        float dataLen = _unitWidth * [_endTime timeIntervalSinceDate:_startTime] / 3600;
        float contentLen = dataLen;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = /*NSCalendarUnitYear | //年
                                NSCalendarUnitMonth | //月份
                                NSCalendarUnitDay | //日*/
                                NSCalendarUnitHour |  //小时
                                NSCalendarUnitMinute |  //分钟
                                NSCalendarUnitSecond;  // 秒
        NSDateComponents *sdc = [calendar components:unitFlags fromDate:_startTime];
        startHour = [sdc hour];
        NSInteger sec = [sdc minute] * 60 + [sdc second];
        startHourOffset = _unitWidth * sec / 3600.0;
        if(startHourOffset < self.bounds.size.width / 2){
            headerWidth = self.bounds.size.width / 2 - startHourOffset;
        }else{
            headerWidth = 0;
        }
        
        long stime = floor([_startTime timeIntervalSince1970] - sec);
        
        NSDateComponents *edc = [calendar components:unitFlags fromDate:_endTime];
        sec = [edc minute] * 60 + [edc second];
        endHourOffset = _unitWidth * sec / 3600.0;
        if((_unitWidth - endHourOffset) < self.bounds.size.width / 2){
            footerWidth = self.bounds.size.width / 2 - (_unitWidth - endHourOffset);
        }else{
            footerWidth = 0;
        }
        
        long etime = floor([_endTime timeIntervalSince1970] - sec);
        
        hours = 1 + (etime - stime) / 3600;
        
        
//        _collectionView.contentSize     = CGSizeMake(contentLen + headerWidth + footerWidth, self.bounds.size.height);//需要根据时间计算长度

        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"headCell"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"footerCell"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"custemCell"];
    }else{
        [_collectionView setFrame:frame];
    }
    return _collectionView;
}

-(void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    _collectionView.backgroundColor = _bgColor;
}
-(void)setIndicatorColor:(UIColor *)indicatorColor{
    _indicatorColor = indicatorColor;
    _indicator.indicatorColor = _indicatorColor;
}

-(float)getStartViewWidth{
    float diff = startHourOffset - self.bounds.size.width / 2;
    if(diff > 0){
        return _unitWidth - diff;
    }else{
        return _unitWidth;
    }
}

-(float)getEndViewWidth{
    float diff = (_unitWidth - endHourOffset) - self.bounds.size.width / 2;
    if(diff > 0){
        return _unitWidth - diff;
    }else{
        return _unitWidth;
    }
}

#pragma mark UICollectionViewDataSource & Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2 + hours;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == 0){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headCell" forIndexPath:indexPath];
        TRHeaderRulerView *view = [cell.contentView viewWithTag:1000];
        CGRect frame = CGRectMake(0, 0, headerWidth, self.bounds.size.height);
        if (!view){
            view = [[TRHeaderRulerView alloc]initWithFrame:frame];
            
            view.tag              =  1000;
            
            view.unitWidth = _unitWidth;
            view.tickColor = _tickColor;
            view.tickWidth = _tickWidth;
            view.longTickHeight = _longTickHeight;
            view.mediumTickHeight = _mediumTickHeight;
            view.shortTickHeight = _shortTickHeight;
            view.timeFontSize = _timeFontSize;
            view.timeFontColor = _timeFontColor;

            [cell.contentView addSubview:view];
        }else{
            [view setFrame:frame];
        }
        view.hour = (startHour - 1) % 24;
        view.backgroundColor  = _bgColor;
        
        return cell;
    }else if( indexPath.item == hours +1){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"footerCell" forIndexPath:indexPath];
        TRFooterRulerView *view = [cell.contentView viewWithTag:1001];
        if (!view){
            view = [[TRFooterRulerView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height)];
            
            view.tag              = 1001;
            
            view.unitWidth = _unitWidth;
            view.tickColor = _tickColor;
            view.tickWidth = _tickWidth;
            view.longTickHeight = _longTickHeight;
            view.mediumTickHeight = _mediumTickHeight;
            view.shortTickHeight = _shortTickHeight;
            view.timeFontSize = _timeFontSize;
            view.timeFontColor = _timeFontColor;

            [cell.contentView addSubview:view];
        }
        view.hour = (startHour + hours) % 24;
        view.backgroundColor  = _bgColor;
        
        return cell;
    }else{
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"custemCell" forIndexPath:indexPath];
        TRRulerView *view = [cell.contentView viewWithTag:1002];
        float width = _unitWidth;
        UnitAlign align = UnitAlignLeft;
        if(1 == indexPath.item){
            width = [self getStartViewWidth];
            align = UnitAlignRight;
        }else if(hours == indexPath.item){
            width = [self getEndViewWidth];
        }
        
        CGRect frame = CGRectMake(0, 0, width, self.bounds.size.height);
        if (!view){
            view  = [[TRRulerView alloc]initWithFrame:frame];
            view.tag               = 1002;
            
            view.align = align;
            view.unitWidth = _unitWidth;
            view.tickColor = _tickColor;
            view.tickWidth = _tickWidth;
            view.longTickHeight = _longTickHeight;
            view.mediumTickHeight = _mediumTickHeight;
            view.shortTickHeight = _shortTickHeight;
            view.timeFontSize = _timeFontSize;
            view.timeFontColor = _timeFontColor;
            [cell.contentView addSubview:view];
        }
        view.hour = (startHour + indexPath.item - 1) % 24;
        view.backgroundColor   =  _bgColor;

        [view setNeedsDisplay];
        
        return cell;
    }
}

-(CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float height = self.bounds.size.height;
    if (indexPath.item == 0){
        return CGSizeMake(headerWidth, height);
    }else if(indexPath.item == hours + 1){
        return CGSizeMake(footerWidth, height);
    }else if(indexPath.item == 1){//第一个有可能超出范围
        return CGSizeMake([self getStartViewWidth], height);
    }else if(indexPath.item == hours){//最后一个有可能超出范围
        return CGSizeMake([self getEndViewWidth], height);
    }else{
        return CGSizeMake(_unitWidth, height);
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}

#pragma mark -UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(trTimeRulerView:valueChange:)]) {
        [self.delegate trTimeRulerView:self valueChange:[self getTime:scrollView]];
    }
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{//拖拽时没有滑动动画
    if (!decelerate){
        [self onScrollEnd: scrollView];
//        [self setRealValue:round(scrollView.contentOffset.x/(RulerGap)) animated:YES];//吸附到一个位置
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    int value = scrollView.contentOffset.x/RulerGap;
//    [self setRealValue:round(value) animated:YES];//吸附到一个位置
    [self onScrollEnd: scrollView];
}

-(int)getTime:(UIScrollView *)scrollView{
    return scrollView.contentOffset.x;
}

-(void)onScrollEnd:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(trTimeRulerView:finalValue:)]) {
        [self.delegate trTimeRulerView:self finalValue:[self getTime:scrollView]];
    }
}

@end

