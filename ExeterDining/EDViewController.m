//
//  EDViewController.m
//  ExeterDining
//
//  Created by Programming on 2016. 3. 11..
//  Copyright (c) 2016년 BrianBae. All rights reserved.
//

#import "EDViewController.h"
#import <Crashlytics/Crashlytics.h>
#import <Google/Analytics.h>

@interface EDViewController ()

@end

@implementation EDViewController{
    bool isFullBreakfast;
    bool isFullLunch;
    bool isFullDinner;
    
    NSMutableArray *fullMeals;
}
#define TAG_BUTTON_MORE 11011

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:[NSString stringWithFormat:@"PAGE_VIEW"]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self autoRefresh];
    [SVProgressHUD show];
    [_dhallSelect addTarget:self action:@selector(changeHall:) forControlEvents:UIControlEventValueChanged];
    _menuTable.dataSource = self;
    _menuTable.delegate = self;
    _menuTable.bounces = NO;
    isFullBreakfast = NO;
    isFullLunch = NO;
    isFullDinner = NO;
    fullMeals = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:isFullBreakfast], [NSNumber numberWithBool:isFullLunch],[NSNumber numberWithBool:isFullDinner], nil];
    ServerConnection *server = [[ServerConnection alloc] init];
    [server getMenu:^(NSInteger status, NSDictionary *wMenu, NSDictionary *eMenu, NSError *error) {
        _wMenu = [wMenu objectForKey:@"Wetherell"];
        if (!_wMenu) {
            
        }
        _eMenu = [eMenu objectForKey:@"Elm Street"];
        [self toWetherell];
        [_menuTable reloadData];
        [SVProgressHUD dismiss];
    }];
    [self toWetherell];
}

- (void)autoRefresh {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    UILocalNotification *alarm = [[UILocalNotification alloc] init];
    NSDate *now = [NSDate date];
    NSCalendar *curr = [NSCalendar currentCalendar];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Seoul"]];

    NSDate *startOfToday = [curr startOfDayForDate:now];
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    startOfToday = [curr dateByAddingComponents:dayComponent toDate:startOfToday options:0];
    [form setDateStyle:NSDateFormatterShortStyle];
    [form setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *currentTime = [formatter stringFromDate:now];
    NSString *midnight = [form stringFromDate:startOfToday];
    NSLog(@"%@",currentTime);
    NSLog(@"%@",midnight);
    
    alarm.fireDate = startOfToday;
//    // 알림 메시지 설정
//    alarm.alertBody = @"Just Do It";
//    
//    // 알림 액션 설정
//    alarm.alertAction = @"GOGO";
    [[UIApplication sharedApplication] scheduleLocalNotification:alarm];
}
- (void)reloadDataFromNotification{
    [SVProgressHUD show];
    [_dhallSelect addTarget:self action:@selector(changeHall:) forControlEvents:UIControlEventValueChanged];
    _menuTable.dataSource = self;
    _menuTable.delegate = self;
    _menuTable.bounces = NO;
    isFullBreakfast = NO;
    isFullLunch = NO;
    isFullDinner = NO;
    fullMeals = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:isFullBreakfast], [NSNumber numberWithBool:isFullLunch],[NSNumber numberWithBool:isFullDinner], nil];
    ServerConnection *server = [[ServerConnection alloc] init];
    [server getMenu:^(NSInteger status, NSDictionary *wMenu, NSDictionary *eMenu, NSError *error) {
        _wMenu = [wMenu objectForKey:@"Wetherell"];
        _eMenu = [eMenu objectForKey:@"Elm Street"];
        [self toWetherell];
        [_menuTable reloadData];
        [SVProgressHUD dismiss];
    }];
    [self toWetherell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeHall:(UISegmentedControl *)sender{
    for(int i = 0; i<[fullMeals count];i++)
    {
        fullMeals[i] = [NSNumber numberWithBool:NO];
    }
    switch ([sender selectedSegmentIndex]) {
        case 0:
            [self toWetherell];
            break;
            
        case 1:
            [self toElmStreet];
            break;
        default:
            break;
    }
}

- (void)toElmStreet{
    self.eBreakfast = [[NSMutableArray alloc] initWithObjects:@"No Menu", nil];
    self.eLunch = [[NSMutableArray alloc] initWithObjects:@"No Menu", nil];
    self.eDinner = [[NSMutableArray alloc] initWithObjects:@"No Menu", nil];
    if ([_eMenu objectForKey:@"breakfast"] != [NSNull null]) {
        self.eBreakfast = [[NSMutableArray alloc] initWithArray:([_eMenu objectForKey:@"breakfast"])];
    }
    if ([_eMenu objectForKey:@"lunch"] != [NSNull null]) {
        self.eLunch = [[NSMutableArray alloc] initWithArray:([_eMenu objectForKey:@"lunch"])];
    }
    if ([_eMenu objectForKey:@"dinner"] != [NSNull null]) {
        self.eDinner = [[NSMutableArray alloc] initWithArray:([_eMenu objectForKey:@"dinner"])];
    }
    self.Menus = [[NSMutableArray alloc] initWithObjects:_eBreakfast,_eLunch,_eDinner, nil];
    [_menuTable reloadData];
}

- (void)toWetherell{
    self.restaurants = [[NSArray alloc] initWithObjects: @"Breakfast",@"Lunch",@"Dinner", nil];
    self.wBreakfast = [[NSMutableArray alloc] initWithObjects:@"No Menu", nil];
    self.wLunch = [[NSMutableArray alloc] initWithObjects:@"No Menu", nil];
    self.wDinner = [[NSMutableArray alloc] initWithObjects:@"No Menu", nil];
    if ([_wMenu objectForKey:@"breakfast"] != [NSNull null]) {
        self.wBreakfast = [[NSMutableArray alloc] initWithArray:([_wMenu objectForKey:@"breakfast"])];
    }
    if ([_wMenu objectForKey:@"lunch"] != [NSNull null]) {
        self.wLunch = [[NSMutableArray alloc] initWithArray:([_wMenu objectForKey:@"lunch"])];
    }
    if ([_wMenu objectForKey:@"dinner"] != [NSNull null]) {
        self.wDinner = [[NSMutableArray alloc] initWithArray:([_wMenu objectForKey:@"dinner"])];
    }
    self.Menus = [[NSMutableArray alloc] initWithObjects:_wBreakfast,_wLunch,_wDinner, nil];
    [_menuTable reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *aView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    UILabel *sectionLabel =[[UILabel alloc] initWithFrame:CGRectMake(8, 2, aView.frame.size.width - 48, 40)];
    NSMutableArray *mealName = [[NSMutableArray alloc] initWithObjects:@"Breakfast",@"Lunch",@"Dinner", nil];
    [sectionLabel setText:[mealName objectAtIndex:section]];
    [sectionLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [aView setBackgroundColor: [UIColor colorWithRed:189.f/255 green:189.f/255 blue:189.f/255 alpha:0.8]];
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(sectionLabel.frame.size.width+8, 2, 40, 40)];
    UIImage *up = [UIImage imageNamed:@"up"];
    UIImage *down = [UIImage imageNamed:@"down"];
    if([[fullMeals objectAtIndex:section] boolValue])
    {
        [btn setImage:up forState:UIControlStateNormal];
    }
    else
    {
        [btn setImage:down forState:UIControlStateNormal];
    }
    if([[self.Menus objectAtIndex:section] count] <=3)
    {
        btn.enabled = NO;
    }
    [btn addTarget:self action:@selector(sectionTapped:) forControlEvents:UIControlEventTouchDown];
    //[btn setFrame:CGRectMake(8+sectionLabel.frame.size.width, 2, 40, 40)];
    [btn setTag:section+1];
    [aView addSubview:btn];
    [aView addSubview:sectionLabel];
    return aView;
}

- (IBAction)sectionTapped:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
            [fullMeals replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:![[fullMeals objectAtIndex:0] boolValue]]];
            break;
        case 2:
            [fullMeals replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:![[fullMeals objectAtIndex:1] boolValue]]];
            break;
        case 3:
            [fullMeals replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:![[fullMeals objectAtIndex:2] boolValue]]];
            break;
            
        default:
            break;
    }
    [_menuTable reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNumber = [[self.Menus objectAtIndex:section] count];
    if (rowNumber <= 3) {
        return rowNumber;
    }
    else {
        if ([[fullMeals objectAtIndex:section] boolValue]) {
            return rowNumber;
        }
        return 4;
    }
    return 0;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [self.restaurants objectAtIndex:section];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noMeaning"];
    NSMutableArray *restaurant = [self.Menus objectAtIndex:indexPath.section];
    NSString *menu = [restaurant objectAtIndex:indexPath.row];
    [cell.textLabel setText:menu];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 3 && ![[fullMeals objectAtIndex:indexPath.section] boolValue]) {
        [cell.textLabel setText:@"More..."];
        cell.tag = TAG_BUTTON_MORE;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *clickedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger mealNumber = indexPath.section + 1;
    if (clickedCell.tag == TAG_BUTTON_MORE) {
        UIButton *btnForMore = [[UIButton alloc] init];
        btnForMore.tag = mealNumber;
        [self sectionTapped:btnForMore];
    }
}

@end
