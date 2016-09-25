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
WeMos (nodeMCU protoboard) + SD Card shield (hassle-free version).

Use the latest nodemcu-firmware with "FatFS" support. You can
create your own firmware on https://nodemcu-build.com/
At the moment (Sept. 2016) you must select the DEV branch to have FatFS
Select SPI and FatFS for your build.

The SD must have at least two folders in the root directory:
 - "html" for all static resources like html/js/css or images
 - "lua" for all dynamic HTML files ( e.g. for ajax endpoints)

