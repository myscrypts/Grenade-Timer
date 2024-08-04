# Time Grenades 🕒💣

**Version:** 3.7  
**Author:** hckr

---

## 📝 Description:
Allows admins and VIPs to set custom explosion times for grenades via in-game menu and shows HUD countdown.

## 🔍 Overview
*Settings Time Grenades* plugin enables server admins and VIPs to configure the explosion times for grenades (HE, Flashbang, and Smoke Grenades) through an in-game menu. The plugin also displays a countdown timer on the HUD for the grenades. It includes functionality to reset grenade times to default and manage permissions for setting times.

## ✨ Features
- **Customizable Grenade Times:**
  - 💥 **HE Grenade:** Set custom explosion time.
  - 🌟 **Flashbang:** Set custom explosion time.
  - 💨 **Smoke Grenade:** Set custom explosion time.
  
- **HUD Countdown:**
  - 🖥️ Displays a countdown timer on the HUD for each grenade type.
- **Admin and VIP Access:**
  - 🔐 Allows only users with specific access rights (admins and VIPs) to configure grenade times.
- **Menu Options:**
  - ⚙️ Set custom times for HE, Flashbang, and Smoke Grenades.
  - 🔄 Reset grenade times to default values.

## ⚙️ Configuration
- **Constants:**
  - `MAX_GRENADE_TIME`: Maximum allowed grenade time (10.0 seconds).
  - `DEFAULT_HE_TIME`: Default explosion time for HE Grenades (3.0 seconds).
  - `DEFAULT_FLASH_TIME`: Default explosion time for Flashbangs (2.0 seconds).
  - `DEFAULT_SMOKE_TIME`: Default explosion time for Smoke Grenades (4.0 seconds).

## 🖥️ Commands
- **`say .gt`**: Opens the grenade time settings menu.
- **`enter_he_time`**: Sets the time for HE Grenades.
- **`enter_flash_time`**: Sets the time for Flashbangs.
- **`enter_smoke_time`**: Sets the time for Smoke Grenades.

## 📋 Menu
The grenade time settings menu allows the user to:
1. Set the explosion time for HE Grenades.
2. Set the explosion time for Flashbangs.
3. Set the explosion time for Smoke Grenades.
4. Reset all grenade times to default values.

## 📥 Installation
1. Place the plugin file in the `plugins` directory of your AMXX server.
2. Add the corresponding line to the `plugins.ini` file to register the plugin.
3. Restart the server or change the map.

## 📝 Notes
- Adjust access levels and default grenade times as needed in the plugin code or configuration files.

## 📜 License
This project is licensed under the terms of the GNU General Public License, version 3. You can find a copy of the license at [https://www.gnu.org/licenses/gpl-3.0.html](https://www.gnu.org/licenses/gpl-3.0.html).
