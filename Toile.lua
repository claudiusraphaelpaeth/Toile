TOILE_VERSION=2.0002

-- Ensure we're not using obsolete version
assert( SELENE_VERSION >= 4.0200, "HDB requires at least Selene v4.02.00" )

-- compatibility with newer Lua
-- local unpack = unpack or table.unpack


-- modules helpers
lfs = require "lfs" -- LuaFileSystem


function loaddir(path, dir )
	local t={}

	for f in lfs.dir(path..dir) do
		local attr = lfs.attributes( path..dir ..'/'.. f )
		local found, len, res = f:find("^(.*)%.[^%.]*$")
		if found and attr.mode == 'file' and res:sub(1,1) ~= '.' and f:match("^.+(%..+)$") ~= '.md' then
			table.insert( t, res )
		end
	end

	table.sort(t)

	for _,res in ipairs( t ) do
		require(dir ..'/'.. res)
		SelLog.log("*L* " .. dir ..'/'.. res .. ' loaded')
	end
end

-- load modules
local info = debug.getinfo(1,'S');
local whereiam = string.match(info.source, "@(.-)([^\\/]-%.?([^%.\\/]*))$")

SelLog.log('Loading Toile v'.. TOILE_VERSION ..' ...' )
loaddir(whereiam, 'Supports')
animTimer = bipTimer(.25)	-- Animation timer
wdTimer = bipTimer(1)	-- Wathdog timer

loaddir(whereiam, 'Inputs')
loaddir(whereiam, 'GUI')

