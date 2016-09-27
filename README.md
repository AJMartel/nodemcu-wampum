# nodemcu-wampum
**A ESP8266 web server delivering static/dyn pages from SD card**

A simple HTTP web server hosting HTML,JS,CSS and server side lua script files
**from SD** card instead of the flash ram.

This server is very limited in resources and you must code your pages carefully. Best you clone 
some of the example web projects listed on the bottom of the page.

Just load your project on the SD card and your are done.


![WebServer](/teaser.png?raw=true "ESP8266 as full web server")

## Yet another NodeMCU WebServer?
You find a lot of examples how to setup the NodeMCU as simple WebServer
serving a simple and ugly web page turning a LED on/off. But this far
from the reality and it is almost impossible to build a fancy UI for your
IoT project.

## Features
 - GET, POST, PUT and minor changes to support other methods
 - Multiple MIME types
 - Error pages (404 and others)
 - Server-side execution of Lua scripts
 - Query string argument parsing with decoding of arguments
 - Serving .gz compressed files

## Requirements
You must connect an SD card to your nodeMCU or you are using
[WeMos](http://www.wemos.cc) (nodeMCU protoboard) + [SD Card shield](http://www.wemos.cc/product/micro-sd-card-shield.html) (hassle-free version).

Use the latest nodemcu-firmware with "FatFS" support. You can
create your own firmware on the [nodeMCU build server](https://nodemcu-build.com/)
At the moment (Sept. 2016) you must select the DEV branch to have FatFS
Select SPI and FatFS for your build.

This is what my ESP8266 log during startup. Absolute required modules are: SPI and FatFS
```
NodeMCU custom build by frightanic.com
	branch: dev
	commit: 90839f8956961b1ce225bf5b539beaf402155add
	SSL: false
	modules: bit,encoder,file,gpio,http,i2c,net,node,ow,pcm,pwm,rotary,spi,tmr,uart,websocket,wifi
 build 	built on: 2016-09-22 10:18
 powered by Lua 5.1.4 on SDK 1.5.4.1(39cb9a32)

```

![BuildSettings](/nodeMCU_build.png?raw=true "build settings")

## How to upload the code
I recommend using the ESPlorer program created by 4refr0nt to create and save LUA files into your ESP8266.
Follow these instructions to download and install ESPlorer:
 - [Click here to download ESPlorer](Click here to download ESPlorer)
 - Unzip that folder
 - Run ESPlorer.jar. It’s a JAVA program, so you need JAVA installed on your computer.
 - Open the ESPlorer

![ESPlorer](/esplorer.png?raw=true)
 - Connect your NodeMCU to your computer
 - Select your NodeMCU port
 - Press **Open/Close** button
 - Press **Upload** button
 - Select all files from the *nodemcu-wampum* and upload them to the NodeMCU
 - reboot your NodeMCU

![upload](/upload.png?raw=true)



## Web projects
The server delivers the content from the SD card and not from the internal FLASH RAM. This is a little bit 
slower - but you can easily update your WebSite just by update the SD card instead of flash the ESP.


## Configuration by convention
The SD card must have at least two folders in the root directory:
 - "html" for all static resources like html/js/css or images
 - "lua" for all server side scripts ( e.g. for ajax endpoints)

## Connect the client
After you have upload one demo project to your SD card you can connect to the NodeMCU with a browser.

 - select the WiFi network with the name **wampum-xxxxxx**
 - Enter **theballismine** as network password
 - Open browser and connect to http://192.168.111.1/

## Demo Projects

### Blank
A blank example with one HTML page and a LUA dynamic page. This project is a good starting point
if you host just some HTML pages without jQuery and a little bit of CSS styling.
 
Github Repo: [nodemcu-wampum-example](https://github.com/freegroup/nodemcu-wampum-example)

### jQuery UI with Ajax backend
This projects is based on the jquery lib and toggles the WeMos LED on/off with a AJAX calls. **no page refresh**
All the files are located on the ESP8266 and the connected SD-shield.

Github Repo: [nodemcu-wampum-jquery](https://github.com/freegroup/nodemcu-wampum-jquery)
