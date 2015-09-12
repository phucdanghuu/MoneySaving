//
//  EUSelectorView.m
//  EasternUnion
//
//  Created by Gia on 9/14/13.
//  Copyright (c) 2013 opemoko. All rights reserved.
//

#import "EUSelectorView.h"

@interface EUSelectorView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) NSArray *selections;
@property (nonatomic, strong) UIView *viewContainer;


@end

@implementation EUSelectorView

- (id)initWithView:(UIView *)view{
    self = [super initWithFrame:view.frame];
    if (self) {
        self.viewContainer = [[UIView alloc] initWithFrame:self.frame];
        self.viewContainer.backgroundColor = [UIColor blackColor] ;
        self.viewContainer.alpha = 0.5f;
        self.viewContainer.userInteractionEnabled = NO;
        self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [GDUtils screenSize].width, 44)];
        self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
        UIBarButtonItem *flexibleBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *setBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(tap:)];
        [self.toolbar setItems:@[cancelBtn,flexibleBtn,setBtn]];
        [self addSubview:self.viewContainer];
        [self addSubview:self.toolbar];
    }
    return self;
}

/** Fix issue: https://trello.com/c/sdFeiMXH/169-modify-tabs-content-on-leads-page
  * If user click "Done" while scrolling. The bug is happen.
  * Solution: force DatePicker scroll to current selected date.
  * Since, If we set date is current selected date, it's not effect. So, work-around is set date to Now, then set date to selected date.
 */
- (void) willMoveToSuperview:(UIView *)newSuperview {
    NSDate *date = self.datePickerView.date;
    [self.datePickerView setDate:[NSDate date] animated:NO];
    [self.datePickerView setDate:date animated:NO];
}

- (id)initAsDatePicker:(UIView *)view mode:(UIDatePickerMode)mode{
    self = [self initWithView:view];
    if (self) {
        self.datePickerView = [[UIDatePicker alloc] init];
        self.datePickerView.datePickerMode = mode;
        self.datePickerView.frame = CGRectSetY(self.datePickerView.frame,view.frame.size.height-216);
        self.datePickerView.frame = CGRectSetWidth(self.datePickerView.frame, view.frame.size.width);
        [self addSubview:self.datePickerView];
        self.datePickerView.backgroundColor = [UIColor whiteColor];
        self.datePickerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
        self.toolbar.frame = CGRectSetWidth(self.toolbar.frame, view.frame.size.width);
        self.toolbar.frame = CGRectSetY(self.toolbar.frame,self.datePickerView.frame.origin.y-self.toolbar.frame.size.height);
    }
    return self;
}

- (id)initWithSelection:(NSArray *)array view:(UIView *)view{
    self = [self initWithView:view];
    if (self) {
        self.selections = array;
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 216)];
        self.pickerView.frame = CGRectSetWidth(self.datePickerView.frame, view.frame.size.width);
        self.pickerView.backgroundColor = [UIColor whiteColor];
        self.pickerView.frame = CGRectSetOrigin(self.pickerView.frame,CGPointMake(0, view.frame.size.height-216));
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.showsSelectionIndicator = YES;
        [self addSubview:self.pickerView];
        self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
        self.toolbar.frame = CGRectSetWidth(self.toolbar.frame, view.frame.size.width);
        self.toolbar.frame = CGRectSetY(self.toolbar.frame,self.pickerView.frame.origin.y-self.toolbar.frame.size.height);
        
    }
    return self;
}


- (void)setSelectedIndex:(NSInteger)index{
    if (index < [self.pickerView numberOfRowsInComponent:0]) {
        [self.pickerView selectRow:index inComponent:0 animated:NO];
    }
}


- (void)refreshSelectionArray:(NSArray *)array{
    if (self.pickerView) {
        self.selections = array;
        [self.pickerView reloadAllComponents];
    }else{
        // do nothing since this is date selection
    }
}

- (void)tap:(id)sender{
    if (self.pickerView) {
        if ([self.delegate respondsToSelector:@selector(view:didPressDone:index:)]) {
            if ([self.pickerView selectedRowInComponent:0]==-1||
                [self.pickerView selectedRowInComponent:0] >= self.selections.count) {
                
                [self.delegate view:self didPressDone:@"" index:-1];
            }else{
                [self.delegate view:self didPressDone:self.selections[[self.pickerView selectedRowInComponent:0]] index:[self.pickerView selectedRowInComponent:0]];
            }
        }
    }else if(self.datePickerView){
        if ([self.delegate respondsToSelector:@selector(view:didChooseDate:)]) {
            [self.delegate view:self didChooseDate:self.datePickerView.date];
        }
    }
}

- (void)cancel:(id)sender{
    if ([self.delegate respondsToSelector:@selector(view:didPressCancel:index:)]) {
        [self.delegate view:self didPressCancel:@"" index:-1];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([self.delegate respondsToSelector:@selector(view:didChoose:index:)]){
        [self.delegate view:self didChoose:self.selections[row] index:[self.pickerView selectedRowInComponent:component]];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.selections[row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.selections.count;
}




@end
