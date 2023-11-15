note
	description	: "[
		Helper class for MindStorms robot project, containing shared objects
	]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2010, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision:  $"

class
	NXT_CONSTANTS

feature -- Basic operations

	wait (a_time: INTEGER)
			-- Wait for `a_time' milliseconds
		do
			c_wait (a_time)
		end

feature -- Access

	Default_nxt: NXT
			-- A default NXT
		once
			create Result
			Result.attach_motor (motor_a)
			Result.attach_motor (motor_b)
			Result.attach_motor (motor_c)
			Result.attach_sensor (touch_sensor)
			Result.attach_sensor (light_sensor)
			Result.attach_sensor (sound_sensor)
			Result.attach_sensor (distance_sensor)
		end

	motor_a: MOTOR
			-- The motor connected to motor port A
		once
			create Result.make (port_a)
		end

	motor_b: MOTOR
			-- The motor connected to motor port B
		once
			create Result.make (port_b)
		end

	motor_c: MOTOR
			-- The motor connected to motor port C
		once
			create Result.make (port_c)
		end

	touch_sensor: TOUCH_SENSOR
			-- The touch sensor; defaults to port 1
		once
			create Result.make (port_1)
		end

	light_sensor: LIGHT_SENSOR
			-- The light sensor; defaults to port 2
		once
			create Result.make (port_2)
		end

	sound_sensor: SOUND_SENSOR
			-- The sound sensor; defaults to port 3
		once
			create Result.make (port_3)
		end

	distance_sensor: DISTANCE_SENSOR
			-- The distance sensor; defaults to port 4)
		once
			create Result.make (port_4)
		end

feature -- Enumerations

	port_a: INTEGER
			-- Motor port A
		once
			Result := c_port_a
		end

	port_b: INTEGER
			-- Motor port B
		once
			Result := c_port_b
		end

	port_c: INTEGER
			-- Motor port C
		once
			Result := c_port_c
		end

	port_1: INTEGER
			-- Sensor port 1
		once
			Result := c_port_1
		end

	port_2: INTEGER
			-- Sensor port 2
		once
			Result := c_port_2
		end

	port_3: INTEGER
			-- Sensor port 3
		once
			Result := c_port_3
		end

	port_4: INTEGER
			-- Sensor port 4
		once
			Result := c_port_4
		end

feature -- Contract checking

	is_valid_motor_port (a_port: INTEGER): BOOLEAN
			-- Is `a_port' a valid port number for a motor?
		do
			Result := a_port = port_a or else
						a_port = port_b or else
						a_port = port_c
		end

	is_valid_sensor_port (a_port: INTEGER): BOOLEAN
			-- Is `a_port' a valid port number of a sensor?
		do
			Result := a_port = port_1 or else
						a_port = port_2 or else
						a_port = port_3 or else
						a_port = port_4
		end

feature {NONE} -- Implementation

	c_wait (a_time: INTEGER)
			-- Call c function to pause `a_time' milliseconds
		external
			"C++ inline use %"nxt++.h%""
		alias
			"[
			Wait ((int) $a_time);
			]"
		end

	c_port_a: INTEGER
			-- Calls C++ function to get the enumerated value
		external
			"C++ inline use %"nxt++.h%""
		alias
			"[
			return (EIF_INTEGER) OUT_A;
			]"
		end

	c_port_b: INTEGER
			-- Calls C++ function to get the enumerated value
		external
			"C++ inline use %"nxt++.h%""
		alias
			"[
			return (EIF_INTEGER) OUT_B;
			]"
		end

	c_port_c: INTEGER
			-- Calls C++ function to get the enumerated value
		external
			"C++ inline use %"nxt++.h%""
		alias
			"[
			return (EIF_INTEGER) OUT_C;
			]"
		end

	c_port_1: INTEGER
			-- Calls C++ function to get the enumerated value
		external
			"C++ inline use %"nxt++.h%""
		alias
			"[
			return (EIF_INTEGER) IN_1;
			]"
		end

	c_port_2: INTEGER
			-- Calls C++ function to get the enumerated value
		external
			"C++ inline use %"nxt++.h%""
		alias
			"[
			return (EIF_INTEGER) IN_2;
			]"
		end

	c_port_3: INTEGER
			-- Calls C++ function to get the enumerated value
		external
			"C++ inline use %"nxt++.h%""
		alias
			"[
			return (EIF_INTEGER) IN_3;
			]"
		end

	c_port_4: INTEGER
			-- Calls C++ function to get the enumerated value
		external
			"C++ inline use %"nxt++.h%""
		alias
			"[
			return (EIF_INTEGER) IN_4;
			]"
		end

end
