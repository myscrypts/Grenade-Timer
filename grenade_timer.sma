#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>

public stock const
    PluginName[] = "Grenades Time",
    PluginVersion[] = "3.8",
    PluginAuthor[] = "hckr",
    PluginURL[] = "https://github.com/myscrypts/Grenade-Timer",
    PluginDescription[] = "Allows admins and VIPs to set custom explosion times for grenades via in-game menu and shows HUD countdown";

const m_fBombStatus = 96;
const m_usEvent     = 114;
    
const fBombPlanted = 1 << 8;
const fExploEvent  = 1 << 0;
const fSmokeEvent  = 1 << 1;

const Float:MAX_GRENADE_TIME = 10.0;
const Float:DEFAULT_HE_TIME = 3.0;
const Float:DEFAULT_FLASH_TIME = 2.0;
const Float:DEFAULT_SMOKE_TIME = 4.0;

new Float:g_flTimeHe[33];
new Float:g_flTimeFlash[33];
new Float:g_flTimeSmoke[33];

new HamHook:SmokeThink;
new HudSync;

public plugin_init()
{
    register_plugin(PluginName, PluginVersion, PluginAuthor);
    
    register_clcmd("say .gt", "CmdGrenadeTime");
    register_clcmd("enter_he_time", "SetHETime");
    register_clcmd("enter_flash_time", "SetFlashTime");
    register_clcmd("enter_smoke_time", "SetSmokeTime");
    
    register_event("HLTV", "roundBegin", "a", "1=0", "2=0");
    register_forward(FM_SetModel, "Fw_NadeModel", 1);
    
    SmokeThink = RegisterHam(Ham_Think, "grenade", "Fw_NadeThink");
    RegisterHam(Ham_Think, "grenade", "Fw_GrenadeThink", 1);
    
    HudSync = CreateHudSyncObj();
    
    set_task(10.0, "check_player_privileges", .flags = "b");
    
    roundBegin();
}

public client_putinserver(id)
{
    reset_grenade_times(id);
}

public CmdGrenadeTime(id)
{
    if (!has_access(id))
    {
        client_print(id, print_chat, "No tienes acceso a este comando.");
        return PLUGIN_HANDLED;
    }
    
    ShowGrenadeTimeMenu(id);
    return PLUGIN_HANDLED;
}

public ShowGrenadeTimeMenu(id)
{
    new menu_title[128];
    formatex(menu_title, charsmax(menu_title), "rConfigurar tiempo de Granadas^nyTiempos actuales: HE: (%.1f), Flash: (%.1f), Smoke: (%.1f)", g_flTimeHe[id], g_flTimeFlash[id], g_flTimeSmoke[id]);
    new menu = menu_create(menu_title, "HandleGrenadeTimeMenu");
    
    menu_additem(menu, "Establecer tiempo de granada [HE]", "1");
    menu_additem(menu, "Establecer tiempo de granada [FB]", "2");
    menu_additem(menu, "Establecer tiempo de granada [SG]", "3");
    menu_additem(menu, "Restablecer tiempos por defecto", "4");
    
    menu_setprop(menu, MPROP_EXIT, MEXIT_ALL);
    
    menu_display(id, menu, 0);
}

public HandleGrenadeTimeMenu(id, menu, item)
{
    if (item == MENU_EXIT)
    {
        menu_destroy(menu);
        return PLUGIN_HANDLED;
    }
    
    new data[6], iName[64];
    new access, callback;
    
    menu_item_getinfo(menu, item, access, data, 5, iName, 63, callback);
    
    new choice = str_to_num(data);
    
    switch (choice)
    {
        case 1: client_cmd(id, "messagemode enter_he_time");
        case 2: client_cmd(id, "messagemode enter_flash_time");
        case 3: client_cmd(id, "messagemode enter_smoke_time");
        case 4: 
        {
            reset_grenade_times(id);
            client_print(id, print_chat, "Los tiempos de las granadas han sido restablecidos a los valores por defecto.");
            ShowGrenadeTimeMenu(id);
        }
    }
    
    menu_destroy(menu);
    return PLUGIN_HANDLED;
}

public SetHETime(id)
{
    if (!has_access(id))
        return PLUGIN_HANDLED;

    new szTime[32];
    read_args(szTime, charsmax(szTime));
    remove_quotes(szTime);
    trim(szTime);
    
    new Float:time = str_to_float(szTime);
    
    if (time < 0.1 || time > MAX_GRENADE_TIME)
    {
        client_print(id, print_chat, "Tiempo no válido. Introduzca un valor entre 0.1 y %.1f segundos.", MAX_GRENADE_TIME);
        ShowGrenadeTimeMenu(id);
        return PLUGIN_HANDLED;
    }
    
    g_flTimeHe[id] = time;
    client_print(id, print_chat, "Tiempo de granada [HE] establecido en %.1f segundos", g_flTimeHe[id]);
    ShowGrenadeTimeMenu(id);
    return PLUGIN_HANDLED;
}

public SetFlashTime(id)
{
    if (!has_access(id))
        return PLUGIN_HANDLED;

    new szTime[32];
    read_args(szTime, charsmax(szTime));
    remove_quotes(szTime);
    trim(szTime);
    
    new Float:time = str_to_float(szTime);
    
    if (time < 0.1 || time > MAX_GRENADE_TIME)
    {
        client_print(id, print_chat, "Tiempo no válido. Introduzca un valor entre 0.1 y %.1f segundos.", MAX_GRENADE_TIME);
        ShowGrenadeTimeMenu(id);
        return PLUGIN_HANDLED;
    }
    
    g_flTimeFlash[id] = time;
    client_print(id, print_chat, "Tiempo de granada [FB] establecido en %.1f segundos", g_flTimeFlash[id]);
    ShowGrenadeTimeMenu(id);
    return PLUGIN_HANDLED;
}

public SetSmokeTime(id)
{
    if (!has_access(id))
        return PLUGIN_HANDLED;

    new szTime[32];
    read_args(szTime, charsmax(szTime));
    remove_quotes(szTime);
    trim(szTime);
    
    new Float:time = str_to_float(szTime);
    
    if (time < 0.1 || time > MAX_GRENADE_TIME)
    {
        client_print(id, print_chat, "Tiempo no válido. Introduzca un valor entre 0.1 y %.1f segundos.", MAX_GRENADE_TIME);
        ShowGrenadeTimeMenu(id);
        return PLUGIN_HANDLED;
    }
    
    g_flTimeSmoke[id] = time;
    client_print(id, print_chat, "Tiempo de granada [SG] establecido en %.1f segundos", g_flTimeSmoke[id]);
    ShowGrenadeTimeMenu(id);
    return PLUGIN_HANDLED;
}

stock bool:has_access(id)
{
    new flags = get_user_flags(id);
    return (flags & ADMIN_LEVEL_H || flags & ADMIN_RESERVATION);
}

public roundBegin()
{
    if (g_flTimeSmoke[0] <= 0.0)
    {
        if (SmokeThink)
        {
            DisableHamForward(SmokeThink);
        }
    }
    else
    {
        if (SmokeThink)
        {
            EnableHamForward(SmokeThink);
        }
        else
        {
            SmokeThink = RegisterHam(Ham_Think, "grenade", "Fw_NadeThink"); 
        }
    }
}

public Fw_NadeModel(const nade, const NadeModel[]) 
{ 
    if (pev_valid(nade)) 
    { 
        static nade_ID;
        nade_ID = grenade_type(nade, 1);
        
        if (nade_ID) 
        { 
            new owner = pev(nade, pev_owner);
            new Float:nadeTime;
            
            if (has_access(owner))
            {
                switch (nade_ID)
                {
                    case CSW_HEGRENADE: nadeTime = g_flTimeHe[owner];
                    case CSW_FLASHBANG: nadeTime = g_flTimeFlash[owner];
                    case CSW_SMOKEGRENADE: nadeTime = g_flTimeSmoke[owner];
                }
            }
            else
            {
                switch (nade_ID)
                {
                    case CSW_HEGRENADE: nadeTime = DEFAULT_HE_TIME;
                    case CSW_FLASHBANG: nadeTime = DEFAULT_FLASH_TIME;
                    case CSW_SMOKEGRENADE: nadeTime = DEFAULT_SMOKE_TIME;
                }
            }
            
            if (nadeTime > 0.0)
            {
                set_pev(nade, pev_dmgtime, get_gametime() + nadeTime);
            }
        }
    }
} 

public Fw_NadeThink(const nade) 
{ 
    if (pev_valid(nade) && grenade_type(nade) == CSW_SMOKEGRENADE) 
    { 
        set_pev(nade, pev_flags, FL_ONGROUND);
    }
} 

public Fw_GrenadeThink(ent)
{
    if (!pev_valid(ent))
        return HAM_IGNORED;
    
    static owner;
    owner = pev(ent, pev_owner);
    
    if (!is_user_connected(owner) || !has_access(owner))
        return HAM_IGNORED;
    
    static Float:dmgtime;
    pev(ent, pev_dmgtime, dmgtime);
    
    static Float:current_time;
    current_time = get_gametime();
    
    if (dmgtime > current_time)
    {
        static nade_type;
        nade_type = grenade_type(ent);
        
        if (nade_type == CSW_HEGRENADE || nade_type == CSW_FLASHBANG || nade_type == CSW_SMOKEGRENADE)
        {
            static Float:time_left;
            time_left = dmgtime - current_time;
            
            static nade_name[16];
            switch (nade_type)
            {
                case CSW_HEGRENADE: nade_name = "HE";
                case CSW_FLASHBANG: nade_name = "Flash";
                case CSW_SMOKEGRENADE: nade_name = "Smoke";
            }
            
            set_hudmessage(15, 190, 255, -0.11, -0.14, 0, 6.0, 0.1, 0.0, 0.0, -1);
            ShowSyncHudMsg(owner, HudSync, "%s: %.1f", nade_name, time_left);
        }
    }
    
    return HAM_IGNORED;
}

stock grenade_type(const index, const checkClassName = 0)  
{ 
    static classname[9];
    
    if (checkClassName) 
    { 
        pev(index, pev_classname, classname, 8);
        if (!equal(classname, "grenade")) 
        { 
            return 0;
        } 
    } 
    
    if (get_pdata_int(index, m_fBombStatus) & fBombPlanted)
    {
        return 0;
    }
    
    static bits; bits = get_pdata_int(index, m_usEvent);
    
    if (bits & fExploEvent) 
    { 
        return CSW_HEGRENADE;
    } 
    else if (!bits) 
    { 
        return CSW_FLASHBANG;
    } 
    else if (bits & fSmokeEvent) 
    { 
        return CSW_SMOKEGRENADE;
    } 
    
    return 0;
}

stock reset_grenade_times(id)
{
    g_flTimeHe[id] = DEFAULT_HE_TIME;
    g_flTimeFlash[id] = DEFAULT_FLASH_TIME;
    g_flTimeSmoke[id] = DEFAULT_SMOKE_TIME;
}

public check_player_privileges()
{
    static players[32], num, i, id;
    get_players(players, num);
    
    for (i = 0; i < num; i++)
    {
        id = players[i];
        if (!has_access(id))
        {
            reset_grenade_times(id);
        }
    }
}
