# Where-To-Snowboard v0.1

It's a simple app, which download information from skimap.org API about ski areas, base on the region specify by user. App is saving data into the core data, so it can be use also without internet connection (once when data are downloaded and if user don't want to change region). It' consuming data from one source https://skimap.org/pages/Developers. Information about regions are provided in XML format and information about ski areas are provided in JSON format, so I had to work with it as with two speared API data sources. 

## Ideas for v0.2
- add more information’s about ski are
- add table view for ski maps
- add detail view for ski maps
- add possibility to download all information about selected region in one method. It will be slow, by user can wait a little bit for it. It will be many API calls to skimap.org. It will download all ski areas and ski maps in selected region.
- add weather info


## App contains 4 views:

* **Region View**: User can select a region. Regions can be selected in picker views. Regions are populated from skimap.org and are populated base on the region selected in previous level (example: If you select region in lvl0, app will populate region in lvl1 base on the region selected in lvl0). If latest selected region contains a ski areas, app will show information about count of ski areas and enable button "show regions".
* **Table View**: Table view, with all ski areas in selected region. User can tab on ski area and app will switch him to detail ski area view. When user open detail view, app will download detail information about ski area. Skimap.org doesn't provide API method, which contains more detail information about more that one ski area. I didn't want to download all details about all ski areas in many separated API call. I think it will slow down an app and it will not be a user friendly. From this view, user can also change region, by tab on Region button in left top corner.
* **Map View**: Map view, which contains all ski areas saved in core data with information about location. Ski area are represented as map pins. User can tab on the pin and small detail information view will appear. When user tab on info icon, app will switch him to derail ski are view
* **Detail SkiAre View**: Detail view contains map view, with pin representing a ski are on the map. It contains also name and operating status of ski area. You can see two button in this view. "Get direction" - which will open a map app with preselected pin and you can find the way to ski area. "Open Official Web" - which will open official web page of ski area. These two button are enabled, only if location info and official web page are available from API.

## Your starting point...
### 1. download the APP from github
### 2. open app in xcode and run it in simulator

When you open app for the first time, you will se empty table view. Tab on the Region button in the left-top corner and set your region. You will go through region from lvl0 to the point, app will show you number of ski areas in your resort and enable "show region" button. This button will switch you to table view, where you check all ski areas in selected region. Then you can check map view and see details abou ski area by tab on in table view. 


