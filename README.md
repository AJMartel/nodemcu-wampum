# nodemcu-wampum
**A ESP8266 web server delivering static/dyn pages from SD card**

A simple HTTP web server hosting static and dynamic lua script files
from SD card instead of the flash ram.
This server is very limited and you must code your pages carefully
Go to the GITHUB repository and clone an example HTML project as
getting started.

*THERE IS NO NEED TO MODIFY THIS PROJECT TO SERVE YOUR PROJECT/WEBSITE*

Just load your pages on the SD card and your are done.

Requirements:
-------------
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


The SD must have at least two folders in the root directory:
 - "html" for all static resources like html/js/css or images
 - "lua" for all dynamic HTML files ( e.g. for ajax endpoints)

