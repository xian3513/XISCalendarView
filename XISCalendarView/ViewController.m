//
//  ViewController.m
//  date
//
//  Created by kt on 15/5/5.
//  Copyright (c) 2015年 kt. All rights reserved.
//

#import "ViewController.h"
#import "XISCalendarView.h"
@interface ViewController ()<XISCalendarViewDelegate,XISCalendarViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
   [super viewDidLoad];
   XISCalendarView *calendarView = [[XISCalendarView alloc]initWithFrame:CGRectMake(0, 20, 320, 300)];
   calendarView.backgroundColor = [UIColor grayColor];
   calendarView.delegate = self;
   calendarView.dataSource = self;
   [self.view addSubview:calendarView];
   
}

- (void)XISCalendarView:(XISDayView *)currentDayView currentDate:(NSDate *)date {
   NSLog(@"%@",date);
   currentDayView.title = @"签到";
}

- (XISDayView *)XISCalendarView:(XISCalendarView *)calendarView dayViewForDate:(NSInteger)date {
   XISDayView *cell = nil;
   if(date == 10) {
      cell = [[XISDayView alloc]init];
      cell.title = @"haha";
      cell.backgroundColor = [UIColor redColor];
       NSLog(@"currentDay:%ld",calendarView.dayOfCurrentMonth);
   }
  
  // NSLog(@"date:%ld",date);
   return cell;
}

- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}

@end
