note
	description: "[
		Represents the distance (or untrasonic) sensor for the NXT
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2010, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	DISTANCE_SENSOR

inherit

	SENSOR
		redefine
			value
		end

create
	make

feature -- Access

	value: INTEGER
			-- The value read from the sensor
		do
			Result := c_get_dist_nx_value (c_object, port)
		end

	distance: INTEGER
			-- The distance as read from the sensor
			-- Same as value
		require
			is_attached: is_attached
		do
			Result := value
		end

	average_distance: INTEGER
			-- An average of several reading made by the sensor
		require
			is_attached: is_attached
		do
			Result := c_get_clean_dist_nx_value (c_object, port)
		end

feature {NONE} -- Implementation

	set_sensor
			-- Call the c code to attach the sensor
		do
			c_set_dist_nx (c_object, port)
		end

	c_set_dist_nx (obj: POINTER; a_port: INTEGER)
			-- Wrapper to tell the connection (the obj) that the
			-- distance sensor is connected to `a_port'
		require
			object_exists: obj /= default_pointer
		external
			"C++ inline use %"NXT++.h%""
		alias
			"[
			NXT::Sensor::SetDistNx ((Comm::NXTComm *) $obj, (int) $a_port);
			]"
		end

	c_get_dist_nx_value (obj: POINTER; a_port: INTEGER): INTEGER
			-- Get the distance value from this sensor
		require
			object_exists: obj /= default_pointer
		external
			"C++ inline use %"NXT++.h%""
		alias
			"[
			return (EIF_INTEGER) NXT::Sensor::GetDistNxValue ((Comm::NXTComm *) $obj, (int) $a_port);
			]"
		end

	c_get_clean_dist_nx_value (obj: POINTER; a_port: INTEGER): INTEGER
			-- Get an average of several distance readings from this sensor
		require
			object_exists: obj /= default_pointer
		external
			"C++ inline use %"NXT++.h%""
		alias
			"[
			return (EIF_INTEGER) NXT::Sensor::GetCleanDistNxValue ((Comm::NXTComm *) $obj, (int) $a_port);
			]"
		end

end
