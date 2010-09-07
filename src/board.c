/*
 * See Licensing and Copyright notice in naev.h
 */

/**
 * @file board.c
 *
 * @brief Deals with boarding ships.
 */


#include "board.h"

#include "naev.h"

#include "log.h"
#include "pilot.h"
#include "player.h"
#include "toolkit.h"
#include "space.h"
#include "rng.h"
#include "economy.h"
#include "hook.h"


#define BOARDING_WIDTH  370 /**< Boarding window width. */
#define BOARDING_HEIGHT 200 /**< Boarding window height. */

#define BUTTON_WIDTH     50 /**< Boarding button width. */
#define BUTTON_HEIGHT    30 /**< Boarding button height. */


static int board_stopboard = 0; /**< Whether or not to unboard. */
static int numbOutfits = 0; /**< number of outfits installed on boarded ship. */

/*
 * prototypes
 */
static void board_exit( unsigned int wdw, char* str );
static void board_stealCreds( unsigned int wdw, char* str );
static void board_stealCargo( unsigned int wdw, char* str );
static void board_stealFuel( unsigned int wdw, char* str );
static void board_stealEquipment( unsigned int wdw, char* str );
static int board_trySteal( Pilot *p );
static int board_fail( unsigned int wdw );
static void board_update( unsigned int wdw );



/**
 * @fn void player_board (void)
 *
 * @brief Attempt to board the player's target.
 *
 * Creates the window on success.
 */
void player_board (void)
{
   Pilot *p;
   unsigned int wdw;
   char c;
   HookParam hparam[2];


   if (player.p->target==PLAYER_ID) {
      player_message("\erYou need a target to board first!");
      return;
   }

   p = pilot_get(player.p->target);
   c = pilot_getFactionColourChar( p );

   if (!pilot_isDisabled(p)) {
      player_message("\erYou cannot board a ship that isn't disabled!");
      return;
   }
   else if (vect_dist(&player.p->solid->pos,&p->solid->pos) >
         p->ship->gfx_space->sw * PILOT_SIZE_APROX) {
      player_message("\erYou are too far away to board your target.");
      return;
   }
   else if ((pow2(VX(player.p->solid->vel)-VX(p->solid->vel)) +
            pow2(VY(player.p->solid->vel)-VY(p->solid->vel))) >
         (double)pow2(MAX_HYPERSPACE_VEL)) {
      player_message("\erYou are going too fast to board the ship.");
      return;
   }
   else if (pilot_isFlag(p,PILOT_NOBOARD)) {
      player_message("\erTarget ship can not be boarded.");
      return;
   }
   else if (pilot_isFlag(p,PILOT_BOARDED)) {
      player_message("\erYour target cannot be boarded again.");
      return;
   }
   /* We'll recover it if it's the pilot's ex-escort. */
   else if (p->parent == PLAYER_ID) {
      /* Try to recover. */
      pilot_dock( p, player.p, 0 );
      if (pilot_isFlag(p, PILOT_DELETE )) { /* Hack to see if it boarded. */
         player_message("\epYou recover \eg%s\ep into your fighter bay.", p->name);
         return;
      }
   }


   /* pilot will be boarded */
   pilot_setFlag(p,PILOT_BOARDED);
   player_message("\epBoarding ship \e%c%s\e0.", c, p->name);


   /*
    * create the boarding window
    */
   wdw = window_create( "Boarding", -1, -1, BOARDING_WIDTH, BOARDING_HEIGHT );
	/*window coords(from side, from top, width, height)*/
   window_addText( wdw, 20, -30, 120, 60,
         0, "txtGoodies", &gl_smallFont, &cDConsole,
         "Credits:\n"
         "Cargo:\n"
		 "Equipment:\n"
         "Fuel:\n"
         );
   window_addText( wdw, 90, -30, (BOARDING_WIDTH-90-20), (BOARDING_HEIGHT-30-BUTTON_HEIGHT-20 ),
         0, "txtData", &gl_smallFont, &cBlack, NULL );

   /*window_addButton( wdw, 20, 20, BUTTON_WIDTH, BUTTON_HEIGHT, "btnStealCredits", "Credits", board_stealCreds);
   window_addButton( wdw, 20+BUTTON_WIDTH+20, 20, BUTTON_WIDTH, BUTTON_HEIGHT, "btnStealCargo", "Cargo", board_stealCargo);
   window_addButton( wdw, 20+2*(BUTTON_WIDTH+20), 20, BUTTON_WIDTH, BUTTON_HEIGHT, "btnStealFuel", "Fuel", board_stealFuel);
   window_addButton( wdw, 20+3*(BUTTON_WIDTH+20), 20, BUTTON_WIDTH, BUTTON_HEIGHT, "btnStealFuelTest", "Test", board_stealFuel);

   window_addButton( wdw, -20, 20, BUTTON_WIDTH, BUTTON_HEIGHT, "btnBoardingClose", "Leave", board_exit );*/
	
   window_addButton( wdw, 20, 20, BUTTON_WIDTH, BUTTON_HEIGHT, "btnStealCredits", "Credits", board_stealCreds);
   window_addButton( wdw, 20+BUTTON_WIDTH+20, 20, BUTTON_WIDTH, BUTTON_HEIGHT, "btnStealCargo", "Cargo", board_stealCargo);
   window_addButton( wdw, 20+2*(BUTTON_WIDTH+20), 20, BUTTON_WIDTH, BUTTON_HEIGHT, "btnEquipment", "Equipment", board_stealEquipment);
   window_addButton( wdw, 20+3*(BUTTON_WIDTH+20), 20, BUTTON_WIDTH, BUTTON_HEIGHT, "btnStealFuel", "Fuel", board_stealFuel);

	 
   window_addButton( wdw, 20+4*(BUTTON_WIDTH+20), 20, BUTTON_WIDTH, BUTTON_HEIGHT, "btnBoardingClose", "Leave", board_exit );
	


   board_update(wdw);

   /* Don't unboard. */
   board_stopboard = 0;

   /*
    * run hook if needed
    */
   hparam[0].type       = HOOK_PARAM_PILOT;
   hparam[0].u.lp.pilot = p->id;
   hparam[1].type       = HOOK_PARAM_SENTINAL;
   hooks_runParam( "board", hparam );
   pilot_runHook(p, PILOT_HOOK_BOARD);

   if (board_stopboard) {
      board_exit( wdw, NULL );
   }
}


/**
 * @brief Forces unboarding of the pilot.
 */
void board_unboard (void)
{
   board_stopboard = 1;
}


/**
 * @brief Closes the boarding window.
 *
 *    @param wdw Window triggering the function.
 *    @param str Unused.
 */
static void board_exit( unsigned int wdw, char* str )
{
   (void) str;
	numbOutfits=0;
   window_destroy( wdw );
}


/**
 * @brief Attempt to steal the boarded ship's credits.
 *
 *    @param wdw Window triggering the function.
 *    @param str Unused.
 */
static void board_stealCreds( unsigned int wdw, char* str )
{
   (void)str;
   Pilot* p;

   p = pilot_get(player.p->target);

   if (p->credits==0) { /* you can't steal from the poor */
      player_message("\epThe ship has no credits.");
      return;
   }

   if (board_fail(wdw)) return;

   player_modCredits( p->credits );
   p->credits = 0;
   board_update( wdw ); /* update the lack of credits */
   player_message("\epYou manage to steal the ship's credits.");
}


/**
 * @brief Attempt to steal the boarded ship's equipment.
 *
 *    @param wdw Window triggering the function.
 *    @param str Unused.
 */
static void board_stealEquipment( unsigned int wdw, char* str )
{
   (void)str;
   int i, q, qq;
   Pilot* p;

   p = pilot_get(player.p->target);

	if (numbOutfits==0) { /* no outfits */
		player_message("\epThe ship has no equipment.");
		return;
	}
	/*this is here under the initial assumption the player could only take as much as they had space for*/
	else if (pilot_cargoFree(player.p) <= 0) {
      player_message("\erYou have no room for the ship's cargo.");
      return;
   }

   if (board_fail(wdw)) return;

   /** steal as many outfits as possible - maybe open up an planet equipment type window */
   /*it bugs me that the player can get hundreds of tons of stuff. where does it all go?*/
   q = 1;
	i=1;
	for (i=1; i<p->noutfits; i++){
		if (p->outfits[i]->outfit==NULL){
			continue;
		}else{
			q=player_addOutfit(p->outfits[i]->outfit, 1);
			qq=pilot_rmOutfit(p, p->outfits[i]);
		}
		q=1;
	}

   board_update( wdw );
   player_message("\epYou manage to steal the ship's equipment.");
}


/**
 * @brief Attempt to steal the boarded ship's cargo.
 *
 *    @param wdw Window triggering the function.
 *    @param str Unused.
 */
static void board_stealCargo( unsigned int wdw, char* str )
{
	(void)str;
	int q;
	Pilot* p;
	
	p = pilot_get(player.p->target);
	
	if (p->ncommodities==0) { /* no cargo */
		player_message("\epThe ship has no cargo.");
		return;
	}
	else if (pilot_cargoFree(player.p) <= 0) {
		player_message("\erYou have no room for the ship's cargo.");
		return;
	}
	
	if (board_fail(wdw)) return;
	
	/** steal as much as possible until full - @todo let player choose */
	q = 1;
	while ((p->ncommodities > 0) && (q!=0)) {
		q = pilot_addCargo( player.p, p->commodities[0].commodity,
						   p->commodities[0].quantity );
		pilot_rmCargo( p, p->commodities[0].commodity, q );
	}
	
	board_update( wdw );
	player_message("\epYou manage to steal the ship's cargo.");
}

/**
 * @brief Attempt to steal the boarded ship's fuel.
 *
 *    @param wdw Window triggering the function.
 *    @param str Unused.
 */
static void board_stealFuel( unsigned int wdw, char* str )
{
   (void)str;
   Pilot* p;

   p = pilot_get(player.p->target);

   if (p->fuel <= 0.) { /* no fuel. */
      player_message("\epThe ship has no fuel.");
      return;
   }
   else if (player.p->fuel == player.p->fuel_max) {
      player_message("\erYour ship is at maximum fuel capacity.");
      return;
   }

   if (board_fail(wdw))
      return;

   /* Steal fuel. */
   player.p->fuel += p->fuel;
   p->fuel = 0.;

   /* Make sure doesn't overflow. */
   if (player.p->fuel > player.p->fuel_max) {
      p->fuel      = player.p->fuel - player.p->fuel_max;
      player.p->fuel = player.p->fuel_max;
   }

   board_update( wdw );
   player_message("\epYou manage to steal the ship's fuel.");
}


/**
 * @brief Checks to see if the pilot can steal from it's target.
 *
 *    @param p Pilot stealing from it's target.
 *    @return 0 if successful, 1 if fails, -1 if fails and kills target.
 */
static int board_trySteal( Pilot *p )
{
   Pilot *target;

   /* Get the target. */
   target = pilot_get(p->target);
   if (target == NULL)
      return 1;

   /* See if was successful. */
   if (RNGF() > (0.5 *
            (10. + (double)target->ship->crew)/(10. + (double)p->ship->crew)))
      return 0;

   /* Triggered self destruct. */
   if (RNGF() < 0.4) {
      /* Don't actually kill. */
      target->armour = 1.;
      /* This will make the boarding ship take the possible faction hit. */
      pilot_hit( target, NULL, p->id, DAMAGE_TYPE_KINETIC, 100. );
      /* Return ship dead. */
      return -1;
   }

   return 1;
}


/**
 * @brief Checks to see if the hijack attempt failed.
 *
 *    @return 1 on failure to board, otherwise 0.
 */
static int board_fail( unsigned int wdw )
{
   int ret;

   ret = board_trySteal( player.p );

   if (ret == 0)
      return 0;
   else if (ret < 0) /* killed ship. */
      player_message("\epYou have tripped the ship's self destruct mechanism!");
   else /* you just got locked out */
      player_message("\epThe ship's security system locks %s out.",
            (player.p->ship->crew > 0) ? "your crew" : "you" );

   board_exit( wdw, NULL);
   return 1;
}


/**
 * @brief Updates the boarding window fields.
 *
 *    @param wdw Window to update.
 */
static void board_update( unsigned int wdw )
{
   int i, j, k;
   char str[PATH_MAX];
   char cred[ECON_CRED_STRLEN];
   Pilot* p;

   p = pilot_get(player.p->target);
   j = 0;

   /* Credits. */
   credits2str( cred, p->credits, 2 );
   j += snprintf( &str[j], PATH_MAX-j, "%s\n", cred );
	

   /* Commodities. */
   if (p->ncommodities==0)
      j += snprintf( &str[j], PATH_MAX-j, "none\n" );
   else {
	   for (i=0; i<p->ncommodities; i++)
		   j += snprintf( &str[j], PATH_MAX-j, "%d %s\n", p->commodities[i].quantity, p->commodities[i].commodity->name );
   }
	
	/*Outfits*/
	k=0;
	for (i=1; i<p->noutfits; i++){
		if (p->outfits[i]->outfit==NULL){
			continue;
		}else{
			numbOutfits++;
			j += snprintf( &str[j], PATH_MAX-k, (k==0) ? "%s" : ", %s", p->outfits[i]->outfit->name);
			k++;
		}
	}
	if (numbOutfits==0){
		j += snprintf( &str[j], PATH_MAX-j, "none" );
	}
	j += snprintf( &str[j], PATH_MAX-j, "\n" );
	
		

   /* Fuel. */
   if (p->fuel <= 0.)
      j += snprintf( &str[j], PATH_MAX-j, "none\n" );
   else
      j += snprintf( &str[j], PATH_MAX-j, "%.0f Units\n", p->fuel );

	
   window_modifyText( wdw, "txtData", str );

}


/**
 * @brief Has a pilot attempt to board another pilot.
 *
 *    @param p Pilot doing the boarding.
 *    @return 1 if target was boarded.
 */
int pilot_board( Pilot *p )
{
   Pilot *target;

   /* Make sure target is sane. */
   target = pilot_get(p->target);
   if (target == NULL) {
      DEBUG("NO TARGET");
      return 0;
   }

   /* Check if can board. */
   if (!pilot_isDisabled(target))
      return 0;
   else if (vect_dist(&p->solid->pos, &target->solid->pos) >
         target->ship->gfx_space->sw * PILOT_SIZE_APROX )
      return 0;
   else if ((pow2(VX(p->solid->vel)-VX(target->solid->vel)) +
            pow2(VY(p->solid->vel)-VY(target->solid->vel))) >
            (double)pow2(MAX_HYPERSPACE_VEL))
      return 0;
   else if (pilot_isFlag(target,PILOT_BOARDED))
      return 0;

   /* Set the boarding flag. */
   pilot_setFlag(target, PILOT_BOARDED);
   pilot_setFlag(p, PILOT_BOARDING);

   /* Set time it takes to board. */
   p->ptimer = 3.;

   return 1;
}


/**
 * @brief Finishes the boarding.
 *
 *    @param p Pilot to finish the boarding.
 */
void pilot_boardComplete( Pilot *p )
{
   int ret;
   Pilot *target;

   /* Make sure target is sane. */
   target = pilot_get(p->target);
   if (target == NULL)
      return;

   /* Steal stuff, we only do credits for now. */
   ret = board_trySteal(p);
   if (ret == 0) {
      p->credits += target->credits;
      target->credits = 0.;
   }

   /* Finish the boarding. */
   pilot_rmFlag(p, PILOT_BOARDING);
}


