## USA Realism RP Codebase

To get started with your own testing environment:
1) Download and install [couchDB](http://couchdb.apache.org/)
    * Once installed, open a browser and navigate to `http://127.0.0.1:5984/_utils/` to open your couchDB instance interface
    * Go to "Your Account" and create an admin account
    * Base64 encode your username and password in the format `username:password`
        - Save it for the next step
2) Create the file `resources/essentialmode/sv_es-DB-config.lua`  
    * Set the variable `ip` to your couchDB IP (default = 127.0.0.1)
    * Set the variable `port` your couchDB port (default = 5984)
    * Set your base64 encoded credentials to the variable `auth` as a string
    * Create three exports in the file to return the variables set above:
		- ``getIP``
		- ``getPort``
		- ``getAuth``
3) Create the file `server_internal.cfg` in the project root directory
    * write `sv_hostname <server name>`, replacing `<server name>` with a name of your choice
    * write `sv_licenseKey <license key>`, replacing `<license key>` with a [FiveM license key](https://keymaster.fivem.net/)
4) Create path for log file (optional)
    * We use this to expose a chat log via an HTTP web server, so we provide a path to a file in its public directory
	* For example: ``C:/wamp/www/log.txt``
5) Create your database views (see below view definitions)
6) Add ``stop usa_utils`` and ``stop _anticheese`` to your ``server_internal.cfg`` so you don't get banned for code injection when developing.
7) Generate a Steam API dev key and paste it into your `server_internal.cfg` file on a new line in the format: `set steam_webApiKey "key here"`.
8) Start the server.
	* Windows:
		- with resource scrambling: ``./start.bat`` from the ``server-data`` folder
		- without resource scrambling: ``..\FXServer.exe +exec server.cfg +set onesync on`` from the ``server-data`` folder
	* Linux:
		- with resource scrambling: ``/start.sh`` from the ``server-data`` folder
		- without resource scrambling: ``bash run.sh +exec server-data/server.cfg`` from folder where server .dlls are

**DB Notes**
1)  Must create following couch db views in a ``vehicleFilters`` design doc in a ``vehicles`` db:  
	* **getMakeModelOwner**  
		- ``emit(doc._id, [doc.owner, doc.make, doc.model]);``  
	* **getMakeModelPlate**  
		- ``emit(doc._id, [doc.plate, doc.make, doc.model]);``  
	* **getVehicleCustomizationsByPlate**  
		- ``emit(doc._id, [doc.customizations]);``  
	* **getVehicleInventoryAndCapacityByPlate** 
		- ``emit(doc._id, [doc.inventory, doc.storage_capacity]);``  
	* **getVehicleInventoryByPlate**  
		- ``emit(doc._id, [doc.inventory]);``  
	* **getVehiclesForGarageMenu**  
		- ``emit(doc._id, [doc.plate, doc.make, doc.model, doc.impounded, doc.stored, doc.hash, doc.owner, doc.stats, doc.upgrades]);``  
	* **getVehiclesForMenuWithPlates**  
		- ``emit(doc._id, [doc.make, doc.model, doc.price, doc.stored, doc.stored_location, doc._id]);``  
	* **getVehiclesToSellWithPlates**  
		- ``emit(doc._id, [doc.plate, doc.make, doc.model, doc.price, doc._rev]);``
2) Must create following views for ``gcphone``:
	* In the ``phone-contacts`` db:
		* **getContactsByIdentifier**
			- ``emit(doc.ownerIdentifier, doc);``
3) Must create following couch db views in a ``characterFilters`` design doc in the ``characters`` db:
	* **getCharactersForSelectionBySteamID**
		- ``emit(doc.created.ownerIdentifier, [doc._id, doc._rev, doc.name, doc.dateOfBirth, doc.money, doc.bank, doc.spawn, doc.created.time]);``
4) Must create following couch db views in a ``businessFilters`` design doc in the ``businesses`` db:
	* **getBusinessByName**
		- ``emit(doc._id, doc);``
	* **getBusinessFeeInfo**
		- ``emit(doc._id, [doc._id, doc.fee.paidAt]);``
	* **getBusinessOwner**
		- ``emit(doc._id, doc.owner);``
	* **getBusinessStorage**
		- ``emit(doc._id, doc.storage);``
5) [optional] Create index on the ``stored_location`` field in the ``vehicles`` database for ``usa-properties-og`` to function correctly when storing/retrieving vehicles from property garages.
6) [optional] Create indexes on the ``receiver`` and ``transmitter`` fields (in that order) in the ``phone-messages`` database for ``gcphone`` to function correctly when storing/retrieving/updating phone text messages.
7) [optional] Create indexes on the ``owner`` and ``num`` fields in the ``phone-calls`` database for ``gcphone`` to function most efficiently when storing/retrieving phone call history.
8) [optional] Create index on the ``owner.identifiers.id`` field in the ``businesses`` database for ``usa-businesses` to function most efficiently when retreiving owned businsess for a character. 

**Webhooks**

[optional] Set the following convars in your `server_internal.cfg` file like so:

```
set status-channel-webhook ""
set server-monitor-webhook ""
set ban-log-webhook ""
set modder-log-webhook ""
set property-log-webhook ""
set search-warrant-log-webhook ""
set warrant-log-webhook ""
set dmv-log-webhook ""
set event-team-webhook ""
set gov-funds-webhook ""
set hospital-log-webhook ""
set jail-log-webhook ""
set detention-webhook ""
set morgue-log-webhook ""
set sasp-timesheet-webhook ""
set bcso-timesheet-webhook ""
set ems-timesheet-webhook ""
set doj-timesheet-webhook ""
```

Just replace the empty strings with your channel's webhook URL.

You'll also either want to disable the `block_vpn` script or get an account api key from proxycheck.io and set the `block-vpn-token` convar equal to it.

**Common Framework Usage**

```
--[[
	The server-sided character object (from usa-characters) has a whole bunch of helpful properties and methods pertaining to the player's character
]]

-- for example:
local char = exports["usa-characters]:GetCharacter(source) -- get the usa-characters resource character object for player with given source

if char.get("money") > 100 then
	-- do something
end

if char.hasItem("Tuna Fish") then
	-- do something
end

if char.get("job") == "sheriff" then
	-- do something
end
```

**Job Types**
1. "civ"
2. "sheriff" (AKA SASP)
3. "ems"
4. "corrections" (AKA BCSO)
5. "judge"
6. "taxi"
7. "tow"
8. "reporter" (weazel news)
9. "chickenFactory"
10. "gopostal"
11. "burgerShotEmployee"
11. ... could be more ...