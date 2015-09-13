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
    if (self.checkBtn.selected == YES) {
        [UIAlertView showWithTitle:@"Tính rút tiền khỏi heo à???"
                           message:nil
                 cancelButtonTitle:@"Dạ em không dám."
                 otherButtonTitles:nil
                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                              
                          }];
        return;
    }
    [UIAlertView showWithTitle:@"Em có chắc là đã bỏ tiền vào heo chưa???"
                       message:nil
             cancelButtonTitle:@"Để em kiểm tra lại!"
             otherButtonTitles:@[@"Dạ rồi!"]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if (buttonIndex == [alertView cancelButtonIndex]) {
                              NSLog(@"Cancelled");
                          } else if (buttonIndex == 1) {
                              self.checkBtn.selected = !self.checkBtn.selected;
                              self.money.isChecked = self.checkBtn.selected;
                              if ([self.delegate respondsToSelector:@selector(cell:didUpdateMoney:)]) {
                                  [self.delegate cell:self didUpdateMoney:self.money];
                              }
                          }
                      }];
}

- (void) updateCell:(Money*)money{
    self.money = money;
    self.orderLbl.text = [NSString stringWithFormat:@"%d",money.stt];
    self.currentMoneyLbl.text = [NSString stringWithFormat:@"%dk",money.currentMoney];
    self.totalMoneyLbl.text = [NSString stringWithFormat:@"%dk",money.totalMoney];
    self.dateLbl.text = [self getDateString:money.date];
    self.checkBtn.selected = money.isChecked;
}

- (NSString *)getDateString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM"];
    dateFormatter.locale = [NSLocale currentLocale];
    
    return [dateFormatter stringFromDate:date];
}

@end
