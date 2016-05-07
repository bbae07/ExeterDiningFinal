//
//  EDViewController.h
//  ExeterDining
//
//  Created by Programming on 2016. 3. 11..
//  Copyright (c) 2016년 BrianBae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerConnection.h"
#import "Dhall.h"
#import "SVProgressHUD.h"

@interface EDViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *dhallSelect;
@property (weak, nonatomic) IBOutlet UITableView *menuTable;
@property NSDictionary *wMenu;
@property NSDictionary *eMenu;
@property NSArray *restaurants;
@property NSMutableArray *wBreakfast;
@property NSMutableArray *wLunch;
@property NSMutableArray *wDinner;
@property NSMutableArray *eBreakfast;
@property NSMutableArray *eLunch;
@property NSMutableArray *eDinner;
@property NSMutableArray * Menus;

- (void)reloadDataFromNotification;
@end
