/*
 * See Licensing and Copyright notice in naev.h
 */



#ifndef LAND_H
#  define LAND_H


#include "space.h"


/*
 * The window interfaces.
 */
enum {
   LAND_WINDOW_MAIN,         /**< Main window. */
   LAND_WINDOW_BAR,          /**< Bar window. */
   LAND_WINDOW_MISSION,      /**< Mission computer window. */
   LAND_WINDOW_OUTFITS,      /**< Outfits window. */
   LAND_WINDOW_SHIPYARD,     /**< Shipyard window. */
   LAND_WINDOW_EQUIPMENT,    /**< Equipment window. */
   LAND_WINDOW_COMMODITY,    /**< Commodity window. */
   LAND_NUMWINDOWS           /**< Number of land windows. */
};


/*
 * Default button sizes.
 */
#define LAND_BUTTON_WIDTH 200 /**< Default button width. */
#define LAND_BUTTON_HEIGHT 40 /**< Default button height. */


/*
 * Minor hack, for 'buy map' button.
 */
#define LOCAL_MAP_NAME "Local System Map"


/*
 * Landed at.
 */
extern int landed;
extern Planet* land_planet;


/* Tracking for which tabs have been generated. */
#define land_tabGenerate(w)       (land_generated |= (1 << w)) /**< Mark tab generated. */
#define land_tabGenerated(w)     (land_generated & (1 << w)) /**< Check if tab has been generated. */
extern unsigned int land_generated;


/*
 * Main interface.
 */
void land_queueTakeoff (void);
int land_doneLoading (void);
void land( Planet* p, int load );
void land_genWindows( int load, int changetab );
void takeoff( int delay );
void land_cleanup (void);
void land_exit (void);
int land_setWindow( int window );


/*
 * Internal usage.
 */
void land_refuel (void);
void land_checkAddMap (void);
void land_buttonTakeoff( unsigned int wid, char *unused );
unsigned int land_getWid( int window );
void bar_regen (void);

/*
 * Error dialogue generation and associated sanity checks.
 */
int can_swap( char* shipname );
int can_swapEquipment( char* shipname );
int can_sell( char* shipname );
int land_errDialogue( char* name, char* type );
void land_errDialogueBuild( const char *fmt, ... );


#endif /* LAND_H */
