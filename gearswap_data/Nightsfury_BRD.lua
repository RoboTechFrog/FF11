
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:
    
    ExtraSongsMode may take one of three values: None, Dummy, FullLength
    
    You can set these via the standard 'set' and 'cycle' self-commands.  EG:
    gs c cycle ExtraSongsMode
    gs c set ExtraSongsMode Dummy
    
    The Dummy state will equip the bonus song instrument and ensure non-duration gear is equipped.
    The FullLength state will simply equip the bonus song instrument on top of standard gear.
    
    
    Simple macro to cast a dummy Daurdabla song:
    /console gs c set ExtraSongsMode Dummy
    /ma "Shining Fantasia" <me>
    
--]]

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.ExtraSongsMode = M{['description']='Extra Songs', 'None', 'FullLength', 'Dummy'}
	state.LullabyMode = M{['description']='Lullaby Mode','Gjallarhorn','Daurdabla'}
    state.Buff['Pianissimo'] = buffactive['pianissimo'] or false
	state.IdleMode:options('Normal','PDT','MEVA')
	state.TPMode = M{['description']='TP Mode', 'Normal', 'WeaponLock'}
	send_command('alias tp gs c cycle tpmode')
	send_command('bind f10 gs c cycle idlemode')
	send_command('bind f11 gs c cycle LullabyMode')
	send_command("alias buff gs equip sets.midcast.SongEffect")
    send_command("alias debuff gs equip sets.midcast.SongDebuff")
	send_command("alias macc gs equip sets.midcast.ResistantSongDebuff")
	send_command("alias lul gs equip sets.midcast.LullabyFull")
	send_command("alias fc gs equip sets.precast.FastCast.BardSong")
	send_command("alias idle gs equip sets.Idle.Current")
	send_command("alias meva gs equip sets.meva")
	send_command("alias enh gs equip sets.midcast['Enhancing Magic']")
	send_command("alias eng gs equip sets.engaged")
	send_command("alias wsset gs equip sets.precast.WS")
	    -- For tracking current recast timers via the Timers plugin.
    custom_timers = {}
	
	send_command("alias g11_m2g16 input /ws Rudra's Storm")
	send_command("alias g11_m2g17 input /ws Mordant Rime")
	send_command("alias g11_m2g18 input /ws Exenterator")
	
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal')
    state.CastingMode:options('Normal', 'Resistant')
    
    -- Adjust this if using the Terpander (new +song instrument)
    info.ExtraSongInstrument = 'Terpander'
    -- How many extra songs we can keep from Daurdabla/Terpander
    
	info.MaxSongs = 3
	
	-- If Max Job Points - adds alot of timers to the custom timers
	MaxJobPoints = 1
    
    -- Set this to false if you don't want to use custom timers.
    state.UseCustomv = M(false, 'Use Custom Timers')
    
    -- Additional local binds
    --send_command('bind ^` gs c cycle ExtraSongsMode')
    --send_command('bind !` input /ma "Chocobo Mazurka" <me>')

    select_default_macro_book()
	--send_command('@wait 5;input /lockstyleset 40')
	
	waittime = 2.7

end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------			
    -- Start defining the sets
    --------------------------------------
    
	weaponlock_main="Aeneas"
	weaponlock_sub="Genmei Shield"
	    -- Precast Sets

	-- Fast cast sets for spells
	sets.precast.FastCast = {}
    sets.precast.FC = {
		main={ name="Kali", augments={'MP+60','Mag. Acc.+20','"Refresh"+1',}},  --7
    	--sub="Genmei Shield",
		hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}}, --8
		left_ring="Kishar Ring", --4
		body="Inyanga Jubbah +1", --10
		right_ear="Aoidos' Earring", --2
		legs="Aya. Cosciales +2", --5
		head="Nahtirah Hat", --10
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+5','"Fast Cast"+10','Damage taken-5%',}},
	}

    sets.precast.FastCast.Cure = set_combine(sets.precast.FastCast, {
		head="Nahtirah Hat",
		main={ name="Serenity", augments={'MP+50','Enha.mag. skill +8','"Cure" potency +3%','"Cure" spellcasting time -9%',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
		legs="Gyve Trousers",
		waist="Hachirin-no-Obi",
		left_ear="Darkside Earring",
		body="Inyanga Jubbah +1", --10			
		right_ear="Hermetic Earring", 			
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+5','"Fast Cast"+10','Damage taken-5%',}},
		left_ring="Kishar Ring",
		sub="Achaq Grip",
	})

    sets.precast.FastCast.Stoneskin = set_combine(sets.precast.FastCast, { waist="Siegel Sash", })

    sets.precast.FastCast['Enhancing Magic'] = set_combine(sets.precast.FastCast, {
		main={ name="Serenity", augments={'MP+50','Enha.mag. skill +8','"Cure" potency +3%','"Cure" spellcasting time -9%',}},
	})

    sets.precast.FastCast.BardSong = {
		
	}

    sets.precast.FastCast.Daurdabla = set_combine(sets.precast.FastCast.BardSong, {
		
	})
        
    
    -- Precast sets to enhance JAs
    
    sets.precast.JA.Nightingale = {

	}
    sets.precast.JA.Troubadour = {

	}
    sets.precast.JA['Soul Voice'] = {

	}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {}
    
       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
		main={ name="Taming Sari", augments={'STR+9','DEX+8','DMG:+14',}},
		sub="Odium",
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands="Aya. Manopolas +2",
		legs="Aya. Cosciales +2",
		feet="Aya. Gambieras +2",
		neck="Lissome Necklace",
		waist="Grunfeld Rope",
		left_ear="Suppanomimi",
		right_ear="Brutal Earring",
		left_ring="Petrov Ring",
		right_ring="Rajas Ring",
		back="Atheling Mantle",
	}

		
    
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {

	})
    sets.precast.WS['Rudras Storm'] = set_combine(sets.precast.WS)
    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {

	})
	sets.precast.WS['Mordant Rime'] = set_combine(sets.precast.WS)
	
	sets.precast.WS['Aeolian Edge'] = {
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands={ name="Chironic Gloves", augments={'"Mag.Atk.Bns."+19','"Fast Cast"+4','Mag. Acc.+14',}},
		legs="Gyve Trousers",
		feet="Aya. Gambieras +2",
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Friomisi Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +25',}},
		left_ring="Acumen Ring",
		right_ring="Arvina Ringlet +1",
		back="Laic Mantle",
	}
    
    
    -- Midcast Sets

    -- General set for recast times.
    sets.midcast.FastRecast = {
		body="Inyanga Jubbah +1", --10
		ring2="Kishar Ring", --4
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+5','"Fast Cast"+10','Damage taken-5%',}},
	}
        
    -- Gear to enhance certain classes of songs. //gs 
    sets.midcast.Ballad = {}
    sets.midcast.Lullaby = {hands="Brioso Cuffs +3"}
    sets.midcast.Madrigal = {head="Fili Calot +1",back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+5','"Fast Cast"+10','Damage taken-5%',}},}
	sets.midcast.Prelude = {back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}}}
    sets.midcast.March = {hands="Fili Manchettes"}
	sets.midcast.HonorMarch = {hands="Fili Manchettes",range="Marsyas"}
    sets.midcast.Minuet = {body="Fili Hongreline +1"}
    sets.midcast.Minne = {}
    sets.midcast.Paeon = {head="Brioso Roundlet +3"}
    sets.midcast.Carol = {hands="Mousai Gages"}
    sets.midcast["Sentinel's Scherzo"] = {feet="Fili Cothurnes +1"}
    sets.midcast['Magic Finale'] = {legs="Fili Rhingrave +1"}

    sets.midcast.Mazurka = {
		neck="Moonbow Whistle",
	}

	sets.midcast.Requiem = {  -- Hidden Treasure Hunter Set!
		head="Wh. Rarab Cap +1",  -- 1
		legs={ name="Chironic Hose", augments={'Accuracy+8','Pet: Mag. Acc.+19','"Treasure Hunter"+2','Accuracy+11 Attack+11',}}, -- 2
		waist="Chaac Belt" -- 1
	}
    

    -- For song buffs (duration and AF3 set bonus)
    sets.midcast.SongEffect = {
		main={ name="Kali", augments={'MP+60','Mag. Acc.+20','"Refresh"+1',}},  --5
    	sub="Genmei Shield",
		neck="Moonbow Whistle",	-- +3
		body="Fili Hongreline +1", -- 12
		feet="Brioso Slippers +2", -- 13
		hands="Inyanga Dastanas +2", -- skill
		legs="Inyanga Shalwar +2", --17
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+5','"Fast Cast"+10','Damage taken-5%',}},
	}

    -- For song defbuffs (duration primary, accuracy secondary)
    sets.midcast.SongDebuff = {
		main={ name="Kali", augments={'MP+60','Mag. Acc.+20','"Refresh"+1',}},
    	sub="Genmei Shield",
		range="Gjallarhorn",
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands="Inyanga Dastanas +2",
		legs="Inyanga Shalwar +2",
		feet="Inyan. Crackows +1",
		neck="Moonbow Whistle",
		waist="Eschan Stone",
		left_ear="Darkside Earring",
		right_ear="Hermetic Earring",
		left_ring="Stikini Ring +1",
		right_ring="Inyanga Ring",		
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+5','"Fast Cast"+10','Damage taken-5%',}},
	}

    -- For song defbuffs (accuracy primary, duration secondary)
    sets.midcast.ResistantSongDebuff = {
		main={ name="Kali", augments={'MP+60','Mag. Acc.+20','"Refresh"+1',}},
    	sub="Genmei Shield",
		range="Gjallarhorn",
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands="Inyanga Dastanas +2",
		legs="Inyanga Shalwar +2",
		feet="Inyan. Crackows +1",
		neck="Moonbow Whistle",
		waist="Eschan Stone",
		left_ear="Darkside Earring",
		right_ear="Hermetic Earring",
		left_ring="Stikini Ring +1",
		right_ring="Inyanga Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+5','"Fast Cast"+10','Damage taken-5%',}},
	}
	
		
	sets.midcast.LullabyFull = set_combine(sets.midcast.SongDebuff, sets.midcast.Lullaby)
	sets.midcast.LullabyFull.ResistantSongDebuff = set_combine(sets.midcast.ResistantSongDebuff, sets.midcast.Lullaby)

    -- Song-specific recast reduction
    sets.midcast.SongRecast = {

	} --back="Harmony Cape",waist="Corvax Sash",

    --sets.midcast.Daurdabla = set_combine(sets.midcast.FastRecast, sets.midcast.SongRecast, {range=info.ExtraSongInstrument})

    -- Cast spell with normal gear, except using Daurdabla instead
    sets.midcast.Daurdabla = {
		--range=info.ExtraSongInstrument
	}

    -- Dummy song with Daurdabla; minimize duration to make it easy to overwrite.
    sets.midcast.DaurdablaDummy = {

	}

    -- Other general spells and classes.
    sets.midcast.Cure = {
		main={ name="Serenity", augments={'MP+50','Enha.mag. skill +8','"Cure" potency +3%','"Cure" spellcasting time -9%',}},
		sub="Achaq Grip",
		legs="Gyve Trousers",
		waist="Hachirin-no-Obi",
		back="Solemnity Cape",
		left_ring="Stikini Ring +1",
	}
        
    sets.midcast.Curaga = sets.midcast.Cure
        
        
    sets.midcast.Cursna = sets.midcast.Cure

    
	sets.midcast['Enhancing Magic'] = {

	}
	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {waist="Siegel Sash"})
    
	sets.midcast.RefreshRecieved = set_combine(sets.midcast['Enhancing Magic'], {

	})

	sets.midcast.Regen = {
		head="Inyanga Tiara +2",
	}
	
	
	
    -- Sets to return to when not performing an action.
    
    
    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.Idle = {
		main={ name="Kali", augments={'MP+60','Mag. Acc.+20','"Refresh"+1',}},
		sub="Genmei Shield",
		--range="Gjallarhorn",
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands="Inyan. Dastanas +2",
		legs="Inyanga Shalwar +2",
		feet="Aya. Gambieras +2",
		neck="Twilight Torque",
		waist="Flume Belt",
		left_ear="Darkside Earring",
		right_ear="Ethereal Earring",
		left_ring="Stikini Ring +1",
		right_ring="Inyanga Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+5','"Fast Cast"+10','Damage taken-5%',}},
	}
	sets.Idle.Main = {
		main={ name="Kali", augments={'MP+60','Mag. Acc.+20','"Refresh"+1',}},
		sub="Genmei Shield",
		--range="Gjallarhorn	",
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands="Inyan. Dastanas +2",
		legs="Inyanga Shalwar +2",
		feet="Aya. Gambieras +2",
		neck="Twilight Torque",
		waist="Flume Belt",
		left_ear="Darkside Earring",
		right_ear="Ethereal Earring",
		left_ring="Stikini Ring +1",
		right_ring="Inyanga Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+5','"Fast Cast"+10','Damage taken-5%',}},
	}
	sets.idle.Town = set_combine(sets.Idle.Main, {
		feet="Fili Cothurnes +1"
	})
	sets.Idle.PDT = {
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands="Aya. Manopolas +2",
		legs="Aya. Cosciales +2",
		feet="Aya. Gambieras +2",
		neck="Twilight Torque",
		waist="Flume Belt",
		left_ear="Darkside Earring",
		right_ear="Ethereal Earring",
		left_ring="Moonbeam Ring",
		right_ring="Defending Ring",
		back="Solemnity Cape",
	}
	sets.Idle.Current = sets.Idle.Main
    
    -- Defense sets

    sets.defense.PDT = sets.Idle

    sets.defense.MDT = sets.Idle

    sets.Kiting = sets.Idle

    sets.latent_refresh = {
			
	}

    -- Engaged sets

	sets.engaged = {
		main={ name="Taming Sari", augments={'STR+9','DEX+8','DMG:+14',}},
		sub="Odium",
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands="Aya. Manopolas +2",
		legs="Aya. Cosciales +2",	
		feet="Aya. Gambieras +2",
		neck="Lissome Necklace",
		waist="Grunfeld Rope",
		left_ear="Suppanomimi",
		right_ear="Brutal Earring",
		left_ring="Petrov Ring",
		right_ring="Rajas Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
	}
	
	sets.meva = {

	}
	
	
	
	-- Relevant Obis. Add the ones you have.
    sets.obi = {}
    sets.obi.Wind = {waist='Hachirin-no-obi'}
    sets.obi.Ice = {waist='Hachirin-no-obi'}
    sets.obi.Lightning = {waist='Hachirin-no-obi'}
    sets.obi.Light = {waist='Hachirin-no-obi'}
    sets.obi.Dark = {waist='Hachirin-no-obi'}
    sets.obi.Water = {waist='Hachirin-no-obi'}
    sets.obi.Earth = {waist='Hachirin-no-obi'}
    sets.obi.Fire = {waist='Hachirin-no-obi'}
    
	

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.

function job_pretarget(spell)
--checkblocking(spell)
	-- if spell.action_type == 'Magic' then
	-- 	if aftercast_start and os.clock() - aftercast_start < waittime then
	-- 		windower.add_to_chat(8,"Precast too early! Adding Delay:"..waittime - (os.clock() - aftercast_start))
	-- 		cast_delay(waittime - (os.clock() - aftercast_start))
	-- 	end
	-- end
end

function job_precast(spell, action, spellMap, eventArgs)
--[[
	for i,v in pairs(buff) do
	   for i2,v2 in pairs(v) do
	      print(i2,v2)
		end
	end
    ]]
    -- handle_equipping_gear(player.status)
	precast_start = os.clock()
	handle_equipping_gear(player.status)
	if spell.type == 'BardSong' then
		if buffactive.Nightingale then
			local generalClass = get_song_class(spell)
            if generalClass and sets.midcast[generalClass] then
				windower.add_to_chat(8,'Equipping Midcast - Nightingale active.'..generalClass)
                equip(sets.midcast[generalClass])
             end
		else 
			equip(sets.precast.FastCast.BardSong)
		end
		if buffactive.Troubadour and string.find(spell.name,'Lullaby') then
			equip({range="Marsyas"})
			equip(sets.midcast.LullabyFull)
			windower.add_to_chat(8,'Marsyas Equipped - Troubadour / Lullaby active')
		end
	elseif string.find(spell.name,'Cur') and spell.name ~= 'Cursna' then
		equip(sets.precast.FastCast.Cure)
	elseif spell.name == 'Stoneskin' then 
		equip(sets.precast.FastCast.Stoneskin)
	elseif string.find(spell.name,'Regen') then
		equip(sets.midcast.regen)
	elseif spell.name == 'Pianissimo' or spell.name == 'Tenuto' then
		return
	else
		equip(sets.precast.FastCast)
	end
	-- Auto use Extra Song Instrument for Buffs if less than max # of songs
	
	-- Some thoughts:
	-- How to watch party buffs - can take from partybuffs lua and build a table.
	
	local bard_buff_ids = S{195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 218, 219, 220, 221, 222}
	
	num_bard_songs = 0
	local self = windower.ffxi.get_player()
	for i,v in pairs(self.buffs) do
		if bard_buff_ids:contains(v) then
		   num_bard_songs = num_bard_songs +1
		end
	end
	
	local generalClass = get_song_class(spell)
	
	if num_bard_songs == 2  then
		--windower.add_to_chat(10,"Swapping to "..info.ExtraSongInstrument.."! Number of bard buffs = "..num_bard_songs)
		--equip({range=info.ExtraSongInstrument})
	else
		--equip({range="Gjallarhorn"})
	end
	-- end --
	
	if spell.name == 'Honor March' then
        equip({range="Marsyas"})
	end
	
	if string.find(spell.name,'Horde') and state.LullabyMode == 'Daurdabla' then 
		--equip({range="Terpander"})
	end

end

	
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
	local generalClass = get_song_class(spell)
    if spell.action_type == 'Magic' then
        if spell.type == 'BardSong' then
            -- layer general gear on first, then let default handler add song-specific gear.
            if generalClass and sets.midcast[generalClass] then
                equip(sets.midcast[generalClass])
            end
        end
    end
	-- Auto use Extra Song Instrument for Buffs if less than max # of songs
	
	if spell.english == 'Refresh' and spell.target.type == 'SELF' then
	  equip(sets.midcast.RefreshRecieved)
	end
    
	
	if num_bard_songs >= 2 and num_bard_songs < info.MaxSongs and spell.name ~= 'Honor March' and generalClass == 'SongEffect' then
		--equip({range=info.ExtraSongInstrument})
	end
	-- end -- 
	if spell.name == 'Honor March' then
        equip(sets.midcast.HonorMarch)
	end
	if buffactive.Troubadour and string.find(spell.name,'Lullaby') then
		equip(sets.midcast.LullabyFull)
		equip({range="Marsyas"})
	end
	--weathercheck(spell.element)
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' then
        if state.ExtraSongsMode.value == 'FullLength' then
            equip(sets.midcast.Daurdabla)
        end
    end
	--weathercheck(spell.element)
end

function job_aftercast(spell, action, spellMap, eventArgs)
	aftercast_start = os.clock()
	
	local generalClass = get_song_class(spell)
    if spell.type == 'BardSong' and not spell.interrupted then
        -- if spell.target and spell.target.type == 'SELF' then
		-- if spell.target.type ~= 'SELF' and spell.name ~= "Magic Finale" then   -- (Only using Custom Timers for debuffs; no huge reason for buffs)
		if spell.name ~= "Magic Finale" and (generalClass == "SongDebuff" or generalClass == "ResistantSongDebuff") then   -- (Only using Custom Timers for debuffs; no huge reason for buffs)
            --adjust_timers(spell, spellMap)
			local dur = calculate_duration(spell, spellMap)
			send_command('timers create "'..spell.target.name..':'..spell.name..'" '..dur..' down')
        end	
		state.ExtraSongsMode:reset()
    end
    if spell.interrupted then
	  add_to_chat(8,'--------- Casting Interupted: '..spell.name..'---------')
	end 
	equip(sets.Idle.Current)    
	if precast_start then 
		--add_to_chat(8,"Spell: "..spell.name..string.format(" Casting Time: %.2f", aftercast_start - precast_start))
	end
	precast_start = nil

	
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------


function status_change(new,tab)
    handle_equipping_gear(player.status)
    if new == 'Resting' then
        equip(sets.Resting)
    else
        equip(sets.Idle.Current)
    end
end


-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    job_handle_equipping_gear(player.status)
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------


-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Determine the custom class to use for the given song.
function get_song_class(spell)
    -- Can't use spell.targets:contains() because this is being pulled from resources
	if spell.skill == 'Singing' then 
		if set.contains(spell.targets, 'Enemy') then
			if state.CastingMode.value == 'Resistant' then
				return 'ResistantSongDebuff'
			else
				return 'SongDebuff'
			end
		elseif state.ExtraSongsMode.value == 'Dummy' then
			return 'DaurdablaDummy'
		else
			return 'SongEffect'
		end
	else
		return spell.skill
	end
end


function calculate_duration(spell, spellMap)
    local mult = 1
    if player.equipment.range == 'Daurdabla' then mult = mult + 0.3 end -- change to 0.25 with 90 Daur
    if player.equipment.range == "Gjallarhorn" then mult = mult + 0.4 end -- change to 0.3 with 95 Gjall
	if player.equipment.range == "Marsyas" then mult = mult + 0.5 end -- 
    
    if player.equipment.main == "Carnwenhan" then mult = mult + 0.1 end -- 0.1 for 75, 0.4 for 95, 0.5 for 99/119
    if player.equipment.main == "Legato Dagger" then mult = mult + 0.05 end
    if player.equipment.main == "Kali" then mult = mult + 0.05 end
    if player.equipment.sub == "Kali" then mult = mult + 0.05 end
    if player.equipment.sub == "Legato Dagger" then mult = mult + 0.05 end
    if player.equipment.neck == "Aoidos' Matinee" then mult = mult + 0.1 end
	if player.equipment.neck == "Moonbow Whistle" then mult = mult + 0.2 end 
    if player.equipment.body == "Fili Hongreline +1" then mult = mult + 0.12 end
    if player.equipment.legs == "Inyanga Shalwar +1" then mult = mult + 0.15 end
	if player.equipment.legs == "Inyanga Shalwar +2" then mult = mult + 0.17 end
    if player.equipment.feet == "Brioso Slippers" then mult = mult + 0.1 end
    if player.equipment.feet == "Brioso Slippers +1" then mult = mult + 0.11 end
	if player.equipment.feet == "Brioso Slippers +2" then mult = mult + 0.13 end
	if player.equipment.feet == "Brioso Slippers +3" then mult = mult + 0.15 end
    
    if spellMap == 'Paeon' and player.equipment.head == "Brioso Roundlet" then mult = mult + 0.1 end
	if spellMap == 'Paeon' and player.equipment.head == "Brioso Roundlet +3" then mult = mult + 0.2 end
	if spellMap == 'Paeon' and player.equipment.head == "Brioso Roundlet +2" then mult = mult + 0.1 end
    if spellMap == 'Paeon' and player.equipment.head == "Brioso Roundlet +1" then mult = mult + 0.1 end
    if spellMap == 'Madrigal' and player.equipment.head == "Fili Calot +1" then mult = mult + 0.1 end
    if spellMap == 'Minuet' and player.equipment.body == "Fili Hongreline +1" then mult = mult + 0.1 end
    if spellMap == 'March' and player.equipment.hands == 'Fili Manchettes +1' then mult = mult + 0.1 end
    if spellMap == 'Ballad' and player.equipment.legs == "Fili Rhingrave +1" then mult = mult + 0.1 end
	if spellMap == 'Lullaby' and player.equipment.hands == 'Brioso Cuffs +1' then mult = mult + 0.1 end
	if spellMap == 'Lullaby' and player.equipment.hands == 'Brioso Cuffs +2' then mult = mult + 0.1 end
	if spellMap == 'Lullaby' and player.equipment.hands == 'Brioso Cuffs +3' then mult = mult + 0.2 end
    if spell.name == "Sentinel's Scherzo" and player.equipment.feet == "Fili Cothurnes +1" then mult = mult + 0.1 end
	if MaxJobPoints == 1 then
		mult = mult + 0.05
	end
    
    if buffactive.Troubadour then
        mult = mult*2
    end
    if spell.name == "Sentinel's Scherzo" then
        if buffactive['Soul Voice'] then
            mult = mult*2
        elseif buffactive['Marcato'] then
            mult = mult*1.5
        end
    end
	
	local generalClass = get_song_class(spell)
	-- add_to_chat(8,'Info: Spell Name'..spell.name..' Spell Map:'..spellMap..' General Class:'..generalClass..' Multiplier:'..mult)
	if spell.name == "Foe Lullaby II" or spell.name == "Horde Lullaby II" then 
		base = 60
	elseif spell.name == "Foe Lullaby" or spell.name == "Horde Lullaby" then 
		base = 30
	elseif spell.name == "Carnage Elegy" then 
		base = 180
	elseif spell.name == "Battlefield Elegy" then
		base = 120
	elseif spell.name == "Pining Nocturne" then
		base = 120
	elseif spell.name == "Maiden's Virelai" then
		base = 20
	else
		base = 120	
		
	end
	
	if generalClass == 'SongEffect' then 
		base = 120
		totalDuration = math.floor(mult*base)		
	end
	
	totalDuration = math.floor(mult*base)		
	
	if MaxJobPoints == 1 then 
		if string.find(spell.name,'Lullaby') then
			-- add_to_chat(8,'Adding 20 seconds to Timer for Lullaby Job Points')
			totalDuration = totalDuration + 20
		end
		if buffactive['Clarion Call'] then
			if buffactive.Troubadour then 
				-- Doubles Clarion Call Gain for 80 seconds
				totalDuration = totalDuration + 80
			else
				-- add_to_chat(8,'Adding 20 seconds to Timer for Clarion Call Job Points')
				totalDuration = totalDuration + 40
			end
		end
		if buffactive['Tenuto'] then
			-- add_to_chat(8,'Adding 20 seconds to Timer for Tenuto Job Points')
			totalDuration = totalDuration + 20
		end
		if buffactive['Marcato'] then
			-- add_to_chat(8,'Adding 20 seconds to Timer for Marcato Job Points')
			totalDuration = totalDuration + 20
		end
	end
	
	
	if buffactive.Troubadour then 
		totalDuration = totalDuration + 20  -- Assuming 20 seconds for capped Trobodour and you actually pre-cast with a Bihu Justaucorps.
	end
	add_to_chat(8,'Total Duration:'..totalDuration)
	
    return totalDuration
	
end



-- Function to reset timers.
function reset_timers()
    for i,v in pairs(custom_timers) do
        send_command('timers delete "'..i..'"')
    end
    custom_timers = {}
end

-- Called any time we attempt to handle automatic gear equips (ie: engaged or idle gear).
function job_handle_equipping_gear(playerStatus, eventArgs)    	
	if state.TPMode.value == "WeaponLock" then
	  equip({main=weaponlock_main,sub=weaponlock_sub})

	else

	end
	
	if state.IdleMode.value == "PDT" then
	   sets.Idle.Current = sets.Idle.PDT
	elseif state.IdleMode.value == "MEVA" then
		sets.Idle.Current = sets.meva
	else
		sets.Idle.Current = sets.Idle.Main
	end
	if playerStatus == 'Idle' then
        equip(sets.Idle.Current)
    end
	
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 14)
end


windower.raw_register_event('logout',reset_timers)