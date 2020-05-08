note
	description: "[
		Represents the sound sensor for the NXT
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2010, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	SOUND_SENSOR

inherit

	SENSOR

create
	make

feature {NONE} -- Implementation

	set_sensor
			-- Call the c code to attach the sensor
		do
			c_set_sound (c_object, port)
		end

	c_set_sound (obj: POINTER; a_port: INTEGER)
			-- Wrapper to tell the connection (the obj) that the
			-- light sensor is connected to `a_port'
		require
			object_exists: obj /= default_pointer
		external
			"C++ inline use %"NXT++.h%""
		alias
			"[
			NXT::Sensor::SetSound ((Comm::NXTComm *) $obj, (int) $a_port);
			]"
		end

end
