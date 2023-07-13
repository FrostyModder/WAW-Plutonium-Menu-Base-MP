#include scripts\sp\zm_ayumu;

GodMode()
{
    if(!self.GodMode)
    {
        self iprintln("God Mode [^2ON^7]");
        self EnableInvulnerability();
        self.GodMode = true;
    }
    else
    {
        self iprintln("God Mode [^1OFF^7]");
        self DisableInvulnerability();
        self.GodMode = false;
    }
}

ToggleAmmo()
{
	if(!isDefined(self.uAmmo))
	{
		self.uAmmo = true;
		self thread selfUnlimitedAmmo();
        self thread ToggleEquipment();
        self iprintln("Infinite Ammo [^2ON^7]");
	}
	else
	{
		self.uAmmo = undefined;
        self iprintln("Infinite Ammo [^1OFF^7]");
	}
}
selfUnlimitedAmmo()
{
	while(isDefined(self.uAmmo))
	{
		self giveMaxAmmo(self getCurrentWeapon());
		self setWeaponAmmoClip(self getCurrentWeapon(),1000);
		wait .05;
	}
}

ToggleEquipment()
{
	if(!isDefined(self.unlimEquip))
	{
		self.unlimEquip = true;
		self thread doEquip2();
	}
	else
	{
		self.unlimEquip = undefined;
		self notify("unlimitedEquip_over");
	}
}

doEquip2()
{
	self endon("death");
	self endon("disconnect");
	self endon("unlimitedEquip_over");
	while(1)
	{
		self giveWeapon("stielhandgranate",4);
		self giveWeapon("fraggrenade",4);
		if(self hasWeapon("zombie_cymbal_monkey")) self giveWeapon("zombie_cymbal_monkey",3);
		if(self hasWeapon("molotov")) self giveWeapon("molotov",4);
		if(self hasWeapon("mine_bouncing_betty")) self giveWeapon("mine_bouncing_betty",2);
		wait .05;
	}
}


unlimEquipment()
{
	if(!isDefined(self.unlimEquip))
	{
		self.unlimEquip = true;
		self thread doEquip();
        self iprintln("Infinite Equipment [^2ON^7]");
	}
	else
	{
		self.unlimEquip = undefined;
		self notify("unlimitedEquip_over");
        self iprintln("Infinite Equipment [^1OFF^7]");
	}
}
doEquip()
{
	self endon("death");
	self endon("disconnect");
	self endon("unlimitedEquip_over");
	while(1)
	{
		self giveWeapon("stielhandgranate",4);
		self giveWeapon("fraggrenade",4);
		if(self hasWeapon("zombie_cymbal_monkey")) self giveWeapon("zombie_cymbal_monkey",3);
		if(self hasWeapon("molotov")) self giveWeapon("molotov",4);
		if(self hasWeapon("mine_bouncing_betty")) self giveWeapon("mine_bouncing_betty",2);
		wait .05;
	}
}

healthShield()
{
	if(!isDefined(self.healthShield))
	{
		self.healthShield = true;
		self enableHealthShield(true);
        self iprintln("Health Shield [^2ON^7]");
	}
	else
	{
		self.healthShield = undefined;
		self enableHealthShield(false);
        self iprintln("Health Shield [^1OFF^7]");
	}
}

noClip()
{
	self endon("death");
	self endon("disconnect");
	if(!isDefined(self.noClip))self.noClip=false;
	self iPrintln("Press [{+melee}] To Move");
	self iPrintln("Press [{+frag}] To Exit Noclip");
	if(!self.noClip)
	{
		self EnableHealthShield(true);
		self EnableInvulnerability();
		self freezeControls(false);
		self.noClip=true;
		clip=spawn("script_origin",self.origin);
		clip enableLinkTo();
		self playerLinkTo(clip);
		self iPrintln("Noclip ^2[ON]");
		wait 0.001;
		for(;;)
		{
			vec=anglesToForward(self getPlayerAngles());
			end =(vec[0]*25,vec[1]*25,vec[2]*25);
			if(self meleeButtonPressed())clip.origin=clip.origin+end;
			if(self fragButtonPressed())break;
			wait .05;
		}
		wait 0.001;
		self.noClip=undefined;
		self enableWeapons();
		self enableOffHandWeapons();
		self unlink();
		clip delete();
		self iPrintln("Noclip ^1[OFF]");
	}
}

ProMod()
{
    if(self.ProMod == 1)
    {
        self iprintln("Pro Mod ^2ON^7");
        setDvar("cg_gun_x", 6);
        self.ProMod = 0;
    }
    else
    {
        self iprintln("Pro Mod ^1OFF^7");
        setDvar("cg_gun_x", 0);
        self.ProMod = 1;
    }
}

notarget()
{
	if(!isDefined(self.Target))
	{
		self.Target = true;
		self iPrintLn("No Target ^2ON^7");
		self.iqnoreme = true;
	}
	else
	{
		self.Target = undefined;
		self iPrintLn("No Target ^1OFF");
		self.iqnoreme = false;
	}
}
