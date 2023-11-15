note
	description: "[
		Represents the light sensor for the NXT
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2010, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	LIGHT_SENSOR

inherit

	SENSOR
		redefine
			make,
			set_active,
			set_passive
		end

create
	make

feature {NONE} -- Initialization

	make (a_port: INTEGER)
			-- Create a sensor using the indicated port
			-- Set the infrared sensor to off
		do
			Precursor {SENSOR} (a_port)
			set_passive
		end

feature -- Status setting

	set_active
			-- Turn the infrared light on
		do
			Precursor {SENSOR}
			if is_attached then
				c_set_light (c_object, port, is_active)
			end
		end

	set_passive
			-- Turn the infrared light off
		do
			Precursor {SENSOR}
			if is_attached then
				c_set_light (c_object, port, is_active)
			end
		end

feature {NONE} -- Implementation

	set_sensor
			-- Call the c code to attach the sensor
		do
			c_set_light (c_object, port, is_active)
		end

	c_set_light (obj: POINTER; a_port: INTEGER; is_infrared_on: BOOLEAN)
			-- Wrapper to tell the connection (the obj) that the
			-- light sensor is connected to `a_port'
		require
			object_exists: obj /= default_pointer
		external
			"C++ inline use %"NXT++.h%""
		alias
			"[
			NXT::Sensor::SetLight ((Comm::NXTComm *) $obj, (int) $a_port, (bool) $is_infrared_on);
			]"
		end

end
