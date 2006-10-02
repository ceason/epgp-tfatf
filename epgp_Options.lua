-------------------------------------------------------------------------------
-- Constants for EP and GP
-------------------------------------------------------------------------------
EPGP:RegisterDefaults("profile", {
  -- The Zones we keep track of along with the respective GP multipliers
  zones = {
    ["Zul'Gurub"]=1,
    ["Ruins of Ahn'Qiraj"]=1,
    ["Onyxia's Lair"]=1.5,
    ["Molten Core"]=1,
    ["Blackwing Lair"]=1.5,
    ["Temple of Ahn'Qiraj"]=2,
    ["Naxxramas"]=2
  },
  -- The bossses we keep track of in a map with EP values assigned
  bosses = {
  	-- ZG:
  	["High Priestess Jeklik"]=20,
  	["High Priest Venoxis"]=20,
  	["High Priestess Mar'li"]=20,
  	["High Priest Thekal"]=50,
  	["High Priestess Arlokk"]=50,
  	["Hakkar the Soulflayer"]=100,
  	["Bloodlord Mandokir"]=50,
  	["Jin'do the Hexxer"]=80,
  	["Gahz'ranka"]=50,
  	["Gri'lek"]=30,
  	["Renataki"]=30,
  	["Hazza'rah"]=30,
  	["Wushoolay"]=30,
  	-- Onyxia:
  	["Onyxia"]=10,
  	-- AQ 20:
  	["Kurinnaxx"]=2,
  	["General Rajaxx"]=2,
  	["Moam"]=2,
  	["Buru the Gorger"]=2,
  	["Ayamiss the Hunter"]=2,
  	["Ossirian the Unscarred"]=2,
  	-- MC:
  	["Lucifron"]=2,
  	["Magmadar"]=2,
  	["Gehennas"]=2,
  	["Garr"]=2,
  	["Baron Geddon"]=2,
  	["Shazzrah"]=2,
  	["Golemagg The Incinerator"]=5,
  	["Sulfuron Harbinger"]=5,
  	["Majordomo Executus"]=10,
  	["Ragnaros"]=20,
  	-- BWL:
  	["Razorgore the Untamed"]=5,
  	["Vaelastrasz the Corrupt"]=5,
  	["Broodlord Lashlayer"]=5,
  	["Firemaw"]=5,
  	["Ebonroc"]=5,
  	["Flamegor"]=5,
  	["Chromaggus"]=10,
  	["Nefarian"]=30,
  	-- AQ40:
  	["The Prophet Skeram"]=10,
  	["Vem"]=10,
  	["Yauj"]=10,
  	["Kri"]=10,
  	["Battleguard Sartura"]=10,
  	["Fankriss the Unyielding"]=10,
  	["Viscidus"]=10,
  	["Princess Huhuran"]=10,
  	["Emperor Vek'lor"]=10,
  	["Emperor Vek'nilash"]=10,
  	["Ouro the Sandworm"]=10,
  	["C'Thun"]=30,
  	-- Naxx:
  	["Anub'Rekhan"]=10,
  	["Grand Widow Faerlina"]=10,
  	["Maexxna"]=10,
  	["Patchwerk"]=10,
  	["Grobbulus"]=10,
  	["Gluth"]=10,
  	["Thaddius"]=10,
  	["Feugen"]=10,
  	["Stalagg"]=10,
  	["Noth The Plaguebringer"]=10,
  	["Heigan the Unclean"]=10,
  	["Loatheb"]=10,
  	["Instructor Razuvious"]=10,
  	["Gothik the Harvester"]=10,
  	["Highlord Mograine"]=10,
  	["Thane Korthazz"]=10,
  	["Lady Blaumeux"]=10,
  	["Sir Zeliek"]=10,
  	["Sapphiron"]=10,
  	["Kel'Thuzad"]=10
  },
  -- The raid_window size on which we count EPs and GPs.
  -- Anything out of the window will not be taken into account.
  raid_window_size = 10,
  -- The event log, indexed by raid_id
  event_log = { ['*'] = nil }
})

local Tablet = AceLibrary("Tablet-2.0")
local Dewdrop = AceLibrary("Dewdrop-2.0")

function EPGP:GetBossEP(boss)
  local value = self.db.profile.bosses[boss]
  if (self:IsDebugging() and not value) then
    return 1
  end
  return value
end

function EPGP:SetBossEP(boss, ep)
  local value = self.db.profile.bosses[boss]
  if (value) then
    self.db.profile.bosses[boss] = ep
  end
end

function EPGP:OnTooltipUpdate()
  -- A refresh button
  Tablet:AddCategory():AddLine(
    "text", "Refresh",
    "func", function() EPGP:UpdateTooltip() end
  )
  -- The standings
  local cat = Tablet:AddCategory(
      'text', "Standings",
      'columns', 4,
      'child_textR' , 1, 'child_textG' , 1, 'child_textB' , 0,
      'child_textR2', 1, 'child_textG2', 1, 'child_textB2', 1,
      'child_textR3', 1, 'child_textG3', 1, 'child_textB3', 1,
      'child_textR4', 0, 'child_textG4', 1, 'child_textB4', 0
  )
  cat:AddLine(
    "text", "Name",
    "text2", "EP",
    "text3", "GP",
    "text4", "PR"
  )
  
  local standings = self:ComputeStandings()
  table.foreach(standings, function(_, stats)
      cat:AddLine(
        "text", stats[1],
        "text2", stats[2],
        "text3", stats[3],
        "text4", stats[4]     
      )
    end
  )
end

function EPGP:OnDataUpdate()
  self.OnMenuRequest = EPGP:BuildOptions()
end
