//
//  AdvertiseModel.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "AdvertiseModel.h"

@implementation AdvertiseModel

@end

@implementation TradeUserInfo

@end

@implementation UserStatistics


- (NSString *)goodCommentRate {
    
    if (self.beiHaoPingCount == 0) {
        
        return @"0%";
    }
    
    CGFloat rate = 100*self.beiHaoPingCount/(self.beiPingJiaCount*1.0);
    
    NSString *rateStr = [NSString stringWithFormat:@"%.0lf%%", rate];
    
    return rateStr;
}
@end
