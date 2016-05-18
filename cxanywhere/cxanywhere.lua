cxAnywhere = {};

local log = cwAPI.util.log;

function cxAnywhere.openRepair() 
	SHOP_REPAIR_ITEM();
end

function cxAnywhere.fakeSell() 
	local frame = ui.GetFrame("shop");	

	local invItemList = session.GetInvItemList();
	local index = invItemList:Head();
	local itemCount = session.GetInvItemList():Count();

	local firstsell = nil;

	for i = 0, itemCount - 1 do		
		local invItem = invItemList:Element(index);
		local clsItem = GetClassByType("Item",invItem.type);
		local itemProp = geItemTable.GetPropByName(clsItem.ClassName);
		if (not firstsell and itemProp:IsTradable() == true) then firstsell = invItem; end
		index = invItemList:Next(index);
	end

	if (firstsell) then 
		SHOP_SELL(firstsell,1); 
		SHOP_BUTTON_BUYSELL(frame);
	end
end

function cxAnywhere.openSell() 
	local frame = ui.GetFrame("shop");	
	frame:ShowWindow(1);
	if (session.GetSoldItemList():Count() == 0) then
		ui.MsgBox("No sold items detected. That probably means you're opening a shop for the first time. Do you want to fake-sell a random item? That will enable this shop.","cxAnywhere.fakeSell()","Nope");
	end
end

function cxAnywhere.openMarket() 
	MARKET_BUYMODE();
end

function cxAnywhere.openTPShop()
	local frame = ui.GetFrame("tpitem");
	frame:ShowWindow(1);
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
	cwAPI.commands.register('/tp',cxAnywhere.openTPShop);

	cwAPI.events.on('SHOP_ITEM_LIST_GET',cxAnywhere.SHOP_ITEM_LIST_GET,1);


	return true;
end

