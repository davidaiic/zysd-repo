//
//  BasicRefreshHeader.m
//  Basic
//
//  Created by wangteng on 2023/3/26.
//

#import "BasicRefreshHeader.h"
#import "DRPRefreshControl.h"
#import "DRPLoadingSpinner.h"

@interface BasicRefreshHeader ()

@property (strong) DRPLoadingSpinner *spinner;

@end

@implementation BasicRefreshHeader

- (void)prepare{
    [super prepare];
    self.spinner = [[DRPLoadingSpinner alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.spinner.rotationCycleDuration = 0.5;
    self.spinner.drawCycleDuration = .2;
    self.spinner.lineWidth = 2;
    self.spinner.colorSequence = @[[UIColor colorWithRed:94.0/255.0 green:204.0/255.0 blue:178.0/255.0 alpha:1]];
    self.spinner.maximumArcLength = M_PI / 3;
    self.spinner.minimumArcLength = M_PI / 3;
    self.spinner.backgroundRailColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    self.spinner.rotationDirection = DRPRotationDirectionClockwise;
    [self addSubview:self.spinner];
}

- (void)placeSubviews
{
    [super placeSubviews];
    self.spinner.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    self.lastUpdatedTimeLabel.hidden = true;
    self.stateLabel.font = [UIFont systemFontOfSize:13];
    self.stateLabel.textColor = [UIColor colorWithRed:94.0/255.0 green:204.0/255.0 blue:178.0/255.0 alpha:1];
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            [UIView animateWithDuration:self.slowAnimationDuration animations:^{
                self.spinner.alpha = 0.0;
            } completion:^(BOOL finished) {
                if (self.state != MJRefreshStateIdle) return;
                self.spinner.alpha = 1.0;
                [self.spinner stopAnimating];
                self.stateLabel.hidden = false;
            }];
        } else {
            [self.spinner stopAnimating];
            self.stateLabel.hidden = false;
        }
    } else if (state == MJRefreshStatePulling) {
        [self.spinner stopAnimating];
        self.stateLabel.hidden = false;
    } else if (state == MJRefreshStateRefreshing) {
        [self.spinner startAnimating];
        self.stateLabel.hidden = true;
    }
}

@end
