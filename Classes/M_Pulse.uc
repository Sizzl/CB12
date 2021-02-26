// ============================================================
// TIW.M_Pulse: put your comment here

// Created by UClasses - (C) 2000 by meltdown@thirdtower.com
// ============================================================

class M_Pulse expands Mutator;

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	local PulseGun PG;

	PG = PulseGun(Other);
	if ( PG != None )
	{
		PG.Default.PickupMessage = "You got a TI Pulse Gun";
		PG.PickupMessage = "You got a TI Pulse Gun";
		PG.AltProjectileClass=Class'TIW_StarterBolt';
	}
	return True;
}

function PostNetBeginPlay()
{
	if (Level.NetMode == NM_Client)
		Class'PulseGun'.Default.PickupMessage = "You got a TI Pulse Gun";
}

defaultproperties
{
    bAlwaysRelevant=True
}