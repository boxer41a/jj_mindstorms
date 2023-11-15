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

	motor (a_port: INTEGER): MOTOR
			-- The motor that is attached to `a_port'
		require
			is_valid_port: is_valid_motor_port (a_port)
			is_port_occupied: is_motor_port_occupied (a_port)
		do
			Result := motors [a_port]
		end

	sensor (a_port: INTEGER): SENSOR
			-- The sensor that is attached to `a_port'
		require
			is_valid_port: is_valid_sensor_port (a_port)
			is_port_occupied: is_sensor_port_occupied (a_port)
		do
			Result := sensors [a_port]
		end

feature -- Status report

	is_connected: BOOLEAN
			-- Has a connection been established?

feature -- Element change

	attach_motor (a_motor: MOTOR)
			-- Attach `a_motor' to the NXT at the motor's `port' number
		require
			motor_exists: a_motor /= Void
			valid_port: is_valid_motor_port (a_motor.port)
		do
			if motors [a_motor.port] /= a_motor then
				clear_motor_port (a_motor.port)
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
		local
			m: MOTOR
		do
			if motors [a_port] /= Void then
				m := motors [a_port]
				motors [a_port] := Void
				m.detach
			end
			check
				motor_detached: not m.is_attached
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
		local
			s: SENSOR
		do
			if sensors [a_port] /= Void then
				s := sensors [a_port]
				sensors [a_port] := Void
				s.detach
			end
			check
				sensor_detached: not s.is_attached
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
					-- create the c connection to the sensors
					-- This is different form the motors
				if sensors [port_1] /= Void then
					sensors [port_1].set_sensor
				end
				if sensors [port_2] /= Void then
					sensors [port_2].set_sensor
				end
				if sensors [port_3] /= Void then
					sensors [port_3].set_sensor
				end
				if sensors [port_4] /= Void then
					sensors [port_4].set_sensor
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

	motors: ARRAY [MOTOR]
			-- Array that can contain up to three motors
			-- The index indicates the port number on which
			-- the motor is attached to the NXT

	sensors: ARRAY [SENSOR]
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
