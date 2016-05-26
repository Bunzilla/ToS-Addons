ui.SysMsg("==== addonLoader ====");

addonloader = {};
addonloader.loaded = false;

-- ======================================================
--	settings
-- ======================================================

addonloader.settings = {};
addonloader.settings.devMode = false;
addonloader.settings.keepOpen = 0; -- 0 or 1

-- ======================================================
--	debug
-- ======================================================

function addonloader.debug(msg) 
	if (addonloader.settings.devMode) then
		CHAT_SYSTEM(msg);
	end
end

-- ======================================================
--	files
-- ======================================================

function addonloader.dofile(fullpath) 
	local f, error = io.open(fullpath,"r");
	if (f ~= nil) then
		io.close(f);
		dofile(fullpath);
		return true;
	else 
		return false;
	end
end

function addonloader.load(root,addonname) 
	return addonloader.dofile('../'..root..'/'..addonname..'/'..addonname..'.lua');
end

-- ======================================================
--	Excrulon compatibility
-- ======================================================

addonloader.dofile('../addons/utility.lua');

-- ======================================================
--	addons
-- ======================================================

_G["ADDON_LOADER"] = {};

addonloader.roots = {};
table.insert(addonloader.roots,'addons');
-- table.insert(addonloader.roots,'addons2');

addonloader.run = function()
	ui.SysMsg("Addonloader running...");
	
	addonloader.addons = {};
	
	for i,root in pairs(addonloader.roots) do
		for folder in io.popen('dir "..\\'..root..'\" /b /ad'):lines() do
			addonloader.debug('- '..root..'/'..folder);
		   	local loaded = addonloader.load(root,folder);	   	
		   	if (loaded) then table.insert(addonloader.addons,folder); end	  
		end
	end

	addonloader.debug('Initializing addons...');

	for i,addonName in pairs(addonloader.addons) do
		addonloader.debug('- '..addonName);
		local fn = _G['ADDON_LOADER'][addonName];
		local ok = true;
		if fn then ok = fn(); end
		if (not ok) then CHAT_SYSTEM('['..addonName..'] failed.') end
	end

	ui.SysMsg("Addonloader done!");
	addonloader.loaded = true;
end

-- ======================================================
--	calling it when the button is clicked
-- ======================================================

addonloader.run();

-- ======================================================
-- adjusting the addon button frame
-- ======================================================

local addonLoaderFrame = ui.GetFrame("addonloader");
addonLoaderFrame:Move(0, 0);
addonLoaderFrame:SetOffset(500,30);
addonLoaderFrame:ShowWindow(addonloader.settings.keepOpen);

-- ======================================================
-- hooking it on map-init
-- ======================================================

function addonloader_mapOnInit(addon,frame)
	_G['MAP_ON_INIT_OLD'](addon,frame);

	if (addonloader.loaded) then
		local addonLoaderFrame = ui.GetFrame("addonloader");
		addonLoaderFrame:ShowWindow(addonloader.settings.keepOpen); 
	end
end

SETUP_HOOK(addonloader_mapOnInit,'MAP_ON_INIT');
