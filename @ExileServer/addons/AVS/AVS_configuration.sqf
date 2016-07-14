/*
© 2015 Zenix Gaming Ops
Developed by Rod-Serling and Vishpala

All rights reserved.

Function:
	AVS_configuration - Defines the configuration for AVS.
*/

AVS_Debug = false;

// This array contains world center and radius for maps supported.
AVS_WorldInfo =
[
    ["Altis", [15350, 15350, 0], 15350],
    ["Esseker", [6150,6150,0], 6150],
    ["Chernarus", [7700,8500,0], 11000],
	["Lingor3", [4968.00,4938.00,0], 10000]
];

//**************************************************************

// Setting this to true will disable thermal for all vehicles.
AVS_DisableVehicleThermalGlobal = true;

// If the above is not set to true, then this will disable thermal for specific classes of vehicles.
AVS_DisableVehicleThermal =
[
//	"VehicleClassName"
];

// Setting this to true will disable NVGs for all vehicles.
AVS_DisableVehicleNVGsGlobal = false;

// If the above is not set to true, then this will disable thermal for specific classes of vehicles.
AVS_DisableVehicleNVG =
[
//	"VehicleClassName"
];

// Any weapon classes listed here will be sanitized from all vehicles.
AVS_GlobalWeaponBlacklist =
[
//	"WeaponClassName"
	"missiles_DAR", 				// Removes DAR missiles from all vehicles
	"missiles_DAGR"
];

// Any ammo classes listed here will be sanitized from all vehicles.
AVS_GlobalAmmoBlacklist =
[
//	"AmmoClassName"
	"24Rnd_missiles",
	"12Rnd_PG_missiles"
];

// You may remove specific weapon classes from specific vehicle classes here.
AVS_VehicleWeaponBlacklist =
[
//	["VehicleClassName", ["WeaponClassName1", "WeaponClassName2", ...]]
];

// You may remove specific ammo classes from specific vehicle classes here.
AVS_VehicleAmmoBlacklist =
[
//	["VehicleClassName", ["AmmoClassName1", "AmmoClassName2", ...]]
];

//**************************************************************

// Set to false to disable the entire rearm system.
AVS_RearmSystemActive = true;

// Distance away from an object to get the rearm option.
AVS_RearmDistance = 10;

// Number of seconds it takes to rearm. (NOT YET IMPLEMENTED)
AVS_RearmTime = 15;

// Disabled rearming at ammo trucks.
AVS_DisableStockRearm = true;

// Objects of this type will give the "rearm" action.
AVS_RearmObjects =
[
//	"ClassName"
	//"Land_fs_feed_F"	// Gas station pump.
	"Land_Hangar_F",
	"Land_TentHangar_V1_F",
	"Land_HelipadSquare_F",
	"Land_HelipadCircle_F"
];

// Default cost of a magazine if not found in AVS_RearmCosts
AVS_RearmCostDefault = 99999999;

// Costs of individual magazines.
AVS_RearmCosts =
[
//	["MagazineClassName", cost]
	["Laserbatteries", 0],								// Laser Designator Batteries
	["SmokeLauncherMag", 20],							// Smoke CM magazine
	["200Rnd_127x99_mag_Tracer_Yellow", 400],			// Strider HMG gun
	["200Rnd_127x99_mag_Tracer_Red", 400],				// Hunter HMG gun
	["168Rnd_CMFlare_Chaff_Magazine", 20],				// Helicopter flares
	["2000Rnd_65x39_Belt_Tracer_Red", 4000],			// Ghosthawk & Huron guns
	["100Rnd_127x99_mag_Tracer_Yellow", 200],			// Armed Offroad magazine.
	["5000Rnd_762x51_Belt", 6000],						// Pawnee belt
	["5000Rnd_762x51_Yellow_Belt", 6000],				// Hellcat belt
	["2000Rnd_65x39_Belt_Tracer_Green_Splash", 4000],	// Orca belt
	["200Rnd_762x51_Belt_Green", 500],					// BRDM2_HQ
	["50Rnd_127x107_DSHKM_M", 350],						// BTR40_MG
	["2000Rnd_762x51_Belt", 2400]						// HMMWV_M134
];

//**************************************************************

// Disabled stock refueling at fuel trucks / gas pumps.
AVS_DisableStockRefuel = true;

// Use AVS Refuel System
AVS_RefuelSystemActive = true;

// Use AVS to fill Fuel-Canister with AVS Refuel Objects (Gas Station Pump). It's active only if AVS Refuel System is active too.

AVS_RefuelObjects =
[
	"Land_fs_feed_F" // Gas Station Pump
];

AVS_FuelCost = 5;					// 5 poptabs/liter
AVS_RefuelSpeed = 3;				// 3 liters/second (for ground vehicles, small tank)
AVS_RefuelSpeedAirVehicle = 20;		// 20 liters/second (for air vehicles, big tank so need to be faster)

//**************************************************************

AVS_DebugMarkers = false;
AVS_PersistentVehiclesPinCode = "0000";
AVS_PersistentVehiclesAmmoPercent = 0; // 100 = full ammo, 50 = half ammo, 0 = no ammo
AVS_PersistentVehiclesFuelPercent = 25; // 100 = full, 50 = half, 0 = empty

//**************************************************************

AVS_useSpawnedPersistentVehiclesLocation = false; // Spawns persistent vehicles at specified locations
AVS_LocationSearchRadius = 50; // Set to 0 for exact positioning.
AVS_spawnedPersistentVehiclesLocation =
[
	//["ID Tag", ["ClassName", "ClassName", ...], [DamageMin, DamageMax], NumberToPersist, [[Location1], [Location2], ...]]
	// NOTE: ID Tag is how AVS tracks how many to persist. If there's 5 vehicles with the ID tag "RandomVehicles" then no more will spawn here.
	["RandomVehicles", ["I_MRAP_03_hmg_F", "B_Heli_Light_01_armed_F"], [0.1, 0.75], 5, [[14909.1,16462.8,0.00143814], [15086.6,16636.2,0.00144386]]],
	// OR
	//["ID Tag", ["ClassName", "ClassName", ...], Damage, NumberToPersist, [[Location1], [Location2], ...]]
	["RandomHeli", ["B_Heli_Light_01_armed_F"], 0.25, 2, [[15186.8,16741.9,0.00143814]]]
];

//**************************************************************

AVS_useSpawnedPersistentVehiclesRoadside = false; // Spawns persistent vehicles near roads.
AVS_RoadSearchRadius = 200; // Max distance to the road
AVS_spawnedPersistentVehiclesRoadside =
[
	//["ID Tag", ["Class1", "Class2"], [DamageMin, DamageMax], NumberToPersist],
	// OR
	//["ID Tag", ["Class1", "Class2"], Damage, NumberToPersist]
];

//**************************************************************

AVS_useSpawnedPersistentVehiclesRandom = false; // Spawns persistent vehicles completely randomly.
AVS_spawnedPersistentVehiclesRandom =
[
	//["ID Tag", ["Class1", "Class2"], [DamageMin, DamageMax], NumberToPersist],
	// OR
	//["ID Tag", ["Class1", "Class2"], Damage, NumberToPersist]
];
