// ============================================================
// TIW.M_Minigun: put your comment here

// Created by UClasses - (C) 2000 by meltdown@thirdtower.com
// ============================================================

class M_Minigun expands Mutator;

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	if ( Other.IsA('minigun2') && !Other.IsA('TIW_Minigun2') )
	{
		ReplaceWith(Other, "CB12.TIW_Minigun2");
		return False;
	}
	return True;
}

defaultproperties
{
}