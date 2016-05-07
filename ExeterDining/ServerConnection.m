//
//  ServerConnection.m
//  ExeterDining
//
//  Created by Programming on 2016. 3. 8..
//  Copyright (c) 2016년 BrianBae. All rights reserved.
//

#import "ServerConnection.h"

@implementation ServerConnection
- (void) getMenu:(void (^)(NSInteger status, NSDictionary *wMenu, NSDictionary *eMenu, NSError *error))action
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://leekyungmoon.pythonanywhere.com/exeter/json" parameters:nil success:^(NSURLSessionDataTask * __nonnull task, id __nonnull responseObject)
    {
        NSDictionary *wMenu = [[responseObject objectForKey:@"Restaurants"] objectAtIndex:0];
        NSDictionary *eMenu = [[responseObject objectForKey:@"Restaurants"] objectAtIndex:1];
        NSInteger status = [[responseObject objectForKey:@"Status"] integerValue];
        action(status,wMenu,eMenu,nil);
        
        
    } failure:^(NSURLSessionDataTask * __nullable task, NSError * __nonnull responseObject) {
        action(1,nil,nil,nil);
    }];
}

-(void) registerDev:(void (^)(NSInteger status, NSError *error))action token:(NSString *)token
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *apnsToken = @{@"APNS_TOKEN":token};
    [manager POST:@"http://leekyungmoon.pythonanywhere.com/exeter/register" parameters:apnsToken success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSInteger status = [[responseObject objectForKey:@"RESULT"] integerValue];
        action(status,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        action(2,error);
    }];
}

@end
