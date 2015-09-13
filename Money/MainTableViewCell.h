//
//  MainTableViewCell.h
//  Money
//
//  Created by Phuc Dang on 9/9/15.
//  Copyright (c) 2015 Cogini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Money.h"

@class MainTableViewCell;

@protocol MainTableViewCellDelegate <NSObject>

- (void)cell:(MainTableViewCell*)cell didUpdateMoney:(Money*)money;

@end

@interface MainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *currentMoneyLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLbl;

@property (weak, nonatomic) Money *money;

@property (nonatomic, assign) id<MainTableViewCellDelegate> delegate;

- (void) updateCell:(Money*)money;

+ (UINib*) nib;
+ (NSString*) cellIndentifier;
@end
