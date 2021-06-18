# SCANDO iOS

On my Final Project (Thesis) for my Bachelor degree, I made an apps that translate Braille Document, and send the translation result to the Braille Printer owned by Institut Teknologi Sepuluh Nopember (ITS) via an IoT Device to be duplicated.

The purpose of this project is to make copier system for Braille Documents. It start from the story of there are a huge numbers of Braille Documents in the libraries which are getting obselete. To conserve them, we have to re-print them. But unfortunately, they don’t have their original text, so re-printing them is imposible to do otherwise we have to translate them manually, input the translation data into computer, and print it. Imagine doing it manually to a huge numbers of Braille Documents.

Photo-Copier machine just can not do this stuff. It can only duplicate ink-printed document. But, duplicating braille document? Yes, this project will do.

Check the video demo here. [https://youtu.be/uzVC4SG5RDM](https://youtu.be/uzVC4SG5RDM)

On the begining of the videos, you’ll see the step by step how the braille document is translated to the text. It covers about cropping image, applying perspective transform, grayscaling, applying adaptive threshold, dilation, erotion, finding contour, filtering the contour, getting braille dot’s coordinate, finding the one-line dots member statistically, grouping to make a segmentation, decoding every segment, and looking up from the table to encode it to be readable text.

An iOS apps for translating Braille document captured by iPhone camera, then send translation result to ITS's Braille printer for duplicating purpose (re-printing, copying braille document with no original text).

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

[SCANDO_ESP32](https://github.com/rickirby/SCANDO_ESP32) version: 0.2.0

