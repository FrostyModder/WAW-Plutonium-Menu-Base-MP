#include maps\_utility;
#include maps\_hud_util;
#include common_scripts\utility;

#include scripts\sp\Menu_Functions\MainShit;


init()
{
    level.clientid = 0;
    level thread onPlayerConnect();
    precacheShader("black");
    precacheShader("white");
    precacheShader("congratulations");
    precacheShader("menu_bio_american");
    precacheShader("floatz_display");
    precacheShader("scorebar_zom_1");
    precacheShader("white_line_faded_center");
    precacheShader("hud_compass_highlight");
    precacheShader("rank_prestige10");
    precacheShader("ui_slider2");
    precacheShader("ui_sliderbutt_1");
    precacheShader("hud_icon_colt");
    precacheShader("hud_icon_raygun");
    precacheShader("hud_checkbox_active");
    precacheShader("hud_checkbox_done");
    precacheShader("ui_host");
    precacheShader("zombie_intro");
    precacheShader("rank_comm1");
    precacheShader("rank_prestige4");
    precacheShader("popmenu_bg");
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player.clientid = level.clientid;
        level.clientid++;
        player thread onPlayerSpawned();

        player.Verified = false;
        player.VIP = false;
        player.Admin = false;
        player.CoHost = false;
        player.MyAccess = "";
        //self playsound("bt_busted_02_lp");
    }
}

onPlayerSpawned()
{    
    //self endon( "disconnect" );
    //level endon( "game_ended" );

    for(;;)
    {
        self waittill("spawned_player");
        
        self SetClientDvar( "loc_warnings", "0" );
        self SetClientDvar( "loc_warningsAsErrors", "0" );

        //isBot is not defined on humans
        //if(isDefined(self.pers["isBot"]) && self.pers["isBot"]) {
        //}
        //else {
        //    self freezeControls(false);
        //}

        self thread dpadupniguess();
        self thread dpaddowniguess();
        self thread death_handler();
        //self thread Instructions();
        //self thread zy0nText("Youtube/MrFrosty23", "^4", "^7", 1);
        self setupdvars();
        self setupClient();
        //self.Hud.InfoBar =  createRectangle("RIGHT", "BOTTOM", 400, 100, 1000, 260, self.sMenu["Color"]["White"], 0.8, -1, "black");
        if(self == get_host())
        {
            self.Verified  = true;
            self.accessLvl = "host";
        }
        else
        {
            self.accessLvl = "none";
        }
    }
}

/*zy0nText(text, color, color2, speed)
{
self endon("disconnect");
disp = createFontString("default", 2, self);
disp setPoint("TOPCENTER");

for(i=0;;i++)
{
if(i==text.size) i=0;
start = "";
for(c=0;c<i;c++) start += text[c];
if(i==text.size-1)
{
for(t=0;t<2;t++)
{
disp setText(color+start+text[i]);
wait speed;
disp setText(color2+start+text[i]);
wait speed;
}
} else disp setText(start+color+text[i]);
wait speed;
}
}*/

/*Instructions(){
Instruct = self createfontstring("default", 1.5, self);
Instruct.sort = 15;
Instruct setPoint("RIGHT", "BOTTOM", 2000, -12);
Instruct settext("^1Welcome ^2USER To ^4Frosty's ^7Ayumu Menu Aim + V To Open And Shoot To Scroll Press F To Go Options");
while(1){
Instruct setPoint("LEFT", "BOTTOM", -1500, -25, 25);
wait 20;
Instruct setPoint("RIGHT", "BOTTOM", 1500, -25, 25);
}
wait 1;
}*/

death_handler() {//euph
    self waittill("death");
    if(isDefined(self.Hud.Background)) {
        self thread destroyMenuText();
        self thread destroyHud();
    }
}


buttonMon()
{
    self endon("death");//you need this
    for(;;)
    {
        if( self AdsButtonPressed() && self MeleeButtonPressed() && self.isOpen[ "Menu" ] == false )//
        {
            self.isOpen[ "Menu" ] = true;
            self _loadMenu("main");
            //self playsound("mp_bonus_start");
            self thread drawHuds();
            wait .3;
        }
        if(self usebuttonpressed() && self.isOpen[ "Menu" ] == true )
        {
            if(isDefined(self.Menu.Input[self.Menu.CurrentMenu][self.Scroller])) {//if params defined. Prevents script errors
                self thread [[self.Menu.Func[self.Menu.CurrentMenu][self.Scroller]]](self.Menu.Input[self.Menu.CurrentMenu][self.Scroller]);
             
            }
            else {
                self thread [[self.Menu.Func[self.Menu.CurrentMenu][self.Scroller]]]();
                   //self playsound("mp_suitcase_pickup02");
            }
            wait .3;
        }
        if( self meleebuttonpressed() && self.isOpen[ "Menu" ] == true ) // circle close?
        {
            if( self.Menu.parent[ self.Menu.CurrentMenu ] == "Exit")
            {
                self.lastscroll[self.Menu.CurrentMenu] = self.Scroller;
                self.isOpen[ "Menu" ] = false; 
                self thread destroyMenuText();
                self thread destroyHud();

            }
            else
            {
                self _loadMenu(self.Menu.parent[self.Menu.CurrentMenu]);
            }
            wait .3;
        }
        wait .1;
    }
}

setupdvars()
{

}

dpadupniguess()
{
    self endon("death");//you need this
    //self notifyOnCommand( "dpad_up", "+actionslot 1" );
    //
    //for ( ;; )
    //{
    //    self waittill( "dpad_up" );
    //    if(self.isOpen[ "Menu" ] == true ) // up dpad
    //    {
    //        self.Scroller --;
    //        self _scrollUpdate();
    //        wait .1;
    //    }
    //    wait 0.1;
    //}
    for ( ;; )
    {
        if(self AdsButtonPressed()) {
            if(self.isOpen[ "Menu" ] == true )
            {
                self.Scroller--;
                self _scrollUpdate();
                wait .1;
            }
        } 
        wait 0.1;
    }
}

dpaddowniguess()
{
    self endon("death");//you need this

    //self notifyOnPlayerCommand( "dpad_down", "+actionslot 2" );
    //for ( ;; )
    //{
    //    self waittill( "dpad_up" );
    //    if(self.isOpen[ "Menu" ] == true ) // up dpad
    //    {
    //        self.Scroller++;
    //        self _scrollUpdate();
    //        wait .1;
    //    }
    //    wait 0.1;
    //}
    for ( ;; )
    {
        if(self AttackButtonPressed()) {
            if(self.isOpen[ "Menu" ] == true )
            {
                self.Scroller++;
                self _scrollUpdate();
                wait .1;
            }
        } 
        wait 0.1;
    }
}

setupClient()
{
    self.Hud = spawnStruct();
    self.Menu = spawnStruct();
    self.Menu.Text = [];
    self.Menu.Func = [];
    self.Menu.Input = [];
    self.sMenu["Color"]["1, 0, 1"] = (0,0,255);
    self.sMenu["Color"]["0, 0, 255"] = (0, 0, 0);
    self thread buttonMon();
    self.isOpen["Menu"] = false;
    self optStruct();
}



drawHuds()
{  
    self.Hud.Background =  createRectangle("CENTER", "CENTER", 5, 0, 200, 300, self.sMenu["Color"]["White"], 0.8, -1, "black");
    self.Hud.Scrollbar = createRectangle("CENTER", "middle", 5, (-1 + ( 10 * self.Scroller )), 200, 19, self.sMenu["Color"]["1, 0, 1"], 1, 1, "white");
    self.Hud.LeftLine = createRectangle("CENTER", "CENTER", -94, 0, 2, 300, self.sMenu["Color"]["1, 0, 1"], 1, 1, "white" );
    self.Hud.RightLine = createRectangle("CENTER", "CENTER", 105, 0, 2, 300, self.sMenu["Color"]["1, 0, 1"], 1, 1, "white" );
    self.Hud.TopLine = createRectangle("TOPLEFT", "TOP", -95, 90, 199, 40, self.sMenu["Color"]["1, 0, 1"], 1, 1, "white" );
    self.Hud.BottomLine = createRectangle("TOPLEFT", "TOP", -95, 388, 201, 26, self.sMenu["Color"]["1, 0, 1"], 1, 1, "white" );
    self.Hud.MenuName = createText("big", 1.5, "CENTER", "CENTER", 5, -130, 80, "Menu Base Text");
    self.Hud.BaseBy = createText("big", 1.5, "CENTER", "CENTER", 5, 160, 80, "Menu Base By MrFrosty");

}

destroyHud()
{
    self.Hud.Background Destroy();
    self.Hud.LeftLine Destroy();
    self.Hud.RightLine Destroy();
    self.Hud.MenuName Destroy();
    self.Hud.BaseBy Destroy();
    self.Hud.Scrollbar Destroy();
    self.Hud.TopLine Destroy();
    self.Hud.BottomLine Destroy();
}

createRectangle(align, relative, x, y, width, height, color, alpha, sort, shader)
{
    barElemBG = newClientHudElem( self );
    barElemBG.elemType = "icon";
    if ( !level.splitScreen )
    {
        barElemBG.x = -2;
        barElemBG.y = -2;
    }
    barElemBG.horzAlign = align;
    barElemBG.vertAlign = relative;
    barElemBG.xOffset = 0;
    barElemBG.yOffset = 0;
    barElemBG.children = [];
    barElemBG setParent(level.uiParent);
    barElemBG setShader( shader, width , height );
    barElemBG setPoint(align, relative, x, y);
    barElemBG.color = color;
    barElemBG.alpha = alpha;    
    barElemBG.hideWhenInMenu = true;
    barElemBG.sort = sort;
    return barElemBG;
}

createText(font, fSize, align, relative, x, y, sort, text) {
    txt = createFontString(font, fSize);
    txt.elemtype = "font";
    txt setPoint(align, relative, 0, 0);
    txt.horzAlign = align;
    txt.vertAlign = relative;
    txt.x = x;
    txt.y = y;
    txt.hidden = false;
    txt.hideWhenInMenu = true;
    txt setText(text);
    return txt;
}


addMenu( menu, title, parent )
{
    self.Menu.title[menu] = title;
    self.Menu.parent[menu] = parent;
}

addOpt( menu, index, text, func, input )
{
    if( !isDefined(self.Menu.Text[menu])){
       self.Menu.Text[menu] = [];
       self.Menu.Func[menu] = [];
       self.Menu.Input[menu] = [];
    }

    self.Menu.Text[menu][index] = text;
    self.Menu.Func[menu][index] = func;
    self.Menu.Input[menu][index] = input;
}

createMenuText()
{
    self endon("death");//you need this
    self.menuText = "";
    for( i = 0; i < self.Menu.Text[ self.Menu.CurrentMenu ].size; i++ )
    {                
        if(!isDefined(self.Menu.Text[self.Menu.CurrentMenu][i])) {
            print("menu option "+i+" does not exist for menu "+self.Menu.Text[self.Menu.CurrentMenu]);//prints info to plutonium external console
            continue;
        }
        self.Hud.Text[ i ] = createText("default", 1.0, "TOPCENTER", "TOPCENTER", 5, (148 + ( 18 * i )), 3, self.Menu.Text[self.Menu.CurrentMenu][i]);
        self.Hud.Text[ i ].foreground = true;       
    }
}

destroyMenuText()
{
    if(isDefined(self.Hud.Text))
    {
        for( i = 0; i < self.Hud.Text.size; i++ )
        {
            if(isDefined(self.Hud.Text[i])) {
                self.Hud.Text[i] destroy();
            }
        }
    }
}



_loadMenu(menu)
{
    if(!isDefined(self.Menu.CurrentMenu)) {//prevent error
        self.Menu.CurrentMenu = menu;
    }
    self.lastscroll[self.Menu.CurrentMenu] = self.Scroller;
    self destroyMenuText();
    self.Menu.CurrentMenu = menu;

    if(!isdefined(self.lastscroll[self.Menu.CurrentMenu]))
        self.Scroller = 0;
    else
        self.Scroller = self.lastscroll[self.Menu.CurrentMenu];

    //---self.Hud.Title does not exist and is not a hud element--- You can fix this by adding the hud elem in
    //self.Hud.Title settext( self.Menu.title[ self.Menu.CurrentMenu ] );
    self createMenuText();
    self _scrollUpdate();
}

doUnverif()
{
    players = get_players();
    player = players[self.Menu.System["ClientIndex"]];
    if(player == get_host())
    {
        self iPrintln("You can't Un-Verify the Host!");
    }
    else
    {
        player.Verified = false;
        player.VIP = false;
        player.Admin = false;
        player.CoHost = false;
        player suicide();
        self iPrintln( player.playername + " is ^1Unverfied" );
    }
}

Verify()
{
    players = get_players();
    player = players[self.Menu.System["ClientIndex"]];
    if(player == get_host())
    {
        self iPrintln("You can't Verify the Host!");
    }
    else
    {
        player UnverifMe();
        player.Verified = true;
        player.VIP = false;
        player.Admin = false;
        player.CoHost = false;
        self iPrintln( player.playername + " is ^1Verified" );
    }
}

changeAccess(lvl, Test)
{
    players = get_players();
    test = players[Test];
    test.accessLvl = lvl;
    test kill(Test);
    if(test.accessLvl!="none")
        test thread setupClient();
}

kill(Test)
{
    players = get_players();
    test = players[Test];
    test suicide();
}

UnverifMe()
{
    self.Verified = false;
    self.VIP = false;
    self.Admin = false;
    self.CoHost = false;
    self suicide();
}

_scrollUpdate()
{
    if(self.Scroller<0)
    {
        self.Scroller = self.Menu.Text[self.Menu.CurrentMenu].size-1;
    }
    if(self.Scroller > self.Menu.Text[self.Menu.CurrentMenu].size-1)
    {
        self.Scroller = 0;
    }

    if(self.isOpen[ "Menu" ] == true && isDefined(self.Hud.Scrollbar)) {
        self.Hud.Scrollbar hudMoveY((self.Hud.Scrollbar.y + self.Hud.Scrollbar.y), 0.05);
        self.Hud.Scrollbar.y = -86+(18*self.Scroller);
    }
      
}

hudMoveY(y,time)
{
    self moveOverTime(time);
    self.y = y;
    wait time;
}
Test()
{
    self IPrintLn("^1Test Option Sub 1");
}

Test2()
{
    self IPrintLn("^1Test Option Sub 2");
}

AllWeapons()
{
    self iPrintln("You Now Have ^2All Weapons");
    self endon("death");
    self endon("disconnect");
    self GiveWeapon("defaultweapon");
    self GiveWeapon("zombie_melee");
    self GiveWeapon("walther");
    self GiveWeapon("colt_dirty_harry");
    self switchToWeapon("defaultweapon");
    keys = GetArrayKeys(level.zombie_weapons);
    for (i = 0;i < keys.size;i++)
    {
        self GiveWeapon(keys[i], 0);
        wait 0.02;
    }
}

optStruct()
{
    self endon("death");//you need this
    self endon("disconnect");
    self addMenu( "main", "Main Menu", "Exit" );
    self addOpt( "main", 0, "Basic Mods", ::_loadMenu, "basicMods");
    self addOpt( "main", 1, "Fun Menu", ::_loadMenu, "FunMenu");
    self addOpt( "main", 2, "Test", ::_loadMenu, "test2" );//placeholder to prevent undefined params
    self addOpt( "main", 3, "Test", ::_loadMenu, "test3" );//placeholder to prevent undefined params
    self addOpt( "main", 4, "Test", ::_loadMenu, "test4" );//placeholder to prevent undefined params
    self addOpt( "main", 5, "Test", ::_loadMenu, "test5" );//placeholder to prevent undefined params
    self addOpt( "main", 6, "Test", ::_loadMenu, "test6" );//placeholder to prevent undefined params
    self addOpt( "main", 7, "Test", ::_loadMenu, "test7" );//placeholder to prevent undefined params
    self addOpt("main", 8, "Client Menu", ::_loadMenu, "players");


    self addMenu( "basicMods", "^3Basic Mods", "main" );
    self addOpt( "basicMods", 0, "God mode", ::GodMode);
    self addOpt( "basicMods", 1, "Infinite Ammo", ::ToggleAmmo);
    self addOpt( "basicMods", 2, "Give all weapons", ::AllWeapons);
    self addOpt( "basicMods", 3, "Infinite Equipment", ::unlimEquipment);
    self addOpt( "basicMods", 4, "Health Shield", ::healthShield);
    self addOpt( "basicMods", 5, "No Clip", ::noClip);
    self addOpt( "basicMods", 6, "Pro Mod", ::ProMod);
    self addOpt( "basicMods", 7, "No Target", ::notarget); //Means Zombies Will Iqnore You
    self addOpt( "basicMods", 8, "Next Page", ::_loadMenu, "Page2");

    self addMenu("Page2", "Page 2", "main");
    self addOpt("Page2", 0, "Aimbot", ::Test);
    self addOpt("Page2", 1, "Option", ::Test);
    self addOpt("Page2", 2, "Option", ::Test);
    self addOpt("Page2", 3, "Option", ::Test);
    self addOpt("Page2", 4, "Option", ::Test);
    self addOpt("Page2", 5, "Option", ::Test);
    self addOpt("Page2", 6, "Option", ::Test);
    self addOpt("Page2", 7, "Option", ::Test);
    self addOpt("Page2", 8, "Option", ::Test);

    self addMenu("FunMenu", "^3Fun Menu", "main");
    self addOpt("FunMenu", 0, "Option");
    self addOpt("FunMenu", 1, "Option");
    self addOpt("FunMenu", 2, "Option");
    self addOpt("FunMenu", 3, "Option");
    self addOpt("FunMenu", 4, "Option");
    self addOpt("FunMenu", 5, "Option");
    self addOpt("FunMenu", 6, "Option");
    self addOpt("FunMenu", 7, "Option");
    self addOpt("FunMenu", 8, "Option");


  self addMenu( "players", "Players Menu", "main" );
    //for(;;)
   // {
        players = get_players();
        //self IPrintLn("players.size() == ^2" + players.size);
        for(i = 0;i < players.size;i++)
        {
            //self IPrintLn("players[^2" + i + "^7].playername == " + players[i].playername);
            self addOpt( "players", i, players[i].playername, ::_loadMenu, players[i].playername + "main" );
        
            self addMenu( players[i].playername + "main", players[i].playername, "players" );
            self addOpt( players[i].playername + "main", 0, "Give Menu", ::VerifyClient, players[i]);
            self addOpt( players[i].playername + "main", 1, "Take Menu", ::RemoveMenu, players[i]);
            self addOpt( players[i].playername + "main", 2, "Kill Player", ::KillMeh, players[i]); 
            //--whoever is in charge of this needs to make override function for extra params--
            //self addOpt( players[i].playername + "main", 3, "Give VIP", ::changeAccess, "vip", players[i]);
            wait 0.1;
        }
        wait 0.5;
    //}
}
MonitorPlayers()
{
    self endon("disconnect");
    for(;;)
    {
        players = get_players();
        for(i = 0;i < players.size;i++)
        {
            self.Menu.System["MenuTexte"]["Players"][i] = "[" + players[i].MyAccess + "^7] " + players[i].playername;
            self.Menu.System["MenuFunction"]["Players"][i] = ::_loadMenu;
            self.Menu.System["MenuInput"]["Players"][i] = "Players";
            wait .01;
        }
        wait .5;
    }
}

VerifyClient(Clients)
{
    if(Clients GetEntityNumber() == 0)
    {
        self iPrintln("^1You Can't Do That To The Host");
        Clients iPrintln(self.name + " Tried To Give You The Menu");
    }
    else
    {
        Clients thread buttonMon();
        Clients thread optStruct();
        Clients iPrintlnBold("You Have Been Verified");
        self iPrintln("You Verified " + Clients.name);
        Clients endon("Menu Taken");
        for(;;)
        {
            Clients waittill("spawned_player");
            Clients thread buttonMon();
            Clients thread optStruct();
        }
    }
}

RemoveMenu(Clients)
{
    if(Clients GetEntityNumber() == 0)
    {
        self iPrintln("^1You Can't Do That To The Host");
        Clients iPrintln(self.name + " Tried To Take Your Menu");
    }
    else
    {
        Clients notify("Menu Taken");
        Clients thread destroyHud();
        Clients iPrintlnBold("Menu Taken!");
        self iPrintln("Menu Taken From " + Clients.name);
    }
}

KillMeh(Clients)
{
    if(Clients GetEntityNumber() == 0)
    {
        self iPrintln("^1You Can't Do That To The Host");
        Clients iPrintln(self.name + " Tried To Kill You");
    }
    else
    {
    
        Clients suicide();
    }

}