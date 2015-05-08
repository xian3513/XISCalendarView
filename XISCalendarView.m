//
//  XISCalendarView.m
//  date
//
//  Created by kt on 15/5/5.
//  Copyright (c) 2015年 kt. All rights reserved.
//

#import "XISCalendarView.h"

static NSInteger weekNumber = 7;

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                              XISWeekView                                   //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////


@implementation XISWeekView
- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor yellowColor];
        NSMutableArray *weekArray = [[NSMutableArray alloc]initWithObjects:@"Sun",@"Mon",@"Tues",@"Wed",@"Thur",@"Fri",@"Sat", nil];
        CGFloat width = frame.size.width/weekNumber;
        for(NSInteger i=0;i<weekArray.count;i++) {
            UILabel *weekLab = [[UILabel alloc]initWithFrame:CGRectMake(i*width, 0, width, frame.size.height)];
            weekLab.textAlignment = NSTextAlignmentCenter;
            weekLab.font = [UIFont systemFontOfSize:13];
            weekLab.text = [weekArray objectAtIndex:i];
            [self addSubview:weekLab];
        }
    }
    return self;
}
@end


////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                              XISDayView                                    //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

@implementation XISDayView {
    UILabel *titleLab;
}
- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLab];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
     titleLab.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
     [super setFrame:frame];
   
}
- (void)setTitle:(NSString *)title {
    _title = title;
    titleLab.text = title;
}

@end


////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                              XISDateView                                   //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////


@implementation XISDateView {
    NSMutableArray *daysArray;
    XISCalendarView *calendarView;
}
- (id)initWithFrame:(CGRect)frame targate:(XISCalendarView *)targate {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        calendarView = targate;
        daysArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

- (void)show {
    [self beginDraw];
}
- (void)beginDraw {
    if(self.row>0&&self.weeklyOfFirstDay>0&&self.daysOfcurrentMonth>0&&self.currentDate>0) {
        CGFloat height = self.frame.size.height/self.row;
        CGFloat width = self.frame.size.width/weekNumber;
        for(NSInteger i=0;i<self.row*weekNumber;i++) {
            NSInteger rowNumber = i/weekNumber;
            XISDayView *dayView = [[XISDayView alloc]initWithFrame:CGRectMake(i%weekNumber*width, rowNumber*height, width, height)];
            if (i<self.weeklyOfFirstDay-1) {
                              //上月
                    dayView.backgroundColor = [UIColor grayColor];
            }
            else if (i>=self.daysOfcurrentMonth+self.weeklyOfFirstDay-1) {
                                 //下月
                dayView.backgroundColor = [UIColor grayColor];
            }
            else {
                              //当前月
               
               //判断是否实现dataSource 自定义dayView
                XISDayView *tempDataSourceDayView = nil;
                if( [calendarView.dataSource respondsToSelector:@selector(XISCalendarView:dayViewForDate:)]) {
                   tempDataSourceDayView = [calendarView.dataSource XISCalendarView:calendarView dayViewForDate:i+1-self.weeklyOfFirstDay+1];
                }
                
                if(tempDataSourceDayView) {
                    tempDataSourceDayView.frame = dayView.frame;
                    dayView = tempDataSourceDayView;
                   if(!dayView.title) {
                      dayView.title = @"签到";
                   }
                }
                else {
                    dayView.title = [NSString stringWithFormat:@"%ld",i+2-self.weeklyOfFirstDay];
                }
               
                              //当前日
                if(i == self.currentDate+self.weeklyOfFirstDay-2) {
                    dayView.backgroundColor = [UIColor greenColor];
                   [self addTapGestureOnView:dayView];
                }
            }
            [self addSubview:dayView];
            [daysArray addObject:dayView];
        }
    }
}

/*
 *    添加点击事件
 */
- (void)addTapGestureOnView:(UIView *)view {
   UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(currentDatePress:)];
   tap.numberOfTapsRequired = 1;
   [view addGestureRecognizer:tap];
}

- (void)currentDatePress:(UITapGestureRecognizer *)tap {
    if([calendarView.delegate respondsToSelector:@selector(XISCalendarView:currentDate:)]) {
        [calendarView.delegate XISCalendarView:(XISDayView *)tap.view currentDate:[calendarView current_Date]];
    }
}

@end


////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                              XISCalendarView                               //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////


@implementation XISCalendarView {
    UIButton *lastMonth;
    UIButton *nextMonth;
    UILabel *dateLab;
    XISWeekView *weekView;
    XISDateView *dateView;
}
- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        CGFloat screenWidth = frame.size.width;
        CGFloat screenHeight = frame.size.height;
       _dayOfCurrentMonth = [self currentDate_day];
      //
        lastMonth = [self monthButtonsWith:@"上个月" frame:CGRectMake(screenWidth/12,0, screenWidth/6, 45)];
        nextMonth = [self monthButtonsWith:@"下个月" frame:CGRectMake(screenWidth-screenWidth/12-screenWidth/6,  lastMonth.frame.origin.y, screenWidth/6,lastMonth.frame.size.height)];
        
        dateLab = [[UILabel alloc]initWithFrame:CGRectMake(lastMonth.frame.origin.x+lastMonth.frame.size.width, lastMonth.frame.origin.y, screenWidth-(screenWidth/12*2+screenWidth/6*2), lastMonth.frame.size.height)];
        dateLab.textAlignment = NSTextAlignmentCenter;
        dateLab.text = [self currentDate_Y_M_D];
        [self addSubview:dateLab];
        //
        weekView = [[XISWeekView alloc]initWithFrame:CGRectMake(0, lastMonth.frame.origin.y+lastMonth.frame.size.height, screenWidth, lastMonth.frame.size.height)];
        [self addSubview:weekView];
        //
        dateView = [[XISDateView alloc]initWithFrame:CGRectMake(0, weekView.frame.origin.y+weekView.frame.size.height, screenWidth, screenHeight-(weekView.frame.origin.y+weekView.frame.size.height)) targate:self];
        dateView.row = [self numberOfRowInMonth];
        dateView.daysOfcurrentMonth = [self numberOfDaysInCurrentMonth];
        dateView.weeklyOfFirstDay = [self weeklyOrdinality];
         dateView.currentDate = [self currentDate_day];
        [self addSubview:dateView];
    }
//    NSLog(@"date:%ld",[self year]);
//    NSLog(@"date:%ld",[self month]);
//    NSLog(@"date:%ld",[self day]);
//    NSLog(@"date:%ld",[self numberOfDaysInCurrentMonth]);
//    NSLog(@"date:%ld",[self weeklyOrdinality]);
//     NSLog(@"date:%ld",[self numberOfRowInMonth]);
    return self;
}

- (void)setDelegate:(id<XISCalendarViewDelegate>)delegate {
    _delegate = delegate;
    [self show];
}
- (void)setDataSource:(id<XISCalendarViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self show];
}

- (void)show {
    if(self.delegate&&self.dataSource) {
        [dateView show];
    }
}
- (NSInteger)currentDate_day {
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"dd"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSLog(@"currentDate:%ld",[locationString integerValue]);
   return [locationString integerValue];
    
}

- (NSString *)currentDate_Y_M_D {
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
       return locationString ;
    
}

- (NSDate *)current_Date {//转换为东八区后的时间
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}

- (NSInteger)numberOfRowInMonth { //得到当月行数
    NSInteger allDays = [self numberOfDaysInCurrentMonth];
    NSInteger today = [self weeklyOrdinality];
    return ceilf((allDays-(7-today))/7.0)+1;
}
- (NSUInteger)weeklyOrdinality { //本月第一天是星期几
   NSDateComponents *_comps = [[NSDateComponents alloc] init];
   [_comps setDay:1];
   [_comps setMonth:[self month]];
   [_comps setYear:[self year]];
   NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
   NSDate *_date = [gregorian dateFromComponents:_comps];
   NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:_date];
   NSInteger _weekday = [weekdayComponents weekday];
   return _weekday;
}

- (NSUInteger)numberOfDaysInCurrentMonth  {  //一个月有多少天
    return [[NSCalendar currentCalendar]rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]].length;
}

-(NSInteger)year {
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitYear fromDate:[NSDate date]];
    return [components year];
}

-(NSInteger)month {
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitMonth fromDate:[NSDate date]];
    return [components month];
}

-(NSInteger)day {
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitDay fromDate:[NSDate date]];
    return [components day];
}

- (UIButton *)monthButtonsWith:(NSString *)title frame:(CGRect)frame {
    CGSize maxSize = CGSizeMake(80, 0);
    CGPoint point = frame.origin;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = (frame.size.width>maxSize.width?CGRectMake(point.x, point.y, maxSize.width, frame.size.height):frame);
    [button setFont:[UIFont systemFontOfSize:16]];
    [button setTitle:title forState:UIControlStateNormal];
    [self addSubview:button];
    return button;
}
@end

