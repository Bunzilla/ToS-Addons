## Tree of Savior Lua Mods - cwLibrary ##

Here you can find all the addons I've created. Feel free to use my cwAPI to create yours too! Ask me if you need help.

Also, please check my database website. It's growing! http://tosdb.org/

Have any question or suggestion about the addons or the website? Hit me at http://discordapp.com (user fiote#3304).

## Addons Available

<b>[cwRepair](https://github.com/fiote/treeofsavior-addons/wiki/cwRepair):</b>

cwRepair lets you define a durability% to consider a gear "good" and easily repair the bads when visiting a repair shop.

<b>[cwSet](https://github.com/fiote/treeofsavior-addons/wiki/cwSet):</b>

cwSet allows you to store an infinite number of gear 'sets', so you can easily switch between them.

<b>[cwFarmed](https://github.com/fiote/treeofsavior-addons/wiki/cwFarmed):</b>

cwFarmed allows you to easily see what's really being farmed while you grind your way through the game.

<b>[cwMarket](https://github.com/fiote/treeofsavior-addons/wiki/cwMarket):</b>

cwMarket add 2 buttons to your cabinet window, making it possible to retrieve all items or all silver with one click.

<b>[cwToLearn](https://github.com/fiote/treeofsavior-addons/wiki/cwToLearn):</b>

cwToLearn hides maxed out attributes on the Class Trainer when "Show only attributes that can be learned" is checked.

<b>[cwCleric](https://github.com/fiote/treeofsavior-addons/wiki/cwCleric):</b>

cwCleric is a class helper. It'll remind you to toggle "Heal: Remove Damage" on/off when joining/leaving parties.

## cwAPI

cwAPI is my core library. All my addons depend on it so it.

In time, all functions will be documented on [the wiki](https://github.com/fiote/treeofsavior-addons/wiki/cwAPI-(core-library))!

## Download ##

Make sure you always download the <a href='https://github.com/fiote/treeofsavior-addons/releases'>latest release</a>!

## Installation ##

Extract the zip to your Tree of Savior directory (C:\Program Files (x86)\Steam\steamapps\common\TreeOfSavior for me). Say yes to overwrite any files. An addons folder should be in the root directory. Your directories should look something like this:

<img src='https://camo.githubusercontent.com/3dd7b4c321f4c9f8013ebdff2985d52461c67e64/687474703a2f2f692e696d6775722e636f6d2f776d65316b4f632e706e67'>

* If you're also using the older version of Excrulon addons (which contains data/SumAni.ipf), then the folder work is done.

* If you're using the new version of Excrulon addons (or aren't using those at all), then you must download [Excrulon latest SumAni.ipf](https://github.com/Excrulon/Tree-of-Savior-Lua-Mods/raw/72ec297300cb57a16b11538873a43a1635c6d54c/data/SumAni.ipf) and put it on your /data folder. 

<b>What's on SumAni.ipf?</b><br/>
That file is used to create the "Load Addons" button, which when clicked runs the addonloader.lua.

Start game and login to character.
Press the "Load Addons" button. It should disappear. You're done!

## Uninstall ##

Delete any folder inside the addons directory that starts with cw. Those are my addons. You can keep the addonloader.lua since that'll keep other addons you might have still working.

