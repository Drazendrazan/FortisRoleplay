QB = {}

QB.Doors = {
	-- Los Santos HB
	-- Begane Grond
	-- Glazen personeelspoort links
	{
		textCoords = vector3(445.77, -974.16, 30.72),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'T1JNES_MRPD_GLASSDOORGATE',
				--objYaw = -135.0,
				objCoords = vector3(445.72, -973.90, 30.72),			
			},
			{
				objName = 'T1JNES_MRPD_GLASSDOORGATE',
				--objYaw = 45.0,
				objCoords = vector3(445.71, -974.25, 30.72)			
			}
		}
	},
	-- Glazen personeelspoort rechts (2x)
	{
		textCoords = vector3(445.71, -986.35, 30.72),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'T1JNES_MRPD_GLASSDOORGATE',
				--objYaw = -135.0,
				objCoords = vector3(445.72, -986.14, 30.72),			
			},
			{
				objName = 'T1JNES_MRPD_GLASSDOORGATE',
				--objYaw = 45.0,
				objCoords = vector3(445.66, -986.51, 30.72)			
			}
		}
	},
	{
		textCoords = vector3(445.83, -994.26, 30.72),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'T1JNES_MRPD_GLASSDOORGATE',
				--objYaw = -135.0,
				objCoords = vector3(445.74, -994.04, 30.72),			
			},
			{
				objName = 'T1JNES_MRPD_GLASSDOORGATE',
				--objYaw = 45.0,
				objCoords = vector3(445.72, -994.43, 30.72)			
			}
		}
	},
	-- 1.03 Persruimte
	{
		textCoords = vector3(438.70, -994.28, 30.72),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'T1JNES_MRPD_DOOR01',
				objYaw = 90.0,
				objCoords = vector3(438.45, -994.67, 30.72),			
			},
			{
				objName = 'T1JNES_MRPD_DOOR01',
				objYaw = 270.0,
				objCoords = vector3(438.63, -993.71, 30.72)			
			}
		}
	},
	-- Dubbele deuren buitenkant rechts
	{
		textCoords = vector3(441.53, -998.87, 30.72),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'T1JNES_MRPD_ENTRANCEDOOR',
				--objYaw = -135.0,
				objCoords = vector3(440.89, -998.84, 30.72),			
			},
			{
				objName = 'T1JNES_MRPD_ENTRANCEDOOR',
				--objYaw = 45.0,
				objCoords = vector3(442.06, -998.86, 30.72)			
			}
		}
	},	
	-- Dubbele deuren buitenkant links
	{
		textCoords = vector3(457.05, -972.03, 30.72),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'T1JNES_MRPD_DOOR05',
				objYaw = -180.0,
				objCoords = vector3(457.39, -972.02, 30.72),			
			},
			{
				objName = 'T1JNES_MRPD_DOOR05',
				objYaw = 0.0,
				objCoords = vector3(456.61, -971.95, 30.72)			
			}
		}
	},	
	-- Beneden verdieping
	-- Hek aan de achterkant
	{
		objName = 'hei_prop_station_gate',
		objYaw = 90.0,
		objCoords  = vector3(488.8, -1017.2, 27.1),
		textCoords = vector3(488.44, -1019.99, 28.04),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 10,
		size = 2
	},
	-- 0.01 Garage 
	{
		objName = 'T1JNES_MRPD_DOOR03',
		objYaw = 270.0,
		objCoords  = vector3(463.08, -997.28, 27.48),
		textCoords = vector3(463.08, -997.15, 27.48),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	-- 0.03 Verwerking 
	{
		objName = 'T1JNES_MRPD_DOOR02',
		objYaw = 360.0,
		objCoords  = vector3(457.47, -999.48, 27.48),
		textCoords = vector3(457.47, -999.48, 27.48),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	-- 0.03 Verwerking 2
	{
		objName = 'T1JNES_MRPD_DOOR02',
		objYaw = 90.0,
		objCoords  = vector3(451.08, -1002.46, 27.49),
		textCoords = vector3(451.08, -1002.56, 27.49),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	-- 0.02 Bewijskluis
	{
		objName = 'T1JNES_MRPD_DOORARMORY',
		objYaw = 180.0,
		objCoords  = vector3(457.40, -990.38, 27.48),
		textCoords = vector3(457.40, -990.38, 27.48),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	-- 0.06 Verhoorkamer 1
	{
		objName = 'T1JNES_MRPD_DOOR03',
		objYaw = 180.0,
		objCoords  = vector3(445.25, -990.44, 27.48),
		textCoords = vector3(445.25, -990.44, 27.48),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1,
		size = 2
	},
	-- 0.07 Verhoorkamer 2
	{
		objName = 'T1JNES_MRPD_DOOR03',
		objYaw = 180.0,
		objCoords  = vector3(441.68, -990.37, 27.48),
		textCoords = vector3(441.68, -990.37, 27.48),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1,
		size = 2
	},
	-- 0.08 Verhoorkamer 3
	{
		objName = 'T1JNES_MRPD_DOOR03',
		objYaw = 180.0,
		objCoords  = vector3(438.00, -990.32, 27.48),
		textCoords = vector3(438.00, -990.32, 27.48),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1,
		size = 2
	},
	-- Celldeuren 001 t/m 006
	{
		objName = 'T1JNES_MRPD_CELLDOOR',
		objYaw = 270.0,
		objCoords  = vector3(436.21, -994.99, 27.48),
		textCoords = vector3(436.21, -994.99, 27.48),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	{
		objName = 'T1JNES_MRPD_CELLDOOR',
		objYaw = 270.0,
		objCoords  = vector3(436.09, -998.46, 27.48),
		textCoords = vector3(436.09, -998.46, 27.48),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	{
		objName = 'T1JNES_MRPD_CELLDOOR',
		objYaw = 270.0,
		objCoords  = vector3(436.09, -1001.92, 27.48),
		textCoords = vector3(436.09, -1001.92, 27.48),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	{
		objName = 'T1JNES_MRPD_CELLDOOR',
		objYaw = 90.0,
		objCoords  = vector3(440.20, -1001.95, 27.48),
		textCoords = vector3(440.20, -1001.95, 27.48),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	{
		objName = 'T1JNES_MRPD_CELLDOOR',
		objYaw = 90.0,
		objCoords  = vector3(440.27, -998.40, 27.48),
		textCoords = vector3(440.27, -998.40, 27.48),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	{
		objName = 'T1JNES_MRPD_CELLDOOR',
		objYaw = 90.0,
		objCoords  = vector3(440.19, -994.93, 27.48),
		textCoords = vector3(440.19, -994.93, 27.48),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	-- 1e verdieping
	-- 2.04 Wapenkamer
	{
		objName = 'T1JNES_MRPD_DOOR03',
		objYaw = 360.0,
		objCoords  = vector3(443.17, -985.52, 34.30),
		textCoords = vector3(443.17, -985.52, 34.30),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	--
	--
	-- Bureau Paleto Bay
	{
		textCoords = vector3(-435.57, 6008.76, 27.98),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_ph_gendoor002',
				objYaw = -135.0,
				objCoords = vector3(-436.5157, 6007.844, 28.13839),			
			},
			{
				objName = 'v_ilev_ph_gendoor002',
				objYaw = 45.0,
				objCoords = vector3(-434.6776, 6009.681, 28.13839)			
			}
		}
	},	
	-- Achterdeur links
	{
		objName = 'v_ilev_rc_door2',
		objYaw = 135.0,
		objCoords  = vector3(-450.9664, 6006.086, 31.99004),		
		textCoords = vector3(-451.38, 6006.55, 31.84),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	-- Achterdeur rechts
	{
		objName = 'v_ilev_rc_door2',
		objYaw = -45.0,
		objCoords  = vector3(-447.2363, 6002.317, 31.84003),		
		textCoords = vector3(-446.77, 6001.84, 31.68),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	
	-- Wapenkamer
	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = -135.0,
		objCoords  = vector3(-439.1576, 5998.157, 31.86815),						
		textCoords = vector3(-438.64, 5998.51, 31.71), 
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},	
	-- Verhoorkamer
	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = 45.0,
		objCoords  = vector3(-436.6276, 6002.548, 28.14062),							
		textCoords = vector3(-437.09, 6002.100, 27.98),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	-- Entree cellen 1
	{
		objName = 'v_ilev_ph_cellgate1',
		objYaw = 45.0,
		objCoords  = vector3(-438.228, 6006.167, 28.13558),							
		textCoords = vector3(-438.610, 6005.64, 27.98),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	-- Entree cellen 2
	{
		objName = 'v_ilev_ph_cellgate1',
		objYaw = 45.0,
		objCoords  = vector3(-442.1082, 6010.052, 28.13558),							
		textCoords = vector3(-442.55, 6009.61, 27.98),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},	
	-- Cel
	{
		objName = 'v_ilev_ph_cellgate1',
		objYaw = 45.0,
		objCoords  = vector3(-444.3682, 6012.223, 28.13558),								
		textCoords = vector3(-444.77, 6011.74, 27.98),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},						
	-- Gang lockers (dubbele deuren)
	{
		textCoords = vector3(-442.09, 6011.93, 31.86523),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = 225.0,
				objCoords  = vector3(-441.0185, 6012.795, 31.86523),			
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = 45.0,
				objCoords  = vector3(-442.8578, 6010.958, 31.86523)			
			}
		}
	},	
	-- Gang naar achterkant (dubbele deuren)
	{
		textCoords = vector3(-448.67, 6007.52, 31.86523),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = 135.0,
				objCoords = vector3(-447.7283, 6006.702, 31.86523),				
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = -45.0,
				objCoords = vector3(-449.5656, 6008.538, 31.86523)		
			}
		}
	},				
	--
	-- Bolingbroke Penitentiary
	--
	-- Entrance (Two big gates)
	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1844.9, 2604.8, 44.6),
		textCoords = vector3(1844.9, 2608.5, 48.0),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 13,
		size = 2,
		gevangenis1 = true
	},
	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1818.5, 2604.8, 44.6),
		textCoords = vector3(1818.5, 2608.4, 48.0),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 13,
		size = 2,
		gevangenisFull = true
	},
	{
		objName = 'prop_gate_prison_01',
		objCoords = vector3(1799.237, 2616.303, 44.6),
		textCoords = vector3(1795.941, 2616.969, 48.0),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 10,
		size = 2,
		gevangenisFull = true
	},


	--outside doors
	{
		objName = 'prop_fnclink_03gate5',
		objCoords = vector3(1796.322, 2596.574, 45.565),
		textCoords = vector3(1796.322, 2596.574, 45.965),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2,
		gevangenisFull = true
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords = vector3(1821.677, 2477.265, 45.945),
		textCoords = vector3(1821.677, 2477.265, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2,
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords = vector3(1760.692, 2413.251, 45.945),
		textCoords = vector3(1760.692, 2413.251, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords = vector3(1543.58, 2470.252, 45.945),
		textCoords = vector3(1543.58, 2470.25, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords = vector3(1659.733, 2397.475, 45.945),
		textCoords = vector3(1659.733, 2397.475, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords = vector3(1537.731, 2584.842, 45.945),
		textCoords = vector3(1537.731, 2584.842, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords  = vector3(1571.964, 2678.354, 45.945),
		textCoords = vector3(1571.964, 2678.354, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords  = vector3(1650.18, 2755.104, 45.945),
		textCoords = vector3(1650.18, 2755.104, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords  = vector3(1771.98, 2759.98, 45.945),
		textCoords = vector3(1771.98, 2759.98, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords  = vector3(1845.7, 2699.79, 45.945),
		textCoords = vector3(1845.7, 2699.79, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	{
		objName = 'v_ilev_gtdoor',
		objCoords  = vector3(1820.68, 2621.95, 45.945),
		textCoords = vector3(1820.68, 2621.95, 45.945),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		size = 2
	},
	--
	-- Bolingbroke Extra
	--
	-- To Offices
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 90.0,
		objCoords  = vector3(1819.129, 2593.64, 46.09929),
		textCoords = vector3(1843.3, 2579.39, 45.98),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},

	--To Changingroom
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 360.0,
		objCoords  = vector3(1827.365, 2587.547, 46.09929),
		textCoords = vector3(1835.76, 2583.15, 45.95),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	-- To CrimChangingroom
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 90.0,
		objCoords  = vector3(1826.466, 2585.271, 46.09929),
		textCoords = vector3(1835.77, 2589.76, 45.95),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
		size = 2
	},
	-- To CheckingRoom
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 0.0,
		objCoords  = vector3(1827.521, 2583.905, 45.28576),
		textCoords = vector3(1828.638, 2584.675, 45.95233),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},
	-- Checking Gate
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 270.0,
		objCoords  = vector3(1837.714, 2595.185, 46.09929),
		textCoords = vector3(1837.714, 2595.185, 46.09929),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	-- To CheckingRoomFromCheck
	-- {
	-- 	objName = 'v_ilev_gtdoor',
	-- 	objYaw = 90.0,
	-- 	objCoords  = vector3(1837.697, 2585.24, 46.09929),
	-- 	textCoords = vector3(1837.697, 2585.24, 46.09929),
	-- 	authorizedJobs = { 'police' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 1.5,
	-- 	size = 2
	-- },
	-- To SecondCheckGate
	
	-- 58
	-- X:1845.198 Y:2585.24 Z:46.09929
	-- {
	-- 	objName = 'v_ilev_gtdoor',
	-- 	objYaw = 90.0,
	-- 	objCoords  = vector3(1845.198, 2585.24, 46.09929),
	-- 	textCoords = vector3(1845.198, 2585.24, 46.09929),
	-- 	authorizedJobs = { 'police' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 1.5,
	-- 	size = 2
	-- },
	-- To MainHall
	-- To VisitorRoom
	{
		objName = 'prison_prop_door2',
		objYaw = 90.0,
		objCoords  = vector3(1784, 2599, 46),
		textCoords = vector3(1785.808, 2590.02, 44.79703),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	{
		textCoords = vector3(1779.67, 2601.83, 50.71),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'prison_prop_door2',
				objYaw = 1.5,
				objCoords = vector3(1781, 2602, 51),	
			},

			{
				objName = 'prison_prop_door2',
				objYaw = 180.0,
				objCoords = vector3(1778, 2602, 51),
			}
		}
	},
	{
		objName = 'prison_prop_door2',
		objYaw = 0.0,
		objCoords  = vector3(1780, 2596, 51),
		textCoords = vector3(1785.808, 2590.02, 44.79703),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	{
		objName = 'prison_prop_door1',
		objYaw = 0.0,
		objCoords  = vector3(1787, 2621, 46),
		textCoords = vector3(1785.808, 2590.02, 44.79703),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	{
		objName = 'prison_prop_door2',
		objYaw = 270.0,
		objCoords  = vector3(1788, 2606, 51),
		textCoords = vector3(1785.808, 2590.02, 44.79703),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	-- To DoctorRoom
	-- {
	-- 	objName = 'v_ilev_ph_gendoor002',
	-- 	objYaw = 90.0,
	-- 	objCoords  = vector3(1786.4, 2579.8, 45.97),
	-- 	textCoords = vector3(1786.4, 2579.8, 45.97),
	-- 	authorizedJobs = { 'police' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 1.0,
	-- 	size = 2
	-- },
	-- HallGate
	{
		objName = 'prison_prop_door2',
		objYaw = 0.0,
		objCoords  = vector3(1786, 2567, 46),
		textCoords = vector3(1778.91, 2568.91, 46.07),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	-- HallGate 2
	{
		objName = 'prison_prop_door1',
		objYaw = 270.0,
		objCoords  = vector3(1792, 2551, 46),
		textCoords = vector3(1773.49, 2568.9, 46.07),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	{
		textCoords = vector3( 1781.72, 2552.07, 49.57),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'prison_prop_door2',
				objYaw = 269.5,
				objCoords = vector3(1782, 2551, 50),		
			},

			{
				objName = 'prison_prop_door2',
				objYaw = 90.0,
				objCoords = vector3(1782, 2553, 50),	
			}
		}
	},	
	-- Gate To Work
	{
		objName = 'prison_prop_door2',
		objYaw = 90.0,
		objCoords  = vector3(1786, 2552, 50),
		textCoords = vector3(1760.89, 2578.51, 46.07),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	-- Cell Maindoor
	{
		objName = 'prison_prop_door2',
		objYaw = 180.0,
		objCoords  = vector3(1785, 2550, 46),
		textCoords = vector3(1760.89, 2578.51, 46.07),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	{
		objName = 'prison_prop_door1a',
		objYaw = 270.0,
		objCoords  = vector3(1776, 2551, 46),
		textCoords = vector3(1760.89, 2578.51, 46.07),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	{
		objName = 'prison_prop_door1a',
		-- objYaw = 270.0,
		objCoords  = vector3(1759.78, 2615.38, 45.56),
		textCoords = vector3(1759.78, 2615.38, 45.56),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	{
		objName = 'prison_prop_door1',
		-- objYaw = 270.0,
		objCoords  = vector3(1785.72, 2600.2, 45.8),
		textCoords = vector3(1785.72, 2600.2, 45.8),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	----------------
	-- ANWB Kantoor
	-- Hek achter
	{
		objName = 'prop_gate_prison_01',
		-- objYaw = 0.0,
		objCoords  = vector3(-376.33, -67.94, 45.66),
		textCoords = vector3(-377.42, -70, 45.66),
		authorizedJobs = { 'mechanic' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 10,
		size = 2
	},
	-- Kledingdeur
	{
		objName = 'ajaxon_burton_lsc_office_door',
		objYaw = 93.0,
		objCoords  = vector3(-334.98, -161.62, 44.58),
		textCoords = vector3(-334.98, -161.62, 44.58),
		authorizedJobs = { 'mechanic' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	-- Kantoordeur
	{
		textCoords = vector3(-334.81, -155.52, 44.58),
		authorizedJobs = { 'mechanic' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		doors = {
			{
				objName = 'ajaxon_burton_lsc_office_door',
				objYaw = 84.0,
				objCoords = vector3(-334.89, -156.16, 44.58),		
			},

			{
				objName = 'ajaxon_burton_lsc_office_door',
				objYaw = 263.0,
				objCoords = vector3(-334.62, -154.93, 44.58),	
			}
		}
	},
	----------------
	-- Pacific Bank
	----------------
	-- First Door
	-- {
	-- 	objName = 'hei_v_ilev_bk_gate_pris',			
	-- 	objCoords  = vector3(257.41, 220.25, 106.4),
	-- 	textCoords = vector3(257.41, 220.25, 106.4),
	-- 	authorizedJobs = { 'police' },
	-- 	objYaw = -20.0,
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = true,
	-- 	distance = 1.5,
	-- 	size = 2
	-- },
	-- -- Second Door
	-- {
	-- 	objName = 'hei_v_ilev_bk_gate2_pris',
	-- 	objCoords  = vector3(261.83, 221.39, 106.41),
	-- 	textCoords = vector3(261.83, 221.39, 106.41),
	-- 	authorizedJobs = { 'police' },
	-- 	objYaw = -110.0,
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 1.5,
	-- 	size = 2
	-- },
	-- -- Office to gate door
	-- {
	-- 	objName = 'v_ilev_bk_door',
	-- 	objCoords  = vector3(265.19, 217.84, 110.28),
	-- 	textCoords = vector3(265.19, 217.84, 110.28),
	-- 	authorizedJobs = { 'police' },
	-- 	objYaw = -20.0,
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = true,
	-- 	distance = 1.5,
	-- 	size = 2
	-- },

	-- -- First safe Door
	-- {
	-- 	objName = 'hei_v_ilev_bk_safegate_pris',
	-- 	objCoords  = vector3(252.98, 220.65, 101.8),
	-- 	textCoords = vector3(252.98, 220.65, 101.8),
	-- 	authorizedJobs = { 'police' },
	-- 	objYaw = 160.0,
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 1.5,
	-- 	size = 2
	-- },
	-- -- Second safe Door
	-- {
	-- 	objName = 'hei_v_ilev_bk_safegate_pris',
	-- 	objCoords  = vector3(261.68, 215.62, 101.81),
	-- 	textCoords = vector3(261.68, 215.62, 101.81),
	-- 	authorizedJobs = { 'police' },
	-- 	objYaw = -110.0,
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 1.5,
	-- 	size = 2
	-- },

	----------------
	-- Fleeca Banks
	----------------
	-- Door 1
	{
		objName = 'v_ilev_gb_vaubar',
		objCoords  = vector3(314.61, -285.82, 54.49),
		textCoords = vector3(313.3, -285.45, 54.49),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	-- Door 2
	{
		objName = 'v_ilev_gb_vaubar',
		objCoords  = vector3(148.96, -1047.12, 29.7),
		textCoords = vector3(148.96, -1047.12, 29.7),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	-- Door 3
	{
		objName = 'v_ilev_gb_vaubar',
		objCoords  = vector3(-351.7, -56.28, 49.38),
		textCoords = vector3(-351.7, -56.28, 49.38),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	-- Door 4
	{
		objName = 'v_ilev_gb_vaubar',
		objCoords  = vector3(-2956.18, -335.76, 38.11),
		textCoords = vector3(-2956.18, -335.76, 38.11),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	-- Door 5
	{
		objName = 'v_ilev_gb_vaubar',
		objCoords  = vector3(-2956.18, 483.96, 16.02),
		textCoords = vector3(-2956.18, 483.96, 16.02),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	-- Paleto Door 1
	{
		objName = 'v_ilev_cbankvaulgate01',
		objCoords  = vector3(-105.77, 6472.59, 31.81),
		textCoords = vector3(-105.77, 6472.59, 31.81),
		objYaw = 45.0,
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	-- Paleto Door 2
	{
		objName = 'v_ilev_cbankvaulgate02',
		objCoords  = vector3(-106.26, 6476.01, 31.98),
		textCoords = vector3(-105.5, 6475.08, 31.99),
		objYaw = -45.0,
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	-----
	-- Police front gate // Hek die er niet was bij hoofdbureau bp
	-----
	-- {
	-- 	objName = 'prop_gate_airport_01',
	-- 	objYaw = -90.0,
	-- 	objCoords  = vector3(411.0243, -1025.057, 28.33853),
	-- 	textCoords = vector3(411.0243, -1025.057, 30.5),
	-- 	authorizedJobs = { 'police' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 10,
	-- 	size = 2
	-- },
	
	-----------------------------------------------------------------------------
	--Oude guiliano garage
	
	-- Voordeur 1
	--{
	--	objName = 'apa_prop_apa_cutscene_doorb',
	--	objCoords  = vector3(-21.71276, -1392.778, 29.63847),		
	--	textCoords = vector3(-22.31276, -1392.778, 29.63847),
	--	authorizedJobs = { 'guiliano' },
	--	objYaw = -180.0,
	--	locking = false,
	--	locked = true,
	--	pickable = false,
	--	distance = 2.5,
	--	size = 2
	--},	
	---- Voordeur 2
	--{
	--	objName = 'apa_prop_apa_cutscene_doorb',
	--	objCoords  = vector3(-32.67987, -1392.064, 29.63847),		
	--	textCoords = vector3(-32.10987, -1392.064, 29.63847),
	--	authorizedJobs = { 'guiliano' },
	--	objYaw = 0.0,
	--	locking = false,
	--	locked = true,
	--	pickable = false,
	--	distance = 2.5,
	--	size = 2
	--},	
	---- Deur naar kelder
	--{
	--	objName = 'apa_prop_apa_cutscene_doorb',
	--	objCoords  = vector3(-24.22668, -1403.067, 29.63847),				
	--	textCoords = vector3(-24.22668, -1402.537, 29.63847),
	--	authorizedJobs = { 'guiliano' },
	--	objYaw = 90.0,
	--	locking = false,
	--	locked = true,
	--	pickable = false,
	--	distance = 1.5,
	--	size = 2
	--},	
	---- Achterdeur
	--{
	--	objName = 'apa_prop_apa_cutscene_doorb',
	--	objCoords  = vector3(-21.27107, -1406.845, 29.63847),			
	--	textCoords = vector3(-21.27107, -1406.245, 29.63847),
	--	authorizedJobs = { 'guiliano' },
	--	objYaw = 90.0,
	--	locking = false,
	--	locked = true,
	--	pickable = false,
	--	distance = 2.0,
	--	size = 2
	--},		
	---- Roldeur
	--{
	--	objName = 'prop_com_gar_door_01',
	--	objCoords  = vector3(-21.04025, -1410.734, 30.51094),			
	--	textCoords = vector3(-21.04025, -1410.734, 30.51094),
	--	authorizedJobs = { 'guiliano' },
	--	locking = false,
	--	locked = true,
	--	pickable = false,
	--	distance = 6.0,
	--	size = 2
	--},
	-----------------------------------------------------------------------------
	-- Ambulance
	{
		objName = 'gabz_pillbox_singledoor',
		objCoords  = vector3(308.44, -597.42, 43.48)		,			
		textCoords = vector3(308.44, -597.42, 43.48)		,
		authorizedJobs = { 'ambulance' },
		objYaw = 160.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},	
	{
		textCoords = vector3(338.91, -588.82, 28.80),
		authorizedJobs = { 'ambulance' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		doors = {
			{
				objName = 'gabz_pillbox_doubledoor_l',
				objCoords = vector3(338.56, -589.46, 28.79),
				objYaw = 70.5,
			},

			{
				objName = 'gabz_pillbox_doubledoor_r',
				objCoords = vector3(338.18, -588.55, 28.79),
				objYaw = 70.0,
			}
		}
	},

	-- Sandy HB

	-- Cellen
	{
		objName = 'v_ilev_ph_cellgate1',
		objYaw = -60.0,
		objCoords  = vector3(1859.37, 3687.15, 29.96),
		textCoords = vector3(1859.37, 3687.15, 29.96),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	{
		objName = 'v_ilev_ph_cellgate1',
		objYaw = -60.0,
		objCoords  = vector3(1858.7, 3695.63, 29.96),
		textCoords = vector3(1858.7, 3695.63, 29.96),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	{
		objName = 'v_ilev_ph_cellgate1',
		objYaw = -60.0,
		objCoords  = vector3(1860.71, 3692.39, 29.96),
		textCoords = vector3(1860.71, 3692.39, 29.96),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	{
		objName = 'v_ilev_ph_cellgate1',
		objYaw = -60.0,
		objCoords  = vector3(1862.49, 3688.92, 29.96),
		textCoords = vector3(1862.49, 3688.92, 29.96),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	-- Voordeur 
	{
		objName = 'v_ilev_shrfdoor',
		objYaw = 30.0,
		objCoords  = vector3(1855.05, 3683.52, 33.97),
		textCoords = vector3(1855.05, 3683.52, 33.97),
		authorizedJobs = { 'police' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 1.5,
	},

	-- Kantoor
	{
		objName = 'v_ilev_rc_door2',
		objYaw = -150.0,
		objCoords  = vector3(1856.73, 3689.88, 33.97),
		textCoords = vector3(1856.73, 3689.88, 33.97),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	-- Armory 
	{
		textCoords = vector3(1848.27, 3690.57, 33.97),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objCoords = vector3(1847.47, 3690.33, 33.27),
				objYaw = 29.0,
			},

			{
				objName = 'v_ilev_rc_door2',
				objCoords = vector3(1848.98, 3691.04, 33.27),
				objYaw = -151.0,
			}
		}
	},
	
	-- Naar beneden
	{
		textCoords = vector3(1850.76, 3682.9, 33.97),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objCoords = vector3(1851.25, 3682.27, 33.27),
				objYaw = 119.0,
			},

			{
				objName = 'v_ilev_rc_door2',
				objCoords = vector3(1850.17, 3683.69, 33.27),
				objYaw = -59.0,
			}
		}
	},


	-- Gangs --
	-- Gangs --
	-- Gangs --
	-- Gangs --
	-- Gangs --
	-- Gangs --
	-- Gangs --
	-- Gangs --
	-- Gangs --

	-- Bruinsma
	-- Voordeur
	-- {
	-- 	objName = 'apa_p_mp_yacht_door_01',
	-- 	objCoords  = vector3(-112.40, 986.31, 235.78)		,			
	-- 	textCoords = vector3(-112.40, 986.31, 235.78)		,
	-- 	authorizedJobs = { 'bruinsma' },
	-- 	objYaw = -70.0,
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.0,
	-- 	size = 2
	-- },	
	-- -- Achterdeur 
	-- {
	-- 	objName = 'apa_p_mp_yacht_door_01',
	-- 	objCoords  = vector3(-62.48, 998.48, 234.68)		,			
	-- 	textCoords = vector3(-62.48, 998.48, 234.68)		,
	-- 	authorizedJobs = { 'bruinsma' },
	-- 	objYaw = -40.0,
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 3.0,
	-- 	size = 2
	-- },
	-- -- Poorten
	-- {
	-- 	textCoords = vector3(-135.35, 972.59, 235.88),
	-- 	authorizedJobs = { 'bruinsma' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 5.0,
	-- 	doors = {
	-- 		{
	-- 			objName = 'prop_lrggate_01c_r',
	-- 			objCoords = vector3(-134.01, 971.93, 235.84),
	-- 			objYaw = -23.0,
	-- 		},

	-- 		{
	-- 			objName = 'prop_lrggate_01c_l',
	-- 			objCoords = vector3(-137.14, 973.43, 235.81),
	-- 			objYaw = -25.0,
	-- 		}
	-- 	}
	-- },


	-- Guiliano
	-- Voordeur
	{
		objName = 'brofx_mansion07_dvere',
		objCoords  = vector3(-1465.39, -34.51, 55.15)		,			
		textCoords = vector3(-1465.39, -34.51, 55.15)		,
		authorizedJobs = { 'gotti' },
		objYaw = 130.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},	

	-- Garage
	{
		objName = 'brofx_mansion07_dvere',
		objCoords  = vector3(-1465.38, -47.19, 54.94)		,			
		textCoords = vector3(-1465.38, -47.19, 54.94)		,
		authorizedJobs = { 'gotti' },
		objYaw = 40.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	-- Achtertuin
	{
		objName = 'brofx_mansion07_dvere',
		objCoords  = vector3(-1482.59, -49.18, 54.94)		,			
		textCoords = vector3(-1482.59, -49.18, 54.94)		,
		authorizedJobs = { 'gotti' },
		objYaw = -50.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	{
		objName = 'brofx_mansion07_dvere',
		objCoords  = vector3(-1473.04, -58.24, 54.93)		,			
		textCoords = vector3(-1473.04, -58.24, 54.93)		,
		authorizedJobs = { 'gotti' },
		objYaw = -50.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	{
		objName = 'brofx_mansion07_dvere',
		objCoords  = vector3(-1468.72, -59.36, 54.93)		,			
		textCoords = vector3(-1468.72, -59.36, 54.93)		,
		authorizedJobs = { 'gotti' },
		objYaw = 220.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	{
		objName = 'brofx_mansion07_dvere',
		objCoords  = vector3(-1486.31, -22.47, 54.95)		,			
		textCoords = vector3(-1486.31, -22.47, 54.95)		,
		authorizedJobs = { 'gotti' },
		objYaw = -137.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	{
		objName = 'brofx_mansion07_dvere',
		objCoords  = vector3(-1472.13, -49.33, 54.63)		,			
		textCoords = vector3(-1472.13, -49.33, 54.63)		,
		authorizedJobs = { 'gotti' },
		objYaw = -50.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	{
		textCoords = vector3(-1480.48, -40.65, 56.84),
		authorizedJobs = { 'gotti' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		doors = {
			{
				objName = 'brofx_mansion07_dvere',
				objCoords = vector3(-1481.11, -40.28, 56.84),
				objYaw = -50.0,
			},

			{
				objName = 'brofx_mansion07_dvere',
				objCoords = vector3(-1480.02, -41.90, 56.84),
				objYaw = -230.0,
			}
		}
	},
	-- Terras boven
	{
		objName = 'brofx_mansion07_dvere',
		objCoords  = vector3(-1468.20, -36.88, 62.05)		,			
		textCoords = vector3(-1468.20, -36.88, 62.05)		,
		authorizedJobs = { 'gotti' },
		objYaw = 130.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	{
		objName = 'brofx_mansion07_dvere',
		objCoords  = vector3(-1470.83, -44.49, 62.03)		,			
		textCoords = vector3(-1470.83, -44.49, 62.03)		,
		authorizedJobs = { 'gotti' },
		objYaw = 220.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	-- 3 deuren terras
	{
		objName = 'brofx_mansion07_dvere',
		objCoords  = vector3(-1475.11, -33.61, 63.02)		,			
		textCoords = vector3(-1475.11, -33.61, 63.02)		,
		authorizedJobs = { 'gotti' },
		objYaw = 220.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	{
		objName = 'brofx_mansion07_dvere',
		objCoords  = vector3(-1477.26, -35.34, 63.02)		,			
		textCoords = vector3(-1477.26, -35.34, 63.02)		,
		authorizedJobs = { 'gotti' },
		objYaw = 220.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	{
		objName = 'brofx_mansion07_dvere',
		objCoords  = vector3(-1479.32, -37.13, 63.02)		,			
		textCoords = vector3(-1479.32, -37.13, 63.02)		,
		authorizedJobs = { 'gotti' },
		objYaw = 220.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	-- Geheime deur keuken
	{
		objName = 'brofx_07_mansion_secret',
		objCoords  = vector3(-1479.97, -37.20, 54.57)		,			
		textCoords = vector3(-1479.97, -37.20, 54.57)		,
		authorizedJobs = { 'gotti' },
		objYaw = 40.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	-- Poorten
	{
		textCoords = vector3(-1453.76, -32.05, 54.64),
		authorizedJobs = { 'gotti' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 6.0,
		doors = {
			{
				objName = 'prop_lrggate_01_r',
				objCoords = vector3(-1455.02, -34.43, 54.62),
				objYaw = 251.0,
			},

			{
				objName = 'prop_lrggate_01_l',
				objCoords = vector3(-1453.38, -29.58, 54.64),
				objYaw = 251.0,
			}
		}
	},

	{
		textCoords = vector3(-1472.73, -14.23, 54.64),
		authorizedJobs = { 'gotti' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 6.0,
		doors = {
			{
				objName = 'prop_lrggate_01_l',
				objCoords = vector3(-1475.12, -15.12, 54.64),
				objYaw = 9.0,
			},

			{
				objName = 'prop_lrggate_01_r',
				objCoords = vector3(-1469.93, -14.23, 54.64),
				objYaw = 10.0,
			}
		}
	},

	-- De Baron
	-- Voordeur
	-- {
	-- 	objName = 'ba_prop_door_club_entrance',
	-- 	objCoords  = vector3(757.96, -816.08, 26.50),			
	-- 	textCoords = vector3(757.96, -816.08, 26.50),
	-- 	authorizedJobs = { 'bruinsma' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.0,
	-- 	size = 2
	-- },
	-- -- Zijdeur
	-- {
	-- 	objName = 'ba_prop_door_club_entrance',
	-- 	objCoords  = vector3(751.23, -810.21, 23.66),			
	-- 	textCoords = vector3(751.23, -810.21, 23.66),
	-- 	authorizedJobs = { 'bruinsma' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.0,
	-- 	size = 2
	-- },
	-- -- Kantoor
	-- {
	-- 	objName = 'ch_prop_ch_corridor_door_beam',
	-- 	objCoords  = vector3(738.10, -811.00, 24.26),			
	-- 	textCoords = vector3(738.10, -811.00, 24.26),
	-- 	authorizedJobs = { 'bruinsma' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.0,
	-- 	size = 2
	-- },
	-- -- Koelkast
	-- {
    --     textCoords = vector3(740.47, -810.09, 30.07),
	-- 	authorizedJobs = { 'bruinsma' },
    --     locking = false,
    --     locked = true,
    --     pickable = false,
    --     distance = 2.0,
    --     doors = {
    --         {
    --             objName = 'ball_fridge_arcade_l',
    --             objYaw = 0.0,
    --             objCoords = vector3(740.28, -809.56, 24.30),
    --         },

    --         {
    --             objName = 'ball_fridge_arcade_r',
    --             objYaw = 0.0,
    --             objCoords = vector3(740.64, -809.74, 24.30),
    --         },
    --     },
    -- },
	-- -- Kelder
	-- {
	-- 	objName = 'v_ilev_rc_door2',
	-- 	objCoords  = vector3(-740.50, -797.71, 19.66),			
	-- 	textCoords = vector3(-740.50, -797.71, 19.66),
	-- 	authorizedJobs = { 'bruinsma' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.0,
	-- 	size = 2
	-- },
	-- -- Garage deur
	-- {
	-- 	objName = 'road_garage_door2',
	-- 	objCoords  = vector3(717.45, -767.51, 24.90),			
	-- 	textCoords = vector3(717.45, -767.51, 24.90),
	-- 	authorizedJobs = { 'bruinsma' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 3.5,
	-- 	size = 2
	-- },

	-- Camorra Vineyard
	-- Voordeur links
	-- {
	-- 	textCoords = vector3(-1888.99, 2051.98, 140.98),
	-- 	authorizedJobs = { 'camorra' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.0,
	-- 	doors = {
	-- 		{
	-- 			objName = 'ball_prop_italy2',
	-- 			objCoords  = vector3(-1889.46, 2051.95, 141.00)
	-- 		},

	-- 		{
	-- 			objName = 'ball_prop_italy2',
	-- 			objCoords  = vector3(-1888.58, 2051.56, 141.00)
	-- 		}
	-- 	}
	-- },
	-- -- Voordeur rechts
	-- {
	-- 	textCoords = vector3(-1886.36, 2050.98, 141.00),
	-- 	authorizedJobs = { 'camorra' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.0,
	-- 	doors = {
	-- 		{
	-- 			objName = 'ball_prop_italy2',
	-- 			objCoords  = vector3(-1886.86, 2050.98, 141.00)
	-- 		},

	-- 		{
	-- 			objName = 'ball_prop_italy2',
	-- 			objCoords  = vector3(-1885.87, 2050.59, 141.00)
	-- 		}
	-- 	}
	-- },
	-- -- Zijdeur linkerkant links
	-- {
	-- 	textCoords = vector3(-1911.11, 2074.76, 140.40),
	-- 	authorizedJobs = { 'camorra' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.0,
	-- 	doors = {
	-- 		{
	-- 			objName = 'ball_prop_italy3',
	-- 			objCoords  = vector3(-1911.41, 2075.05, 140.40)
	-- 		},

	-- 		{
	-- 			objName = 'ball_prop_italy3',
	-- 			objCoords  = vector3(-1910.74, 2074.49, 140.40)
	-- 		}
	-- 	}
	-- },
	-- -- Zijdeur rechterkant
	-- {
	-- 	textCoords = vector3(-1908.76, 2072.76, 140.40),
	-- 	authorizedJobs = { 'camorra' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.0,
	-- 	doors = {
	-- 		{
	-- 			objName = 'ball_prop_italy3',
	-- 			objCoords  = vector3(-1909.05, 2073.02, 140.40)
	-- 		},

	-- 		{
	-- 			objName = 'ball_prop_italy3',
	-- 			objCoords  = vector3(-1908.22, 2072.39, 140.40)
	-- 		}
	-- 	}
	-- },
	-- -- Zijdeur rechterkant rechts
	-- {
	-- 	textCoords = vector3(-1860.47, 2053.79, 141.00),
	-- 	authorizedJobs = { 'camorra' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.0,
	-- 	doors = {
	-- 		{
	-- 			objName = 'ball_prop_italy2',
	-- 			objCoords  = vector3(-1860.96, 2053.84, 141.00)
	-- 		},

	-- 		{
	-- 			objName = 'ball_prop_italy2',
	-- 			objCoords  = vector3(-1859.92, 2053.84, 141.00)
	-- 		}
	-- 	}
	-- },
	-- -- Linkerzijde links
	-- {
	-- 	textCoords = vector3(-1907.03, 2084.84, 140.39),
	-- 	authorizedJobs = { 'camorra' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.0,
	-- 	doors = {
	-- 		{
	-- 			objName = 'ball_prop_italy3',
	-- 			objCoords  = vector3(-1906.42, 2085.09, 140.39)
	-- 		},

	-- 		{
	-- 			objName = 'ball_prop_italy3',
	-- 			objCoords  = vector3(-1907.20, 2084.40, 140.39)
	-- 		}
	-- 	}
	-- },
	-- -- Linkerzijde rechts
	-- {
	-- 	textCoords = vector3(-1910.84, 2079.57, 140.40),
	-- 	authorizedJobs = { 'camorra' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.0,
	-- 	doors = {
	-- 		{
	-- 			objName = 'ball_prop_italy3',
	-- 			objCoords  = vector3(-1910.62, 2079.99, 140.40)
	-- 		},

	-- 		{
	-- 			objName = 'ball_prop_italy3',
	-- 			objCoords  = vector3(-1911.28, 2079.35, 140.39)
	-- 		}
	-- 	}
	-- },
	-- -- Achterzijde meest rechterdeur
	-- {
	-- 	textCoords = vector3(-1901.90, 2085.65, 140.40),
	-- 	authorizedJobs = { 'camorra' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.0,
	-- 	doors = {
	-- 		{
	-- 			objName = 'ball_prop_italy3',
	-- 			objCoords  = vector3(-1901.60, 2085.34, 140.40)
	-- 		},

	-- 		{
	-- 			objName = 'ball_prop_italy3',
	-- 			objCoords  = vector3(-1902.34, 2086.09, 140.40)
	-- 		}
	-- 	}
	-- },
	-- -- Achterzijde rechterdeur
	-- {
	-- 	textCoords = vector3(-1899.48, 2083.63, 140.40),
	-- 	authorizedJobs = { 'camorra' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.0,
	-- 	doors = {
	-- 		{
	-- 			objName = 'ball_prop_italy3',
	-- 			objCoords  = vector3(-1899.12, 2083.24, 140.40)
	-- 		},

	-- 		{
	-- 			objName = 'ball_prop_italy3',
	-- 			objCoords  = vector3(-1899.95, 2083.92, 140.40)
	-- 		}
	-- 	}
	-- },
	-- -- Achterzijde midden
	-- {
	-- 	textCoords = vector3(-1893.89, 2075.18, 141.00),
	-- 	authorizedJobs = { 'camorra' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.0,
	-- 	doors = {
	-- 		{
	-- 			objName = 'ball_prop_italy2',
	-- 			objCoords  = vector3(-1893.39, 2074.84, 141.00)
	-- 		},

	-- 		{
	-- 			objName = 'ball_prop_italy2',
	-- 			objCoords  = vector3(-1894.14, 2075.51, 141.00)
	-- 		}
	-- 	}
	-- },
	-- -- Achterzijde linkerdeur
	-- {
	-- 	textCoords = vector3(-1886.10, 2073.88, 141.00),
	-- 	authorizedJobs = { 'camorra' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.0,
	-- 	doors = {
	-- 		{
	-- 			objName = 'ball_prop_italy2',
	-- 			objCoords  = vector3(-1885.58, 2073.57, 140.99)
	-- 		},

	-- 		{
	-- 			objName = 'ball_prop_italy2',
	-- 			objCoords  = vector3(-1886.52, 2074.10, 141.00)
	-- 		}
	-- 	}
	-- },
	-- -- Achterzijde meest linkerdeur
	-- {
	-- 	textCoords = vector3(-1874.43, 2069.72, 141.00),
	-- 	authorizedJobs = { 'camorra' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.0,
	-- 	doors = {
	-- 		{
	-- 			objName = 'ball_prop_italy2',
	-- 			objCoords  = vector3(-1873.94, 2069.60, 141.00)
	-- 		},

	-- 		{
	-- 			objName = 'ball_prop_italy2',
	-- 			objCoords  = vector3(-1874.98, 2069.87, 141.00)
	-- 		}
	-- 	}
	-- },

	-- Pizzeria Camorra
	-- Kelder
	-- {
	-- 	objName = 'e1_drusillasdoor',
	-- 	objCoords  = vector3(-1351.27, -1064.52, 7.39)		,			
	-- 	textCoords = vector3(-1351.27, -1064.52, 7.39)		,
	-- 	authorizedJobs = { 'camorra' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.0,
	-- 	size = 2
	-- },

	-- Sons of Anarchy
    -- Voordeur
    -- {
    --     objName = 'v_bam_gypdoor01',
    --     objYaw = 90.0,
    --     objCoords  = vector3(915.81, 3577.18, 33.53),
    --     textCoords = vector3(915.81, 3577.18, 33.53),
    --     authorizedJobs = { 'sons' },
    --     locking = false,
    --     locked = true,
    --     pickable = false,
    --     distance = 1.5,
    -- },
    -- -- Garagedeur groot
    -- {
    --     objName = 'v_bam_gypcardoor01',
    --     -- objYaw = -60.0,
    --     objCoords  = vector3(903.15, 3585.79, 33.45),
    --     textCoords = vector3(903.15, 3585.79, 33.45),
    --     authorizedJobs = { 'sons' },
    --     locking = false,
    --     locked = true,
    --     pickable = false,
    --     distance = 3.5,
    -- },
    -- -- Garagedeur klein
    -- {
    --     objName = 'v_bam_gypdoor02',
    --     objYaw = 180.0,
    --     objCoords  = vector3(905.91, 3585.82, 33.54),
    --     textCoords = vector3(905.91, 3585.82, 33.54),
    --     authorizedJobs = { 'sons' },
    --     locking = false,
    --     locked = true,
    --     pickable = false,
    --     distance = 1.5,
    -- },
    -- -- Kelderdeur
    -- {
    --     objName = 'v_ilev_cm_door1',
    --     objYaw = 90.0,
    --     objCoords  = vector3(908.99, 3584.30, 33.54),
    --     textCoords = vector3(908.99, 3584.30, 33.54),
    --     authorizedJobs = { 'sons' },
    --     locking = false,
    --     locked = true,
    --     pickable = false,
    --     distance = 1.5,
    -- },
    -- -- Celdeur
    -- {
    --     objName = 'v_bam_gypdoor04',
    --     objYaw = 270.0,
    --     objCoords  = vector3(906.91, 3572.51, 29.91),
    --     textCoords = vector3(906.91, 3572.51, 29.91),
    --     authorizedJobs = { 'sons' },
    --     locking = false,
    --     locked = true,
    --     pickable = false,
    --     distance = 1.5,
    -- },
	
	-- Peaky Blinder's
    -- Voordeur
    -- {
    --  textCoords = vector3(1395.80, 1141.86, 114.65),
    --  authorizedJobs = { 'livingstone' },
    --  locking = false,
    --  locked = true,
    --  pickable = false,
    --  distance = 2.0,
    --  doors = {
    --      {
    --          objName = 'v_ilev_ra_door4l',
    --          objYaw = -90.0,
    --          objCoords = vector3(1396.13, 1142.30, 114.33),
    --      },
	
    --        {
    --           objName = 'v_ilev_ra_door4r',
    --            objYaw = 90.0,
    --            objCoords = vector3(1395.97, 1141.33, 114.64),
    --        },
    --    },
    -- },
    -- -- Voordeur rechts
    -- {
    --     textCoords = vector3(1390.66, 1132.19, 114.33),
    --     authorizedJobs = { 'livingstone' },
    --     locking = false,
    --     locked = true,
    --     pickable = false,
    --     distance = 2.0,
    --     doors = {
    --         {
    --             objName = 'v_ilev_ra_door1_l',
    --             objYaw = 90.0,
    --             objCoords = vector3(1390.58, 1132.71, 114.33),
    --         },

    --         {
    --             objName = 'v_ilev_ra_door1_r',
    --             objYaw = 90.0,
    --             objCoords = vector3(1390.66, 1131.73, 114.64),
    --         },
    --     },
    -- },
    -- -- Voordeur links
    -- {
    --     textCoords = vector3(1390.45, 1162.28, 114.33),
    --     authorizedJobs = { 'livingstone' },
    --     locking = false,
    --     locked = true,
    --     pickable = false,
    --     distance = 2.0,
    --     doors = {
    --         {
    --             objName = 'v_ilev_ra_door1_l',
    --             objYaw = 90.0,
    --             objCoords = vector3(1390.46, 1162.80, 114.33),
    --         },

    --         {
    --             objName = 'v_ilev_ra_door1_r',
    --             objYaw = 90.0,
    --             objCoords = vector3(1390.33, 1161.88, 114.33),
    --         },
    --     },
	-- },
    -- -- Achterdeur raadzaal rechts
    -- {
    --     textCoords = vector3(1408.12, 1164.75, 114.33),
    --     authorizedJobs = { 'livingstone' },
    --     locking = false,
    --     locked = true,
    --     pickable = false,
    --     distance = 2.0,
    --     doors = {
    --         {
    --             objName = 'v_ilev_ra_door1_l',
    --             objYaw = 90.0,
    --             objCoords = vector3(1408.72, 1164.35, 114.33),
    --         },

    --         {
    --             objName = 'v_ilev_ra_door1_r',
    --             objYaw = 90.0,
    --             objCoords = vector3(1408.165, 1165.20, 114.33),
    --         },
    --     },
    -- },
    -- -- Achterdeur raadzaal links
    -- {
    --     textCoords = vector3(1408.12, 1160.11, 114.33),
    --     authorizedJobs = { 'livingstone' },
    --     locking = false,
    --     locked = true,
    --     pickable = false,
    --     distance = 2.0,
    --     doors = {
    --         {
    --             objName = 'v_ilev_ra_door1_l',
    --             objYaw = 90.0,
    --             objCoords = vector3(1408.12, 1159.52, 114.33),
    --         },

    --         {
    --             objName = 'v_ilev_ra_door1_r',
    --             objYaw = 90.0,
    --             objCoords = vector3(1408.16, 1160.58, 114.33),
    --         },
    --     },
    -- },
    -- -- Zijdeur linkerkant
    -- {
    --     textCoords = vector3(1400.47, 1128.22, 114.33),
    --     authorizedJobs = { 'livingstone' },
    --     locking = false,
    --     locked = true,
    --     pickable = false,
    --     distance = 2.0,
    --     doors = {
    --         {
    --             objName = 'v_ilev_ra_door1_l',
    --             objYaw = 0.0,
    --             objCoords = vector3(1399.99, 1128.34, 114.33),
    --         },

    --         {
    --             objName = 'v_ilev_ra_door1_r',
    --             objYaw = 0.0,
    --             objCoords = vector3(1400.97, 1128.37, 114.33),
    --         },
    --     },
    -- },
    -- -- Kelderdeur
    -- {
    --     objName = 'v_ilev_ra_door4r',
	-- 	objYaw = 180.0,
    --     objCoords  = vector3(1406.94, 1128.39, 114.33),
    --     textCoords = vector3(1406.94, 1128.39, 114.33),
    --     authorizedJobs = { 'livingstone' },
    --     locking = false,
    --     locked = true,
    --     pickable = false,
    --     distance = 2,
    --     size = 2
    -- },
	-- Bratva
	-- Voordeur
	-- {
	-- 	objName = 'ed_whitemansion_frontdoor',
	-- 	objYaw = 54.5,
	-- 	objCoords  = vector3(-888.78, 42.88, 49.14),
	-- 	textCoords = vector3(-888.78, 42.88, 49.14),
	-- 	authorizedJobs = { 'bratva' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 1.5,
	-- },
	-- {
	-- 	objName = 'ed_whitemansion_frontdoor',
	-- 	objYaw = 234.5,
	-- 	objCoords  = vector3(-895.35, 49.59, 50.04),
	-- 	textCoords = vector3(-895.35, 49.59, 50.04),
	-- 	authorizedJobs = { 'bratva' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 1.5,
	-- },
	-- -- Garagedeuren
	-- {
	-- 	textCoords = vector3(-872.47, 51.74, 48.79),
	-- 	authorizedJobs = { 'bratva' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 3.0,
	-- 	doors = {
	-- 		{
	-- 			objName = 'ed_whitemansion_garagedoor_l',
	-- 			objYaw = 15.0,
	-- 			objCoords = vector3(-873.00, 51.50, 48.78),		
	-- 		},

	-- 		{
	-- 			objName = 'ed_whitemansion_garagedoor_r',
	-- 			objYaw = 15.0,
	-- 			objCoords = vector3(-871.86, 51.85, 48.80),	
	-- 		}
	-- 	}
	-- },
	-- {
	-- 	textCoords = vector3(-876.01, 50.72, 48.76),
	-- 	authorizedJobs = { 'bratva' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 3.0,
	-- 	doors = {
	-- 		{
	-- 			objName = 'ed_whitemansion_garagedoor_l',
	-- 			objYaw = 15.0,
	-- 			objCoords = vector3(-876.80, 50.62, 48.76),		
	-- 		},

	-- 		{
	-- 			objName = 'ed_whitemansion_garagedoor_r',
	-- 			objYaw = 15.0,
	-- 			objCoords = vector3(-875.47, 50.92, 48.76),	
	-- 		}
	-- 	}
	-- },
	-- -- Hek
	-- {
	-- 	objName = 'prop_lrggate_02_ld',
	-- --	objYaw = 150.0,
	-- 	objCoords  = vector3(-875.84, 18.54, 45.36),
	-- 	textCoords = vector3(-878.29, 19.92, 45.24),
	-- 	authorizedJobs = { 'bratva' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 10,
	-- 	size = 2
	-- },
	-- Bratva deur
	{
		objName = 'ed_nhentrance_garagedoor',
		objCoords  = vector3(307.61, -2733.49, 6.02),
		textCoords = vector3(307.61, -2733.49, 6.02),
		authorizedJobs = { 'bratva' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 15.0,
		size = 0.1
	},
	-- Gebroeders W
	-- Dubbele deuren voorkant
	-- {
	-- 	textCoords = vector3(-60.14, -1093.94, 26.67),
	-- 	authorizedJobs = { 'gebroedersw' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.5,
	-- 	doors = {
	-- 		{
	-- 			objName = 'v_ilev_csr_door_l',
	-- 			objYaw = 250.0,
	-- 			objCoords = vector3(-60.10, -1093.46, 26.67),	
	-- 		},

	-- 		{
	-- 			objName = 'v_ilev_csr_door_r',
	-- 			objYaw = 250.0,
	-- 			objCoords = vector3(-60.34, -1094.24, 26.67),
	-- 		}
	-- 	}
	-- },
	-- -- Dubbele deuren zijkant
	-- {
	-- 	textCoords = vector3(-38.28, -1108.48, 26.46),
	-- 	authorizedJobs = { 'gebroedersw' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.5,
	-- 	doors = {
	-- 		{
	-- 			objName = 'v_ilev_csr_door_l',
	-- 			objYaw = 340.0,
	-- 			objCoords = vector3(-38.59, -1108.35, 26.46),	
	-- 		},

	-- 		{
	-- 			objName = 'v_ilev_csr_door_r',
	-- 			objYaw = 340.0,
	-- 			objCoords = vector3(-37.83, -1108.63, 26.46),
	-- 		}
	-- 	}
	-- },
	-- Kantoor 1
	{
		objName = 'v_ilev_fib_door1',
		objYaw = 70.0,
		objCoords  = vector3(-34.00, -1108.28, 26.42),
		textCoords = vector3(-34.00, -1108.28, 26.42),
		authorizedJobs = { 'gebroedersw' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	-- Kantoor 2
	{
		objName = 'v_ilev_fib_door1',
		objYaw = 70.0,
		objCoords  = vector3(-32.00, -1102.48, 26.42),
		textCoords = vector3(-32.00, -1102.48, 26.42),
		authorizedJobs = { 'gebroedersw' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},
	-- Benzon
	-- Voordeur
	{
		objName = 'apa_p_mp_yacht_door_01',
		objCoords  = vector3(-112.40, 986.31, 235.78)		,			
		textCoords = vector3(-112.40, 986.31, 235.78)		,
		authorizedJobs = { 'benzon' },
		objYaw = -70.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
		size = 2
	},	
	-- Achterdeur 
	{
		objName = 'apa_p_mp_yacht_door_01',
		objCoords  = vector3(-62.48, 998.48, 234.68)		,			
		textCoords = vector3(-62.48, 998.48, 234.68)		,
		authorizedJobs = { 'benzon' },
		objYaw = -40.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 3.0,
		size = 2
	},
	-- Hek
	{
		objName = 'prop_lrggate_02_ld',
		objCoords  = vector3(-137.60, 973.53, 235.78)		,			
		textCoords = vector3(-135.43, 972.62, 235.88)		,
		authorizedJobs = { 'benzon' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 14.0,
		size = 2
	},
	-- Bratva (Boytsovskiy klub)
	-- Voordeur
	{
		objName = 'vu_fight_club_door',
		objCoords  = vector3(186.75, -1273.13, 29.19)		,			
		textCoords = vector3(186.75, -1273.13, 29.19)		,
		authorizedJobs = { 'bratva' },
		objYaw = 257.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 3.0,
		size = 2
	},
	-- Deur beneden
	{
		objName = 'v_ilev_tort_door',
		objCoords  = vector3(175.83, -1264.91, 14.19)		,			
		textCoords = vector3(175.83, -1264.91, 14.19)		,
		authorizedJobs = { 'bratva' },
		objYaw = 77.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 3.0,
		size = 2
	},
	-- Hek ring
	{
		objName = 'prop_fnclink_03gate5',
		objCoords  = vector3(164.45, -1268.89, 10.99)		,			
		textCoords = vector3(164.45, -1268.89, 10.99)		,
		authorizedJobs = { 'bratva' },
		objYaw = 167.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 3.0,
		size = 2
	},
	-- VIP lounge
	{
		objName = 'prop_strip_door_01',
		objCoords  = vector3(161.80, -1274.01, 20.33)		,			
		textCoords = vector3(161.80, -1274.01, 20.33)		,
		authorizedJobs = { 'bratva' },
		objYaw = 167.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 3.0,
		size = 2
	},
	-- Martelkamer 
	{
		objName = 'prop_damdoor_01',
		objCoords  = vector3(164.17, -1251.35, 14.19)		,			
		textCoords = vector3(164.17, -1251.35, 14.19)		,
		authorizedJobs = { 'bratva' },
		objYaw = 347.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 3.0,
		size = 2
	},
	-- Martelkamer 2
	{
		objName = 'prop_damdoor_01',
		objCoords  = vector3(165.24, -1245.93, 14.19)		,			
		textCoords = vector3(165.24, -1245.93, 14.19)		,
		authorizedJobs = { 'bratva' },
		objYaw = 167.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 3.0,
		size = 2
	},
-- Diamond Casino 
-- Voordeur
	-- {
	-- 	textCoords = vector3(-1816.85, -1194.26, 14.33),
	-- 	authorizedJobs = { 'diamondcasino' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.5,
	-- 	doors = {
	-- 		{
	-- 			objName = 'sibaaa_pearls_maindoor',
	-- 			objYaw = -120.0,
	-- 			objCoords = vector3(-1816.63, -1194.52, 14.33),			
	-- 		},
	-- 		{
	-- 			objName = 'sibaaa_pearls_maindoor',
	-- 			objYaw = -300.0,
	-- 			objCoords = vector3(-1817.27, -1193.91, 14.32)			
	-- 		}
	-- 	}
	-- },
	-- -- Zijdeur
	-- {
	-- 	textCoords = vector3(-1842.38, -1199.01, 14.30),
	-- 	authorizedJobs = { 'diamondcasino' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.5,
	-- 	doors = {
	-- 		{
	-- 			objName = 'sibaaa_pearls_maindoor',
	-- 			objYaw = -210.0,
	-- 			objCoords = vector3(-1842.61, -1199.45, 14.30),			
	-- 		},
	-- 		{
	-- 			objName = 'sibaaa_pearls_maindoor',
	-- 			objYaw = -30.0,
	-- 			objCoords = vector3(-1842.36, -1198.65, 14.33)			
	-- 		}
	-- 	}
	-- },
	-- {
	-- 	objName = 'sibaaa_pearls_frontdoor',
	-- 	objCoords  = vector3(-1830.78, -1181.32, 14.33)		,			
	-- 	textCoords = vector3(-1830.78, -1181.32, 14.33)		,
	-- 	authorizedJobs = { 'diamondcasino' },
	-- 	objYaw = 62.0,
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 3.0,
	-- 	size = 2
	-- },
	-- -- Keukendeur
	-- {
	-- 	objName = 'sibaaa_pearls_kitchendoor',
	-- 	objCoords  = vector3(-1846.55, -1190.40, 14.33)		,			
	-- 	textCoords = vector3(-1846.55, -1190.40, 14.33)		,
	-- 	authorizedJobs = { 'diamondcasino' },
	-- 	objYaw = 332.0,
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 3.0,
	-- 	size = 2
	-- },
	-- {
	-- 	textCoords = vector3(-1823.22, -1201.00, 19.47),
	-- 	authorizedJobs = { 'diamondcasino' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 2.5,
	-- 	doors = {
	-- 		{
	-- 			objName = 'v_ilev_csr_door_l',
	-- 			objYaw = -300.0,
	-- 			objCoords = vector3(-1823.40, -1201.45, 19.47),			
	-- 		},
	-- 		{
	-- 			objName = 'v_ilev_csr_door_r',
	-- 			objYaw = -300.0,
	-- 			objCoords = vector3(-1822.87, -1200.78, 19.47)			
	-- 		}
	-- 	}
	-- },
	-- {
	-- 	objName = 'v_ilev_fa_backdoor',
	-- 	objCoords  = vector3(-1842.93, -1194.48, 19.19)		,			
	-- 	textCoords = vector3(-1842.93, -1194.48, 19.19)		,
	-- 	authorizedJobs = { 'diamondcasino' },
	-- 	objYaw = -300.0,
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 3.0,
	-- 	size = 2
	-- },
	-- {
	-- 	objName = 'v_ilev_bk_door2',
	-- 	objCoords  = vector3(-1830.95, -1181.23, 19.26)		,			
	-- 	textCoords = vector3(-1830.95, -1181.23, 19.26)		,
	-- 	authorizedJobs = { 'diamondcasino' },
	-- 	objYaw = -30.0,
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = false,
	-- 	distance = 3.0,
	-- 	size = 2
	-- },
	-- Gotti Bar
	{
		objName = 'v_ilev_fa_slidedoor',
		objCoords  = vector3(413.28, -1487.02, 33.91),			
		textCoords = vector3(413.28, -1487.02, 33.916),
		authorizedJobs = { 'gotti' },
		objYaw = -30.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 3.0,
		size = 2
	},
	{
		objName = 'v_ilev_ss_door01',
		objCoords  = vector3(427.64, -1515.11, 29.29),			
		textCoords = vector3(427.64, -1515.11, 29.29),
		authorizedJobs = { 'gotti' },
		objYaw = 30.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 3.0,
		size = 2
	},
	{
		objName = 'v_ilev_bk_door2',
		objCoords  = vector3(424.12, -1500.89, 30.155),			
		textCoords = vector3(424.12, -1500.89, 30.155),
		authorizedJobs = { 'gotti' },
		objYaw = -150.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 3.0,
		size = 2
	},
	{
		objName = 'v_ilev_bk_door2',
		objCoords  = vector3(417.00, -1501.93, 33.80),			
		textCoords = vector3(417.00, -1501.93, 33.80),
		authorizedJobs = { 'gotti' },
		objYaw = 30.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 3.0,
		size = 2
	},
	{
		textCoords = vector3(416.26, -1497.53, 33.80),
		authorizedJobs = { 'gotti' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_bk_door2',
				objYaw = -240.0,
				objCoords = vector3(416.06, -1496.5, 33.80),			
			},
			{
				objName = 'v_ilev_bk_door2',
				objYaw = -60.0,
				objCoords = vector3(416.06, -1498.5, 33.80),		
			}
		}
	},
	{
		objName = 'v_ilev_fa_slidedoor',
		objCoords  = vector3(410.12, -1499.66, 33.80),			
		textCoords = vector3(410.12, -1499.66, 33.80),
		authorizedJobs = { 'gotti' },
		objYaw = 30.0,
		locking = false,
		locked = true,
		pickable = false,
		distance = 3.0,
		size = 2
	},
}