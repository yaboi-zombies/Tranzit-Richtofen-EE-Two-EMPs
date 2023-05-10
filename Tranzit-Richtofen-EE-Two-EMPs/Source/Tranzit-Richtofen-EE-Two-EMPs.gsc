#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\gametypes_zm\_globallogic_score;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zm_transit_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
	if( getPlayers() <= 1 )
	{
		replaceFunc(maps\mp\zm_transit_sq::richtofen_sidequest_c, ::custom_richtofen_sidequest_c);
	}
}

custom_richtofen_sidequest_c()
{
	level endon( "power_off" );
	level endon( "richtofen_sq_complete" );
	screech_zones = getstructarray( "screecher_escape", "targetname" );
	level thread screecher_light_hint();
	level thread screecher_light_on_sq();
	level.sq_richtofen_c_screecher_lights = [];
	while ( 1 )
	{
		level waittill( "safety_light_power_off", screecher_zone );
		while ( !level.sq_progress[ "rich" ][ "A_complete" ] || !level.sq_progress[ "rich" ][ "B_complete" ] )
		{
			level thread richtofensay( "vox_zmba_sidequest_emp_nomag_0" );
		}
		level.sq_richtofen_c_screecher_lights[ level.sq_richtofen_c_screecher_lights.size ] = screecher_zone;
		level.sq_progress[ "rich" ][ "C_screecher_light" ]++;
		if ( level.sq_progress[ "rich" ][ "C_screecher_light" ] >= 2 )
		{
			break;
		}
		else
		{
			if ( isDefined( level.checking_for_richtofen_c_failure ) && !level.checking_for_richtofen_c_failure )
			{
				level thread check_for_richtofen_c_failure();
			}
		}
	}
	level thread richtofensay( "vox_zmba_sidequest_4emp_mag_0" );
	level notify( "richtofen_c_complete" );
	player = get_players();
	player[ 0 ] setclientfield( "screecher_sq_lights", 0 );
	level thread richtofen_sidequest_complete_check( "C_complete" );
}