note
	description: "[
		Represents the touch sensor for the NXT
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2010, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	TOUCH_SENSOR

inherit

	SENSOR

create
	make

feature -- Status report

	is_pressed: BOOLEAN
			-- Is the touch sensor pressed?
		do
			Result := is_attached and then value /= 0
		end

feature {NONE} -- Implementation

	set_sensor
			-- Call the c code to attach the sensor
		do
			c_set_touch (c_object, port)
		end

	c_set_touch (obj: POINTER; a_port: INTEGER)
			-- Wrapper to tell the connection (the obj) that the
			-- touch sensor is connected to `a_port'
		require
			object_exists: obj /= default_pointer
		external
			"C++ inline use %"NXT++.h%""
		alias
			"[
			NXT::Sensor::SetTouch ((Comm::NXTComm *) $obj, (int) $a_port);
			]"
		end

end
