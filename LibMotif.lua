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
	local max_motif_id 	= GetHighestItemStyleId()
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

-- SlashCommand --------------------------------------------------------------

function LibMotif.Scan()
	local self = LibMotif
	self.log:Debug("scan")

	local r = self:ScanMotifs()
	self.motif 			= r.motif
	self.motif_seen_ct 	= r.motif_seen_ct
	self.max_motif_id 	= r.max_motif_id
end

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
