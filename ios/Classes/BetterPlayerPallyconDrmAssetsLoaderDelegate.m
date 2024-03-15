// Copyright 2022 InkaEntworks.

#import "BetterPlayerPallyconDrmAssetsLoaderDelegate.h"

@implementation BetterPlayerPallyconDrmAssetsLoaderDelegate

//PallyCon DRM
NSString * DEFAULT_PALLYCON_LICENSE_SERVER_URL = @"https://license-global.pallycon.com/ri/licenseManager.do";

- (instancetype)init:(NSURL *)certificateURL withLicenseURL:(NSURL *)licenseURL
    withHeaders:(NSDictionary *)headers{

    self = [super init];
    _certificateURL = certificateURL;
    _licenseURL = licenseURL;
    _requestHeaders = [[NSMutableDictionary alloc] init];

    for(id key in headers) {
        if ([key isEqualToString:@"siteId"]) {
            _siteId = [NSString stringWithString:headers[key]];
        } else {
            [_requestHeaders setObject:headers[key] forKey:key];
        }
    }

    return self;
}

/*------------------------------------------
 **
 ** getContentLicense
 **
 ** ---------------------------------------*/
- (NSData *)getContentLicense:(NSData*)requestBytes and:(NSDictionary *)headers and:(NSError *)errorOut {
    NSData * decodedData;
    NSURLResponse * response;

    NSURL * finalLicenseURL;
    if ([_licenseURL checkResourceIsReachableAndReturnError:nil] == NO) {
        finalLicenseURL = _licenseURL;
    } else {
        finalLicenseURL = [[NSURL alloc] initWithString: DEFAULT_PALLYCON_LICENSE_SERVER_URL];
    }
    
    NSURL * requestURL = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"%@", finalLicenseURL]];
    NSString * pallyConSpc = [NSString stringWithFormat:@"spc=%@", [requestBytes base64EncodedStringWithOptions:0]];
    NSData * data = [pallyConSpc dataUsingEncoding:NSUTF8StringEncoding];

    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];

    for (NSString* key in headers) {
        [request setValue:headers[key] forHTTPHeaderField:key];
    }

    @try {
        NSData * data = [self sendSynchronousRequest:request returningResponse:&response error:nil];
        decodedData = [[NSData alloc] initWithBase64EncodedData:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    @catch (NSException* excp) {
        NSLog(@"SDK Error, SDK responded with Error: (error)");
    }
    
    [self checkPallyConServerError:data];

    return decodedData;
}

/*------------------------------------------
 **
 ** getAppCertificate
 **
 ** ---------------------------------------*/
- (NSData *)getAppCertificate:(NSString *)siteId {
    NSData * certificate = nil;
    NSURLResponse * response;
    NSURL * requestURL = nil;
   
    NSString *urlString = [_certificateURL absoluteString];
    NSRange range = [urlString rangeOfString:@"siteId="];

    // 특정 문자를 찾았는지 확인
    if (range.location != NSNotFound) {
        requestURL = _certificateURL;
    } else {
        requestURL = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"%@?siteId=%@", _certificateURL , siteId]];
    }

    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    [request setHTTPMethod:@"POST"];
    
    @try {
        NSData * cert = [self sendSynchronousRequest:request returningResponse:&response error:nil];
        certificate = [[NSData alloc] initWithBase64EncodedData:cert options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    @catch (NSException* e) {
        NSLog(@"SDK Error, SDK responded with Error: (error)");
    }
    
    [self checkPallyConServerError:certificate];
    
    return certificate;
}

- (Boolean)checkPallyConServerError:(NSData *)response {
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response
                                                         options:kNilOptions
                                                           error:&error];
    if (error) {
        return true;
    }
    
    if (json[@"errorCode"] && json[@"message"]) {
        NSLog(@"errorCode = %@, messsage = %@", json[@"errorCode"], json[@"message"]);
        return false;
    }
    
    return true;
}

- (NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error
{
    NSError __block *err = NULL;
    NSData __block *data;
    BOOL __block reqProcessed = false;
    NSURLResponse __block *resp;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable _data, NSURLResponse * _Nullable _response, NSError * _Nullable _error) {
            resp = _response;
            err = _error;
            data = _data;
            reqProcessed = true;
            dispatch_semaphore_signal(semaphore);
        }] resume];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    if (response != nil)
        *response = resp;
    if (error != nil)
        *error = err;
    
    return data;
}

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    NSURL *assetURI = loadingRequest.request.URL;
    
    NSString * fullAssetID = assetURI.absoluteString;
    NSData * assetIDData = [fullAssetID dataUsingEncoding:NSUTF8StringEncoding];

    NSString * scheme = assetURI.scheme;
    NSData * requestBytes;
    NSData * certificate;
    if (!([scheme isEqualToString: @"skd"])){
        return NO;
    }
    @try {
        certificate = [self getAppCertificate:_siteId];
    }
    @catch (NSException* excp) {
        [loadingRequest finishLoadingWithError:[[NSError alloc] initWithDomain:NSURLErrorDomain code:NSURLErrorClientCertificateRejected userInfo:nil]];
    }

    @try {
        requestBytes = [loadingRequest streamingContentKeyRequestDataForApp:certificate contentIdentifier: assetIDData options:nil error:nil];
    }
    @catch (NSException* excp) {
        [loadingRequest finishLoadingWithError:nil];
        return YES;
    }

    NSData * responseData;
    NSError * error;

    responseData = [self getContentLicense:requestBytes and:_requestHeaders and:error];

    if (responseData != nil && responseData != NULL && ![responseData.class isKindOfClass:NSNull.class]){
        AVAssetResourceLoadingDataRequest * dataRequest = loadingRequest.dataRequest;
        [dataRequest respondWithData:responseData];
        [loadingRequest finishLoading];
    } else {
        [loadingRequest finishLoadingWithError:error];
    }

    return YES;
}

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForRenewalOfRequestedResource:(AVAssetResourceRenewalRequest *)renewalRequest {
    return [self resourceLoader:resourceLoader shouldWaitForLoadingOfRequestedResource:renewalRequest];
}

@end
