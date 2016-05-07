//
//  EDTableViewController.h
//  ExeterDining
//
//  Created by Programming on 2016. 1. 2..
//  Copyright (c) 2016년 BrianBae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerConnection.h"
#import "Dhall.h"
#import "SVProgressHUD.h"

@interface EDTableViewController : UITableViewController
@property NSDictionary *wMenu;
@property NSDictionary *eMenu;
@property NSArray *restaurants;
@property NSMutableArray *WetherellMenus;
@property NSMutableArray *ElmMenus;
@property NSArray * Menus;

@end
