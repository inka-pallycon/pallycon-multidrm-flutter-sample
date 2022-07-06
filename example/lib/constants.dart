class Constants {
  static const String bugBuckBunnyVideoUrl =
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
  static const String forBiggerBlazesUrl =
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4";
  static const String fileTestVideoUrl = "testvideo.mp4";
  static const String fileTestVideoEncryptUrl = "testvideo_encrypt.mp4";
  static const String networkTestVideoEncryptUrl =
      "https://github.com/tinusneethling/betterplayer/raw/ClearKeySupport/example/assets/testvideo_encrypt.mp4";
  static const String fileExampleSubtitlesUrl = "example_subtitles.srt";
  static const String hlsTestStreamUrl =
      "https://mtoczko.github.io/hls-test-streams/test-group/playlist.m3u8";
  static const String hlsPlaylistUrl =
      "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8";
  static const Map<String, String> exampleResolutionsUrls = {
    "LOW":
        "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4",
    "MEDIUM":
        "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_640_3MG.mp4",
    "LARGE":
        "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_1280_10MG.mp4",
    "EXTRA_LARGE":
        "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_1920_18MG.mp4"
  };
  static const String phantomVideoUrl =
      "http://sample.vodobox.com/skate_phantom_flex_4k/skate_phantom_flex_4k.m3u8";
  static const String elephantDreamVideoUrl =
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4";
  static const String forBiggerJoyridesVideoUrl =
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4";
  static const String verticalVideoUrl =
      "http://www.exit109.com/~dnn/clips/RW20seconds_1.mp4";
  static String logo = "logo.png";
  static String placeholderUrl =
      "https://imgix.bustle.com/uploads/image/2020/8/5/23905b9c-6b8c-47fa-bc0f-434de1d7e9bf-avengers-5.jpg";
  static String elephantDreamStreamUrl =
      "http://cdn.theoplayer.com/video/elephants-dream/playlist.m3u8";
  static String tokenEncodedHlsUrl =
      "https://amssamples.streaming.mediaservices.windows.net/830584f8-f0c8-4e41-968b-6538b9380aa5/TearsOfSteelTeaser.ism/manifest(format=m3u8-aapl)";
  static String tokenEncodedHlsToken =
      "Bearer=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1cm46bWljcm9zb2Z0OmF6dXJlOm1lZGlhc2VydmljZXM6Y29udGVudGtleWlkZW50aWZpZXIiOiI5ZGRhMGJjYy01NmZiLTQxNDMtOWQzMi0zYWI5Y2M2ZWE4MGIiLCJpc3MiOiJodHRwOi8vdGVzdGFjcy5jb20vIiwiYXVkIjoidXJuOnRlc3QiLCJleHAiOjE3MTA4MDczODl9.lJXm5hmkp5ArRIAHqVJGefW2bcTzd91iZphoKDwa6w8";
  static String widevineVideoUrl =
      "https://storage.googleapis.com/wvmedia/cenc/h264/tears/tears_sd.mpd";
  static String widevineLicenseUrl =
      "https://proxy.uat.widevine.com/proxy?provider=widevine_test";
  static String fairplayHlsUrl =
      "https://fps.ezdrm.com/demo/hls/BigBuckBunny_320x180.m3u8";
  static String fairplayCertificateUrl =
      "https://github.com/koldo92/betterplayer/raw/fairplay_ezdrm/example/assets/eleisure.cer";
  static String fairplayLicenseUrl = "https://fps.ezdrm.com/api/licenses/";
  static String catImageUrl =
      "https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/other/cat_relaxing_on_patio_other/1800x1200_cat_relaxing_on_patio_other.jpg";
  static String dashStreamUrl =
      "https://bitmovin-a.akamaihd.net/content/sintel/sintel.mpd";
  static String segmentedSubtitlesHlsUrl =
      "https://eng-demo.cablecast.tv/segmented-captions/vod.m3u8";
  static String InkaDashContents =
      "https://contents.pallycon.com/DEMO/app/big_buck_bunny/dash/stream.mpd";
  static String InkaHlsContents =
      "https://contents.pallycon.com/TEST/PACKAGED_CONTENT/TEST_SIMPLE/hls/master.m3u8";
  static String InkaLicenseUrl =
      "https://license-global.pallycon.com/ri/licenseManager.do";
  static String InkaCertUrl =
      "https://license.pallycon.com/ri/fpsKeyManager.do";
  static String InkaDashCustomData =
      "eyJkcm1fdHlwZSI6IldpZGV2aW5lIiwic2l0ZV9pZCI6IkRFTU8iLCJ1c2VyX2lkIjoidGVzdFVzZXIiLCJjaWQiOiJkZW1vLWJiYi1zaW1wbGUiLCJwb2xpY3kiOiI5V3FJV2tkaHB4VkdLOFBTSVljbkp1dUNXTmlOK240S1ZqaTNpcEhIcDlFcTdITk9uYlh6QS9pdTdSa0Vwbk85c0YrSjR6R000ZkdCMzVnTGVORGNHYWdPY1Q4Ykh5c3k0ZHhSY2hYV2tUcDVLdXFlT0ljVFFzM2E3VXBnVVdTUCIsInJlc3BvbnNlX2Zvcm1hdCI6Im9yaWdpbmFsIiwia2V5X3JvdGF0aW9uIjpmYWxzZSwidGltZXN0YW1wIjoiMjAyMi0wNi0xOVQyMzo0NjoyOFoiLCJoYXNoIjoid3dWSFVhNnRNT1BUUmZmNkRWZUVua0Z0cWMvMkJPRkpGUzU1aE5iNkp2ND0ifQ==";
  static String InkaHlsCustomData =
      "eyJrZXlfcm90YXRpb24iOmZhbHNlLCJyZXNwb25zZV9mb3JtYXQiOiJvcmlnaW5hbCIsInVzZXJfaWQiOiJ1dGVzdCIsImRybV90eXBlIjoiZmFpcnBsYXkiLCJzaXRlX2lkIjoiREVNTyIsImhhc2giOiJHOXRub25WaU0zUHZEeUpVaVMycmxJUWhqN3VcL2xGc3dQNThhejB0c3AyTT0iLCJjaWQiOiJUZXN0UnVubmVyIiwicG9saWN5IjoiOVdxSVdrZGhweFZHSzhQU0lZY25Kc2N2dUE5c3hndWJMc2QrYWp1XC9ib21RWlBicUkreGFlWWZRb2Nja3Z1RWZ4RGNjbTdjV2RWWHFyZE1nQVFqbXFmVVhja1doNEgwNGFMODlUa0hKOXUxWjJTUUlhSWFUXC9rd09JUFQyaWZMN2NkK0pBK2l0clpzaHNqbXpxR0R6NWVzOVhtbk0rWktUNnF4WUtOM2o0ekV3WURvTHlBeUhTZzVvN3BVQjVZa1YiLCJ0aW1lc3RhbXAiOiIyMDIxLTA3LTE0VDA5OjM3OjI5WiJ9";
  static String InkaSiteId =
      "DEMO";
  static String InkaSiteKey =
      "";
}
