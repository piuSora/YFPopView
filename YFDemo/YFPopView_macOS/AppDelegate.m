//
//  AppDelegate.m
//  YFPopViewDemo
//
//  Created by OS on 2020/1/3.
//  Copyright © 2020 piu. All rights reserved.
//

#import "AppDelegate.h"
#import <Masonry/Masonry.h>
#import "YFPopView.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}
- (IBAction)showPopViewAction:(NSButton *)sender {
    sender.ignoresMultiClick = true;
    NSView *customView = [[NSView alloc]init];
    customView.wantsLayer = true;
    customView.layer.backgroundColor = NSColor.redColor.CGColor;
    YFPopView *popView = [[YFPopView alloc] initWithSubView:customView];
    popView.duration = 2;
    [customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 80));
        make.center.mas_equalTo(popView);
    }];
    NSView *onView = self.window.contentView;
    switch (sender.tag) {
        case 100:{//top to bottom
            popView.animationStyle = YFPopViewAnimationStyleTopToBottom;
            [popView showPopViewOn:onView];
        }
            break;
        case 200:{//bottom to top
            popView.animationStyle = YFPopViewAnimationStyleBottomToTop;
            [popView showPopViewOn:onView];
        }
            break;
        case 300:{//left to right
            popView.animationStyle = YFPopViewAnimationStyleLeftToRight;
            [popView showPopViewOn:onView];
        }
            break;
        case 400:{//right to left
            popView.animationStyle = YFPopViewAnimationStyleRightToLeft;
            [popView showPopViewOn:onView];
        }
            break;
        case 500:{//scale
            popView.animationStyle = YFPopViewAnimationStyleScale;
            [popView showPopViewOn:onView];
        }
            break;
        case 600:{//fade
            popView.animationStyle = YFPopViewAnimationStyleFade;
            [popView showPopViewOn:onView];
        }
            break;
        default:
            break;
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
