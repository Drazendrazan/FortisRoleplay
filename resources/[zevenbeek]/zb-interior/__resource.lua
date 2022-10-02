resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
	'client/main.lua',
	'client/shells.lua',
	'client/furnished.lua',
}
 
files {
	'playerhouse_hotel/playerhouse_hotel.ytyp',
	'stream/playerhouse_hotel/playerhouse_hotel.ytyp',
	'stream/playerhouse_hotel/playerhouse_hote2.ytyp',
	'stream/playerhouse_tier3/playerhouse_tier3.ytyp',
	'stream/pinkcage/gabz_pinkcage.ytyp',
	'stream/playerhouse_appartment_motel/playerhouse_appartment_motel.ytyp',
	'stream/micheal_shell/micheal_shell.ytyp',
	'stream/trevors_shell/trevors_shell.ytyp',
	'stream/gunshop_shell/gunshop_shell.ytyp',
	'stream/traphouse_shell/traphouse_shell.ytyp',
	'stream/appartment/appartment.ytyp',
	'stream/caravan_shell/caravan.ytyp',
	'stream/frankelientje/frankelientje.ytyp',
	'stream/tante_shell/tante.ytyp',
	'stream/methlab_shell/methlab_shell.ytyp',
	'steam/classichouse_shell/shellpropsv19.ytyp',
	'stream/extra_shell/shellprops.ytyp',
	'stream/extra_shell/shellpropsv2.ytyp',
	'stream/extra_shell/shellpropsv3.ytyp',
	'stream/extra_shell/shellpropsv4.ytyp',
	'stream/extra_shell/shellpropsv5.ytyp',
	'stream/extra_shell/shellpropsv8.ytyp',
	'stream/extra_shell/shellpropsv10.ytyp', 
	'stream/extra_shell/starter_shells_k4mb1.ytyp',
}

data_file 'DLC_ITYP_REQUEST' 'stream/v_int_20.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/playerhouse_hotel/playerhouse_hotel.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/playerhouse_tier1/playerhouse_tier1.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/playerhouse_tier1/playerhouse_tier2.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/playerhouse_tier3/playerhouse_tier3.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/playerhouse_appartment_motel/playerhouse_appartment_motel.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/micheal_shell/micheal_shell.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/trevors_shell/trevors_shell.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gunshop_shell/gunshop_shell.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/traphouse_shell/traphouse_shell.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/appartment/appartment.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/caravan_shell/caravan.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/frankelientje/frankelientje.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/tante_shell/tante.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/methlab_shell/methlab_shell.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/pinkcage/gabz_pinkcage.ytyp'
data_file 'DLC_ITYP_REQUEST' 'steam/classichouse_shell/shellpropsv19.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/extra_shell/shellpropsv2.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/extra_shell/shellprops.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/extra_shell/shellpropsv3.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/extra_shell/shellpropsv4.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/extra_shell/shellpropsv5.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/extra_shell/shellpropsv8.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/extra_shell/shellpropsv10.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/extra_shell/starter_shells_k4mb1.ytyp'


exports {
	'DespawnInterior',
	'CreateHotel',
	'CreateTier1House',
	'CreateTier2House',
	'CreateTier3House',
	'CreateMichaelShell',
	'CreateTrevorsShell',
	'CreateLesterShell',
	'CreateGunshopShell',
	'CreateTrapHouseShell',
	'CreateMethlabShell',
	
	'CreateApartmentShell',
	'CreateCaravanShell',
	'CreateFranklinShell',
	'CreateFranklinAuntShell',

	'CreateTier1HouseFurnished',
	'CreateHotelFurnished',
	'CreateApartmentFurnished',
	'CreateClassicHouse',
	'CreateClassicHouse2',
	'CreateClassicHouse3',
	'CreateHighEndV2',
	'CreateHighEnd',
	'CreateBarber',
	'CreateOffice1',
	'CreateLesterOsso',
	'CreateWarehouse1',
	'CreateWarehouse2',
	'CreateWarehouse3',
	'CreateGarageHigh',
	'CreateGarageMed',
	'CreateGarageLow',
	'CreateGunstore',
	'CreateMedium2',
	'CreateOfficeBig',
	'CreateStore2',
	'CreateStore3',
	'CreateContainer',
}
client_script '@zb-guard/03923.lua'