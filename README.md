# SCANDO iOS
An iOS apps for translating Braille document captured by iPhone camera, then send translation result to ITS's Braille printer for duplicating purpose (re-printing, copying braille document with no original text)

This is the Main repo project for iOS side application. See also [SCANDO_ESP32](https://github.com/rickirby/SCANDO_ESP32) for the Main repo project for ESP32 firmware application.

Created by Ricki Bin Yamin

## This repository uses following dependency:
- [RBToolkit](https://github.com/rickirby/RBToolkit) version 0.0.3
- [RBPhotosGallery](https://github.com/rickirby/RBPhotosGallery) version 0.0.5
- [RBCameraDocScan](https://github.com/rickirby/RBCameraDocScan) version 0.0.3
- [RBImageProcessor](https://github.com/rickirby/RBImageProcessor) version 0.2.1

Use carthage to download listed framework above by simply execute "carthage update --platform iOS" on terminal. 

Note: If carthage failed to build, use the workarround solution for xcode 12, just by executing following lines

```
./Scripts/carthage.sh update --platform iOS
```

## Current Project Version
0.5.1

## Compatibility with [SCANDO_ESP32](https://github.com/rickirby/SCANDO_ESP32)
Since this apps will hit API hosted on [ESP32](https://www.espressif.com/en/products/socs/esp32), this source code should match the compatibility of firmware downloaded to the device.

SCANDO_ESP32 version: 0.2.0

