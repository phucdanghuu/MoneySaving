//
//  EUSelectorView.h
//  EasternUnion
//
//  Created by Gia on 9/14/13.
//  Copyright (c) 2013 opemoko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EUSelectorView;

@protocol EUSelectorViewDelegate <NSObject>
@optional
- (void)view:(EUSelectorView *)view didPressDone:(NSString *)selection index:(NSInteger)index;
-(void) view:(EUSelectorView *)view didPressCancel:(NSString *)selection index:(NSInteger)index;
- (void)view:(EUSelectorView *)view didChoose:(NSString *)selection index:(NSInteger)index;
- (void)view:(EUSelectorView *)view didChooseDate:(NSDate *)date;


@end

@interface EUSelectorView : UIView

@property (nonatomic,assign) id<EUSelectorViewDelegate> delegate;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePickerView;

- (id)initAsDatePicker:(UIView *)view mode:(UIDatePickerMode)mode;
- (id)initWithSelection:(NSArray *)array view:(UIView *)view;

- (void)refreshSelectionArray:(NSArray *)array;
- (void)setSelectedIndex:(NSInteger)index;

@end
