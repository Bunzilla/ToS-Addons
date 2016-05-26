## Tree of Savior Lua Mods - cwLibrary ##

Here you can find all the addons I've created. Feel free to use my cwAPI to create yours too! Ask me if you need help.

Also, please check my database website. It's growing! http://tosdb.org/

Have any question or suggestion about the addons or the website? Hit me at http://discordapp.com (user fiote#3304).

## Download ##

<a href='https://github.com/fiote/treeofsavior-addons/releases'>Get the latest release here</a>

## cwSet
[depends on cwAPI]

<img src='http://i.imgur.com/oA9Afts.png'>

cwSet allows you to store an infinite number of gear 'sets', so you can easily switch between them.

Ex: As a cleric, I usually have 2 sets of gear.
* So I equip all my offensive gear and then I type <code>/set save dps</code>
* Then I equip all my healing gear and type <code>/set save heal</code>.

Now I can simply type <code>/set load dps</code> or <code>/set load heal</code> to switch all my gear (the items must be on your inventory, of course).

<b>ATTENTION:</b> A full gear change will take up to 5 seconds to complete. You must stand still while it's happenning or that may cause the change to be interrupted. If that happens, simply run the command again to switch the remaining items.


## cwMarket
[depends on cwAPI]

cwMarket add 2 new buttons to your cabinet window. 

<img src='http://i.imgur.com/au1iqNQ.png'>

The first shows the number of items that already expired, and the total number of items you have selling. Clicking on it will retrieve all the expired ones.

The second shows the amount of silver from your sales that is ready to retrieve, and the total amount of silver that is/will be yours in some time. Clicking on it retrieves all the silver that can be retrieved.

So in the image above, I have only 1 item in the market, and it already expired so I can retrieve it.
I also have 90k in sales to receive, but only 10k of that can be retrieved right now.

## cwToLearn
[depends on cwAPI]

When selecting the "Show only attributes that can be learned" on the 'Learn Attributes' window, this addon will hide the attributes that you already have at max level.


## cwFarmed
[depends on cwAPI, help avaiable at https://github.com/fiote/treeofsavior-addons/wiki/cwFarmed]

cwFarmed allows you to easily see what's really being farmed while you grind your way through the game.

Can display how much silver you have grinded from mobs in the current section.

<img src='http://i.imgur.com/Gb2f190.png'>

Can display the silver dropped.

<img src='http://i.imgur.com/2Z4Y5pY.png'>

Can display the items dropped.

<img src='http://i.imgur.com/p6PF2aX.png'>

Can display the ammount of XP (base) earned.

<img src='http://i.imgur.com/lIX8Dzy.png'>

Can display the ammount of XP (job) earned.

<img src='http://i.imgur.com/TLgipS6.png'>

Can display the ammount of XP (pet) earned.

<img src='http://i.imgur.com/t49Tztl.png'>

## cwCleric
[depends on cwAPI]

This addon acts as a class helper. If you have your "Heal: Remove Damage" attribute OFF and join a party, it will ask if you want to toggle it ON (so you can heal better). When you leave a party while having the attibute ON, it will ask if you want to toggle it OFF (so you can do more damage while soloing).

<img src='http://i.imgur.com/k2hipF4.png'>

<img src='http://i.imgur.com/8hMvkiZ.png'>

## cwShakeness
[depends on cwAPI]

A tiny addon that disables the 'shake' the games used on certain skills. I read users having headaches and nauseas because of that, so I thought it would be nice being able to disable them while ICM doesn't get us a solution.

Type /skn for help.

## cwAPI
An API of core functionalities.

Enables you to hook on events and decide if you custom function will be called before, after or instead of the original callback.

Enables you to load addon json as tables and save them back to the file (useful to persist user options).

Type /cw for help.

## Installation ##

Extract the zip to your Tree of Savior directory (C:\Program Files (x86)\Steam\steamapps\common\TreeOfSavior for me). Say yes to overwrite any files. An addons folder should be in the root directory. Your directories should look something like this:

<img src='https://camo.githubusercontent.com/3dd7b4c321f4c9f8013ebdff2985d52461c67e64/687474703a2f2f692e696d6775722e636f6d2f776d65316b4f632e706e67'>

* If you're also using the older version of Excrulon addons (which contains data/SumAni.ipf), then the folder work is done.

* If you're using the new version of Excrulon addons (or aren't using those at all), then you must download [Excrulon latest SumAni.pif](https://github.com/Excrulon/Tree-of-Savior-Lua-Mods/raw/72ec297300cb57a16b11538873a43a1635c6d54c/data/SumAni.ipf) and put it on your /data folder. 

<b>What's on SumAni.ipf?</b><br/>
That file is used to create the "Load Addons" button, which when clicked runs the addonloader.lua.

Start game and login to character.
Press the "Load Addons" button. It should disappear. You're done!

## Uninstall ##

Delete any folder inside the addons directory that starts with cw. Those are my addons. You can keep the addonloader.lua since that'll keep other addons you might have still working.

## Usage ##

Right now i'm not using configuration files to control the addons settings. But most of them will let you use /somecommand to configure that. Please refer to each addon on the list at the beginning of this readme.
