//
//  ServerConnection.h
//  ExeterDining
//
//  Created by Programming on 2016. 3. 8..
//  Copyright (c) 2016년 BrianBae. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "Dhall.h"

@interface ServerConnection : NSObject
-   (void) getMenu:(void (^)(NSInteger status, NSDictionary *wMenu, NSDictionary *eMenu, NSError *error))action;
-   (void) registerDev:(void (^)(NSInteger status, NSError *error))action token:(NSString *)token;
@end
