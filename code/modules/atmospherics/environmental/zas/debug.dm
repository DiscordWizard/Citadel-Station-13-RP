GLOBAL_DATUM_INIT(zas_debug_image_assigned, /image, image('icons/testing/Zone.dmi', icon_state = "assigned"))
GLOBAL_DATUM_INIT(zas_debug_image_created, /image, image('icons/testing/Zone.dmi', icon_state = "created"))
GLOBAL_DATUM_INIT(zas_debug_image_merged, /image, image('icons/testing/Zone.dmi', icon_state = "merged"))
GLOBAL_DATUM_INIT(zas_debug_image_invalid_zone, /image, image('icons/testing/Zone.dmi', icon_state = "invalid"))
GLOBAL_DATUM_INIT(zas_debug_image_air_blocked, /image, image('icons/testing/Zone.dmi', icon_state = "block"))
GLOBAL_DATUM_INIT(zas_debug_image_zone_blocked, /image, image('icons/testing/Zone.dmi', icon_state = "zoneblock"))
GLOBAL_DATUM_INIT(zas_debug_image_blocked, /image, image('icons/testing/Zone.dmi', icon_state = "fullblock"))
GLOBAL_DATUM_INIT(zas_debug_image_mark, /image, image('icons/testing/Zone.dmi', icon_state = "mark"))

/datum/zas_edge/var/dbg_out = 0

/turf/var/tmp/dbg_img
/turf/proc/dbg(image/img, d = 0)
	if(d > 0)
		img.dir = d
	cut_overlay(dbg_img)
	add_overlay(img)
	dbg_img = img

/proc/soft_assert(thing,fail)
	if(!thing)
		message_admins(fail)

/client/proc/ZoneTick()
	set category = "Debug"
	set name = "Process Atmos"
	set desc = "Manually run a single tick of the air subsystem"

	// TODO - This might be a useful diagnostic tool.  However its complicated to do with StonedMC
	// Therefore it is left unimplemented for now until its use actually becomes required. ~Leshana
	/*
	if(!check_rights(R_DEBUG)) return

	var/result = SSair.Tick()
	if(result)
		to_chat(src, "Successfully Processed.")

	else
		to_chat(src, "Failed to process! ([SSair.tick_progress])")
	*/

/client/proc/Zone_Info(turf/T as null|turf)
	set category = "Debug"
	if(T)
		if(istype(T,/turf/simulated) && T:zone)
			T:zone:dbg_data(src)
		else
			to_chat(mob, "No zone here.")
			var/datum/gas_mixture/mix = T.return_air()
			to_chat(mob, "[mix.return_pressure()] kPa [mix.temperature]C")
			for(var/g in mix.gas)
				to_chat(mob, "[g]: [mix.gas[g]]\n")
	else
		if(zone_debug_images)
			for(var/zone in  zone_debug_images)
				images -= zone_debug_images[zone]
			zone_debug_images = null

/client/var/list/zone_debug_images

/client/proc/Test_ZAS_Connection(var/turf/simulated/T as turf)
	set category = "Debug"
	if(!istype(T))
		return

	var/direction_list = list(\
	"North" = NORTH,\
	"South" = SOUTH,\
	"East" = EAST,\
	"West" = WEST,\
	#ifdef MULTIZAS
	"Up" = UP,\
	"Down" = DOWN,\
	#endif
	"N/A" = null)
	var/direction = input("What direction do you wish to test?","Set direction") as null|anything in direction_list
	if(!direction)
		return

	if(direction == "N/A")
		if(T.CanAtmosPass(T, NONE) != ATMOS_PASS_AIR_BLOCKED)
			to_chat(mob, "The turf can pass air! :D")
		else
			to_chat(mob, "No air passage :x")
		return

	var/turf/other_turf = T.vertical_step(direction_list[direction])
	if(!istype(other_turf))
		to_chat(mob, "there's no turf in that dir.")
		return
	if(!istype(other_turf, /turf/simulated))
		to_chat(mob, SPAN_RED("the other turf is unsimulated."))

	var/t_block = T.CanAtmosPass(other_turf, T.vertical_dir(other_turf))
	var/o_block = other_turf.CanAtmosPass(T, other_turf.vertical_dir(T))

	if(o_block == ATMOS_PASS_AIR_BLOCKED)
		if(t_block == ATMOS_PASS_AIR_BLOCKED)
			to_chat(mob, "Neither turf can connect. :(")

		else
			to_chat(mob, "The initial turf only can connect. :\\")
		return
	else
		if(t_block == ATMOS_PASS_AIR_BLOCKED)
			to_chat(mob, "The other turf can connect, but not the initial turf. :/")
			return

		else
			to_chat(mob, "Both turfs can connect! :)")

	to_chat(mob, "Additionally, \...")

	if(o_block == ATMOS_PASS_ZONE_BLOCKED)
		if(t_block == ATMOS_PASS_ZONE_BLOCKED)
			to_chat(mob, "neither turf can merge.")
		else
			to_chat(mob, "the other turf cannot merge.")
	else
		if(t_block == ATMOS_PASS_ZONE_BLOCKED)
			to_chat(mob, "the initial turf cannot merge.")
		else
			to_chat(mob, "both turfs can merge.")

/client/proc/ZASSettings()
	set category = "Debug"

	GLOB.atmos_vsc.request_and_set_preset(mob)
