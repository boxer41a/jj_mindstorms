note
	description: "[
		Represents the NXT MindStorms processor
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2010, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	NXT

inherit

	NXT_CONSTANTS
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- Initialize Current
		do
			create motors.make (0, 2)
			create sensors.make (0, 3)
			c_object := c_create
		end

feature -- Access

	motor_a: MOTOR
			-- The motor connected to motor port A
		require
			has_motor_on_port: is_motor_port_occupied (port_a)
		do
			Result := motor (port_a)
		end

	motor_b: MOTOR
			-- The motor connected to motor port B
		require
			has_motor_on_port: is_motor_port_occupied (port_b)
		do
			Result := motor (port_b)
		end

	motor_c: MOTOR
			-- The motor connected to motor port C
		require
			has_motor_on_port: is_motor_port_occupied (port_c)
		do
			Result := motor (port_c)
		end

	motor (a_port: INTEGER): MOTOR
			-- The motor that is attached to `a_port'
		require
			is_valid_port: is_valid_motor_port (a_port)
			is_port_occupied: is_motor_port_occupied (a_port)
		do
			check attached motors [a_port] as m then
				Result := m
			end
		end

	sensor (a_port: INTEGER): SENSOR
			-- The sensor that is attached to `a_port'
		require
			is_valid_port: is_valid_sensor_port (a_port)
			is_port_occupied: is_sensor_port_occupied (a_port)
		do
			check attached sensors [a_port] as s then
				Result := s
			end
		end

feature -- Status report

	is_connected: BOOLEAN
			-- Has a connection been established?

feature -- Element change

	attach_motor (a_motor: MOTOR; a_port: INTEGER)
			-- Attach `a_motor' to the NXT at `a_port' number
		require
			motor_exists: a_motor /= Void
			valid_port: is_valid_motor_port (a_port)
		do
			if motors [a_port] /= a_motor then
				clear_motor_port (a_port)
				motors [a_motor.port] := a_motor
				a_motor.attach (Current, a_motor.port)
			end
		ensure
			has_motor: has_motor (a_motor)
			has_motor_on_port: is_motor_port_occupied (a_motor.port)
			motor_attached_to_correct_port: motor (a_motor.port) = a_motor
		end

	detach_motor (a_motor: MOTOR)
			-- Ensure `a_motor' is not attached to Current
		require
			motor_exists: a_motor /= Void
			has_motor: has_motor (a_motor)
		local
			i: INTEGER
		do
			i := index_of_motor (a_motor)
			clear_motor_port (i)
		ensure
			not_has_motor: not has_motor (a_motor)
		end

	clear_motor_port (a_port: INTEGER)
			-- Ensure the port is not connected to a motor
		require
			is_valid_motor_port: is_valid_motor_port (a_port)
		do
			if attached motors [a_port] as m then
				motors [a_port] := Void
				m.detach
			end
		ensure
			port_is_empty: motors [a_port] = Void
		end

	attach_sensor (a_sensor: SENSOR)
			-- Attach `a_sensor' to the NXT at the sensor's `port' number
		require
			sensor_exists: a_sensor /= Void
			valid_port: is_valid_sensor_port (a_sensor.port)
		do
			if sensors [a_sensor.port] /= a_sensor then
				clear_sensor_port (a_sensor.port)
				sensors [a_sensor.port] := a_sensor
				a_sensor.attach (Current, a_sensor.port)
			end
		ensure
			has_sensor: has_sensor (a_sensor)
			has_sensor_on_port: is_sensor_port_occupied (a_sensor.port)
			sensor_attached_to_correct_port: sensor (a_sensor.port) = a_sensor
		end

	detach_sensor (a_sensor: SENSOR)
			-- Ensure `a_sensor' is not attached to Current
		require
			sensor_exists: a_sensor /= Void
			has_sensor: has_sensor (a_sensor)
		local
			i: INTEGER
		do
			i := index_of_sensor (a_sensor)
			clear_sensor_port (i)
		ensure
			not_has_sensor: not has_sensor (a_sensor)
		end

	clear_sensor_port (a_port: INTEGER)
			-- Ensure the port is not connected to a sensor
		require
			is_valid_sensor_port: is_valid_sensor_port (a_port)
		do
			if attached sensors [a_port] as s then
				sensors [a_port] := Void
				s.detach
			end
		ensure
			port_is_empty: sensors [a_port] = Void
		end

feature -- Basic operations

	connect_bluetooth
			-- Attempt to connect to the NXT robot via bluetooth
		do
			is_connected := c_openBT (c_object)
			if is_connected then
					-- Create the C connection to the sensors
					-- This is different from the motors
				if attached sensors [port_1] as s then
					s.set_sensor
				end
				if attached sensors [port_2] as s then
					s.set_sensor
				end
				if attached sensors [port_3] as s then
					s.set_sensor
				end
				if attached sensors [port_4] as s then
					s.set_sensor
				end
			end
		end

	disconnect
			-- Close the connection
		do
			c_close (c_object)
		end

feature -- Querry

	has_motor (a_motor: MOTOR): BOOLEAN
			-- Is a_motor attached to Current?
		require
			motor_exists: a_motor /= Void
		do
			Result := motors.has (a_motor)
		end

	has_sensor (a_sensor: SENSOR): BOOLEAN
			-- Is a_sensor attached to Current?
		require
			sensor_exists: a_sensor /= Void
		do
			Result := sensors.has (a_sensor)
		end

	index_of_motor (a_motor: MOTOR): INTEGER
			-- On what port is `a_motor' attached?
		require
			motor_exists: a_motor /= Void
			has_motor: has_motor (a_motor)
		do
			if motors [port_a] = a_motor then
				Result := port_a
			elseif motors [port_b] = a_motor then
				Result := port_b
			elseif motors [port_c] = a_motor then
				Result := port_c
			else
				check
					should_not_happend: False
						-- because of precondition
				end
			end
		end

	index_of_sensor (a_sensor: SENSOR): INTEGER
			-- On what port is `a_sensor' attached?
		require
			sensor_exists: a_sensor /= Void
			has_sensor: has_sensor (a_sensor)
		do
			if sensors [port_1] = a_sensor then
				Result := port_1
			elseif sensors [port_2] = a_sensor then
				Result := port_2
			elseif sensors [port_3] = a_sensor then
				Result := port_3
			elseif sensors [port_4] = a_sensor then
				Result := port_4
			else
				check
					should_not_happend: False
						-- because of precondition
				end
			end
		end

	is_motor_port_occupied (a_port: INTEGER): BOOLEAN
			-- Is there a motor attached to `a_port'?
		do
			Result := motors [a_port] /= Void
		end

	is_sensor_port_occupied (a_port: INTEGER): BOOLEAN
			-- Is there a sensor attached to `a_port'?
		do
			Result := sensors [a_port] /= Void
		end

feature {NONE} -- Implementation

	motors: ARRAY [detachable MOTOR]
			-- Array that can contain up to three motors
			-- The index indicates the port number on which
			-- the motor is attached to the NXT

	sensors: ARRAY [detachable SENSOR]
			-- Array that can contain up to three sensors
			-- The index indicates the port number on which
			-- the sensor is attached to the NXT

feature {MOTOR, SENSOR} -- Implementation

	c_object: POINTER
			-- Handle to the NXT_COMM object
--		do
--			Result := connection.c_object
--		end

feature {NONE} -- Implementation

	c_create: POINTER
			-- Call the C++ external to create the object
		external
			"C++ inline use %"comm.h%""
		alias
			"[
			return (EIF_POINTER) new Comm::NXTComm();
			]"
		end

	c_openBT (obj: POINTER): BOOLEAN
			-- Attempt to connect over bluetooth
			-- Return true if successful
		external
			"C++ inline use %"NXT++.h%""
		alias
			"[
			return (EIF_BOOLEAN) NXT::OpenBT ((Comm::NXTComm *) ($obj));
			]"
		end

	c_close (obj: POINTER)
			-- Close the connection
		external
			"C++ inline use %"NXT++.h%""
		alias
			"[
			NXT::Close ((Comm::NXTComm *) ($obj));
			]"
		end

invariant

	motors_exists: motors /= Void
	sensors_exists: sensors /= Void
	c_object_exists: c_object /= Default_pointer

end
