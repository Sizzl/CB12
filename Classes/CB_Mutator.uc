// ===============================================================
// CB.CB_Mutator: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class CB_Mutator extends Mutator;

var config float FriendlyBoostScale;
var config float SelfBoostScale;

var string AdminMsg, SBMsg, FBMsg;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	if (Level.NetMode != NM_Client)
		Level.Game.RegisterDamageMutator(Self);
}

function PostNetBeginPlay()
{
	if (Level.NetMode == NM_Client)
		Class'PulseGun'.Default.PickupMessage = "You got a TI Pulse Gun";
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	local PulseGun PG;

	if ( Other.IsA('minigun2') && !Other.IsA('TIW_Minigun2') )
	{
		ReplaceWith(Other, "CB12.TIW_Minigun2");
		return False;
	}

	PG = PulseGun(Other);

	if ( PG != None )
	{
		PG.Default.PickupMessage = "You got a TI Pulse Gun";
		PG.PickupMessage = "You got a TI Pulse Gun";
		PG.AltProjectileClass=Class'TIW_StarterBolt';
	}
	return True;
}

function MutatorTakeDamage( out int ActualDamage, Pawn Victim, Pawn InstigatedBy, out Vector HitLocation, 
						out Vector Momentum, name DamageType)
{
	if ( InstigatedBy != None ) // Nobody did damage, just ignore (wtf?)
	{
		if ( Victim == InstigatedBy ) // Self damage.
		{
			Momentum = Momentum * SelfBoostScale;
		}
		else if ( Victim.PlayerReplicationInfo.Team == InstigatedBy.PlayerReplicationInfo.Team )	// Same Team
		{
			Momentum = Momentum * FriendlyBoostScale;
		}
	}
	Super.MutatorTakeDamage( ActualDamage, Victim, InstigatedBy, HitLocation, Momentum, DamageType );
}

function SetFB(float f)
{
	FriendlyBoostScale = f;
	SaveConfig();
	Level.BroadCastMessage(FBMsg@FriendlyBoostScale);
}

function SetSB(float f)
{
	SelfBoostScale = f;
	SaveConfig();
	Level.BroadCastMessage(SBMsg@SelfBoostScale);
}

function Mutate(string MutateString, PlayerPawn Sender)
{
	local float f;

	if ( MutateString ~= "showfb" )
	{
		Sender.ClientMessage(FBMsg@FriendlyBoostScale);
	}
	else if ( MutateString ~= "enablefb" ) 
	{
		if ( !Sender.bAdmin )
			Sender.ClientMessage(AdminMsg);
		else
			SetFB(1.0);
	}
	else if ( MutateString ~= "disablefb" )
	{
		if ( !Sender.bAdmin )
			Sender.ClientMessage(AdminMsg);
		else
			SetFB(0.0);
	}
	else if ( Left( MutateString , 6 ) ~= "setfb " )
	{
		if ( !Sender.bAdmin )
			Sender.ClientMessage(AdminMsg);
		else
		{
			f = float( Mid( MutateString , 6 ) );
			SetFB(f);
		}
	}
	else if ( MutateString ~= "showsb" )
	{
		Sender.ClientMessage(SBMsg@SelfBoostScale);
	}
	else if ( MutateString ~= "enablesb" ) 
	{
		if ( !Sender.bAdmin )
			Sender.ClientMessage(AdminMsg);
		else
			SetSB(1.0);
	}
	else if ( MutateString ~= "disablesb" )
	{
		if ( !Sender.bAdmin )
			Sender.ClientMessage(AdminMsg);
		else
			SetSB(0.0);
	}
	else if ( Left( MutateString , 6 ) ~= "setsb " )
	{
		if ( !Sender.bAdmin )
			Sender.ClientMessage(AdminMsg);
		else
		{
			f = float( Mid( MutateString , 6 ) );
			SetSB(f);
		}
	}

	Super.Mutate(MutateString, Sender);
}


defaultproperties
{
    FriendlyBoostScale=1.00
    SelfBoostScale=1.00
    AdminMsg="You must be logged in as admin to use this command!"
    SBMsg="Self Boost Scale is set to"
    FBMsg="Friendly Boost Scale is set to"
    bAlwaysRelevant=True
}