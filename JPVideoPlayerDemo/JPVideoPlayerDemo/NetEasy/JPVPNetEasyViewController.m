//
//  JPVideoPlayerNetEasyViewController.m
//  JPVideoPlayerDemo
//
//  Created by Memet on 2018/4/24.
//  Copyright © 2018 NewPan. All rights reserved.
//

#import "JPVPNetEasyViewController.h"
#import "JPVPNetEasyTableViewCell.h"
#import "JPVideoPlayerKit.h"

@interface JPVPNetEasyViewController ()<JPVideoPlayerDelegate, JPVPNetEasyTableViewCellDelegate>

/**
 * Arrary of video paths.
 * 播放路径数组集合.
 */
@property (nonatomic, strong, nonnull)NSArray *pathStrings;
@property (nonatomic, strong) JPVPNetEasyTableViewCell *playingCell;

@end

@implementation JPVPNetEasyViewController

#pragma mark -生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.playingCell) {
        [self.playingCell.videoPlayView jp_stopPlay];
    }
}

#pragma mark - TableViewDataSouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pathStrings.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 260;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = NSStringFromClass([JPVPNetEasyTableViewCell class]);
    JPVPNetEasyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.playButton.hidden = NO;
    return cell;
}

#pragma mark - JPVPNetEasyTableViewCellDelegate

- (void)cellPlayButtonDidClick:(JPVPNetEasyTableViewCell *)cell {
    if (self.playingCell) {
        [self.playingCell.videoPlayView jp_stopPlay];
        self.playingCell.playButton.hidden = NO;
    }
    self.playingCell = cell;
    self.playingCell.playButton.hidden = YES;
    self.playingCell.videoPlayView.jp_videoPlayerDelegate = self;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.playingCell.videoPlayView jp_playVideoWithURL:[NSURL URLWithString:self.pathStrings[indexPath.row]]
                                     bufferingIndicator:[JPVideoPlayerBufferingIndicator new]
                                            controlView:[[JPVideoPlayerControlView alloc] initWithControlBar:nil blurImage:nil]
                                           progressView:nil
                                configurationCompletion:nil];
}


#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"TableView Did Clicked IndexPath - %ld",indexPath.row);
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.playingCell) {
        return;
    }
    if (cell.hash == self.playingCell.hash) {
        [self.playingCell.videoPlayView jp_stopPlay];
        self.playingCell.playButton.hidden = NO;
        self.playingCell = nil;
    }
}


#pragma mark - Setup

- (void)setup {
    self.title = @"网易云音乐";
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JPVPNetEasyTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([JPVPNetEasyTableViewCell class])];
    // 本地视频播放.
    NSString *locVideoPath = [[NSBundle mainBundle]pathForResource:@"designedByAppleInCalifornia" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:locVideoPath];
    self.pathStrings = @[
            url.absoluteString,
            @"https://www.apple.com/105/media/cn/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-cn-20170912_1280x720h.mp4",
            @"https://static.smartisanos.cn/common/video/smartisan-tnt.mp4",
            @"https://static.smartisanos.cn/common/video/video-jgpro.mp4",
            @"https://static.smartisanos.cn/common/video/m1-coffee.mp4",
            @"https://static.smartisanos.cn/common/video/m1-white.mp4",
            @"https://static.smartisanos.cn/common/video/smartisanT2.mp4",
            @"https://static.smartisanos.cn/common/video/smartisant1.mp4 https://static.smartisanos.cn/common/video/ammounition-video.mp4",
            @"https://static.smartisanos.cn/common/video/t1-ui.mp4"
    ];
}

#pragma mark - JPVideoPlayerDelegate

- (BOOL)shouldShowBlackBackgroundWhenPlaybackStart {
    return YES;
}

- (BOOL)shouldShowBlackBackgroundBeforePlaybackStart {
    return YES;
}

- (BOOL)shouldAutoHideControlContainerViewWhenUserTapping {
    return YES;
}

- (BOOL)shouldShowDefaultControlAndIndicatorViews {
    return NO;
}

@end
