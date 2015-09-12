//
//  MainTableViewCell.m
//  Money
//
//  Created by Phuc Dang on 9/9/15.
//  Copyright (c) 2015 Cogini. All rights reserved.
//

#import "MainTableViewCell.h"

@implementation MainTableViewCell
+ (UINib*) nib {
    return [UINib nibWithNibName:@"MainTableViewCell" bundle:nil];
}

+ (NSString*) cellIndentifier {
    return @"MainTableViewCell";
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)checkBtnPressed:(id)sender {
    self.checkBtn.selected = !self.checkBtn.selected;
}

- (void) updateCell:(Money*)money{
    self.orderLbl.text = [NSString stringWithFormat:@"%d",money.stt];
    self.currentMoneyLbl.text = [NSString stringWithFormat:@"%dk",money.currentMoney];
    self.totalMoneyLbl.text = [NSString stringWithFormat:@"%dk",money.totalMoney];
    self.dateLbl.text = [self getDateString:money.date];
}

- (NSString *)getDateString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM"];
    dateFormatter.locale = [NSLocale currentLocale];
    
    return [dateFormatter stringFromDate:date];
}

@end
