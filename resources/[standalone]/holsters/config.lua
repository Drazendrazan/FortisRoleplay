--[[
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
--]]

-- Created by Jamelele

-- Take a look at the documentation for configuring:
-- https://github.com/Jamelele/holsters/wiki/Configuration-Guide

config = {
  ["weapon"] = { "WEAPON_PISTOL", "WEAPON_COMBATPISTOL", "WEAPON_HEAVYPISTOL" }, -- Whitelisted Wapens
  ["peds"] = {
    ["mp_m_freemode_01"] = { -- Mannelijk
      ["components"] = {
        [5] = { -- Tassen
          [25] = 26
        },
        [7] = { -- Nek
          [4] = 1,
          [2] = 20,
          [3] = 7,
          [5] = 9,
          [6] = 8,
          [48] = 45,
          [46] = 47,
          [79] = 78,--
          [80] = 81, 
          [83] = 82,
          [85] = 84,
          [87] = 86,
          [88] = 89,
          [90] = 91,
          [92] = 93,
          [94] = 95,
          [96] = 97,
          [98] = 99,
          [100] = 101,
          [102] = 103,
          [104] = 105,
          [119] = 120
        },
        [8] = {
          [16] = 18
        }
      }
    },
    ["mp_f_freemode_01"] = { -- Female multiplayer ped
      ["components"] = {
        [7] = { -- Component ID, "Neck" or "Teeth" category
          [4] = 1,
          [2] = 12,
          [3] = 7,
          [5] = 31,
          [6] = 8,
        },
        [8] = {
          [9] = 10
        }
      }
    },
    ["s_m_y_hwaycop_01"] = {
      ["enabled"] = true, -- true/false. Optional field, the ped will default as enabled
      ["components"] = {
        [9] = {
          [1] = 0
        }
      }
    },
    ["s_m_y_cop_01"] = {
      ["components"] = {
        [9] = {
          [1] = 0
        }
      }
    },
    ["s_m_y_sheriff_01"] = {
      ["components"] = {
        [9] = {
          [1] = 0
        }
      }
    },
  }
}