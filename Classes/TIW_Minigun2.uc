// ============================================================
// TIW.TIW_Minigun2: put your comment here

// Created by UClasses - (C) 2000 by meltdown@thirdtower.com
// ============================================================

class TIW_Minigun2 expands minigun2;

var float FireInterval;

state NormalFire
{
	function Tick( float DeltaTime )
	{
		if (Owner==None) 
		{
			AmbientSound = None;
			GotoState('Pickup');
			return;
		}	
		
		FireInterval -= DeltaTime;
		while (FireInterval < 0.0)
		{
			// Original code did: Sleep(0.13)
			// This would (depending on tickrate) get called on irregular intervals.
			// According to a 20 tickrate server, this would result in about 6.667 shots/sec, 
			// 1/6.667 = 0.15ms between, therefore...
			// Due to excessive whining, shots/sec is increased to 7.5
			// 1/7.5 = 0.13ms between.
			FireInterval += 0.13;		// 7.5 shots/sec
			GenerateBullet();
		}

		if	( bFiredShot && ((pawn(Owner).bFire==0) || bOutOfAmmo) ) 
			GoToState('FinishFire');
	}

Begin:
	FireInterval = 0.13;	// Spinup time
}

state AltFiring
{
	function Tick( float DeltaTime )
	{
		if (Owner==None) 
		{
			AmbientSound = None;
			GotoState('Pickup');
			return;
		}	
		
		FireInterval -= DeltaTime;
		while (FireInterval < 0.0)
		{
			// Original code did: Sleep(0.08)
			// This would (depending on tickrate) get called on irregular intervals.
			// According to a 20 tickrate server, this would result in about 10.000 shots/sec, 
			// 1/10.000 = 0.10ms between, therefore...
			// Due to excessive whining, shots/sec increased to 11
			// 1/11 = 0.091ms between
			FireInterval += 0.091;	// 11 shots/sec
			GenerateBullet();
		}

		if	( bFiredShot && ((pawn(Owner).bAltFire==0) || bOutOfAmmo) ) 
			GoToState('FinishFire');
	}

Begin:
	FireInterval = 0.13;	// Spinup time.
}

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local int rndDam;

	if (Other == Level) 
		Spawn(class'UT_LightWallHitEffect',,, HitLocation+HitNormal, Rotator(HitNormal));
	else if ( (Other!=self) && (Other!=Owner) && (Other != None) ) 
	{
		if ( !Other.bIsPawn && !Other.IsA('Carcass') )
			spawn(class'UT_SpriteSmokePuff',,,HitLocation+HitNormal*9); 
		else
			Other.PlaySound(Sound 'ChunkHit',, 4.0,,100);

		if ( Other.IsA('Bot') && (FRand() < 0.2) )
			Pawn(Other).WarnTarget(Pawn(Owner), 500, X);
		// Original code did, 9 + rand(6), which produced 9-14 damage/shot.
		// Also, UT increases all damage with 50% (*1.5), meaning original minigun did 13-21 damage/shot.
		// I feel this is too much, and have reduced it slightly.
		rndDam = 8 + Rand(6);
		// This gives 8-13 damage/shot, or 12-19.5 after multiplication.
		// Original avg damage = 13+21/2 = 17, this avg will be 12+19.5/2 = 15.25
		// Also any "push" (momentum transfer) is removed.
		Other.TakeDamage(rndDam, Pawn(Owner), HitLocation, vect(0,0,0), MyDamageType);
	}
}


defaultproperties
{
    PickupMessage="You got the TI Minigun."
}