cwMarket = {};
cwMarket.reading = false;
cwMarket.timedone = 0;
cwMarket.dumpButton = nil;
cwMarket.outputname = '../addons/cwmarket/data.json';

local log = cwAPI.util.log;
local alert = ui.SysMsg;

-- ======================================================
--	MARKET - SCAN
-- ======================================================

function cwMarket.getMaxPage()
	local frame = ui.GetFrame("market");
	local pagecontrol = GET_CHILD(frame, "pageControl", "ui::CPageController");		
	local maxpage = pagecontrol:GetMaxPage();
	return maxpage, frame;
end

function cwMarket.requestPage(page)
	cwMarket.pgnow = page;
	cwMarket.reading = true;
	local maxpage, frame = cwMarket.getMaxPage();
	cwAPI.util.log('cwMarket.requestPage ('..page..'/'..maxpage..')');
	if (page <= maxpage) then MARGET_FIND_PAGE(frame,page); end
end

function cwMarket.writeFile()
	cwAPI.util.log('Reading done/stopped! Writing (not) file...');
	cwMarket.reading = false;
	cwAPI.util.log('Done.');
end

function cwMarket.marketItemList(frame)	
	if (not cwMarket.reading) then return; end
	local count = session.market.GetItemCount();

	for i = 0 , count - 1 do		
		local marketItem = session.market.GetItemByIndex(i);
		local itemObj = GetIES(marketItem:GetObject());
		local itemid = itemObj.ClassID;
		local price = marketItem.sellPrice;
		local qtde = marketItem.count;

		if (not cwMarket.data[itemid]) then
			cwMarket.data[itemid] = {};
		end

		if (not cwMarket.data[itemid][price]) then
			cwMarket.data[itemid][price] = 0;
		end

		cwMarket.data[itemid][price] = cwMarket.data[itemid][price] + qtde;
	end

	cwMarket.timedone = cwMarket.timedone + IMCRandom(50, 150);
	if (cwMarket.timedone > 5000) then
		os.execute('timeout --quiet 1');
		cwMarket.timedone = 0;
	end

	local next = cwMarket.pgnow+1;
	local max = cwMarket.getMaxPage();

	if (next <= max) then 
		if (cwMarket.reading) then 
			cwMarket.dumpButton:SetText("{@st42}"..next.."/"..max.."{/}");
			cwMarket.requestPage(next); 
		end
	else 
		cwMarket.writeFile();
	end

end

function cwMarket.readMarket()
	cwMarket.data = {};
	cwMarket.pgnow = 0;
	cwMarket.timedone = 0;
	cwMarket.reading = true;
	cwMarket.requestPage(0);
end

function cwMarket.clickButton()
	if (cwMarket.reading) then
		cwMarket.reading = false;
		cwMarket.writeFile();
		cwMarket.dumpButton:SetText("{@st42}Read Market{/}");
	else
		cwMarket.dumpButton:SetText("{@st42}Reading...{/}");
		cwMarket.readMarket();
	end
end

function cwMarket.createExportButton()
	local frame = ui.GetFrame('market');
	if (not frame) then return; end
	local ctrl = frame:CreateOrGetControl('button', 'cwmarket_DUMP', 0, 0, 150, 30);
	tolua.cast(ctrl, 'ui::CCheckBox');
	ctrl:SetMargin(30, 60, 0, 70);
	ctrl:SetGravity(ui.RIGHT, ui.TOP);
	ctrl:Move(0,0);
	ctrl:SetOffset(20,110);
	ctrl:SetText("{@st42}Read Market{/}");
	ctrl:SetClickSound('button_click_big');
	ctrl:SetOverSound('button_over');
	ctrl:SetEventScript(ui.LBUTTONUP,'cwMarket.clickButton()');
	cwMarket.dumpButton = ctrl;
end


-- ======================================================
--	TOOLTIPS
-- ======================================================

function cwMarket.sortPrice(a,b) 
	return a.price < b.price;
end

function cwMarket.drawEtcDescTooltip(tooltipframe, invitem, yPos, mainframename)
	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox');
	local CSet = gBox:CreateOrGetControlSet('tooltip_etc_desc', 'tooltip_etc_desc', 0, yPos);
	local descRichtext = GET_CHILD(CSet,'desc_text','ui::CRichText')

	local itemDesc = descRichtext:GetText();

	local itemid = invitem.ClassID;
	
	local newRows = 0;
	local values = cwMarket.data[itemid];

	if (values) then
		newRows = newRows+1;
		itemDesc = itemDesc .. "{nl}-------------------------------------------------------------";

		local aslist = {};
		for price,qty in pairs(values) do
			local data = {};
			data.price = tonumber(price);
			data.qtde = tonumber(qty);
			table.insert(aslist,data);
		end

		table.sort(aslist,cwMarket.sortPrice);

		for i,data in pairs(aslist) do
			if (newRows <= 3) then
				itemDesc = itemDesc .. "{nl}Z "..GetCommaedText(data.price).." (found "..GetCommaedText(data.qtde).." times)";
				newRows = newRows+1;
			end
		end
	end

	descRichtext:SetText(itemDesc);

	local BOTTOM_MARGIN = CSet:GetUserConfig("BOTTOM_MARGIN"); 
	CSet:Resize(CSet:GetWidth(), descRichtext:GetHeight() + BOTTOM_MARGIN);
	gBox:Resize(gBox:GetWidth(), gBox:GetHeight() + newRows*18);
	return CSet:GetHeight() + CSet:GetY();
end

-- ======================================================
--	MARKET - CABINET
-- ======================================================

function cwMarket.retrieveSome(atr) 
	local list = cwMarket.readytoget[atr];
	local max = #list;
	for i = 0, max do
		local itemID = list[i];
		if (itemID) then market.ReqGetCabinetItem(itemID); end
	end
	cwMarket.itemButton:SetEnable(0);
	cwMarket.silverButton:SetEnable(0);
	market.ReqCabinetList();
end

function cwMarket.retrieveAllSilver() 
	cwMarket.retrieveSome('silver');
end

function cwMarket.retrieveAllItems() 
	cwMarket.retrieveSome('items');
end


function cwMarket.createRetrieveButtons()
	local frame = ui.GetFrame('market_cabinet');
	if (not frame) then return; end
	local ctrl = frame:CreateOrGetControl('button', 'cwmarket_RETRIEVESILVER', 0, 0, 250, 50);
	ctrl:SetSkinName('test_red_button');
	ctrl:SetGravity(ui.RIGHT, ui.BOTTOM);
	ctrl:Move(0,0);
	ctrl:SetOffset(200,20);
	ctrl:SetText("{@st41b}{img Silver 24 24}{/}");
	ctrl:SetClickSound('button_click_big');
	ctrl:SetOverSound('button_over');	
	ctrl:SetEventScript(ui.LBUTTONUP,'cwMarket.retrieveAllSilver()');
	cwMarket.silverButton = ctrl;

	local ctrl = frame:CreateOrGetControl('button', 'cwmarket_RETRIEVEITEMS', 0, 0, 170, 50);
	ctrl:SetSkinName('test_red_button');
	ctrl:SetGravity(ui.RIGHT, ui.BOTTOM);
	ctrl:Move(0,0);
	ctrl:SetOffset(455,20);
	-- 
	ctrl:SetText("{@st41b}{img icon_item_small_bag 24 24}{/}");
	ctrl:SetClickSound('button_click_big');
	ctrl:SetOverSound('button_over');	
	ctrl:SetEventScript(ui.LBUTTONUP,'cwMarket.retrieveAllItems()');
	cwMarket.itemButton = ctrl;

	cwMarket.itemButton:SetEnable(0);
	cwMarket.silverButton:SetEnable(0);

end

function cwMarket.cabinetItemList() 	
	local frame = ui.GetFrame('market_cabinet');
	if (not frame) then return; end

	cwMarket.itemButton:SetEnable(0);
	cwMarket.silverButton:SetEnable(0);

	cwMarket.readytoget = {};
	cwMarket.readytoget.silver = {};
	cwMarket.readytoget.items = {};

	local itemGbox = GET_CHILD(frame, "itemGbox");
	local itemlist = GET_CHILD(itemGbox, "itemlist", "ui::CDetailListBox");

	local cnt = session.market.GetCabinetItemCount();
	local sysTime = geTime.GetServerSystemTime();	

	local result = {};
	result.silver = {};
	result.silver.ready = 0;
	result.silver.total = 0;

	result.items = {};
	result.items.ready = 0;
	result.items.total = 0;

	for i = 0 , cnt - 1 do
		local cabinetItem = session.market.GetCabinetItemByIndex(i);		
		local itemID = cabinetItem:GetItemID();
		local itemObj = GetIES(cabinetItem:GetObject());

		local registerTime = cabinetItem:GetRegSysTime();
		local difSec = imcTime.GetDifSec(registerTime, sysTime);
		local count = cabinetItem.count;

		if (itemObj.ClassID == 900011) then atr = 'silver'; else atr = 'items'; end
		local res = result[atr];

		res.total = res.total + count;
		if (0 >= difSec) then 
			res.ready = res.ready + count; 
			table.insert(cwMarket.readytoget[atr],itemID);
		end
	end

	cwMarket.silverButton:SetText("{@st41b}{img Silver 20 20} "..GetCommaedText(result.silver.ready).." / "..GetCommaedText(result.silver.total).."{/}");
	cwMarket.itemButton:SetText("{@st41b}{img icon_item_small_bag 24 24} "..GetCommaedText(result.items.ready).." / "..GetCommaedText(result.items.total).."{/}");

	if (result.silver.ready > 0) then cwMarket.silverButton:SetEnable(1); end;
	if (result.items.ready > 0) then cwMarket.itemButton:SetEnable(1); end;

end
-- ======================================================
--	LOADER
-- ======================================================

_G['ADDON_LOADER']['cwmarket'] = function() 
	-- checking dependences
	if (not cwAPI) then
		ui.SysMsg('[cwMarket] requires cwAPI to run.');
		return false;
	end
	-- executing onload
	-- cwMarket.data = cwAPI.json.load('cwmarket','values');
	if (not cwMarket.data) then cwMarket.data = {}; end

	cwMarket.createExportButton();
	cwAPI.events.on('ON_OPEN_MARKET',cwMarket.createExportButton,1);
	cwAPI.events.on('ON_MARKET_ITEM_LIST',cwMarket.marketItemList,1);
	cwAPI.events.on('DRAW_ETC_DESC_TOOLTIP',cwMarket.drawEtcDescTooltip,1);

	cwMarket.createRetrieveButtons();
	cwAPI.events.on('ON_CABINET_ITEM_LIST',cwMarket.cabinetItemList,1);	
	cwMarket.cabinetItemList();

	return true;
end
