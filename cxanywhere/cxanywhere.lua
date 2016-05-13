local cxAnywhere = {};

function cxAnywhere.openRepair() 
	SHOP_REPAIR_ITEM();
end

function cxAnywhere.openSell() 
	SHOP_ON_MSG(ui.GetFrame("shop"),'SHOP_ITEM_LIST_GET');
end

function cxAnywhere.openMarket() 
	MARKET_BUYMODE();
end

function cxAnywhere.openCollection(frame)
	cwAPI.util.log('omg opened');
end

-- ======================================================
--	LOADER
-- ======================================================

_G['ADDON_LOADER']['cxanywhere'] = function() 
	-- checking dependences
	if (not cwAPI) then
		ui.SysMsg('[cxAnywhere] requires cwAPI to run.');
		return false;
	end

	cwAPI.commands.register('/repair',cxAnywhere.openRepair);
	cwAPI.commands.register('/sell',cxAnywhere.openSell);
	cwAPI.commands.register('/market',cxAnywhere.openMarket);

	cwAPI.events.on('COLLECTION_DO_OPEN',cxAnywhere.openCollection);

	return true;
end
