//
//  EDTableViewController.m
//  ExeterDining
//
//  Created by Programming on 2016. 1. 2..
//  Copyright (c) 2016년 BrianBae. All rights reserved.
//

#import "EDTableViewController.h"


@interface EDTableViewController ()

@end

@implementation EDTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD show];
    ServerConnection *server = [[ServerConnection alloc] init];
    [server getMenu:^(NSInteger status, NSDictionary *wMenu, NSDictionary *eMenu, NSError *error) {
        _wMenu = [wMenu objectForKey:@"Wetherell"];
        _eMenu = [eMenu objectForKey:@"Elm Street"];
        [self setServerData];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    }];
    [self setServerData];
}

- (void)setServerData{
    
    self.restaurants = [[NSArray alloc] initWithObjects: @"Wetherell",@"Elm Street", nil];
    self.WetherellMenus = [[NSMutableArray alloc] initWithArray:([_wMenu objectForKey:@"breakfast"])];
    self.ElmMenus = [[NSMutableArray alloc] initWithArray:([_eMenu objectForKey:@"breakfast"])];
    self.Menus = [[NSArray alloc] initWithObjects:_WetherellMenus,_ElmMenus, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNumber = [[self.Menus objectAtIndex:section] count];
    return rowNumber;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.restaurants objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noMeaning"];
    NSMutableArray *restaurant = [self.Menus objectAtIndex:indexPath.section];
    NSString *menu = [restaurant objectAtIndex:indexPath.row];
    [cell.textLabel setText:menu];
    
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
