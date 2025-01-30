note
	description: "[
		Represents the sonar sensor for the NXT
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2010, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	SONAR_SENSOR

inherit

	SENSOR
		redefine
			make,
			value,
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
			c_set_sonar (c_object, port)
		end

feature -- Access

	value: INTEGER
			-- The value read from the sensor
		do
			Result := c_get_sonar_value (c_object, port)
		end

feature -- Status setting

	set_active
			-- Turn the infrared light on
		do
			Precursor {SENSOR}
			c_set_sonar_continuous (c_object, port)
		end

	set_passive
			-- Turn the infrared light off
		do
			Precursor {SENSOR}
			c_set_sonar_single_shot (c_object, port)
		end


feature {NONE} -- Implementation

	set_sensor
			-- Call the c code to attach the sensor
		do
			c_set_sonar (c_object, port)
		end

	c_set_sonar (obj: POINTER; a_port: INTEGER)
			-- Wrapper to tell the connection (the obj) that the
			-- sensor is connected to `a_port'
		require
			object_exists: obj /= default_pointer
		external
			"C++ inline use %"NXT++.h%""
		alias
			"[
			NXT::Sensor::SetSonar ((Comm::NXTComm *) $obj, (int) $a_port);
			]"
		end

	c_get_sonar_value (obj: POINTER; a_port: INTEGER): INTEGER
			-- Get the "sonar" value from this sensor
		require
			object_exists: obj /= default_pointer
		external
			"C++ inline use %"NXT++.h%""
		alias
			"[
			return (EIF_INTEGER) NXT::Sensor::GetSonarValue ((Comm::NXTComm *) $obj, (int) $a_port);
			]"
		end

	c_set_sonar_continuous (obj: POINTER; a_port: INTEGER)
			-- Wrapper to make the sonar sensor to continuously emit pulses
		require
			object_exists: obj /= default_pointer
		external
			"C++ inline use %"NXT++.h%""
		alias
			"[
			NXT::Sensor::SetSonarContinuous ((Comm::NXTComm *) $obj, (int) $a_port);
			]"
		end

	c_set_sonar_single_shot (obj: POINTER; a_port: INTEGER)
			-- Wrapper to make the sonar sensor emit pulses only when asked for a value
		require
			object_exists: obj /= default_pointer
		external
			"C++ inline use %"NXT++.h%""
		alias
			"[
			NXT::Sensor::SetSonarSingleShot ((Comm::NXTComm *) $obj, (int) $a_port);
			]"
		end

end
