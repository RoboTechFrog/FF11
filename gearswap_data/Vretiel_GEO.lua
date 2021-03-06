
--[[
        Custom commands:
    
        Toggle Function: 
        gs c toggle melee               Toggle Melee mode on / off and locking of weapons
        gs c toggle mb                  Toggles Magic Burst Mode on / off.
        gs c toggle runspeed            Toggles locking on / off Herald's Gaiters
        gs c toggle idlemode            Toggles between Refresh and DT idle mode. Activating Sublimation JA will auto replace refresh set for sublimation set. DT set will superceed both.        
        gs c toggle regenmode           Toggles between Hybrid, Duration and Potency mode for regen set  
        gs c toggle nukemode            Toggles between Normal and Accuracy mode for midcast Nuking sets (MB included)  
        gs c toggle matchsc             Toggles auto swapping element to match the last SC that just happenned.
		
        Casting functions:
        these are to set fewer macros (2 cycle, 5 cast) to save macro space when playing lazily with controler
        
        gs c nuke cycle              	Cycles element type for nuking & SC
		gs c nuke cycledown				Cycles element type for nuking & SC	in reverse order
        gs c nuke t1                    Cast tier 1 nuke of saved element 
        gs c nuke t2                    Cast tier 2 nuke of saved element 
        gs c nuke t3                    Cast tier 3 nuke of saved element 
        gs c nuke t4                    Cast tier 4 nuke of saved element 
        gs c nuke t5                    Cast tier 5 nuke of saved element 
        gs c nuke ra1                   Cast tier 1 -ra nuke of saved element 
        gs c nuke ra2                   Cast tier 2 -ra nuke of saved element 
        gs c nuke ra3                   Cast tier 3 -ra nuke of saved element 	
		
		gs c geo geocycle				Cycles Geomancy Spell
		gs c geo geocycledown			Cycles Geomancy Spell in reverse order
		gs c geo indicycle				Cycles IndiColure Spell
		gs c geo indicycledown			Cycles IndiColure Spell in reverse order
		gs c geo geo					Cast saved Geo Spell
		gs c geo indi					Cast saved Indi Spell

        HUD Functions:
        gs c hud hide                   Toggles the Hud entirely on or off
        gs c hud hidemode               Toggles the Modes section of the HUD on or off
        gs c hud hidejob                Toggles the job section of the HUD on or off
        gs c hud hidebattle             Toggles the Battle section of the HUD on or off
        gs c hud lite                   Toggles the HUD in lightweight style for less screen estate usage. Also on ALT-END
        gs c hud keybinds               Toggles Display of the HUD keybindings (my defaults) You can change just under the binds in the Gearsets file.

        // OPTIONAL IF YOU WANT / NEED to skip the cycles...  
        gs c nuke Ice                   Set Element Type to Ice DO NOTE the Element needs a Capital letter. 
        gs c nuke Air                   Set Element Type to Air DO NOTE the Element needs a Capital letter. 
        gs c nuke Dark                  Set Element Type to Dark DO NOTE the Element needs a Capital letter. 
        gs c nuke Light                 Set Element Type to Light DO NOTE the Element needs a Capital letter. 
        gs c nuke Earth                 Set Element Type to Earth DO NOTE the Element needs a Capital letter. 
        gs c nuke Lightning             Set Element Type to Lightning DO NOTE the Element needs a Capital letter. 
        gs c nuke Water                 Set Element Type to Water DO NOTE the Element needs a Capital letter. 
        gs c nuke Fire                  Set Element Type to Fire DO NOTE the Element needs a Capital letter. 
--]]

include('Vretiel-Globals.lua')

--Unload Binds
function file_unload()
    send_command('unbind f12')
    send_command('unbind numpad1')
    send_command('unbind numpad2')
    send_command('unbind numpad3')
    send_command('unbind numpad4')
    send_command('unbind numpad5')
    send_command('unbind numpad6')
    send_command('unbind numpad7')
    send_command('unbind numpad8')
    send_command('unbind numpad9')
end

include('organizer-lib') -- Remove if you dont use Organizer

--------------------------------------------------------------------------------------------------------------
res = require('resources')      -- leave this as is    
texts = require('texts')        -- leave this as is    
include('Modes.lua')            -- leave this as is      
--------------------------------------------------------------------------------------------------------------

-- Define your modes: 
-- You can add or remove modes in the table below, they will get picked up in the cycle automatically. 
-- to define sets for idle if you add more modes, name them: sets.me.idle.mymode and add 'mymode' in the group.
-- to define sets for regen if you add more modes, name them: sets.midcast.regen.mymode and add 'mymode' in the group.
-- Same idea for nuke modes. 
idleModes = M('normal', 'dt', 'mdt')
-- To add a new mode to nuking, you need to define both sets: sets.midcast.nuking.mynewmode as well as sets.midcast.MB.mynewmode
nukeModes = M('normal', 'acc')

-- Setting this to true will stop the text spam, and instead display modes in a UI.
-- Currently in construction.
use_UI = true
hud_x_pos = 1700    --important to update these if you have a smaller screen
hud_y_pos = 320     --important to update these if you have a smaller screen
hud_draggable = true
hud_font_size = 8
hud_transparency = 0 -- a value of 0 (invisible) to 255 (no transparency at all)
hud_font = 'Impact'

-- Setup your Key Bindings here:  
    windower.send_command('bind insert gs c nuke cycle')            -- insert Cycles Nuke element
    windower.send_command('bind delete gs c nuke cycledown')        -- delete Cycles Nuke element in reverse order   
    windower.send_command('bind home gs c geo geocycle') 			-- home Cycles Geomancy Spell
    windower.send_command('bind PAGEUP gs c geo geocycledown') 		-- end Cycles Geomancy Spell in reverse order	
    windower.send_command('bind PAGEDOWN gs c geo indicycle') 		-- PgUP Cycles IndiColure Spell
    windower.send_command('bind end gs c geo indicycledown') 	    -- PgDown Cycles IndiColure Spell in reverse order	
    windower.send_command('bind !f9 gs c toggle runspeed') 			-- Alt-F9 toggles locking on / off Herald's Gaiters
	windower.send_command('bind f10 gs c toggle mb')				-- F10 toggles Magic Burst Mode on / off.
    windower.send_command('bind !f10 gs c toggle nukemode')         -- Alt-F10 to change Nuking Mode
    windower.send_command('bind ^F10 gs c toggle matchsc')          -- CTRL-F10 to change Match SC Mode         
    windower.send_command('bind f12 gs c toggle melee')				-- F12 Toggle Melee mode on / off and locking of weapons
	windower.send_command('bind f9 gs c toggle idlemode')			-- F9 Toggles between MasterRefresh or MasterDT when no luopan is out
--[[
    This gets passed in when the Keybinds is turned on.
    Each one matches to a given variable within the text object
    IF you changed the Default Keybind above, Edit the ones below so it can be reflected in the hud using "//gs c hud keybinds" command
]]																	-- or between Full Pet Regen+DT or Hybrid PetDT and MasterDT when a Luopan is out
keybinds_on = {}
keybinds_on['key_bind_idle'] = '(F9)'
keybinds_on['key_bind_regen'] = '(END)'
keybinds_on['key_bind_casting'] = '(ALT-F10)'
keybinds_on['key_bind_mburst'] = '(F10)'
keybinds_on['key_bind_matchsc'] = '(CTRL-F10)'

keybinds_on['key_bind_element_cycle'] = '(INS + DEL)'
keybinds_on['key_bind_geo_cycle'] = '(HOME + PgUP)'
keybinds_on['key_bind_indi_cycle'] = '(End + PgDOWN)'
keybinds_on['key_bind_lock_weapon'] = '(F12)'
keybinds_on['key_bind_movespeed_lock'] = '(ALT-F9)'


-- Remember to unbind your keybinds on job change.
function user_unload()
    send_command('unbind insert')
    send_command('unbind delete')
    send_command('unbind home')
    send_command('unbind PAGEUP')
    send_command('unbind PAGEDOWN')
    send_command('unbind end')
    send_command('unbind f10')
    send_command('unbind f12')
    send_command('unbind f9')
    send_command('unbind !f9')
end

--------------------------------------------------------------------------------------------------------------
include('GEO_Lib.lua')          -- leave this as is     
--------------------------------------------------------------------------------------------------------------

geomancy:set('Geo-Frailty')     -- Geo Spell Default      (when you first load lua / change jobs the saved spells is this one)
indicolure:set('Indi-Fury')    -- Indi Spell Default     (when you first load lua / change jobs the saved spells is this one)
validateTextInformation()

-- Optional. Swap to your geo macro sheet / book
set_macros(1,2) -- Sheet, Book   
    
-- Setup your Gear Sets below:
function get_sets()
  
    -- My formatting is very easy to follow. All sets that pertain to my character doing things are under 'me'.
    -- All sets that are equipped to faciliate my.pan's behaviour or abilities are under .pan', eg, Perpetuation, Blood Pacts, etc
      
    sets.me = {}        -- leave this empty
    sets.pan = {}       -- leave this empty
	sets.me.idle = {}	-- leave this empty    
	sets.pan.idle = {}	-- leave this empty wasa
  
 	-- sets starting with sets.me means you DONT have a luopan currently out.
 	-- sets starting with sets.pan means you DO have a luopan currently out.
 
    -- Your idle set when you D ON'T have a luopan out
    sets.me.idle.normal = {
        main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},
        sub="Ammurapi Shield",
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},

        head="Azimuth Hood +1",
        body="Jhakri Robe +2",
        hands="Mallquis Cuffs +1",
        legs="Assiduity Pants",
        feet="Mallquis Clogs +2",

        neck="Loricate Torque +1",
        waist="Shinjutsu-no-Obi +1",
        left_ear="Handler's Earring +1",
        right_ear="Handler's Earring",
        left_ring="Woltaris Ring",
        right_ring="Stikini Ring",
        back={ name="Nantosuelta's Cape", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','Pet: "Regen"+10','Pet: "Regen"+5',}},
    }
	
	-- This or herald gaiters or +1 +2 +3... 
	sets.me.movespeed = { 
        feet="Geomancy Sandals"
    }
	
    -- Your idle MasterDT set (Notice the sets.me, means no Luopan is out)
    sets.me.idle.dt = set_combine(sets.me.idle.normal,{
        body="Mallquis Saio +2",
    })
    sets.me.idle.mdt = set_combine(sets.me.idle.normal,{
        body="Mallquis Saio +2",
    })	
    -- Your MP Recovered Whilst Resting Set
    sets.me.resting = sets.me.idle.normal
	
	sets.me.latent_refresh = {waist="Fucho-no-obi"}
	
	
    -----------------------
    -- Luopan Perpetuation
    -----------------------

    --Hit Points	        ~1,680
    --Innate Damage Taken	-50%  /  86.5
    --Perpetuation Cost
    --Base	                -24 HP/tic
    --Lasting Emanation	    -17 HP/tic
    --Ecliptic Attrition	-30 HP/tic
    --Both          	    -23 HP/tic
      
    -- Luopan's Out --  notice sets.pan 
    -- This is the base for all perpetuation scenarios, as seen below
    sets.pan.idle.normal = {  -- 29 TOTAL
        main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},
        sub="Ammurapi Shield",
        head="Azimuth Hood +1",  --3
        body={ name="Telchine Chas.", augments={'Pet: "Regen"+2','Enh. Mag. eff. dur. +8',}},   -- 2
        neck="Loricate Torque +1",
        feet={ name="Telchine Pigaches", augments={'Pet: "Regen"+3','Enh. Mag. eff. dur. +9',}},  --3
        hands={ name="Telchine Gloves", augments={'Pet: "Regen"+2','Enh. Mag. eff. dur. +9',}},  -- 2
        legs={ name="Merlinic Shalwar", augments={'STR+6','Pet: "Regen"+4','Accuracy+3 Attack+3',}},  -- 4
        left_ear="Handler's Earring +1",
        right_ear="Handler's Earring",
        back={ name="Nantosuelta's Cape", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','Pet: "Regen"+10','Pet: "Regen"+5',}},  --15 
    }
	
	-- This is when you have a Luopan out but want to sacrifice some slot for master DT, put those slots in.
    sets.pan.idle.dt = set_combine(sets.pan.idle.normal,{
        body="Mallquis Saio +2",
        neck="Loricate Torque +1",
    })   
    sets.pan.idle.mdt = set_combine(sets.pan.idle.normal,{
        neck="Loricate Torque +1",
        body="Mallquis Saio +2",
    })   


    -- Combat Related Sets  ----------------------------------------------
      
    -- Melee
    -- Anything you equip here will overwrite the perpetuation/refresh in that slot.
	-- No Luopan out
	-- they end in [idleMode] so it will derive from either the normal or the dt set depending in which mode you are then add the pieces filled in below.
    sets.me.melee = set_combine(sets.me.idle[idleMode],{

    })
	
    -- Luopan is out
	sets.pan.melee = set_combine(sets.pan.idle[idleMode],{

    }) 
    
    -- Weapon Skill sets
	-- Example:
    sets.me["Flash Nova"] = {

    }

    sets.me["Realmrazer"] = {

    }
	
    sets.me["Exudation"] = {

    } 
    -- Feel free to add new weapon skills, make sure you spell it the same as in game.
  
    ---------------
    -- Casting Sets
    ---------------
      
    sets.precast = {}               -- leave this empty    
    sets.midcast = {}               -- leave this empty    
    sets.aftercast = {}             -- leave this empty    
    sets.midcast.nuking = {}        -- leave this empty
    sets.midcast.MB = {}            -- leave this empty    
    ----------
    -- Precast
    ----------
      
    -- Generic Casting Set that all others take off of. Here you should add all your fast cast  
    sets.precast.casting = {
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
        legs="Geomancy Pants",
        feet={ name="Merlinic Crackows", augments={'Weapon skill damage +3%','Weapon Skill Acc.+7','"Treasure Hunter"+2','Accuracy+8 Attack+8','Mag. Acc.+19 "Mag.Atk.Bns."+19',}},
        main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},
        sub="Ammurapi Shield",
        back={ name="Lifestream Cape", augments={'Geomancy Skill +8','Indi. eff. dur. +17','Pet: Damage taken -4%','Damage taken-4%',}},
    }   

    sets.precast.geomancy = set_combine(sets.precast.casting,{
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
        main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},
        sub="Ammurapi Shield",
        hands="Geomancy Mitaines",
        neck="Bagua Charm +2",
        left_ring= {name="Stikini Ring", bag="wardrobe1"},
        right_ring= {name="Stikini Ring", bag="wardrobe2"},
        body={ name="Bagua Tunic", augments={'Enhances "Bolster" effect',}},
        head="Azimuth Hood +1",
        back={ name="Lifestream Cape", augments={'Geomancy Skill +8','Indi. eff. dur. +17','Pet: Damage taken -4%','Damage taken-4%',}},
    })
    -- Enhancing Magic, eg. Siegal Sash, etc
    sets.precast.enhancing = set_combine(sets.precast.casting,{

    })
  
    -- Stoneskin casting time -, works off of enhancing -
    sets.precast.stoneskin = set_combine(sets.precast.enhancing,{

    })
      
    -- Curing Precast, Cure Spell Casting time -
    sets.precast.cure = set_combine(sets.precast.casting,{
        
    })
    sets.precast.regen = set_combine(sets.precast.casting,{

    })     

    sets.precast['Elemental Magic'] = {
        head="Mallquis Chapeau +1",
        body="Mallquis Saio +2",
        hands="Mallquis Cuffs +1",
        legs="Mallquis Trews",
        feet="Mallquis Clogs +2",
        left_ring="Mallquis Ring",
    }
    ---------------------
    -- Ability Precasting
    ---------------------
	
	-- Fill up with your JSE! 
    sets.precast["Life Cycle"] = {
        body = "Geomancy Tunic",
        back={ name="Nantosuelta's Cape", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','Pet: "Regen"+10','Pet: "Regen"+5',}},
    }
    sets.precast["Bolster"] = {
    	body = "Bagua Tunic",
    }
    sets.precast["Primeval Zeal"] = {
    	head = "Bagua Galero",
    }  
    sets.precast["Cardinal Chant"] = {
    	head = "Geomancy Galero",
    }  
    sets.precast["Full Circle"] = {
        head="Azimuth Hood +1",
    }  
    sets.precast["Curative Recantation"] = {
    	hands = "Bagua Mitaines",
    }  
    sets.precast["Mending Halation"] = {
    	legs = "Bagua Pants",
    }
    sets.precast["Radial Arcana"] = {
    	feet = "Bagua Sandals",
    }

    ----------
    -- Midcast
    ----------
            
    -- Whatever you want to equip mid-cast as a catch all for all spells, and we'll overwrite later for individual spells
    sets.midcast.casting = {}

    sets.midcast.Cursna = {
        neck="Malison Medallion",
        feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
        left_ring = {name="Ephedra Ring", bag="wardrobe1"},
        right_ring = {name="Ephedra Ring", bag="wardrobe2"},
    }
	
	-- For Geo spells /
    sets.midcast.geo = set_combine(sets.midcast.casting,{
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
        main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},
        sub="Ammurapi Shield",
        hands="Geomancy Mitaines",
        feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
        left_ring="Stikini Ring",
        head="Azimuth Hood +1",
        neck="Bagua Charm +2",
        left_ring= {name="Stikini Ring", bag="wardrobe1"},
        right_ring= {name="Stikini Ring", bag="wardrobe2"},
        body={ name="Bagua Tunic", augments={'Enhances "Bolster" effect',}},
        back={ name="Lifestream Cape", augments={'Geomancy Skill +8','Indi. eff. dur. +17','Pet: Damage taken -4%','Damage taken-4%',}},
    })
	-- For Indi Spells
    sets.midcast.indi = set_combine(sets.midcast.geo,{
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
        main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},
        sub="Ammurapi Shield",
        head="Azimuth Hood +1",
        hands="Geomancy Mitaines",
        feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
        neck="Bagua Charm +2",
        left_ring= {name="Stikini Ring", bag="wardrobe1"},
        right_ring= {name="Stikini Ring", bag="wardrobe2"},
        body={ name="Bagua Tunic", augments={'Enhances "Bolster" effect',}},
        back={ name="Lifestream Cape", augments={'Geomancy Skill +8','Indi. eff. dur. +17','Pet: Damage taken -4%','Damage taken-4%',}},
    })

	sets.midcast.Obi = {
	    waist="Hachirin-no-Obi",
	}
	
	-- Nuking
    sets.midcast.nuking.normal = set_combine(sets.midcast.casting,{
        main="Eletta Rod",
        sub="Ammurapi Shield",
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
        head="Jhakri Coronal +1",
        body="Jhakri Robe +2",
        hands="Jhakri Cuffs +1",
        legs={ name="Merlinic Shalwar", augments={'"Mag.Atk.Bns."+24','Attack+8','Accuracy+16 Attack+16','Mag. Acc.+16 "Mag.Atk.Bns."+16',}},
        feet={ name="Merlinic Crackows", augments={'"Cure" spellcasting time -2%','CHR+9','Magic burst dmg.+15%','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},
        neck="Bagua Charm +2",
        waist="Belisama's Rope +1",
        left_ear="Handler's Earring +1",
        right_ear="Gifted Earring",
        left_ring="Acumen Ring",
        right_ring="Mallquis Ring",
        back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},
    })
	sets.midcast.MB.normal = set_combine(sets.midcast.nuking.normal, {
        legs={ name="Merlinic Shalwar", augments={'"Mag.Atk.Bns."+28','Magic burst dmg.+11%','CHR+6','Mag. Acc.+3',}},
	})
    sets.midcast.nuking.acc = set_combine(sets.midcast.nuking.normal,{

    })
    sets.midcast.MB.acc = set_combine(sets.midcast.MB.normal, {

    })

	-- Enfeebling
	sets.midcast.IntEnfeebling = set_combine(sets.midcast.casting,{
        main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},
        sub="Ammurapi Shield",
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
        head="Mallquis Chapeau +1",
        body="Mallquis Saio +2",
        hands="Mallquis Cuffs +1",
        legs="Mallquis Trews +1",
        feet="Mallquis Clogs +2",
        neck="Bagua Charm +2",
        waist="Mrc.Cpt. Belt",
        left_ear="Flashward Earring",
        right_ear="Spellbr. Earring",
        left_ring="Stikini Ring",
        right_ring="Stikini Ring",
        back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},
    })
	sets.midcast.MndEnfeebling = set_combine(sets.midcast.casting,{
        main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},
        sub="Ammurapi Shield",
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
        head="Mallquis Chapeau +1",
        body="Mallquis Saio +2",
        hands="Mallquis Cuffs +1",
        legs="Mallquis Trews +1",
        feet="Mallquis Clogs +2",
        neck="Bagua Charm +2",
        waist="Mrc.Cpt. Belt",
        left_ear="Flashward Earring",
        right_ear="Spellbr. Earring",
        left_ring="Stikini Ring",
        right_ring="Stikini Ring",
        back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},
    })
	
    -- Enhancing
    sets.midcast.enhancing = set_combine(sets.midcast.casting,{
        main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},
        sub="Ammurapi Shield",
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
        head={ name="Telchine Cap", augments={'Pet: "Regen"+2','Enh. Mag. eff. dur. +8',}},
        body={ name="Telchine Chas.", augments={'Pet: "Regen"+2','Enh. Mag. eff. dur. +8',}},
        hands={ name="Telchine Gloves", augments={'Pet: "Regen"+2','Enh. Mag. eff. dur. +9',}},
        feet={ name="Telchine Pigaches", augments={'Pet: "Regen"+3','Enh. Mag. eff. dur. +9',}},
        legs="Geomancy Pants",
        neck="Loricate Torque +1",
        waist="Cascade Belt",
        left_ear="Handler's Earring +1",
        right_ear="Gifted Earring",
        left_ring="Stikini Ring",
        right_ring="Stikini Ring",
        back={ name="Lifestream Cape", augments={'Geomancy Skill +8','Indi. eff. dur. +17','Pet: Damage taken -4%','Damage taken-4%',}},
    })
	
    -- Stoneskin
    sets.midcast.stoneskin = set_combine(sets.midcast.enhancing,{
    })
    sets.midcast.refresh = set_combine(sets.midcast.enhancing,{
    })
    sets.midcast.aquaveil = sets.midcast.refresh
	
	sets.midcast["Drain"] = set_combine(sets.midcast.IntEnfeebling, {
        head="Mallquis Chapeau +1",
        body="Mallquis Saio +2",
        hands="Mallquis Cuffs +1",
        legs="Mallquis Trews",
        feet={ name="Merlinic Crackows", augments={'Weapon skill damage +3%','Weapon Skill Acc.+7','"Treasure Hunter"+2','Accuracy+8 Attack+8','Mag. Acc.+19 "Mag.Atk.Bns."+19',}},
        neck="Bagua Charm +2",
        waist="Belisama's Rope +1",
        left_ear="Handler's Earring +1",
        right_ear="Handler's Earring",
        left_ring= {name="Stikini Ring", bag="wardrobe1"},
        right_ring= {name="Stikini Ring", bag="wardrobe2"},
        back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},
	})

	sets.midcast["Aspir"] = sets.midcast["Drain"]
     
    sets.midcast.cure = {} -- Leave This Empty
    -- Cure Potency
    sets.midcast.cure.normal = set_combine(sets.midcast.casting,{
        main="Tamaxchi",
        sub="Sors Shield",
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
        head="Mallquis Chapeau +1",
        body={ name="Vanya Robe", augments={'HP+50','MP+50','"Refresh"+2',}},
        hands={ name="Telchine Gloves", augments={'Pet: "Regen"+2','Enh. Mag. eff. dur. +9',}},
        legs="Assiduity Pants",
        feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
        neck="Bagua Charm +2",
        waist="Belisama's Rope +1",
        left_ear="Handler's Earring +1",
        right_ear="Handler's Earring",
        left_ring="Stikini Ring",
        right_ring="Stikini Ring",
        back={ name="Nantosuelta's Cape", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','Pet: "Regen"+10','Pet: "Regen"+5',}},
    })
    sets.midcast.cure.weather = set_combine(sets.midcast.cure.normal,{

    })    
    sets.midcast.regen = set_combine(sets.midcast.enhancing,{

    }) 
   
    ------------
    -- Aftercast
    ------------
      
    -- I don't use aftercast sets, as we handle what to equip later depending on conditions using a function, eg, do we have a Luopan pan out?
  
end
