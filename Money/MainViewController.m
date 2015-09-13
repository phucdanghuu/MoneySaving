//
//  MainViewController.m
//  Money
//
//  Created by Phuc Dang on 9/9/15.
//  Copyright (c) 2015 Cogini. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import "Money.h"
#import "EUSelectorView.h"

@interface MainViewController () <EUSelectorViewDelegate, MainTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) NSMutableArray *arrMoney;
@property (strong, nonatomic) NSDate *startDate;
//@property (strong, nonatomic) NSArray *arrChecked;


@property (strong, nonatomic) EUSelectorView *datePicker;

@end

@implementation MainViewController

- (void)generateMoneyTable {
    NSArray *arrChecked = [self getExistedChecked];
    
    [self.arrMoney removeAllObjects];
    int total = 0;
    int step = 10;
    Money *money = nil;
    for (int i = 1; i <= 52; i++) {
        money = [Money new];
        money.stt = i;
        if (i == 1) {
            money.date = self.startDate;
        }else{
            money.date = [self.startDate dateByAddingTimeInterval:((7*(i-1)) * 24 * 3600)];
        }
        money.currentMoney = step * i;
        total += step*i;
        money.totalMoney = total;
        money.isChecked = (arrChecked == nil || arrChecked.count ==0)? NO : [arrChecked[i-1] boolValue];
        [self.arrMoney addObject:money];
    }
    [self.tableView reloadData];
}

- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateFormat];
    return [dateFormatter stringFromDate:date];
}

- (NSArray*)getExistedChecked{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *strDate = [self stringFromDate:self.startDate];
    NSArray *arr = [ud objectForKey:strDate];
    return arr;
}

- (void)saveValueToUserDefaults{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *strDate = [self stringFromDate:self.startDate];
    NSMutableArray *values = [NSMutableArray array];
    [self.arrMoney enumerateObjectsUsingBlock:^(Money *money, NSUInteger idx, BOOL *stop) {
        [values addObject:[NSNumber numberWithBool:money.isChecked]];
    }];
    [ud setObject:values forKey:strDate];
    [ud synchronize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Money+";
    [self.tableView registerNib:[MainTableViewCell nib] forCellReuseIdentifier:[MainTableViewCell cellIndentifier]];
    self.tableView.tableHeaderView = self.headerView;
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame = CGRectMake(0, 0, 30, 30);
    [settingBtn addTarget:self action:@selector(showDatePicker) forControlEvents:UIControlEventTouchUpInside];
    [settingBtn setImage:[UIImage imageNamed:@"button_setting"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    
//    UIButton *pigIcon = [UIButton buttonWithType:UIButtonTypeCustom];
//    pigIcon.frame = CGRectMake(0, 0, 40, 40);
//    pigIcon.userInteractionEnabled = NO;
//    [pigIcon setImage:[UIImage imageNamed:@"icon80"] forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:pigIcon];
//    
    
    self.datePicker = [[EUSelectorView alloc] initAsDatePicker:self.navigationController.view mode:UIDatePickerModeDate];
    self.datePicker.delegate = self;
    
    self.arrMoney = [NSMutableArray array];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDate *saveddate = [ud objectForKey:@"start_date"];
    if (saveddate) {
        self.startDate = saveddate;
    }else{
        NSString *dateString = @"2015-Aug-25";
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = kDateFormat;
        self.startDate = [dateFormatter dateFromString:dateString];
    }
    self.datePicker.datePickerView.date = self.startDate;
    [self generateMoneyTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showDatePicker{
    [self.navigationController.view addSubview:self.datePicker];
}

#pragma mark - UITableViewDelegate UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrMoney count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor whiteColor];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MainTableViewCell cellIndentifier]];
    Money *money = [self.arrMoney objectAtIndex:indexPath.row];
    cell.delegate = self;
    [cell updateCell:money];
    return cell;
}

#pragma mark - EUSelection
- (void)view:(EUSelectorView *)view didChooseDate:(NSDate *)date {
    [view removeFromSuperview];
    self.startDate = date;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:self.startDate forKey:@"start_date"];
    [ud synchronize];
    [self generateMoneyTable];
    
}
-(void) viewCancel:(EUSelectorView *)view{
    [view removeFromSuperview];
}

-(void) view:(EUSelectorView *)view didPressCancel:(NSString *)selection index:(NSInteger)index{
    [view removeFromSuperview];
}

#pragma mark - MainTableViewCellDelegate
- (void)cell:(MainTableViewCell *)cell didUpdateMoney:(Money *)money{
    [self.arrMoney enumerateObjectsUsingBlock:^(Money *currentMoney, NSUInteger idx, BOOL *stop) {
        if (currentMoney.stt == money.stt) {
            [self.arrMoney replaceObjectAtIndex:idx withObject:money];
            [self saveValueToUserDefaults];
            return;
        }
    }];
}


@end
