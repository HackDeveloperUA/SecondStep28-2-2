//
//  vc2.m
//  SecondStep28
//
//  Created by MD on 19.06.15.
//  Copyright (c) 2015 hh. All rights reserved.
//

#import "vc2.h"

@interface vc2 ()

@end

@implementation vc2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scroller layoutIfNeeded];
    [self.scroller setScrollEnabled:YES];
    [self.scroller setContentSize:CGSizeMake(CGRectGetWidth(self.view.bounds), 800)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
