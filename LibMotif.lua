-- LibMotif: Provide data about motifs that the ESO API does not.
--
-- Originally broken out from WritWorthy to hold page ID numbers
-- for motif knowledge.

LibMotif = {}

LibMotif.name = "LibMotif"
LibMotif.saved_var_version = 1

LibMotif.default = {}


-- Scan ----------------------------------------------------------------------

function LibMotif:ScanMotifs()
    local motif        = {}
    local max_motif_id  = GetHighestItemStyleId()
    local motif_seen_ct = 0
    for motif_id = 1, max_motif_id do
        motif_name = GetItemStyleName(motif_id)
        if motif_name and motif_name ~= "" then
            motif[motif_id] = { ["name"] = motif_name }
            motif_seen_ct   = motif_seen_ct + 1
        end
    end
    return { ["motif"        ] = motif
           , ["motif_seen_ct"] = motif_seen_ct
           , ["max_motif_id" ] = max_motif_id
           }
end

local function expand_range(i, r)
    if (r.min == nil) or (i < r.min) then
        r.min = i
    end
    if (r.max == nil) or (r.max < i) then
        r.max = i
    end
    return r
end

function LibMotif:ScanAchievements()
    local min_achievement_id = 1000
    local max_achievement_id = 4000

    local achieve = {}
    local achieve_seen_ct = 0
    local seen_range = {}
    local re = "(.*) Style Master"
    for achievement_id = min_achievement_id, max_achievement_id do
        local achievement_name = GetAchievementName(achievement_id)
        local _, _,motif_name = string.find(achievement_name, re)
        if motif_name then
            achieve[achievement_id] = motif_name
            achieve_seen_ct = achieve_seen_ct + 1
            expand_range( achievement_id, seen_range )
        end
    end

    return { ["achieve"] =  achieve
           , ["achieve_seen_ct"] = achieve_seen_ct
           , ["min_seen_id"] = seen_range.min
           , ["max_seen_id"] = seen_range.max
           }
end

function LibMotif:MergeAchievements()
                        -- Index by visible name
    local names = {}
    for motif_id,m in pairs(self.motif) do
        names[m.name] = { ["motif_id"] = motif_id }
    end

    for achievement_id, motif_name in pairs(self.achieve) do
        names[motif_name] = names[motif_name] or {}
        names[motif_name]["pages_id"] = achievement_id

        motif_id = names[motif_name]["motif_id"]
        if motif_id then
            self.motif[motif_id]["pages_id"] = achievement_id
        end
    end

    self.saved_vars.x = nil -- names
end

function LibMotif.Scan()
    local self = LibMotif
    self.log:Debug("scan")

    local r = self:ScanMotifs()
    self.motif           = r.motif
    self.motif_seen_ct   = r.motif_seen_ct
    self.max_motif_id    = r.max_motif_id

    r = self:ScanAchievements()
    self.achieve         = r.achieve
    self.achieve_seen_ct = r.achieve_seen_ct
    self.achieve_min_id  = r.min_seen_id
    self.achieve_max_id  = r.max_seen_id

    self:MergeAchievements()

    self.saved_vars.motif   = self.motif
    self.saved_vars.achieve = nil -- self.achieve

    self:Export()
end

-- Generate text that's (almost) suitable as copy-and-paste data.
function LibMotif:Export()
    local lines = {}
    local comma = " "
    for motif_id = 1,self.max_motif_id do
        local m = self.motif[motif_id] or {}

        local pages_id = m.pages_id
        local name     = m.name or ""

        local value = "nil"
        if m.pages_id then
            value = string.format("{ pages_id  = %6d }"   , m.pages_id )
        elseif m.is_simple then
            value = string.format("{ is_simple =   true }"             )
        elseif m.crown_id then
            value = string.format("{ crown_id = %6d }"    , m.crown_id )
        end

        local line = string.format(
                          "%s   [%3d] = %-22s -- %s"
                        , comma
                        , motif_id
                        , value
                        , name
                        )
        table.insert(lines, line)
    end

    self.saved_vars.export = lines
end

-- SlashCommand --------------------------------------------------------------

function LibMotif.SlashCommand(arg1)
    self = LibMotif
    if arg1:lower() == "scan" then
        self.log:Info("Scanning...")
        LibMotif.Scan()
        self.log:Info(
              "Scan complete. Motifs seen: %d. Highest id: %d"
            , self.motif_seen_ct
            , self.max_motif_id
            )
        self.log:Info(
              "Achievements seen: %d. Range [%d, %d]"
            , self.achieve_seen_ct
            , self.achieve_min_id
            , self.achieve_max_id
            )
    end
end

function LibMotif.RegisterSlashCommands()
    if (GetDisplayName() ~= "@ziggr") then return end

    local lsc = LibSlashCommander
    if not lsc then
        SLASH_COMMANDS["/lm"] = LibMotif.SlashCommand
        return
    end

    local cmd = lsc:Register( "/lm"
                            , function(arg) LibMotif.SlashCommand(arg) end
                            , "Commands for scanning and querying craftable motifs")

    local sub_forget = cmd:RegisterSubCommand()
    sub_forget:AddAlias("scan")
    sub_forget:SetCallback(function() LibMotif.SlashCommand("scan") end)
    sub_forget:SetDescription("Scan for all craftable motifs")
end

-- Log -----------------------------------------------------------------------

function LibMotif:InitLog()
    if LibDebugLogger then
        self.log = LibDebugLogger.Create(self.name)
    end
    if not self.log then
        local NOP = {}
        function NOP:Debug(...) end
        function NOP:Info(...) end
        function NOP:Warn(...) end
        function NOP:Error(...) end
        self.log = NOP
    end
end

-- Init ----------------------------------------------------------------------

function LibMotif.OnAddOnLoaded(event, addonName)
    self = LibMotif
    if addonName == LibMotif.name then
        if not LibMotif.name then return end
        LibMotif:Initialize()
        EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_ADD_ON_LOADED)
    end
end

function LibMotif:Initialize()
    LibMotif:InitLog()
    self.saved_vars = ZO_SavedVars:NewAccountWide(
                              "LibMotifVars"
                            , self.saved_var_version
                            , nil
                            , self.default
                            )

    LibMotif.RegisterSlashCommands()
end

-- Postamble -----------------------------------------------------------------

EVENT_MANAGER:RegisterForEvent( LibMotif.name
                              , EVENT_ADD_ON_LOADED
                              , LibMotif.OnAddOnLoaded
                              )
