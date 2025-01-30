note
	description: "[
		Root class for NXT sensors
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2010, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision: $"

deferred class
	SENSOR

inherit

	NXT_CONSTANTS

feature {NONE} -- Initialization

	make (a_port: INTEGER)
			-- Create a sensor using the indicated port
		do
			port := a_port
		ensure
			port_is_set: port = a_port
		end

feature -- Access

	nxt: NXT
			-- The nxt, if any, to which Current is attached
		require
			is_attached: is_attached
		do
			check attached nxt_imp as x then
				Result := x
			end
		end

	port: INTEGER
			-- The port to which this sensor is connected

	value: INTEGER
			-- The current value read from the sensor
		require
			is_attached: is_attached
			is_connected: is_connected
		do
			Result := c_get_value (c_object, port)
		end

feature -- Status report

	is_active: BOOLEAN
			-- Is the sensor in active mode?
			-- For a sonar sensor this would say the sonar is
			-- continuously emitting pulses

	is_attached: BOOLEAN
			-- Is Current attached to an NXT?
		do
			Result := nxt /= Void
		end

	is_connected: BOOLEAN
			-- Is Current attached and is the `nxt' connected?
		do
			Result := is_attached and then nxt.is_connected
		end

feature -- Status setting

	set_active
			-- Put the sensor in "active" mode
			-- Example:  for a sonar sensor, could be redefined to make the
			-- sensor continuously emit pulses.
		do
			is_active := True
		end

	set_passive
			-- Put the sensor in "passive" mode
		do
			is_active := False
		end

feature -- Element change

	attach (a_nxt: NXT; a_port: INTEGER)
			-- Attach Current to the NXT on `a_port'
		require
			nxt_exists: a_nxt /= Void
			is_valid_port: is_valid_sensor_port (a_port)
		do
			if is_attached then
				detach
			end
			if not a_nxt.is_sensor_port_occupied (a_port) or else
					(a_nxt.is_sensor_port_occupied (a_port) and then
					 a_nxt.sensor (a_port) /= Current) then
				port := a_port
				nxt_imp := a_nxt
				nxt.attach_sensor (Current)
			end
			if is_connected then
				set_sensor
			end
		ensure
			is_attached: is_attached
			is_attached_to_nxt: a_nxt.has_sensor (Current)
			is_attached_to_correct_port: a_nxt.sensor (a_port) = Current
		end

	detach
			-- Ensure the sensor is not attached to any NXT
		local
			temp_nxt: NXT
		do
			if is_attached then
				temp_nxt := nxt
				nxt_imp := Void
				temp_nxt.detach_sensor (Current)
			end
		ensure
			not_attached: not is_attached
		end

feature {NXT} -- Implementation

	set_sensor
			-- Call the c code to attach the sensor
		require
			is_attached: is_attached
			is_connected: is_connected
		deferred
		end

feature {NONE}

	nxt_imp: detachable NXT
			-- Detachable implementation of `nxt'

	c_object: POINTER
			-- Handle to the nxt's C++ object
		require
			is_attached: is_attached
		do
			Result := nxt.c_object
		end

feature {NONE} -- Implementation

	c_set_raw (obj: POINTER; a_port: INTEGER)
			-- Set the sensor to return raw values from port `a_port'
		require
			object_exists: obj /= default_pointer
			valid_port: is_valid_sensor_port (a_port)
		external
			"C++ inline use %"NXT++.h%""
		alias
			"[
			NXT::Sensor::SetRaw ((Comm::NXTComm *) $obj, (int) $a_port);
			]"
		end

	c_get_value (obj: POINTER; a_port: INTEGER): INTEGER
			-- Wrapper to get the value of the sensor connected to `a_port'
		require
			object_exists: obj /= default_pointer
			valid_port: is_valid_sensor_port (a_port)
		external
			"C++ inline use %"NXT++.h%""
		alias
			"[
			return (EIF_INTEGER) NXT::Sensor::GetValue ((Comm::NXTComm *) $obj, (int) $a_port);
			]"
		end

end
