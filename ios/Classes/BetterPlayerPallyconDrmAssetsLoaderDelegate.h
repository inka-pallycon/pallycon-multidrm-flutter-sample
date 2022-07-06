// Copyright 2022 The InkaEntworks. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface BetterPlayerPallyconDrmAssetsLoaderDelegate : NSObject

@property(readonly, nonatomic) NSURL* certificateURL;
@property(readonly, nonatomic) NSURL* licenseURL;
@property(readonly, nonatomic) NSString* siteId;
@property(readonly, nonatomic) NSMutableDictionary* requestHeaders;

- (instancetype)init:(NSURL *)certificateURL withLicenseURL:(NSURL *)licenseURL
    withHeaders:(NSDictionary *)headers;

@end
