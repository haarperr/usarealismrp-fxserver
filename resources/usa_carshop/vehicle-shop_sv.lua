--# by: minipunch
--# for: USA REALISM RP
--# simple vehicle shop script to preview and purchase a vehicle

-- PERFORM FIRST TIME DB CHECK --
exports["globals"]:PerformDBCheck("vehicle-shop", "vehicles", nil)

local price, vehicleName, hash, plate
local MAX_PLAYER_VEHICLES = 500

local vehicleShopItems = {
	["vehicles"] = {
		["Suvs"] = {
			{make = "Canis", model = "Seminole", price = 12550, hash = 1221512915, storage_capacity = 175.0},
			{make = "Obey", model = "Rocoto", price = 21197, hash = 2136773105, storage_capacity = 175.0},
			{make = "Declasse", model = "Granger", price = 19050, hash = -1775728740, storage_capacity = 185.0},
			{make = "Dundreary", model = "Landstalker", price = 29650, hash = 1269098716, storage_capacity = 175.0},
			{make = "Benefactor", model = "Streiter", price = 31945, hash = "streiter", storage_capacity = 175.0},
			{make = "Benefactor", model = "Dubsta", price = 35469, hash = 1177543287, storage_capacity = 175.0},
			{make = "Benefactor", model = "Dubsta 2", price = 44420, hash = -394074634, storage_capacity = 175.0},
			{make = "Benefactor", model = "Dubsta 6x6", price = 90897, hash = -1237253773, storage_capacity = 215.0},
			{make = "Phatom", model = "FQ2", price = 30369, hash = -1137532101, storage_capacity = 175.0},
			{make = "Bravado", model = "Gresley", price = 22548, hash = -1543762099, storage_capacity = 175.0},
			{make = "Albany", model = "Cavalcade", price = 22989, hash = -789894171, storage_capacity = 175.0},
			{make = "Gallivanter", model = "Baller LE", price = 47457, hash = 1878062887, storage_capacity = 200.0},
			{make = "Gallivanter", model = "Baller", price = 25150, hash = 634118882, storage_capacity = 200.0},
			{make = "Enus", model = "Huntley", price = 37489, hash = 486987393, storage_capacity = 200.0},
			{make = "Mammoth", model = "Patriot", price = 21784, hash = -808457413, storage_capacity = 200.0},
			{make = "Emperor", model = "Habenaro", price = 8559, hash = "habanero", storage_capacity = 200.0},
			{make = "Karin", model = "BeeJay XL", price = 26145, hash = "bjxl", storage_capacity = 200.0},
			{make = "Benefactor", model = "XLS", price = 31999, hash = "xls", storage_capacity = 200.0},
			{make = "Ubermacht", model = "Rebla GTS", price = 65000, hash = "rebla", storage_capacity = 200.0},
			{make = "Canis", model = "Seminole Frontier", price = 31999, hash = "seminole2", storage_capacity = 200.0},
		},
		["Coupes"] = {
			{make = "Ocelot", model = "Jackal", price = 39900, hash = -624529134, storage_capacity = 135.0},
			{make = "Dewbauchee", model = "Exemplar", price = 51980, hash = -5153954, storage_capacity = 135.0},
			{make = "Ubermacht", model = "Sentinel", price = 25500, hash = "sentinel2", storage_capacity = 135.0},
			{make = "Ubermacht", model = "Sentinel XS", price = 29890, hash = "sentinel", storage_capacity = 135.0},
			{make = "Ubermacht", model = "Sentinel Classic", price = 39870, hash = "sentinel3", storage_capacity = 135.0},
			{make = "Enus", model = "Cognoscenti Cabrio", price = 79643, hash = 330661258, storage_capacity = 135.0},
			{make = "Lampadati", model = "Felon", price = 42640, hash = -391594584, storage_capacity = 135.0},
			{make = "Enus", model = "Windsor Cabrio", price = 78543, hash = -1930048799, storage_capacity = 135.0},
			{make = "Albany", model = "Alpha", price = 24980, hash = 767087018, storage_capacity = 135.0},
			{make = "Pfister", model = "Comet 1", price = 34987, hash = -1045541610, storage_capacity = 125.0},
			{make = "Pfister", model = "Comet 2", price = 46965, hash = -2022483795, storage_capacity = 125.0},
			{make = "Pfister", model = "Comet 3", price = 62765, hash = "comet5", storage_capacity = 125.0},
			{make = "Ocelot", model = "Pariah", price = 77912, hash = "pariah", storage_capacity = 145.0},
			{make = "Lampadati", model = "Michelli GT", price = 53540, hash = "michelli", storage_capacity = 110.0},
			{make = "Ocelot", model = "F620", price = 43458, hash = "f620", storage_capacity = 145.0},
			{make = "Benefactor", model = "Schwartzer", price = 48977, hash = "schwarzer", storage_capacity = 135.0},
			{make = "Benefactor", model = "Schlagen GT", price = 70000, hash = "schlagen", storage_capacity = 135.0},
			{make = "Hijak", model = "Ruston", price = 80000, hash = "ruston", storage_capacity = 90.0},
			{make = "Ubermacht", model = "Zion", price = 40000, hash = "zion", storage_capacity = 145.0},
			{make = "Dinka", model = "Jester 3", price = 55000, hash = "jester3", storage_capacity = 125.0},
			{make = "Miabatsu", model = "Penumbra", price = 35000, hash = "penumbra", storage_capacity = 125.0},
			{make = "Karin", model = "Calico GTF", price = 25000, hash = "calico", storage_capacity = 125.0},
			{make = "Ubermacht", model = "Cypher", price = 57500, hash = "cypher", storage_capacity = 125.0},
			{make = "Karin", model = "Previon", price = 30500, hash = "previon", storage_capacity = 125.0},
			{make = "Annis", model = "ZR350", price = 20500, hash = "zr350", storage_capacity = 125.0},
			{make = "Annis", model = "Euros", price = 30000, hash = "euros", storage_capacity = 125.0},
			{make = "Annis", model = "Remus", price = 25500, hash = "remus", storage_capacity = 125.0},
			{make = "Dinka", model = "RT3000", price = 30500, hash = "rt3000", storage_capacity = 125.0},
			{make = "Vulcan", model = "Warrener HKR", price = 20000, hash = "warrener2", storage_capacity = 125.0},
			{make = "Karin", model = "Futo GTX", price = 20500, hash = "futo2", storage_capacity = 125.0},
			{make = "Karin", model = "Sultan RS Classic", price = 25500, hash = "sultan3", storage_capacity = 125.0},
			{make = "Dinka", model = "Jester RR", price = 60000, hash = "jester4", storage_capacity = 125.0},
			{make = "Pfister", model = "Comet 4", price = 52765, hash = "comet4", storage_capacity = 125.0},
			--{make = "Annis", model = "Savestra", price = 27560, hash = "savestra", storage_capacity = 125.0} -- has machine guns
		},
		["Muscles"] = {
			{make = "Willard", model = "Faction", price = 13750, hash = -2119578145, storage_capacity = 160.0},
			{make = "Imponte", model = "Dukes", price = 18800, hash = 723973206, storage_capacity = 160.0},
			{make = "Declasse", model = "Vigero", price = 20430, hash = -825837129, storage_capacity = 160.0},
			{make = "Albany", model = "Buccaneer", price = 18800, hash = -682211828, storage_capacity = 160.0},
			{make = "Albany", model = "Buccaneer 2", price = 25870, hash = -1013450936, storage_capacity = 150.0},
			{make = "Imponte", model = "Ruiner", price = 10850, hash = -227741703, storage_capacity = 160.0},
			{make = "Imponte", model = "Nightshade", price = 29890, hash = -1943285540, storage_capacity = 160.0},
			{make = "Vapid", model = "Dominator", price = 17670, hash = 80636076, storage_capacity = 160.0},
			{make = "Vapid", model = "Dominator 3", price = 38650, hash = "dominator3", storage_capacity = 140.0},
			{make = "Albany", model = "Virgo 1", price = 14980, hash = -498054846, storage_capacity = 160.0},
			{make = "Albany", model = "Virgo 2", price = 22430, hash = -899509638, storage_capacity = 130.0},
			{make = "Declasse", model = "Voodoo", price = 14970, hash = 2006667053, storage_capacity = 130.0},
			{make = "Declasse", model = "Tampa", price = 26876, hash = 972671128, storage_capacity = 160.0},
			{make = "Declasse", model = "Tampa Drift Sport", price = 90000, hash = GetHashKey("tampa2"), storage_capacity = 160.0},
			{make = "Vapid", model = "Chino Custom", price = 40000, hash = -1361687965, storage_capacity = 160.0},
			{make = "Vapid", model = "Ellie", price = 60000, hash = "ellie", storage_capacity = 100.0},
			{make = "Bravado", model = "Gauntlet", price = 75000, hash = -1800170043, storage_capacity = 160.0},
			{make = "Willand", model = "Faction Custom", price = 25000, hash = -1790546981, storage_capacity = 160.0},
			{make = "Willand", model = "Faction Custom Donk", price = 75000, hash = -2039755226, storage_capacity = 160.0},
			{make = "Declasse", model = "Sabre GT", price = 19970, hash = -1685021548, storage_capacity = 155.0},
			{make = "Declasse", model = "Sabre Turbo Custom", price = 40000, hash = 223258115, storage_capacity = 130.0},
			{make = "Declasse", model = "Stallion", price = 20540, hash = 1923400478, storage_capacity = 155.0},
			{make = "Declasse", model = "Impaler", price = 16867, hash = "impaler", storage_capacity = 155.0},
			{make = "Declasse", model = "Vamos", price = 35000, hash = "vamos", storage_capacity = 170.0},
			{make = "Declasse", model = "Tulip", price = 40000, hash = "tulip", storage_capacity = 170.0},
			{make = "Cheval", model = "Picador", price = 12750, hash = "picador", storage_capacity = 170.0},
			{make = "Vapid", model = "Blade", price = 42540, hash = "blade", storage_capacity = 170.0},
			{make = "Vapid", model = "Hotknife", price = 70890, hash = "hotknife", storage_capacity = 170.0},
			{make = "Vapid", model = "Clique", price = 40000, hash = "clique", storage_capacity = 170.0},
			{make = "Imponte", model = "Phoenix", price = 28470, hash = "phoenix", storage_capacity = 170.0},
			{make = "Schyster", model = "Deviant", price = 40000, hash = "deviant", storage_capacity = 170.0},
			{make = "Bravado", model = "Gauntlet Hellfire", price = 60000, hash = "gauntlet4", storage_capacity = 170.0},
			{make = "Bravado", model = "Gauntlet Classic", price = 35000, hash = "gauntlet3", storage_capacity = 170.0},
			{make = "Vapid", model = "Dominator ASP", price = 30500, hash = "dominator7", storage_capacity = 125.0},
			{make = "Vapid", model = "Dominator GTT", price = 40500, hash = "dominator8", storage_capacity = 125.0},
		},
		["Trucks"] = {
			{make = "Karin", model = "Rebel", price = 8800, hash = "rebel", storage_capacity = 230.0},
			{make = "Karin", model = "Rebel 2", price = 14601, hash = -2045594037, storage_capacity = 230.0},
			{make = "Vapid", model = "Bobcat XL", price = 21870, hash = 1069929536, storage_capacity = 230.0},
			{make = "Bravado", model = "Bison", price = 21899, hash = -16948145, storage_capacity = 230.0},
			{make = "Declasse", model = "Yosemite", price = 24446, hash = "yosemite", storage_capacity = 230.0},
			{make = "Vapid", model = "Riata", price = 31878, hash = "riata", storage_capacity = 230.0},
			{make = "Vapid", model = "Slam Van", price = 19000, hash = 729783779, storage_capacity = 230.0},
			{make = "Vapid", model = "Sandking", price = 38320, hash = -1189015600, storage_capacity = 230.0},
			--{make = "Lifted Dodge", model = "Ram", price = 49000, hash = 989381445, storage_capacity = 230.0},
			{make = "Vapid", model = "Sandking 2", price = 45320, hash = 989381445, storage_capacity = 230.0},
			{make = "Vapid", model = "Contender", price = 38649, hash = 683047626, storage_capacity = 230.0},
			{make = "Vapid", model = "Guardian", price = 109999, hash =  -2107990196, storage_capacity = 230.0},
			{make = "Bravado", model = "Rat-Truck", price = 29213, hash =  "ratloader2", storage_capacity = 230.0},
			{make = "Bravado", model = "Duneloader", price = 20899, hash =  "dloader", storage_capacity = 230.0},
			{make = "Vapid", model = "Caracara", price = 65000, hash =  "caracara2", storage_capacity = 230.0},
			{make = "Karin", model = "Everon", price = 60000, hash =  "everon", storage_capacity = 230.0},
		},
		["Compacts"] = {
			{make = "Nagasaki", model = "Caddy", price = 1500, hash = -537896628, storage_capacity = 80.0},
			{make = "Karin", model = "Dilettante", price = 5680, hash = -1130810103, storage_capacity = 170.0},
			{make = "Benefactor", model = "Panto", price = 6169, hash = -431692672, storage_capacity = 125.0},
			{make = "Declasse", model = "Rhapsody", price = 8650, hash = 841808271, storage_capacity = 125.0},
			{make = "Dinka", model = "Blista Compact", price = 7450, hash = 1039032026, storage_capacity = 135.0},
			{make = "Bollokan", model = "Prairie", price = 7060, hash = -1450650718, storage_capacity = 125.0},
			{make = "Weeny", model = "Issi", price = 8960, hash = -1177863319, storage_capacity = 125.0},
			{make = "Weeny", model = "Issi Classic", price = 15020, hash = "issi3", storage_capacity = 125.0},
			{make = "Grotti", model = "Brioso", price = 19570, hash = "brioso", storage_capacity = 125.0},
			{make = "Karin", model = "Futo", price = 7760, hash = "futo", storage_capacity = 125.0},
			{make = "Rune", model = "Cheburek", price = 12650, hash = "cheburek", storage_capacity = 115.0},
		},
		["Offroads"] = {
			{make = "Canis", model = "Kalahari", price = 21888, hash = 92612664, storage_capacity = 170.0},
			{make = "Declasse", model = "Rancher XL", price = 12540, hash = 1645267888, storage_capacity = 170.0},
			{make = "Coil", model = "Brawler", price = 41540, hash = -1479664699, storage_capacity = 170.0},
			{make = "BF", model = "Bifta", price = 33760, hash = -349601129, storage_capacity = 170.0},
			{make = "Canis", model = "Mesa 2", price = 27640, hash = -2064372143, storage_capacity = 170.0},
			{make = "Canis", model = "Mesa", price = 14650, hash = 914654722, storage_capacity = 170.0},
			{make = "Canis", model = "Kamacho", price = 59000, hash = "kamacho", storage_capacity = 130.0},
			{make = "BF", model = "Injection", price = 5930, hash = 1126868326, storage_capacity = 70.0},
			{make = "Canis", model = "Bodhi", price = 21320, hash = "bodhi2", storage_capacity = 70.0},
			{make = "Nagasaki", model = "Blazer", price = 15000, hash = -2128233223, storage_capacity = 170.0},
			{make = "Vapid", model = "Trophy Truck", price = 60000, hash = 101905590, storage_capacity = 100.0},
			{make = "Vapid", model = "Trophy Truck 2", price = 100000, hash = -663299102, storage_capacity = 100.0},
			{make = "Dune", model = "Buggy", price = 80000, hash = -1661854193, storage_capacity = 70.0},
			{make = "Nagasaki", model = "Hot Rod Blazer", price = 20000, hash = "blazer3", storage_capacity = 70.0},
			{make = "Nagasaki", model = "Street Blazer", price = 40000, hash = "blazer4", storage_capacity = 70.0},
			{make = "Declasse", model = "Yosemite Rancher", price = 25000, hash = "yosemite3", storage_capacity = 90.0},
			{make = "Nagasaki", model = "Outlaw", price = 20000, hash = "outlaw", storage_capacity = 70.0},
			{make = "Annis", model = "Hellion", price = 30000, hash = "hellion", storage_capacity = 90.0},
		},
		["Motorcycles"] = {
			{make = "Pegassi", model = "Faggio", price = 2069, hash = -1842748181, storage_capacity = 30.0},
			{make = "Pegassi", model = "Faggio Mod", price = 8000, hash = 55628203, storage_capacity = 50.0},
			{make = "Pegassi", model = "Faggio Sport", price = 6000, hash = -1289178744, storage_capacity = 60.0},
			{make = "Dinka", model = "Double T", price = 35000, hash = "double", storage_capacity = 30.0},
			{make = "Dinka", model = "Enduro", price = 10750, hash = 1753414259, storage_capacity = 30.0},
			{make = "Dinka", model = "Akuma", price = 15760, hash = 1672195559, storage_capacity = 30.0},
			{make = "Maibatsu", model = "Sanchez", price = 14880, hash = -1453280962, storage_capacity = 30.0},
			{make = "Shitzu", model = "Vader", price = 19402, hash = -140902153, storage_capacity = 30.0},
			{make = "Western", model = "Bagger", price = 17000, hash = -2140431165, storage_capacity = 30.0},
			{make = "LCC", model = "Hexer", price = 19765, hash = 301427732, storage_capacity = 30.0},
			{make = "Western", model = "Zombie Chopper", price = 19540, hash = -570033273, storage_capacity = 30.0},
			{make = "Dinka", model = "Thrust", price = 18000, hash = 1836027715, storage_capacity = 30.0},
			{make = "Western", model = "Nightblade", price = 21200, hash = -1606187161, storage_capacity = 30.0},
			{make = "Pegassi", model = "Bati 801", price = 20430, hash = -114291515, storage_capacity = 30.0},
			{make = "Western", model = "Zombie Bobber", price = 26430, hash = -1009268949, storage_capacity = 30.0},
			{make = "Nagasaki", model = "Carbon RS", price = 29500, hash = 11251904, storage_capacity = 30.0},
			{make = "Western", model = "Daemon", price = 19540, hash = 2006142190, storage_capacity = 30.0},
			{make = "Western", model = "Daemon 2", price = 21000, hash = -1404136503, storage_capacity = 30.0},
			{make = "Maibatsu", model = "Manchez", price = 24200, hash = -1523428744, storage_capacity = 30.0},
			{make = "Western", model = "Sovereign", price = 27999, hash = 743478836, storage_capacity = 30.0},
			{make = "Principe", model = "Lectro", price = 27540, hash = "lectro", storage_capacity = 30.0},
			{make = "Shitzu", model = "Defiler", price = 23760, hash = 822018448, storage_capacity = 60.0},
			{make = "Shitzu", model = "Hakuchou", price = 33589, hash = 1265391242, storage_capacity = 60.0},
			{make = "Shitzu", model = "Hakuchou Drag", price = 39980, hash = -255678177, storage_capacity = 60.0},
			{make = "Western", model = "Ratbike", price = 5987, hash = 1873600305, storage_capacity = 45.0},
			{make = "Pegassi", model = "Vortex", price = 38709, hash = -609625092, storage_capacity = 45.0},
			{make = "Nagasaki", model = "Chimera", price = 25000, hash = 6774487, storage_capacity = 30.0},
			{make = "LCC", model = "Sanctus", price = 80000, hash = 1491277511, storage_capacity = 30.0},
			{make = "Western", model = "Wolfsbane", price = 15000, hash = -618617997, storage_capacity = 30.0},
			{make = "LCC", model = "Avarus", price = 18000, hash = "avarus", storage_capacity = 30.0},
			{make = "Pegassi", model = "Esskey", price = 18000, hash = 2035069708, storage_capacity = 45.0},
			{make = "BF", model = "Raptor", price = 40000, hash = -674927303, storage_capacity = 65.0}
		},
		["Vans"] = {
			{make = "Vapid", model = "Speedo", price = 21760, hash = -810318068, storage_capacity = 300.0},
			{make = "Vapid", model = "Minivan", price = 9500, hash = -310465116, storage_capacity = 300.0},
			{make = "Vapid", model = "Minivan 2", price = 19980, hash = -1126264336, storage_capacity = 250.0},
			{make = "Vapid", model = "Clown", price = 17599, hash = 728614474, storage_capacity = 300.0},
			{make = "Declasse", model = "Burrito 1", price = 24900, hash = -1346687836, storage_capacity = 300.0},
			{make = "Declasse", model = "Burrito 2", price = 24900, hash = -907477130, storage_capacity = 300.0},
			{make = "Declasse", model = "Burrito 3", price = 24900, hash = -1743316013, storage_capacity = 300.0},
			{make = "Declasse", model = "Burrito 4", price = 24900, hash = 893081117, storage_capacity = 300.0},
			{make = "Declasse", model = "Burrito 5", price = 24900, hash = 1132262048, storage_capacity = 300.0},
			{make = "BF", model = "Surfer", price = 8970, hash = 699456151, storage_capacity = 300.0},
			{make = "Bravado", model = "Youga Classic", price = 17676, hash = 1026149675, storage_capacity = 300.0},
			{make = "Bravado", model = "Rumpo 3", price = 45432, hash = 1475773103, storage_capacity = 300.0},
			{make = "Brute", model = "Camper", price = 28500, hash = 1876516712, storage_capacity = 300.0},
			{make = "Brute", model = "Taco Van", price = 20500, hash = 1951180813, storage_capacity = 300.0},
			{make = "Declasse", model = "Moonbeam", price = 18500, hash = "moonbeam", storage_capacity = 300.0},
			{make = "Declasse", model = "Moonbeam 2", price = 25500, hash = "moonbeam2", storage_capacity = 300.0},
			{make = "Zirconium", model = "Journey", price = 9570, hash = "journey", storage_capacity = 350.0}
		},
		["Sports"] = {
			{make = "Ubermacht", model = "Zion Cabrio", price = 30540, hash = -1193103848, storage_capacity = 145.0},
			{make = "Invetero", model = "Coquette", price = 59760, hash = 108773431, storage_capacity = 145.0},
			{make = "Benefactor", model = "Surano", price = 64870, hash = 384071873, storage_capacity = 145.0},
			{make = "Dewbauchee", model = "Massacro", price = 77650, hash = -142942670, storage_capacity = 145.0},
			{make = "Benefactor", model = "Schafter V12", price = 49776, hash = -1485523546, storage_capacity = 145.0},
			{make = "Dewbauchee", model = "Rapid GT", price = 48430, hash = -1934452204, storage_capacity = 145.0},
			{make = "Annis", model = "Elegy Retro Custom", price = 39789, hash = 196747873, storage_capacity = 145.0},
			{make = "Vapid", model = "Flash GT", price = 51654, hash = "flashgt", storage_capacity = 125.0},
			{make = "Dewbauchee", model = "Seven-70", price = 74999, hash = -1757836725, storage_capacity = 145.0},
			{make = "Dewbauchee", model = "Specter", price = 75700, hash = 1886268224, storage_capacity = 145.0},
			{make = "Karin", model = "Sultan", price = 40000, hash = 970598228, storage_capacity = 165.0},
			{make = "Karin", model = "Sultan RS", price = 45000, hash = -295689028, storage_capacity = 145.0},
			{make = "Obey", model = "9F", price = 66890, hash = 1032823388, storage_capacity = 145.0},
			{make = "Obey", model = "9F Cabrio", price = 74453, hash = -1461482751, storage_capacity = 145.0},
			{make = "Obey", model = "Omnis", price = 64500, hash = "omnis", storage_capacity = 125.0},
			{make = "Dinka", model = "Jester", price = 74000, hash = -1297672541, storage_capacity = 145.0},
			{make = "Karin", model = "Kuruma", price = 37532, hash = -1372848492, storage_capacity = 145.0},
			{make = "Vapid", model = "GB200", price = 79756, hash = "gb200", storage_capacity = 100.0},
			{make = "Lampadati", model = "Furore GT", price = 69876, hash = -1089039904, storage_capacity = 100.0},
			{make = "Grotti", model = "Bestia GTS", price = 67876, hash = 1274868363, storage_capacity = 120.0},
			{make = "Benefactor", model = "Feltzer", price = 70432, hash = "feltzer2", storage_capacity = 100.0},
			{make = "Bravado", model = "Buffalo S", price = 60000, hash = 736902334, storage_capacity = 135.0},
			{make = "Annis", model = "Elegy RH8", price = 90000, hash = -566387422, storage_capacity = 145.0},
			{make = "Bravado", model = "Banshee 990R", price = 100000, hash = 633712403, storage_capacity = 100.0},
			{make = "Lampadati", model = "Tropos Rallye", price = 70000, hash = "tropos", storage_capacity = 100.0},
			{make = "Obey", model = "8F Drafter", price = 50000, hash = "drafter", storage_capacity = 100.0},
			{make = "Dinka", model = "Sugoi", price = 30000, hash = "sugoi", storage_capacity = 100.0},
			{make = "Enus", model = "Paragon", price = 90000, hash = "paragon", storage_capacity = 100.0},
			{make = "Emperor", model = "Vectre", price = 65000, hash = "vectre", storage_capacity = 125.0},
			{make = "Pfister", model = "Growler", price = 70000, hash = "growler", storage_capacity = 125.0},
			{make = "Pfister", model = "Comet S2", price = 70500, hash = "comet6", storage_capacity = 125.0},
			{make = "Invetero", model = "Coquette D10", price = 90000, hash = "coquette4", storage_capacity = 145.0},
		},
		["Supers"] = {
			{make = "Pegassi", model = "Infernus", price = 368621, hash = 418536135, storage_capacity = 100.0},
			{make = "Vapid", model = "Bullet", price = 396897, hash = -1696146015, storage_capacity = 100.0},
			{make = "Grotti", model = "Cheetah", price = 438442, hash = -1311154784, storage_capacity = 100.0},
			{make = "Pfister", model = "811", price = 422645, hash = -1829802492, storage_capacity = 100.0},
			{make = "Pegassi", model = "Vacca", price = 426392, hash = 338562499, storage_capacity = 100.0},
			{make = "Progen", model = "T20", price = 594846, hash = 1663218586, storage_capacity = 100.0},
			{make = "Pegassi", model = "Osiris", price = 665328, hash = 1987142870, storage_capacity = 100.0},
			{make = "Truffade", model = "Adder", price = 653524, hash = -1216765807, storage_capacity = 100.0},
			{make = "Progen", model = "GP1", price = 647535, hash = 1234311532, storage_capacity = 100.0},
			{make = "Pegassi", model = "Reaper", price = 643956, hash = 234062309, storage_capacity = 100.0},
			{make = "Truffade", model = "Nero", price = 856439, hash = 1034187331, storage_capacity = 100.0},
			{make = "Truffade", model = "Nero Custom", price = 900000, hash = GetHashKey("nero2"), storage_capacity = 100.0},
			{make = "Pegassi", model = "Tempesta", price = 657864, hash = 272929391, storage_capacity = 100.0},
			{make = "Vapid", model = "FMJ", price = 664539, hash = 1426219628, storage_capacity = 100.0},
			{make = "Progen", model = "Itali GTB", price = 668904, hash = -2048333973, storage_capacity = 100.0},
			{make = "Progen", model = "Itali GTB Custom", price = 689476, hash = "italigtb2", storage_capacity = 100.0},
			{make = "Pegassi", model = "Zentorno", price = 697454, hash = -1403128555, storage_capacity = 100.0},
			{make = "Ocelot", model = "XA-21", price = 709875, hash = 917809321, storage_capacity = 100.0},
			--{make = "Ferrari", model = "California", price = 630000, hash = 2072687711, storage_capacity = 100.0},
			{make = "Grotti", model = "Carbonizzare", price = 642164, hash = 2072687711, storage_capacity = 100.0},
			{make = "Grotti", model = "Turismo R", price = 743643, hash = 408192225, storage_capacity = 100.0},
			{make = "Progen", model = "Tyrus", price = 746758, hash = 2067820283, storage_capacity = 100.0},
			{make = "Annis", model = "RE7B", price = 747647, hash = -1232836011, storage_capacity = 100.0},
			{make = "Ubermacht", model = "SC1", price = 676543, hash = "SC1", storage_capacity = 100.0},
			{make = "Ocelot", model = "Penetrator", price = 673970, hash = "penetrator", storage_capacity = 110.0},
			{make = "Emperor", model = "ETR 1", price = 682347, hash = "sheava", storage_capacity = 110.0},
			{make = "Grotti", model = "Itali GTO", price = 686754, hash = "italigto", storage_capacity = 110.0},
			{make = "Overflod", model = "Autarch", price = 756708, hash = "autarch", storage_capacity = 100.0},
			{make = "Overflod", model = "Tyrant", price = 789074, hash = "tyrant", storage_capacity = 100.0},
			{make = "Cheval", model = "Taipan", price = 695375, hash = "taipan", storage_capacity = 110.0},
			{make = "Pegassi", model = "Tezeract", price = 754584, hash = "tezeract", storage_capacity = 110.0},
			{make = "Grotti", model = "Visione", price = 795794, hash = "visione", storage_capacity = 110.0},
			{make = "Dewbauchee", model = "Vagner", price = 884638, hash = "vagner", storage_capacity = 110.0},
			{make = "Principe", model = "Deveste Eight", price = 1200000, hash = "deveste", storage_capacity = 110.0},
			{make = "Overflod", model = "Entity XXR", price = 862000, hash = "entity2", storage_capacity = 110.0},
			{make = "Progen", model = "Emerus", price = 950000, hash = "emerus", storage_capacity = 110.0},
			{make = "Lampadati", model = "Tigon", price = 600000, hash = "tigon", storage_capacity = 100.0},
            {make = "Grotti", model = "Furia", price = 500000, hash = "furia", storage_capacity = 100.0},
            {make = "Pegassi", model = "Zorrusso", price = 600000, hash = "zorrusso", storage_capacity = 100.0},
            {make = "Benefactor", model = "Krieger", price = 800000, hash = "krieger", storage_capacity = 100.0},
            {make = "Truffade", model = "Thrax", price = 900000, hash = "thrax", storage_capacity = 100.0},
		},
		["Classic"] = {
			{make = "Declasse", model = "Tornado", price = 10250, hash = 464687292, storage_capacity = 150.0},
			{make = "Vapid", model = "Peyote", price = 19700, hash = 1830407356, storage_capacity = 135.0},
			{make = "Lampadati", model = "Casco", price = 69990, hash = 941800958, storage_capacity = 135.0},
			{make = "Pegassi", model = "Monroe", price = 67750, hash = -433375717, storage_capacity = 135.0},
			{make = "Grotti", model = "Turismo Classic", price = 72550, hash = -982130927, storage_capacity = 135.0},
			{make = "Grotti", model = "Stinger", price = 66420, hash = 1545842587, storage_capacity = 115.0},
			{make = "Grotti", model = "Stinger GT", price = 78858, hash = -2098947590, storage_capacity = 135.0},
			{make = "Pegassi", model = "Infernus Classic", price = 73500, hash = -1405937764, storage_capacity = 135.0},
			{make = "Albany", model = "Roosevelt Valor", price = 72985, hash = -602287871, storage_capacity = 135.0},
			{make = "Grotti", model = "Cheetah Classic", price = 63330, hash = 223240013, storage_capacity = 120.0},
			{make = "Invetero", model = "Coquette Classic", price = 56564, hash = 1011753235, storage_capacity = 120.0},
			{make = "Invetero", model = "Coquette Blackfin", price = 51430, hash = 784565758, storage_capacity = 120.0},
			{make = "Dewbauchee", model = "JB 700", price = 67689, hash = 1051415893, storage_capacity = 120.0},
			{make = "Declasse", model = "Mamba", price = 51956, hash = -1660945322, storage_capacity = 110.0},
			{make = "Albany", model = "Manana", price = 15969, hash = -2124201592, storage_capacity = 140.0},
			{make = "Lampadati", model = "Pigalle", price = 21999, hash = 1078682497, storage_capacity = 125.0},
			{make = "Pegassi", model = "Torero", price = 68150, hash = 1504306544, storage_capacity = 100.0},
			{make = "Truffade", model = "ZType", price = 95000, hash = "ztype", storage_capacity = 100.0},
			{make = "Albany", model = "Roosevelt", price = 78000, hash = 117401876, storage_capacity = 100.0},
			{make = "Grotti", model = "GT 500", price = 75932, hash = "gt500", storage_capacity = 100.0},
			{make = "Albany", model = "Hermes", price = 39650, hash = "hermes", storage_capacity = 100.0},
			{make = "Karin", model = "190 Z", price = 35430, hash = "z190", storage_capacity = 100.0},
			{make = "Vulcar", model = "Fagaloa", price = 56320, hash = "fagaloa", storage_capacity = 170.0},
			{make = "Declasse", model = "Tornado 6", price = 35000, hash = -1558399629, storage_capacity = 100.0},
			{make = "Enus", model = "Stafford", price = 75000, hash = 'stafford', storage_capacity = 100.0},
			{make = "BF", model = "Weevil", price = 20000, hash = 'weevil', storage_capacity = 100.0},
			{make = "Dinka", model = "Blista Kanjo", price = 15000, hash = 'kanjo', storage_capacity = 100.0},
			{make = "Karin", model = "Sultan Classic", price = 20000, hash = 'sultan2', storage_capacity = 100.0},
			--{make = "Lampadati", model = "Viseris", price = 75000, hash = "viseris", storage_capacity = 170.0}
			--{make = "Ocelot", model = "Swinger", price = 73000, hash = "swinger", storage_capacity = 100.0}
		},
		["Sedans"] = {
			{make = "Albany", model = "Emperor", price = 3050, hash = -1883002148, storage_capacity = 165.0},
			{make = "Albany", model = "Emperor 2", price = 12076, hash = -685276541, storage_capacity = 165.0},
			{make = "Albany", model = "Washington", price = 7846, hash = 1777363799, storage_capacity = 165.0},
			{make = "Karin", model = "Intruder", price = 7490, hash = 886934177, storage_capacity = 165.0},
			{make = "Vulcar", model = "Ingot", price = 4876, hash = -1289722222, storage_capacity = 165.0},
			{make = "Zinconium", model = "Stratum", price = 5847, hash = 1723137093, storage_capacity = 165.0},
			{make = "Vapid", model = "Stanier", price = 6484, hash = -1477580979, storage_capacity = 165.0},
			{make = "Benefactor", model = "Glendale", price = 15047, hash = 75131841, storage_capacity = 165.0},
			{make = "Vulcar", model = "Warrener", price = 14846, hash = 1373123368, storage_capacity = 165.0},
			{make = "Ubermacht", model = "Oracle", price = 32834, hash = -511601230, storage_capacity = 165.0},
			{make = "Enus", model = "Cognoscenti", price = 64733, hash = -2030171296, storage_capacity = 165.0},
			{make = "Enus", model = "Super Diamond", price = 62247, hash = 1123216662, storage_capacity = 165.0},
			{make = "Albany", model = "Primo", price = 9682, hash = "primo", storage_capacity = 155.0},
			{make = "Albany", model = "Primo Custom", price = 19336, hash = "primo2", storage_capacity = 155.0},
			{make = "Cheval", model = "Fugitive", price = 35000, hash = "fugitive", storage_capacity = 155.0},
			{make = "Benefactor", model = "Schafter", price = 42846, hash = "schafter2", storage_capacity = 155.0},
			{make = "Dundreary", model = "Regina", price = 8937, hash = "regina", storage_capacity = 155.0},
			{make = "Pegassi", model = "Toros", price = 57632, hash = "toros", storage_capacity = 155.0},
			{make = "Bravado", model = "Buffalo", price = 30000, hash = -304802106, storage_capacity = 175.0},
			{make = "Obey", model = "Tailgater", price = 30000, hash = -1008861746, storage_capacity = 155.0},
			{make = "Benefactor", model = "Schafter 2", price = 30000, hash = -1255452397, storage_capacity = 155.0},
			{make = "Ocelot", model = "Jugular", price = 50000, hash = "jugular", storage_capacity = 155.0},
			{make = "Lampadati", model = "Komoda", price = 55000, hash = "komoda", storage_capacity = 155.0},
			{make = "Obey", model = "Tailgater S", price = 60500, hash = "tailgater2", storage_capacity = 125.0},
			{make = "Ubermacht", model = "Revolter", price = 49634, hash = "revolter", storage_capacity = 155.0} -- has miniguns in LSC (disabled)
		},
		["Specials"] = {
			{make = "Dundreary", model = "Stretch", price = 25575, hash = -1961627517, storage_capacity = 300.0},
			{make = "Maibatsu", model = "Mule 3", price = 55432, hash = -2052737935, storage_capacity = 575.0},
			{make = "MTL", model = "Pounder", price = 97452, hash = 2112052861, storage_capacity = 900.0},
			{make = "MTL", model = "Dune", price = 150000, hash = GetHashKey("rallytruck"), storage_capacity = 700.0},
			{make = "Declasse", model = "Burrito Lost", price = 27342, hash = -1745203402, storage_capacity = 260.0},
			{make = "Vapid", model = "Slam Van Lost", price = 29545, hash = 833469436, storage_capacity = 260.0},
			{make = "Declasse", model = "Stallion Special", price = 45956, hash =  -401643538, storage_capacity = 155.0},
			{make = "Bravado", model = "Buffalo Special", price = 45364, hash = 237764926, storage_capacity = 155.0},
			{make = "Vapid", model = "Dominator Special", price = 46868, hash = -915704871, storage_capacity = 155.0},
			{make = "Dewbauchee", model = "Massacro Special", price = 82857, hash = -631760477, storage_capacity = 130.0},
			{make = "Dinka", model = "Jester Special", price = 90765, hash = -1106353882, storage_capacity = 120.0},
			{make = "Vapid", model = "Benson", price = 79573, hash = "benson", storage_capacity = 500.0},
			{make = "Declasse", model = "Hotring Sabre", price = 120000, hash = "hotring", storage_capacity = 90.0},
			{make = "Brute", model = "Tour Bus", price = 40000, hash = 1941029835, storage_capacity = 180.0},
			{make = "Trailer", model = "Open", price = 30000, hash = "cotrailer", storage_capacity = 300.0},
        	{make = "Trailer", model = "Closed", price = 80000, hash = "ctrailer", storage_capacity = 400.0},
		},
		["Electric"] = {
			{make = "Coil", model = "Raider", price = 50000, hash = "raiden", storage_capacity = 150.0},
			{make = "Coil", model = "Voltic", price = 44564, hash = "voltic", storage_capacity = 135.0},
			{make = "Pfister", model = "Neon", price = 58674, hash = "neon", storage_capacity = 135.0},
			{make = "Cheval", model = "Surge", price = 17453, hash = "surge", storage_capacity = 135.0},
			{make = "Coil", model = "Cyclone", price = 84372, hash = "cyclone", storage_capacity = 135.0},
			{make = "Hijak", model = "Khamelion", price = 44637, hash = 544021352, storage_capacity = 145.0},
		},
		["Custom"] = {
			{make = "2016 Dodge", model = "Charger", price = 120000, hash = "16charger", storage_capacity = 160.0},
			{make = "Ford", model = "F150 Raptor", price = 150000, hash = "f150", storage_capacity = 280.0},
			{make = "Ford", model = "F150 (1978)", price = 65000, hash = "f15078", storage_capacity = 280.0},
			{make = "Subaru", model = "WRX STI (2004)", price = 100000, hash = "subwrx", storage_capacity = 160.0},
			{make = "Subaru", model = "WRX STI", price = 115000, hash = "subisti08", storage_capacity = 160.0},
			{make = "Chevy", model = "C8", price = 180000, hash = "stingray", storage_capacity = 130.0},
			{make = "Audi", model = "R8", price = 250000, hash = "r820", storage_capacity = 130.0},
			{make = "Ferrari", model = "F8 Tributo", price = 850000, hash = "f8t", storage_capacity = 130.0},
			{make = "Jeep", model = "SRT8", price = 100000, hash = "srt8", storage_capacity = 185.0},
			{make = "Lamborghini", model = "LP 700 R", price = 850000, hash = "lp700r", storage_capacity = 130.0},
			{make = "Ford", model = "Crown Victoria", price = 30000, hash = "crownvic2011", storage_capacity = 155.0},
			{make = "Tesla", model = "Model X", price = 160000, hash = "teslax", storage_capacity = 185.0},
			{make = "Nissan", model = "GTR", price = 275000, hash = "gtr", storage_capacity = 130.0},
			{make = "Chevy", model = "Camaro", price = 160000, hash = "zl12017", storage_capacity = 130.0},
			{make = "Maserati", model = "Levante Novitec", price = 150000, hash = "mlnovitec", storage_capacity = 185.0},
			{make = "Dodge", model = "Challenger", price = 120000, hash = "16challenger", storage_capacity = 130.0},
			{make = "Audi", model = "RS6", price = 170000, hash = "rs6", storage_capacity = 245.0},
			{make = "Subaru", model = "BRZ", price = 80000, hash = "brz13", storage_capacity = 160.0},
			{make = "Chevy", model = "C7", price = 95000, hash = "c7", storage_capacity = 160.0},
			{make = "Porsche", model = "911 Turbo S", price = 280000, hash = "pts21", storage_capacity = 160.0},
			{make = "Mazda", model = "RX-7", price = 80000, hash = "rx7rb", storage_capacity = 150.0},
			{make = "Toyota", model = "Supra", price = 95000, hash = "rmodsuprapandem", storage_capacity = 160.0},
			{make = "Mercedes", model = "GT63", price = 215000, hash = "rmodgt63", storage_capacity = 175.0},
			{make = "Nissan", model = "240SX", price = 70000, hash = "rmod240sx", storage_capacity = 150.0},
			{make = "Mclaren", model = "600LT", price = 500000, hash = "600lt", storage_capacity = 145.0},
			{make = "Toyota", model = "Supra Mk4", price = 100000, hash = "supra2", storage_capacity = 150.0},
			{make = "Ford", model = "Mustang", price = 100000, hash = "mgt", storage_capacity = 150.0},
			{make = "Chevy", model = "Caprice (Donk)", price = 60000, hash = "trixbox", storage_capacity = 200.0},
			{make = "Chevy", model = "Nova", price = 70000, hash = "nova66", storage_capacity = 180.0},
			{make = "Ferrari", model = "California (1957)", price = 600000, hash = "cali57", storage_capacity = 150.0},
			{make = "Chevrolet", model = "Camaro SS (1969)", price = 70000, hash = "camaro69", storage_capacity = 180.0},
			{make = "Chevrolet", model = "Camaro Z28 (1970)", price = 80000, hash = "camaro70", storage_capacity = 180.0},
			{make = "Volkswagon", model = "Golf GTI", price = 90000, hash = "golfgti", storage_capacity = 175.0},
			{make = "Chevrolet", model = "Impala (1959)", price = 70000, hash = "impala59c", storage_capacity = 250.0},
			{make = "Volkswagon", model = "Golf (MK3)", price = 60000, hash = "mk3", storage_capacity = 200.0},
			{make = "Porsche", model = "911 (1973)", price = 60000, hash = "porrs73", storage_capacity = 165.0},
			{make = "Volkswagon", model = "Type 2 (1962)", price = 50000, hash = "type262", storage_capacity = 165.0},
			{make = "Volkswagon", model = "Type 2 (1963)", price = 50000, hash = "type263", storage_capacity = 165.0},
			{make = "Volkswagon", model = "Type 2 (1966)", price = 50000, hash = "type266", storage_capacity = 165.0},
			{make = "Mercedes-Benz", model = "300 SL", price = 700000, hash = "mb300sl", storage_capacity = 165.0},
			{make = "Chevrolet", model = "Corvette (1970)", price = 50000, hash = "corvette70", storage_capacity = 170.0},
			{make = "Dodge", model = "Viper (1999)", price = 250000, hash = "99viper", storage_capacity = 170.0},
			{make = "Porsche", model = "356", price = 100000, hash = "356ac", storage_capacity = 165.0},
			{make = "Porsche", model = "GT3", price = 280000, hash = "pgt3", storage_capacity = 160.0},
			{make = "Nissan", model = "Skyline (R34)", price = 170000, hash = "skyline", storage_capacity = 175.0},
			{make = "Mazda", model = "Miata", price = 40000, hash = "na6", storage_capacity = 160.0},
			{make = "Chevrolet", model = "Silverado 2500 HD", price = 125000, hash = "silv2500hd", storage_capacity = 300.0},
			{make = "Ford", model = "F350", price = 95000, hash = "wdf350", storage_capacity = 300.0},
			{make = "Chevrolet", model = "Camaro (2002)", price = 50000, hash = "camaro02", storage_capacity = 165.0},
			--{make = "Tesla", model = "Model S", price = 140000, hash = "models", storage_capacity = 170.0},
			{make = "Ford", model = "F150 Raptor 2", price = 140000, hash = "foxraptor", storage_capacity = 280.0},
			{make = "Cadillac", model = "CTS-V (2016)", price = 160000, hash = "ctsv16", storage_capacity = 190.0},
			{make = "Rolls Royce", model = "Cullinan", price = 500000, hash = "cullinan", storage_capacity = 230.0},
			{make = "Harley Davidson", model = "FLHXS (2018)", price = 70000, hash = "flhxs_streetglide_special18", storage_capacity = 95.0},
			{make = "Harley Davidson", model = "Road King", price = 55000, hash = "na25", storage_capacity = 70.0},
			{make = "Mercedes-Benz", model = "E55 AMG", price = 100000, hash = "benze55", storage_capacity = 175.0},
			{make = "Tesla", model = "Model S", price = 125000, hash = "teslamodels", storage_capacity = 190.0},
			{make = "Toyota", model = "4 Runner", price = 70000, hash = "4runner", storage_capacity = 280.0},
			--{make = "Jeep", model = "Gladiator", price = 70000, hash = "jeepg", storage_capacity = 280.0}, -- bulletproof
			{make = "Chevrolet", model = "Silverado (Single Cab)", price = 70000, hash = "silv20", storage_capacity = 280.0},
			{make = "GMC", model = "Sierra (2006)", price = 80000, hash = "polar06seirra", storage_capacity = 280.0},
			{make = "Chevrolet", model = "Tahoe (2008)", price = 80000, hash = "tahoe08", storage_capacity = 250.0},
			{make = "Nissan", model = "240SX (s14)", price = 75000, hash = "silvia3", storage_capacity = 150.0},
			{make = "Volkswagon", model = "Golf (Mk6)", price = 75000, hash = "golfmk6", storage_capacity = 200.0},
			{make = "Ford", model = "F-150 SVT Lightning (1999)", price = 70000, hash = "flightning99", storage_capacity = 400.0},
			{make = "Dodge", model = "Ram SRT-10", price = 140000, hash = "ramsrt10", storage_capacity = 400.0},
			{make = "BMW", model = "M8", price = 340000, hash = "bmwm8", storage_capacity = 180.0},
			{make = "Peugeot", model = "206 GTi", price = 30000, hash = "peugeot206", storage_capacity = 175.0},
			{make = "Subaru", model = "WRX STI (2017)", price = 105000, hash = "sti17", storage_capacity = 230.0},
			{make = "Lamborghini", model = "Diablo GTR (1999)", price = 975000, hash = "500gtrlam", storage_capacity = 120.0},
			{make = "Mercedes", model = "S63 AMG Cabriolet (2017)", price = 190000, hash = "mers63c", storage_capacity = 185.0},
			{make = "Can Am", model = "Maverick (2018)", price = 70000, hash = "can", storage_capacity = 100.0},
			{make = "Audi", model = "RS6 Avant (2020)", price = 160000, hash = "rs62", storage_capacity = 285.0},
			{make = "Chrysler", model = "Pacifica Limited S (2020)", price = 45000, hash = "pacificasb", storage_capacity = 375.0},
			{make = "BMW", model = "BMW 1100R Street Fighter", price = 80000, hash = "BMW1100R", storage_capacity = 20.0},
			{make = "BMW", model = "BMW S1000RR (2016)", price = 90000, hash = "BMWS1000RR", storage_capacity = 20.0},
			{make = "Ford", model = "Hula Girl (1932)", price = 60000, hash = "ford32hulagirl", storage_capacity = 160.0},
			{make = "Ford", model = "GT500 (1967)", price = 130000, hash = "67GT500", storage_capacity = 140.0},
			{make = "Bugatti", model = "Veyron Super Sport (2011)", price = 3900000, hash = "supersport", storage_capacity = 120.0},
			{make = "Volkswagen", model = "Passat (2016)", price = 60000, hash = "passat", storage_capacity = 190.0},
			{make = "Honda", model = "Civic Type-R (2018)", price = 90000, hash = "FK8", storage_capacity = 190.0},
			{make = "BMW", model = "i4 (2020)", price = 80000, hash = "ocni422spe", storage_capacity = 190.0},
			{make = "Weeny", model = "Tamworth", price = 28000, hash = "tamworth", storage_capacity = 120.0},
            {make = "Mercedes", model = "G-Class Brabus", price = 180000, hash = "w463a1", storage_capacity = 280.0},
            {make = "Mercedes", model = "S650 Maybach (2019)", price = 220000, hash = "19S650", storage_capacity = 220.0},
            {make = "Bentley", model = "Bentayga (2016)", price = 200000, hash = "bbentayga", storage_capacity = 280.0},
            {make = "Rolls Royce", model = "Wraith (2016)", price = 400000, hash = "wraith", storage_capacity = 220.0},
            {make = "Koenigsegg", model = "Agera RS (2017)", price = 3700000, hash = "agerars", storage_capacity = 120.0},
            {make = "Honda", model = "Civic Type-R (2001)", price = 60000, hash = "ep3", storage_capacity = 190.0},
            {make = "Toyota", model = "Sprinter Trueno GT Apex (AE86) (1985)", price = 78000, hash = "ae86", storage_capacity = 160.0},
            {make = "Chevrolet", model = "Caprice Nip Donk (1973)", price = 90000, hash = "brainshack", storage_capacity = 160.0},
			{make = "Chevrolet", model = "Impala SS (1996)", price = 58000, hash = "impala", storage_capacity = 160.0},
            {make = "Chevrolet", model = "C-10 Stepside Custom", price = 90000, hash = "c10custom", storage_capacity = 190.0},
            {make = "Chevrolet", model = "Silverado (1986)", price = 56000, hash = "SILV86", storage_capacity = 190.0},
            {make = "Ford", model = "Galaxie", price = 62000, hash = "galaxie", storage_capacity = 160.0},
            {make = "GMC", model = "CadimaX 3500HD (2018)", price = 150000, hash = "GODzBGDCADIMAX", storage_capacity = 190.0},
            {make = "Cadillac", model = "Escalade (2021)", price = 130000, hash = "21escalade", storage_capacity = 190.0},
            {make = "Chevrolet", model = "Camaro (2021)", price = 150000, hash = "21camaro", storage_capacity = 160.0},
            {make = "Declasse", model = "Silver-Star", price = 70000, hash = "silverstar", storage_capacity = 210.0},
			{make = "Declasse", model = "Silver-Star (Lowrider)", price = 100000, hash = "silverstar2", storage_capacity = 210.0},
			{make = "Ford", model = "V-8 Coupé (1932)", price = 70000, hash = "fordc32", storage_capacity = 160.0},
            {make = "Ford", model = "V-8 Coupé 2 (1932)", price = 80000, hash = "fordc32h", storage_capacity = 160.0},
            {make = "Datsun", model = "Bluebird 910 SSS (1982)", price = 60000, hash = "datsun910", storage_capacity = 180.0},
            {make = "Porsche", model = "928 GTS (1993)", price = 60000, hash = "928gts", storage_capacity = 160.0},
            {make = "Maserati", model = "GranTurismo (2016)", price = 200000, hash = "stradale18", storage_capacity = 160.0},
            {make = "Lexus", model = "LC 500 (2020)", price = 155000, hash = "lc500", storage_capacity = 160.0},
            {make = "Land Rover", model = "Range Rover Vogue Mansory (2020)", price = 240000, hash = "mansrr", storage_capacity = 280.0},
            {make = "Lincoln", model = "Continental (Custom Wheels) (2020)", price = 90000, hash = "cont", storage_capacity = 220.0},
            {make = "Ford", model = "F-450 Platinum (2021)", price = 170000, hash = "f450plat", storage_capacity = 400.0},
			{make = "Ford", model = "Bronco Wildtrak (2021)", price = 140000, hash = "wildtrak", storage_capacity = 300.0},
        	{make = "Chevrolet", model = "Hoonigan K5 Blazer (1979)", price = 150000, hash = "k5", storage_capacity = 220.0},
		}
	}
}

local BIKES = {
	["BMX"] = { price = 250, hash = 1131912276},
	["Cruiser"] = { price = 300, hash = 448402357},
	["Fixster"] = { price = 350, hash = -836512833},
	["Scorcher"] = { price = 500, hash = -186537451},
	["TriBike"] = { price = 550, hash = 1127861609},
	["Low Rider Bike"] = { price = 3000, hash = GetHashKey("lowriderb")}
}

RegisterServerEvent("vehicle-shop:loadItems")
AddEventHandler("vehicle-shop:loadItems", function()
	TriggerClientEvent("vehicle-shop:loadItems", source, vehicleShopItems)
end)

RegisterServerEvent("mini:checkVehicleMoney")
AddEventHandler("mini:checkVehicleMoney", function(vehicle, business)
	local playerIdentifier = GetPlayerIdentifiers(source)[1]
	local char = exports["usa-characters"]:GetCharacter(source)
	local license = char.getItem("Driver's License")
	local vehicles = char.get("vehicles")
	local money = char.get("bank")
	local owner_name = char.getFullName()
	if license and license.status == "valid" then
		local hash = vehicle.hash
		local price = tonumber(GetVehiclePrice(vehicle))
		if price <= money then
			local plate = generate_random_number_plate()
			if vehicles then
				char.removeBank(price)
				local vehicle = {
					owner = owner_name,
					make = vehicle.make,
					model = vehicle.model,
					hash = hash,
					plate = plate,
					stored = false,
					price = price,
					inventory = exports["usa_vehinv"]:NewInventory(vehicle.storage_capacity),
					storage_capacity = vehicle.storage_capacity
				}

				local vehicle_key = {
					name = "Key -- " .. plate,
					quantity = 1,
					type = "key",
					owner = owner_name,
					make = vehicle.make,
					model = vehicle.model,
					plate = plate
				}

				table.insert(vehicles, vehicle.plate)
				char.set("vehicles", vehicles)
				char.giveItem(vehicle_key, 1)
				AddVehicleToDB(vehicle)

				TriggerEvent("lock:addPlate", vehicle.plate)
				TriggerClientEvent("usa:notify", source, "Here are the keys! Thanks for your business!", "Purchased a " .. vehicle.make .. " " .. vehicle.model .. " for $" .. exports.globals:comma_value(vehicle.price))
				TriggerClientEvent("vehShop:spawnPlayersVehicle", source, hash, plate)

				if business then
					exports["usa-businesses"]:GiveBusinessCashPercent(business, price)
				end
			end
		else
			TriggerClientEvent("usa:notify", source, "Not enough money in bank to purchase!")
		end
	else
		TriggerClientEvent("usa:notify", source, "Come back when you have a valid driver's license!")
	end
end)

RegisterServerEvent("vehShop:loadVehiclesToSell")
AddEventHandler("vehShop:loadVehiclesToSell", function()
	local usource = source
	local char = exports["usa-characters"]:GetCharacter(source)
	local vehicles = char.get("vehicles")
	local endpoint = "/vehicles/_design/vehicleFilters/_view/getVehiclesToSellWithPlates"
	local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
	PerformHttpRequest(url, function(err, responseText, headers)
		if responseText then
			local responseVehArray = {}
			local data = json.decode(responseText)
			if data.rows then
				for i = 1, #data.rows do
					local veh = {
						plate = data.rows[i].value[1], -- plate
						make = data.rows[i].value[2], -- make
						model = data.rows[i].value[3], -- model
						price = data.rows[i].value[4], -- price
						_rev = data.rows[i].value[5] -- _rev
					}
					table.insert(responseVehArray, veh)
				end
			end
			TriggerClientEvent("vehShop:displayVehiclesToSell", usource, responseVehArray)
		end
	end, "POST", json.encode({
		keys = vehicles
	}), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
end)

RegisterServerEvent("vehShop:sellVehicle")
AddEventHandler("vehShop:sellVehicle", function(toSellVehicle)
	local usource = source
	print("toSellVehicle: " .. toSellVehicle.model)
	local vehiclePrice = GetVehiclePrice(toSellVehicle)
	if not vehiclePrice then
		if toSellVehicle.price then
			print("vehicle price nil with toSellVehicle: " .. toSellVehicle.make .. " " .. toSellVehicle.model)
			TriggerClientEvent("chatMessage", usource, "", {}, "^3CAR DEALER: ^0We're not interested in it, sorry.")
		end
		return
	end
	local char = exports["usa-characters"]:GetCharacter(usource)
	local vehicles = char.get("vehicles")
	for i = 1, #vehicles do
		if vehicles[i] == toSellVehicle.plate then
			table.remove(vehicles, i)
			char.set("vehicles", vehicles)
			break
		end
	end
	-- remove from DB / take money --
	RemoveVehicleFromDB(toSellVehicle, function(err, resp)
		char.giveMoney(math.ceil(vehiclePrice * .30))
		TriggerClientEvent("usa:notify", usource, "~y~SOLD:~w~ " .. toSellVehicle.make .. " " .. toSellVehicle.model .. "\n~y~PRICE: ~g~$" .. exports.globals:comma_value(.30 * toSellVehicle.price))
	end)
end)

function GetVehiclePrice(vehicle)
	if vehicle.model ~= "Bicycle" then
		for k, v in pairs(vehicleShopItems["vehicles"]) do
			for i = 1, #v do
				local name1 = vehicle.make .. " " .. vehicle.model
				local name2 = v[i].make .. " " .. v[i].model
				if name1 == name2 then
					return v[i].price
				end
			end
		end
	else -- bike
		return BIKES[vehicle.make].price
	end
end

function generate_random_number_plate()
	local charset = {
		numbers = {},
		letters = {}
	}
	-- QWERTYUIOPASDFGHJKLZXCVBNM1234567890
	for i = 48,  57 do table.insert(charset.numbers, string.char(i)) end -- add numbers 1 - 9
	for i = 65,  90 do table.insert(charset.letters, string.char(i)) end -- add capital letters
	local number_plate = ""
	number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
	number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
	number_plate = number_plate .. charset.letters[math.random(#charset.letters)] -- letter
	number_plate = number_plate .. charset.letters[math.random(#charset.letters)] -- letter
	number_plate = number_plate .. charset.letters[math.random(#charset.letters)] -- letter
	number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
	number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
	number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
	return number_plate
end

-- Insert new vehicle into DB --
function AddVehicleToDB(vehicle)
	TriggerEvent('es:exposeDBFunctions', function(couchdb)
		couchdb.createDocumentWithId("vehicles", vehicle, vehicle.plate, function(success)
			if success then
				--print("* Vehicle created in DB!! *")
			else
				--print("* Error: vehicle was not created in DB!! *")
			end
		end)
	end)
end

-- Delete vehicle from DB --
function RemoveVehicleFromDB(vehicle, cb)
	PerformHttpRequest("http://127.0.0.1:5984/".."vehicles".."/".. vehicle.plate .."?rev=" .. vehicle._rev, function(err, rText, headers)
		RconPrint("\nerr = " .. err)
		RconPrint("\nrText = " .. rText)
		cb(err, rText)
	end, "DELETE", "", {["Content-Type"] = 'application/json', ['Authorization'] = "Basic " .. exports["essentialmode"]:getAuth() })
end
