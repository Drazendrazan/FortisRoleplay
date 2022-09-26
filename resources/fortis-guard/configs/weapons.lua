--[[ Server Side ]]

RS.weaponsProtection = true -- Masterswitch
RS.weapons_serverSide_Give = true -- Detects ANY weapon Give [[This is not going to detect self-giving]]
RS.weapons_serverSide_RemoveWeapon = true -- Detect if a user tries to remove a weapon from a player (Tazer all players aswell)
RS.weapons_serverSide_RemoveWeaponAll = true -- Detect if a user tries to remove all the weapons from a user
RS.weapons_serverSide_WeaponUse = true -- Detect if a user tries to use a blacklisted weapon (in case it doesn't get removed)
RS.weapons_serverSide_WeaponUse_Anti_Aimbot = false -- Experiemental

--[[ Client Side ]]
RS.weapons_clientSide_DetectionMode = 2 -- 0 Warning, 1 Kick, 2 Ban

-- Projectile Detection
RS.projectileProtection = false -- Enable/Disable Projectile Detection
RS.weapons_projectile_blockall = true -- TRUE = Block and Detect any projectile / FALSE = Block and Detect ONLY blacklisted ones (Blacklisted weapons)
RS.weapons_projectile_detection_mode = 2 -- 0 Warning, 1 Kick, 2 Ban