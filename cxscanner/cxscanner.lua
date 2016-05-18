if (not cxScanner) then
	cxScanner = {};
	cxScanner.reading = false;
	cxScanner.timedone = 0;
	cxScanner.dumpButton = nil;
	cxScanner.outputname = '../addons/cxScanner/data.json';
end

local log = cwAPI.util.log;
local alert = ui.SysMsg;

-- ======================================================
--	MARKET - SCAN
-- ======================================================

function cxScanner.getMaxPage()
	local frame = ui.GetFrame("market");
	local pagecontrol = GET_CHILD(frame, "pageControl", "ui::CPageController");		
	local maxpage = pagecontrol:GetMaxPage();
	return maxpage, frame;
end

function cxScanner.requestPage(page)
	cxScanner.pgnow = page;
	cxScanner.reading = true;
	local maxpage, frame = cxScanner.getMaxPage();
	if (page <= maxpage) then MARGET_FIND_PAGE(frame,page); end
end

function cxScanner.writeFile()
	cwAPI.util.log('Reading done/stopped! Writing (not) file...');
	cxScanner.reading = false;
	cwAPI.util.log('Done.');
end

function cxScanner.marketItemList(frame)	
	if (not cxScanner.reading) then return; end
	local count = session.market.GetItemCount();

	for i = 0 , count - 1 do		
		local marketItem = session.market.GetItemByIndex(i);
		local itemObj = GetIES(marketItem:GetObject());
		local itemid = itemObj.ClassID;
		local price = marketItem.sellPrice;
		local qtde = marketItem.count;

		local sellprice = cxScanner.sells[itemid];
		if (not sellprice) then
			local itemProp = geItemTable.GetPropByName(itemObj.ClassName);
			sellprice = geItemTable.GetSellPrice(itemProp);
			cxScanner.sells[itemid] = sellprice;
		end

		if (sellprice ~= nil and sellprice > price) then
			log(sellprice..' > '..price..'!');
		end

		if (not cxScanner.data[itemid]) then
			cxScanner.data[itemid] = {};
		end

		if (not cxScanner.data[itemid][price]) then
			cxScanner.data[itemid][price] = 0;
		end

		cxScanner.data[itemid][price] = cxScanner.data[itemid][price] + qtde;
	end

	cxScanner.timedone = cxScanner.timedone + IMCRandom(50, 150);
	if (cxScanner.timedone > 5000) then
		os.execute('timeout --quiet 1');
		cxScanner.timedone = 0;
	end

	local next = cxScanner.pgnow+1;
	local max = cxScanner.getMaxPage();

	if (next <= max) then 
		if (cxScanner.reading) then 
			cxScanner.dumpButton:SetText("{@st42}"..next.."/"..max.."{/}");
			cxScanner.requestPage(next); 
		end
	else 
		cxScanner.writeFile();
	end

end

function cxScanner.readMarket()
	cxScanner.data = {};
	cxScanner.pgnow = 0;
	cxScanner.timedone = 0;
	cxScanner.reading = true;
	cxScanner.requestPage(0);
end

function cxScanner.clickButton()
	if (cxScanner.reading) then
		cxScanner.reading = false;
		cxScanner.writeFile();
		cxScanner.dumpButton:SetText("{@st42}Read Market{/}");
	else
		cxScanner.dumpButton:SetText("{@st42}Reading...{/}");
		cxScanner.readMarket();
	end
end

function cxScanner.createExportButton()
	local frame = ui.GetFrame('market');
	if (not frame) then return; end
	local ctrl = frame:CreateOrGetControl('button', 'cxScanner_DUMP', 0, 0, 150, 30);
	tolua.cast(ctrl, 'ui::CCheckBox');
	ctrl:SetMargin(30, 60, 0, 70);
	ctrl:SetGravity(ui.RIGHT, ui.TOP);
	ctrl:Move(0,0);
	ctrl:SetOffset(20,110);
	ctrl:SetText("{@st42}Read Market{/}");
	ctrl:SetClickSound('button_click_big');
	ctrl:SetOverSound('button_over');
	ctrl:SetEventScript(ui.LBUTTONUP,'cxScanner.clickButton()');
	cxScanner.dumpButton = ctrl;
end


-- ======================================================
--	TOOLTIPS
-- ======================================================

function cxScanner.sortPrice(a,b) 
	return a.price < b.price;
end

function cxScanner.addMarketPrice(tooltipFrame, mainFrameName, invItem, strArg, useSubFrame)

	local gBox = GET_CHILD(tooltipFrame, mainFrameName,'ui::CGroupBox');    
    local yPos = gBox:GetY() + gBox:GetHeight();    

    local ctrl = gBox:CreateOrGetControl("richtext", 'marketprice', 0, yPos, 350, 30);

    tolua.cast(ctrl, "ui::CRichText");

	local text = '';
	
	local newRows = 2;
	local itemID = invItem.ClassID;
	local values = cxScanner.data[itemID];
	local headText = "{@st42b}----------------------------------------------------{/}{nl}"
	text = text .. "{nl}"..headText;

	if (values) then
		local aslist = {};
		for price,qty in pairs(values) do
			local data = {};
			data.price = tonumber(price);
			data.qtde = tonumber(qty);
			table.insert(aslist,data);
		end

		table.sort(aslist,cxScanner.sortPrice);

		for i,data in pairs(aslist) do
			if (i <= 3) then
				text = text .. GET_MONEY_IMG(24).." {@st66b}"..GetCommaedText(data.price).."{/} {@st66}(x"..GetCommaedText(data.qtde)..").{/} ";
			end
		end
	else 
		text = text .. GET_MONEY_IMG(24) .. " {@st67b}No market info available.{/}";
	end

    ctrl:SetText(text);
    ctrl:SetMargin(20,gBox:GetHeight() - 15,0,0)

    local BOTTOM_MARGIN = tooltipFrame:GetUserConfig("BOTTOM_MARGIN");
    gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + ctrl:GetHeight());
    
    return ctrl:GetHeight() + ctrl:GetY();

end

function cxScanner.drawTooltipEQUIP(tooltipFrame, invItem, strArg, useSubFrame)
	local fn = cwAPI.events.original('ITEM_TOOLTIP_EQUIP');
	yPos = fn(tooltipFrame, invItem, strArg, useSubFrame);
    
    local mainFrameName = 'equip_main'
    local addInfoFrameName = 'equip_main_addinfo'
    local drawNowEquip = 'true'
    
    if useSubFrame == "usesubframe" then
        mainFrameName = 'equip_sub'
        addInfoFrameName = 'equip_sub_addinfo'
    elseif useSubFrame == "usesubframe_recipe" then
        mainFrameName = 'equip_sub'
        addInfoFrameName = 'equip_sub_addinfo'
        drawNowEquip = 'false'
    end
    
    return cxScanner.addMarketPrice(tooltipFrame, mainFrameName, invItem, strArg, useSubFrame);  
end

function cxScanner.drawTooltipETC(tooltipFrame, invItem, strArg, useSubFrame)

	local fn = cwAPI.events.original('ITEM_TOOLTIP_ETC');
	yPos = fn(tooltipFrame, invItem, strArg, useSubFrame);

	local mainFrameName = 'etc'
    
    if useSubFrame == "usesubframe" then
      mainFrameName = "etc_sub"
    elseif useSubFrame == "usesubframe_recipe" then
      mainFrameName = "etc_sub"
    end    

    return cxScanner.addMarketPrice(tooltipFrame, mainFrameName, invItem, strArg, useSubFrame);    
end

-- ======================================================
--	LOADER
-- ======================================================

_G['ADDON_LOADER']['cxscanner'] = function() 
	-- checking dependences
	if (not cwAPI) then
		ui.SysMsg('[cxScanner] requires cwAPI to run.');
		return false;
	end
	-- executing onload
	-- cxScanner.data = cwAPI.json.load('cxScanner','values');
	if (not cxScanner.data) then cxScanner.data = {}; end
	if (not cxScanner.sells) then cxScanner.sells = {}; end

	cxScanner.createExportButton();
	cwAPI.events.on('ON_OPEN_MARKET',cxScanner.createExportButton,1);
	cwAPI.events.on('ON_MARKET_ITEM_LIST',cxScanner.marketItemList,1);
	cwAPI.events.on('ITEM_TOOLTIP_ETC',cxScanner.drawTooltipETC,0);
	cwAPI.events.on('ITEM_TOOLTIP_EQUIP',cxScanner.drawTooltipEQUIP,0);

	return true;
end
