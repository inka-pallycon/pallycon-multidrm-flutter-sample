# PallyCon Multi-DRM sample for Flutter Better Player

This sample code shows how to integrate PallyCon Multi-DRM with [Better Player](https://github.com/jhomlala/betterplayer) project. It supports streaming playback of DRM-protected contents as below.

 - Android: MPEG-DASH content protected by Widevine DRM
 - iOS: HLS content protected by FairPlay Streaming DRM

> If you want download/offline scenario support, you may need to implement the feature on your own or use our `Multi-DRM Client SDK for Flutter` product which is under development.

## Environments

This sample was tested with the below components and environments.

 - Flutter 3.0 or later
 - Better Player 0.0.82 or later

## Widevine DRM integration for Android

In terms of Widevine DRM support for Android app, PallyCon Multi-DRM is compatible with Better Player without any modification. You can simply replace the below values in Better Player example as described in [Better Player's DRM configuration guide](https://jhomlala.github.io/betterplayer/#/drmconfiguration).

  - Widevine content URL : Input your DASH mpd URL in `url` parameter
  - License server URL : Input our DRM license server URL (`https://license-global.pallycon.com/ri/licenseManager.do`)
  - DRM custom data : Input PallyCon DRM license token string as `pallycon-customdata-v2` custom header.

> Please refer to `drm_page.dart` source code in this sample for more details.

## FairPlay Streaming (FPS) DRM integration for iOS

Unlike the Widevine integration for Android, FPS integration for iOS requires modification of Better Player code and additional implementation to support PallyCon Multi-DRM. 

You may follow the below steps or refer to the source files in `ios > Classes` folder of this sample project.

### Modifying BetterPlayerPlugin.m file to get DRM headers

- Modify the line no. 309 to get drmHeaders value

    ```objectivec
    NSDictionary* headers = dataSource[@"headers"];
    **NSDictionary* drmHeaders = dataSource[@"drmHeaders"];**
    NSString* cacheKey = dataSource[@"cacheKey"];
    ```

- Modify the line no. 341 to pass the drmHeaders value to `BetterPlayer.h` ( also need to modify `BetterPlayer.h` to add `widthDrmheaders` parameter )

    ```objectivec
    if (drmHeaders != [NSNull null] || drmHeaders != NULL) {
        [player setDataSourceURL:[NSURL URLWithString:uriArg] withKey:key 
    					withCertificateUrl:certificateUrl withLicenseUrl: licenseUrl 
    					withHeaders:headers withDrmHeaders:drmHeaders 
    					withCache: useCache cacheKey:cacheKey cacheManager:_cacheManager 
    					overriddenDuration:overriddenDuration 
    					videoExtension: videoExtension];
    } else {
        [player setDataSourceURL:[NSURL URLWithString:uriArg] withKey:key 
    				withCertificateUrl:certificateUrl withLicenseUrl: licenseUrl 
    				withHeaders:headers withCache: useCache cacheKey:cacheKey 
    				cacheManager:_cacheManager overriddenDuration:overriddenDuration 
    				videoExtension: videoExtension];
    }
    ```

### Creating BetterPlayerPallyconDrmAssetsLoaderDelegate

The original Better Player project has `BetterPlayerEzDrmAssetsLoaderDelegate` which is for EZDRM integration. You need to add `BetterPlayerPallyconDrmAssetsLoaderDelegate` to support PallyCon Multi-DRM integration.

Please refer to the source files under `ios > Classes` folder of this sample.

### Modifying BetterPlayer

You need to modify `BetterPlayer.h` and `BetterPlayer.m` source codes to receive the `drmHeaders` value from `BetterPlayerPallyconDrmAssetsLoaderDelegate`.

 - `BetterPlayer.h` (overloading setDataSourceURL)
    
    ```objectivec
    @property(readonly, nonatomic) BetterPlayerPallyconDrmAssetsLoaderDelegate* pallyconLoaderDelegate;
    
    - (void)setDataSourceURL:(NSURL*)url withKey:(NSString*)key 
    		withCertificateUrl:(NSString*)certificateUrl 
    		withLicenseUrl:(NSString*)licenseUrl withHeaders:(NSDictionary*)headers 
    		withDrmHeaders:(NSDictionary*)drmHeaders withCache:(BOOL)useCache 
    		cacheKey:(NSString*)cacheKey cacheManager:(CacheManager*)cacheManager 
    		overriddenDuration:(int) overriddenDuration 
    		videoExtension: (NSString*) videoExtension;
    ```

 - `BetterPlayer.m`

    ```objectivec
    - (void)setDataSourceURL:(NSURL*)url withKey:(NSString*)key 
    		withCertificateUrl:(NSString*)certificateUrl 
    		withLicenseUrl:(NSString*)licenseUrl withHeaders:(NSDictionary*)headers 
    		withDrmHeaders:(NSDictionary*)drmHeaders withCache:(BOOL)useCache 
    		cacheKey:(NSString*)cacheKey cacheManager:(CacheManager*)cacheManager 
    		overriddenDuration:(int) overriddenDuration 
    		videoExtension: (NSString*) videoExtension
    {
        _overriddenDuration = 0;
            if (headers == [NSNull null] || headers == NULL){
                NSLog(@"header is null");
                headers = @{};
            }
    
            if (drmHeaders == [NSNull null] || drmHeaders == NULL){
                NSLog(@"drmHeader is null");
                drmHeaders = @{};
            }
    
            for (id key in drmHeaders) {
                NSLog(@"key: %@, value: %@ \n", key, [drmHeaders objectForKey:key]);
            }
    
            AVPlayerItem* item;
            if (useCache){
                if (cacheKey == [NSNull null]){
                    cacheKey = nil;
                }
                if (videoExtension == [NSNull null]){
                    videoExtension = nil;
                }
    
                item = [cacheManager getCachingPlayerItemForNormalPlayback:url cacheKey:cacheKey videoExtension: videoExtension headers:headers];
            } else {
                AVURLAsset* asset = [AVURLAsset URLAssetWithURL:url
                                                        options:@{@"AVURLAssetHTTPHeaderFieldsKey" : headers}];
                if (certificateUrl && certificateUrl != [NSNull null] && [certificateUrl length] > 0) {
                    NSURL * certificateNSURL = [[NSURL alloc] initWithString: certificateUrl];
                    NSURL * licenseNSURL = [[NSURL alloc] initWithString: licenseUrl];
                    _pallyconLoaderDelegate = [[BetterPlayerPallyconDrmAssetsLoaderDelegate alloc] init:certificateNSURL withLicenseURL:licenseNSURL withHeaders:drmHeaders];
                    dispatch_queue_attr_t qos = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_DEFAULT, -1);
                    dispatch_queue_t streamQueue = dispatch_queue_create("streamQueue", qos);
                    [asset.resourceLoader setDelegate:_pallyconLoaderDelegate queue:streamQueue];
                }
                item = [AVPlayerItem playerItemWithAsset:asset];
            }
    
            if (@available(iOS 10.0, *) && overriddenDuration > 0) {
                _overriddenDuration = overriddenDuration;
            }
            return [self setDataSourcePlayerItem:item withKey:key];
    }
    ```

## Useful links

- [PallyCon Multi-DRM Guide Documents](https://pallycon.com/docs/en/multidrm/)
- [PallyCon Multi-DRM License Token Guide](https://pallycon.com/docs/en/multidrm/license/license-token/)
- [FairPlay Certificate Registration Tutorial](https://pallycon.com/docs/en/multidrm/license/fps-cert-tutorial/)
- [License Token Generation on DevConsole](https://sample.pallycon.com/dev/devconsole/customData.do?lang=en#create-token)
- [Better Player Document](https://jhomlala.github.io/betterplayer/#/README)
