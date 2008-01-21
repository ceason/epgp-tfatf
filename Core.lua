local L = EPGPGlobalStrings

EPGP = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceDB-2.0", "AceDebug-2.0", "AceEvent-2.0", "AceModuleCore-2.0")

-------------------------------------------------------------------------------
-- DB defaults
-------------------------------------------------------------------------------
EPGP:RegisterDB("EPGP_Core_DB", "EPGP_Core_PerCharDB")
EPGP:RegisterDefaults("profile", {
                        report_channel = "GUILD",
                        current_listing = "GUILD",
                        RAID = {
                          show_alts = true,
                        },
                        GUILD = {
                          show_alts = false,
                        },
                        GUILD_ONLINE_LABEL = {
                          show_alts = true,
                        },
                        gp_in_tooltips = true,
                        boss_tracking = true,
                        loot_tracking = true,
                        loot_tracking_quality_threshold = 4, -- Epic and above
                        loot_announce = true,
                        reason_award_cache = {},
                        alts = {},
                        outsiders = {},
                        dummies = {},
                        data = {},
                        info = {},
                        base_gp = 0,
                        flat_credentials = false,
                        min_eps = 1000,
                        decay_percent = 10,
                        backup_notes = {},
                        recurring_ep_period = 15 * 60,
                      })

function EPGP:OnInitialize()
  local backend = self:GetModule("EPGP_Backend")
  EPGPFrameTitleText:SetText(GetAddOnMetadata("epgp", "Title").." "..GetAddOnMetadata("epgp", "Version"))
  self:RegisterChatCommand({ "/epgp" }, {
    type = "group",
    desc = L["EPGP Options"],
    args = {
      ["show"] = {
        type = "execute",
        name = L["Show UI"],
        desc = L["Shows the EPGP UI"],
        disabled = function() return EPGPFrame:IsShown() end,
        func =  function() ShowUIPanel(EPGPFrame) end,
        order = 1,
      },
      ["decay"] = {
        type = "execute",
        name = L["Decay EP and GP"],
        desc = L["Decay EP and GP by %d%%"]:format(EPGP.db.profile.decay_percent),
        disabled = function() return not backend:CanLogRaids() end,
        func =  function() StaticPopup_Show("EPGP_DECAY_EPGP", EPGP.db.profile.decay_percent) end,
        order = 4,
      },
      ["reset"] = {
        type = "execute",
        name = L["Reset EPGP"],
        desc = L["Reset all EP and GP to 0 and make officer notes readable by all."],
        guiHidden = true,
        disabled = function() return not backend:CanChangeRules() end,
        func = function() StaticPopup_Show("EPGP_RESET_EPGP") end,
        order = 11,
      },
    },
  },
  "EPGP")
end

function EPGP:OnEnable()
  --EPGP:SetDebugging(true)
  BINDING_HEADER_EPGP = L["EPGP Options"]
  BINDING_NAME_EPGP = L["Toggle EPGP UI"]
  -- Set shift-E as the toggle button if it is not bound
  if #GetBindingAction("J") == 0 then
    SetBinding("J", "EPGP")
  end
end
