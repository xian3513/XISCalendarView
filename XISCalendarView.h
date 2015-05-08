//
//  XISCalendarView.h
//  date
//
//  Created by kt on 15/5/5.
//  Copyright (c) 2015年 kt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XISCalendarViewDelegate;
@protocol XISCalendarViewDataSource;

@interface XISWeekView : UIView

@end

@interface XISDayView : UIView
@property (nonatomic,strong) NSString *title;
@end


////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                              XISCalendarView                               //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

@interface XISCalendarView : UIView
@property (nonatomic,strong) UIColor *weekBackgroudColor;
@property (nonatomic,weak) id<XISCalendarViewDelegate>delegate;
@property (nonatomic,weak) id<XISCalendarViewDataSource>dataSource;
@property (nonatomic,readonly) NSInteger currentDayOfMonth;
- (NSDate *)current_Date;
@end

@protocol XISCalendarViewDelegate <NSObject>
- (void)XISCalendarView:(XISDayView *)currentDayView currentDate:(NSDate *)date;
@end
@protocol XISCalendarViewDataSource <NSObject>
- (XISDayView *)XISCalendarView:(XISCalendarView *)calendarView dayViewForDate:(NSInteger)date;
@end



/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////


@interface XISDateView : UIView
@property (nonatomic) NSInteger row;
@property (nonatomic) NSInteger currentDate;
@property (nonatomic) NSInteger weeklyOfFirstDay;
@property (nonatomic) NSInteger daysOfcurrentMonth;

- (id)initWithFrame:(CGRect)frame targate:(XISCalendarView *)targate;
- (void)show;
@end
