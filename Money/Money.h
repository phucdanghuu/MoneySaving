//
//  Money.h
//  Money
//
//  Created by Phuc Dang on 9/11/15.
//  Copyright (c) 2015 Cogini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Money : NSObject
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) int currentMoney;
@property (nonatomic) int totalMoney;
@property (nonatomic) BOOL isChecked;
@property (nonatomic) int stt;

@end
