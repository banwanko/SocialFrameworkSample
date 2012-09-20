//
//  ViewController.m
//  SocialFrameworkSample
//
//  Created by 渡辺 龍司 on 2012/09/10.
//  Copyright (c) 2012年 Excite Co.,Ltd. All rights reserved.
//

#import "ViewController.h"
#import  <Social/Social.h>
#import <Twitter/TWTweetComposeViewController.h>


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *defaultTextView;
@property (weak, nonatomic) IBOutlet UIImageView *defaultImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *defaultImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *defaultImageView3;
@property (weak, nonatomic) IBOutlet UITextField *defaultURLTextField;

@end

@implementation ViewController {
    BOOL                    _isExistSocialFramework;
}

@synthesize defaultTextView     = _defaultTextView;
@synthesize defaultImageView1   = _defaultImageView1;
@synthesize defaultImageView2   = _defaultImageView2;
@synthesize defaultImageView3   = _defaultImageView3;
@synthesize defaultURLTextField = _defaultURLTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isExistSocialFramework = (NSClassFromString(@"SLComposeViewController") != nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)shareButtonAction:(UIButton*)button {
    // InterfaceBuilderでButtonのtagに1,2を設定しています。
    // 1はTwitterのボタン、2はFacebookのボタンです。
    if(_isExistSocialFramework) {
        NSString *service = button.tag == 1 ? SLServiceTypeTwitter : SLServiceTypeFacebook;
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:service];
        [vc addImage:_defaultImageView1.image];
        [vc addImage:_defaultImageView2.image];
        [vc addImage:_defaultImageView3.image];
        [vc setInitialText:_defaultTextView.text];
        [vc addURL:[NSURL URLWithString:_defaultURLTextField.text]];
        // イベントハンドラ定義
        vc.completionHandler = ^(SLComposeViewControllerResult res) {
            if (res == SLComposeViewControllerResultCancelled) {
                // Cancel
            }
            else if (res == SLComposeViewControllerResultDone) {
                // done!
            }
        };
        [self presentModalViewController:vc animated:YES];
    }
    else {
        // Social.frameworkがないので、自前で処理する
        if(button.tag == 1) {
            // Twitter  (ここではiOS5以降という前提)
            TWTweetComposeViewController *vc = [[TWTweetComposeViewController alloc] init];
            // 送信文字列を設定
            [vc addImage:_defaultImageView1.image];
            [vc addImage:_defaultImageView2.image];
            [vc addImage:_defaultImageView3.image];
            [vc addURL:[NSURL URLWithString:_defaultURLTextField.text]];
            [vc setInitialText:_defaultTextView.text];
            // イベントハンドラ定義
            vc.completionHandler = ^(TWTweetComposeViewControllerResult res) {
                if (res == TWTweetComposeViewControllerResultCancelled) {
                }
                else if (res == TWTweetComposeViewControllerResultDone) {
                }
            };
            // 送信View表示
            [self presentModalViewController:vc animated:YES];
        }
        else {
            // Facebook (省略)
        }
    }
}
@end
