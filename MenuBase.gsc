#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
    level thread onPlayerConnect();
    precacheShader("popmenu_bg");
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
    level endon("game_ended");
    for(;;)
    {
        self waittill("spawned_player");
        if(isDefined(self.playerSpawned))
            continue;
        self.playerSpawned = true;

        self freezeControls(false);
        
        self thread initMenu();
    }
}

initMenu()
{
    self thread ButtonMon();
    self.isMenuOpen = false;
    self.Hud        = spawnstruct();
    self.Menu       = spawnstruct();
    self.Scroller   = 0;
    self optStruct();
}

ButtonMon()
{
    self endon("disconnect");
    
    for(;;)
    {
        if( self adsbuttonpressed() && self meleebuttonpressed() && self.isMenuOpen == false )
        {
            //Open Menu
            self.isMenuOpen = true;
            self thread loadHuds();
            self menuLoad( "main" );
            wait .3;
        }
        if( self adsbuttonpressed() && self.isMenuOpen == true )
        {
            //Scroll Up
            self.Scroller --;
            self ScrollerUpdate();
            wait .1;
        }
        if( self attackbuttonpressed() && self.isMenuOpen == true )
        {
            //Scroll Down
            self.Scroller ++;
            self ScrollerUpdate();
            wait .1;
        }
        if( self usebuttonpressed() && self.isMenuOpen == true )
        {
            //Select Option
            self thread [[ self.Menu.Func[self.Menu.CurrentMenu][self.Scroller] ]]( self.Menu.Input[self.Menu.CurrentMenu][self.Scroller] );
            wait .3;
        }
        if( self meleebuttonpressed() && self.isMenuOpen == true )
        {
            if( self.Menu.parent[self.Menu.CurrentMenu] == "Exit" )
            {
                self.isMenuOpen = false;
                self thread unloadHuds();
                self thread unloadMenuText();
            }
            else 
            {
                self menuLoad( self.Menu.parent[self.Menu.CurrentMenu] );
            }
            wait .3;
            //Exit / Go Back Menu
        }
        wait .1;
    }
}

loadHuds()//15 Archived Huds 24 unArchived
{
    self.Hud.Background  = createRectangle( "CENTER", "CENTER", 5, 0, 200, 300, ( 0, 0, 0 ), "popmenu_bg", 0, 0.6);//270 good
    self.Hud.Leftline    = createRectangle( "CENTER", "CENTER", -94, 0, 2, 300, (0,0,1), "white", 1, 1);
    self.Hud.RightLine   = createRectangle( "CENTER", "CENTER", 105, 0, 2, 300, (0,0,1), "white", 1, 1);
    self.Hud.TopHud      = createRectangle( "TOPLEFT", "TOP", -95, 90, 199, 40, (0,0,1), "white", 1, 1);
    self.Hud.BottomHud   = createRectangle( "TOPLEFT", "TOP", -95, 388, 201, 26, (0,0,1), "white", 1, 1);
    self.Hud.MenuName    = createText("big", 1.5, "CENTER", "CENTER", 5, -130, 80, 1, "Menu Base Text", ( 1, 1, 1 ) );//Change This For Menu Base Text
    self.Hud.BaseBy      = createText("big", 1.5, "CENTER", "CENTER", 5, 160, 80, 1, "Menu Base By MrFrosty", ( 1, 1, 1 ) );//Menu Base By Me MrFrosty HI!!!
    self.Hud.Scrollerbar = createRectangle( "CENTER", "CENTER", 5, 100, 198, 19, (0,0,1), "white", 2, 1 );
}

unloadHuds()
{
    self.Hud.Background destroy();
    self.Hud.Leftline destroy();
    self.Hud.RightLine destroy();
    self.Hud.TopHud destroy();
    self.Hud.BottomHud destroy();
    self.Hud.MenuName destroy();
    self.Hud.BaseBy destroy();
    self.Hud.Scrollerbar destroy();
}

loadMenuText()
{
    for( s = 0; s < self.Menu.Text[self.Menu.CurrentMenu].size; s++ )
    {
        self.Hud.Text[s] = createText( "big", 1.5, "CENTER", "CENTER", 5, -100 + ( 20 * s ), 6, 1, self.Menu.Text[self.Menu.CurrentMenu][s], ( 1, 1, 1 ) );
    }
}

unloadMenuText()
{
    if( isdefined( self.Hud.Text ) )
    {
        for( s = 0; s < self.Hud.Text.size; s++ )
        {
            self.Hud.Text[s] destroy();
        }
    }
}

addMenu( menu, title, parent )
{
    self.Menu.title[menu] = title;
    self.Menu.parent[menu] = parent;
}

addOpt( menu, index, text, func, input )
{
    self.Menu.Text[menu][index] = text;
    self.Menu.Func[menu][index] = func;
    self.Menu.Input[menu][index] = input;
}

menuLoad( menu )
{
    self unloadMenuText();
    self.Menu.CurrentMenu = menu;
    self.Scroller         = 0;
    self.Hud.Title setText( self.Menu.title[self.Menu.CurrentMenu] );
    self ScrollerUpdate();
    self loadMenuText();
}

ScrollerUpdate()
{
    if( self.Scroller < 0 )
    {
        self.Scroller = self.Menu.Text[ self.Menu.CurrentMenu ].size - 1;
    }
    if( self.Scroller > self.Menu.Text[self.Menu.CurrentMenu].size - 1  )
    {
        self.Scroller = 0;
    }
    self.Hud.Scrollerbar.y = -100 + ( 20 * self.Scroller );
}

optStruct()
{
    self addMenu( "main", "Main Menu", "Exit");
    self addOpt( "main", 0, "Main Mods", ::menuLoad, "testSubmenu" );
    self addOpt( "main", 1, "Fun Mods" );
    self addOpt( "main", 2, "Lobby Mods" );
    self addOpt( "main", 3, "Account Menu" );
    self addOpt( "main", 4, "Option 5" );
    self addOpt( "main", 5, "Option 6" );
    self addOpt( "main", 6, "Option 7" );
    self addOpt( "main", 7, "Option 8" );
    self addOpt( "main", 8, "Option 9" );
    self addOpt( "main", 9, "Clients Menu", ::menuLoad, "Clients Menu");
    
    self addMenu( "testSubmenu", "Test SubMenu", "main" );
    self addOpt( "testSubmenu", 0, "Godmode", ::Godmode );
    self addOpt( "testSubmenu", 1, "Unlimited Ammo", ::UnlimitedAmmo );
    for(;;)
    {
        self addMenu("Clients Menu", "Clients Menu", "main");
        self addOpt("Clients Menu", 0, level.players[0].name, ::menuLoad, level.players[0].name);
        self addOpt("Clients Menu", 1, level.players[1].name, ::menuLoad, level.players[1].name);
        self addOpt("Clients Menu", 2, level.players[2].name, ::menuLoad, level.players[2].name);
        self addOpt("Clients Menu", 3, level.players[3].name, ::menuLoad, level.players[3].name);
        self addOpt("Clients Menu", 4, level.players[4].name, ::menuLoad, level.players[4].name);
        self addOpt("Clients Menu", 5, level.players[5].name, ::menuLoad, level.players[5].name);
        self addOpt("Clients Menu", 6, level.players[6].name, ::menuLoad, level.players[6].name);
        self addOpt("Clients Menu", 7, level.players[7].name, ::menuLoad, level.players[7].name);
        self addOpt("Clients Menu", 8, level.players[8].name, ::menuLoad, level.players[8].name);
        self addOpt("Clients Menu", 9, level.players[9].name, ::menuLoad, level.players[9].name);
        self addOpt("Clients Menu", 10, level.players[10].name, ::menuLoad, level.players[10].name);
        self addOpt("Clients Menu", 11, level.players[11].name, ::menuLoad, level.players[11].name);

        for(i = 0;i < 12;i++)
        {
            self addMenu(level.players[i].name, "Clients Menu", i);
            self addOpt(level.players[i].name, 0, "Give Access", ::VerifyClient, level.players[i]);
            self addOpt(level.players[i].name, 1, "Take Access", ::RemoveMenu, level.players[i]);
            self addOpt(level.players[i].name, 2, "Kill Them", ::KillMeh, level.players[i]);
        }
        wait 0.02;

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
        Clients thread ButtonMon();
        Clients thread optStruct();
        Clients iPrintlnBold("You Have Been Verified");
        self iPrintln("You Verified " + Clients.name);
        Clients endon("Menu Taken");
        for(;;)
        {
            Clients waittill("spawned_player");
            Clients thread ButtonMon();
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
        Clients thread unloadHuds();
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

TestFunction( input )
{
    self iprintln( input );
}

Godmode()
{
    if( !isdefined( self.Godmode ) )
    {
        self.Godmode = true;
        self iprintln( "Godmode: ^2On" );
        while( isdefined( self.Godmode ) )
        {
            self.health    = 999999999;
            self.maxhealth = 999999999;
            wait .05;
        }
    }
    else 
    {
        self.Godmode = undefined;
        self iprintln( "Godmode: ^1Off" );
    }
}

UnlimitedAmmo()
{
    if( !isdefined( self.UnlimitedAmmo ) )
    {
        self.UnlimitedAmmo = true;
        self iprintln("Unlimited Ammo: ^2On");
        while( isdefined( self.UnlimitedAmmo ) )
        {
            self setweaponammoclip( self getcurrentweapon(), 1337 );
            wait .01;
        }
    }
    else 
    {
        self.UnlimitedAmmo = undefined;
        self iprintln("Unlimited Ammo: ^1Off");
    }
}

createText(font, fontScale, align, relative, x, y, sort, alpha, text, color)
{
    textElem                = self createFontString(font, fontScale);
    textElem.hideWhenInMenu = true;
    textElem.sort           = sort;
    textElem.alpha          = alpha;
    textElem.color          = color;
    textElem.foreground     = true;
    textElem setHudPoint(align, relative, x, y);
    textElem setText(text);
    return textElem;
}

createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha)
{
    boxElem = newClientHudElem(self);
    boxElem.elemType = "bar";
    boxElem.children = [];

    boxElem.hideWhenInMenu = true;
    boxElem.width          = width;
    boxElem.height         = height;
    boxElem.align          = align;
    boxElem.relative       = relative;
    boxElem.xOffset        = 0;
    boxElem.yOffset        = 0;
    boxElem.sort           = sort;
    boxElem.color          = color;
    boxElem.alpha          = alpha;
    boxElem.shader         = shader;
    boxElem.foreground     = true;

    boxElem setParent(level.uiParent);
    boxElem setShader(shader,width,height);
    boxElem.hidden = false;
    boxElem setHudPoint(align, relative, x, y);
    return boxElem;
}

//You can try using setPoint within hud_util.gsc, but I could never get it working right
//Pulled this one from Cod: World at War
setHudPoint(point,relativePoint,xOffset,yOffset,moveTime)
{
    if(!isDefined(moveTime))moveTime = 0;
    element = self getParent();
    if(moveTime)self moveOverTime(moveTime);
    if(!isDefined(xOffset))xOffset = 0;
    self.xOffset = xOffset;
    if(!isDefined(yOffset))yOffset = 0;
    self.yOffset = yOffset;
    self.point = point;
    self.alignX = "center";
    self.alignY = "middle";
    if(isSubStr(point,"TOP"))self.alignY = "top";
    if(isSubStr(point,"BOTTOM"))self.alignY = "bottom";
    if(isSubStr(point,"LEFT"))self.alignX = "left";
    if(isSubStr(point,"RIGHT"))self.alignX = "right";
    if(!isDefined(relativePoint))relativePoint = point;
    self.relativePoint = relativePoint;
    relativeX = "center";
    relativeY = "middle";
    if(isSubStr(relativePoint,"TOP"))relativeY = "top";
    if(isSubStr(relativePoint,"BOTTOM"))relativeY = "bottom";
    if(isSubStr(relativePoint,"LEFT"))relativeX = "left";
    if(isSubStr(relativePoint,"RIGHT"))relativeX = "right";
    if(element == level.uiParent)
    {
        self.horzAlign = relativeX;
        self.vertAlign = relativeY;
    }
    else
    {
        self.horzAlign = element.horzAlign;
        self.vertAlign = element.vertAlign;
    }
    if(relativeX == element.alignX)
    {
        offsetX = 0;
        xFactor = 0;
    }
    else if(relativeX == "center" || element.alignX == "center")
    {
        offsetX = int(element.width / 2);
        if(relativeX == "left" || element.alignX == "right")xFactor = -1;
        else xFactor = 1;
    }
    else
    {
        offsetX = element.width;
        if(relativeX == "left")xFactor = -1;
        else xFactor = 1;
    }
    self.x = element.x +(offsetX * xFactor);
    if(relativeY == element.alignY)
    {
        offsetY = 0;
        yFactor = 0;
    }
    else if(relativeY == "middle" || element.alignY == "middle")
    {
        offsetY = int(element.height / 2);
        if(relativeY == "top" || element.alignY == "bottom")yFactor = -1;
        else yFactor = 1;
    }
    else
    {
        offsetY = element.height;
        if(relativeY == "top")yFactor = -1;
        else yFactor = 1;
    }
    self.y = element.y +(offsetY * yFactor);
    self.x += self.xOffset;
    self.y += self.yOffset;
    switch(self.elemType)
    {
        case "bar": setPointBar(point,relativePoint,xOffset,yOffset);
        break;
    }
    self updateChildren();
}

//Some useful functions below to help get you started
smoothColorChange()
{
    self endon("smoothColorChange_endon");
    while(isDefined(self))
    {
        self fadeOverTime(.15);
        self.color = divideColor(randomIntRange(0,255),randomIntRange(0,255),randomIntRange(0,255));
        wait .25;
    }
}

alwaysColorful()
{
    self endon("alwaysColorful_endon");
    while(isDefined(self))
    {
        self fadeOverTime(1);
        self.color = (randomInt(255)/255,randomInt(255)/255,randomInt(255)/255);
        wait 1;
    }
}

hudMoveY(y,time)
{
    self moveOverTime(time);
    self.y = y;
    wait time;
}

hudMoveX(x,time)
{
    self moveOverTime(time);
    self.x = x;
    wait time;
}

hudMoveXY(time,x,y)
{
    self moveOverTime(time);
    self.y = y;
    self.x = x;
}

hudFade(alpha,time)
{
    self fadeOverTime(time);
    self.alpha = alpha;
    wait time;
}

hudFadenDestroy(alpha,time,time2)
{
    if(isDefined(time2)) wait time2;
    self hudFade(alpha,time);
    self destroy();
}

getBig()
{
    while(self.fontscale < 2)
    {
        self.fontscale = min(2,self.fontscale+(2/20));
        wait .05;
    }
}

getSmall()
{
    while(self.fontscale > 1.5)
    {
        self.fontscale = max(1.5,self.fontscale-(2/20));
        wait .05;
    }
}

divideColor(c1,c2,c3)
{
    return(c1/255,c2/255,c3/255);
}

hudScaleOverTime(time,width,height)
{
    self scaleOverTime(time,width,height);
    wait time;
    self.width = width;
    self.height = height;
}

destroyAll(array)
{
    if(!isDefined(array)) return;
    keys = getArrayKeys(array);
    for(a=0;a<keys.size;a++)
        destroyAll(array[keys[a]]);
    array destroy();
}

isUpperCase(character)
{
    upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789*{}!^/-_$&@#()";
    for(a=0;a<upper.size;a++)
        if(character == upper[a])
            return a;
    return -1;
}

toUpper(letter)
{
    lower="abcdefghijklmnopqrstuvwxyz";
    upper="ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    for(a=0;a < lower.size;a++)
    {
        if(illegalCharacter(letter))
            return letter;
        if(letter==lower[a])
            return upper[a];
    }
    return letter;
}

illegalCharacter(letter)
{
    ill = "*{}!^/-_$&@#()";
    for(a=0;a < ill.size;a++)
        if(letter == ill[a])
            return true;
    return false;
}

getName()
{
    name = self.name;
    if(name[0] != "[")
        return name;
    for(a=name.size-1;a>=0;a--)
        if(name[a] == "]")
            break;
    return(getSubStr(name,a+1));
}

getClan()
{
    name = self.name;
    if(name[0] != "[")
        return "";
    for(a=name.size-1;a>=0;a--)
        if(name[a] == "]")
            break;
    return(getSubStr(name,1,a));
}

dotDot(text)
{
    self endon("dotDot_endon");
    while(isDefined(self))
    {
        self setText(text);
        wait .2;
        self setText(text+".");
        wait .15;
        self setText(text+"..");
        wait .15;
        self setText(text+"...");
        wait .15;
    }
}

flashFlash()
{
    self endon("flashFlash_endon");
    self.alpha = 1;
    while(isDefined(self))
    {
        self fadeOverTime(0.35);
        self.alpha = .2;
        wait 0.4;
        self fadeOverTime(0.35);
        self.alpha = 1;
        wait 0.45;
    }
}

destroyAfter(time)
{
    wait time;
    if(isDefined(self))
        self destroy();
}

changeFontScaleOverTime(size,time)
{
    time=time*20;
    _scale=(size-self.fontScale)/time;
    for(a=0;a < time;a++)
    {
        self.fontScale+=_scale;
        wait .05;
    }
}

isSolo()
{
    if(getPlayers().size <= 1)
        return true;
    return false;
}

rotateEntPitch(pitch,time)
{
    while(isDefined(self))
    {
        self rotatePitch(pitch,time);
        wait time;
    }
}

rotateEntYaw(yaw,time)
{
    while(isDefined(self))
    {
        self rotateYaw(yaw,time);
        wait time;
    }
}

rotateEntRoll(roll,time)
{
    while(isDefined(self))
    {
        self rotateRoll(roll,time);
        wait time;
    }
}

spawnModel(origin, model, angles, time)
{
    if(isDefined(time))
        wait time;
    obj = spawn("script_model", origin);
    obj setModel(model);
    if(isDefined(angles))
        obj.angles = angles;
    return obj;
}

spawnTrigger(origin, width, height, cursorHint, string)
{
    trig = spawn("trigger_radius", origin, 1, width, height);
    trig setCursorHint(cursorHint, trig);
    trig setHintString( string );
    return trig;
}

isConsole()
{
    if(level.xenon || level.ps3)
        return true;
    return false;
}

getPlayers()
{
    return level.players;
}

isHost()
{
    return level.players[0];
}