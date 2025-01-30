note
	description: "[
		A motor for the NXT
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2010, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	MOTOR

inherit

	NXT_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_nxt: NXT; a_port: INTEGER)
			-- Create a motor using the indicated port and {NXT}
		require
			valid_port: is_valid_motor_port (a_port)
			port_not_occupied: not nxt.is_motor_port_occupied (a_port)
		do
--			port := a_port
--			nxt_imp := a_nxt
			attach (a_nxt, a_port)
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
			-- The port to which this motor is connected

	speed: INTEGER
			-- The speed at which the motor should run

	degrees: INTEGER
			-- The number of degrees the motor should turn when activated

	Maximum_speed: INTEGER = 100
			-- The minimum speed allowed	

	Minimum_speed: INTEGER = 0
			-- The maximum speed allowed	

	Maximum_degrees: INTEGER = 1000
			-- The maximum value for the `degrees'

feature -- Element change

	attach (a_nxt: NXT; a_port: INTEGER)
			-- Attach Current to the NXT on `a_port'
		require
			nxt_exists: a_nxt /= Void
			is_valid_port: is_valid_motor_port (a_port)
		do
			if is_attached then
				detach
			end
			if not a_nxt.is_motor_port_occupied (a_port) or else
					(a_nxt.is_motor_port_occupied (a_port) and then
					 a_nxt.motor (a_port) /= Current) then
				port := a_port
				nxt_imp := a_nxt
				nxt.attach_motor (Current, port)
			end
		ensure
			is_attached: is_attached
			is_attached_to_nxt: a_nxt.has_motor (Current)
			is_attached_to_correct_port: a_nxt.motor (a_port) = Current
		end

	detach
			-- Ensure the motor is not attached to any NXT
		local
			temp_nxt: detachable NXT
		do
			if is_attached then
				temp_nxt := nxt
				nxt_imp := Void
				temp_nxt.detach_motor (Current)
			end
		ensure
			not_attached: not is_attached
		end

	set_speed (a_speed: INTEGER)
			-- Change the motors speed
		require
			speed_large_enough: speed >= Minimum_speed
			speed_small_enough: speed <= Maximum_speed
		do
			speed := a_speed
		end

	set_degrees (a_value: INTEGER)
			-- Set the number of degrees the motor should turn when activated.
			-- If set to zero the motor will run until stopped
		require
			a_value >= 0
			a_value <= Maximum_degrees
		do
			degrees := a_value
		end

feature -- Measurement

	delta: INTEGER
			-- The number of degrees the motor has turned
			-- By default, this is measured from its last position, but can
			-- be measured from an absolute position by using `set_position_absolute'
			-- Reset with `reset_rotation_count'
		require
			is_attached: is_attached
		do
			Result := c_get_rotation_count (c_object, port)
		end

	reset_delta
			-- Reset the `delta'
		require
			is_attached: is_attached
		do
			c_reset_rotation_count (c_object, port, is_position_absolute)
		end

feature -- Status report

	is_attached: BOOLEAN
			-- Is Current attached to an NXT?
		do
			Result := nxt /= Void
		end

	is_position_absolute: BOOLEAN
			-- Is the motors `delta' measured from an absolute position?
			-- See `set_position_absolute' and `set_position_relative'

	is_running: BOOLEAN
			-- Is the motor running?
		local
			rc_start, rc_end: INTEGER
		do
			if is_attached then
				rc_start := delta
					-- wait a short time and retest
				wait (10)
				rc_end := delta
				Result := rc_end /= rc_start
			end
		end

	is_braking: BOOLEAN
			-- Is a the brake turned on?
			-- Default is False, so the motor will coast when stopped

	is_reversed: BOOLEAN
			-- Is the motor to run in reverse?

feature -- Status setting

	set_position_absolute
			-- Make the motor's `delta' be measured from an
			-- absolute (its current) position
		do
			is_position_absolute := True
			if is_attached then
				c_reset_rotation_count (c_object, port, is_position_absolute)
			end
		end

	set_position_relative
			-- Make the motor's `delta' be measured from its last position
		do
			is_position_absolute := False
			if is_attached then
				c_reset_rotation_count (c_object, port, is_position_absolute)
			end
		end

	set_reversed
			-- Make the motor run in reversed when turned on
		do
			is_reversed := True;
		end

	set_forward
			-- Make the motor run forward when turned on
		do
			is_reversed := False;
		end

	set_braking
			-- Make the motor brake for stops
		do
			is_braking := True
		end

	set_coasting
			-- Make the motor coast for stops
		do
			is_braking := False
		end

feature -- Basic operations

	run
			-- Make the motor run based on settings in `speed',
			-- `degrees', `reply'
		require
			is_attached: is_attached
		do
			if is_reversed then
				run_reversed (speed)
			else
				run_forward (speed)
			end
		ensure
			is_running: is_running
		end

	stop
			-- Make the motor come to a stop.
			-- It will stop quickly if `is_braking'; it will coast
			-- to a stop otherwise.
		require
			is_attached: is_attached
		do
			c_stop (c_object, port, is_braking)
		ensure
			is_stopped: not is_running
		end

	change_direction
			-- Change the direction of the motor
		do
			is_reversed := not is_reversed
			if is_running and is_attached then
				stop
				run
			end
		end

	run_forward (a_speed: INTEGER)
			-- Make the motor turn forward at `a_speed'
		require
			is_attached: is_attached
		do
			c_set_forward (c_object, port, a_speed)
		end

	run_reversed (a_speed: INTEGER)
			-- Make the motor turn backward at `a_speed'
		require
			is_attached: is_attached
		do
			c_set_reverse (c_object, port, a_speed)
		end

feature {NONE} -- Implementation

	nxt_imp: detachable NXT
			-- Detachable implementation of `nxt'

	c_object: POINTER
			-- Handle to the corresponding C++ object (i.e. the
			-- {NXT} to which Current is attached)
		require
			is_attached: is_attached
		do
			Result := nxt.c_object
		end

feature {NONE} -- Implementation

	c_set_forward (obj: POINTER; a_port: INTEGER; a_speed: INTEGER)
			-- Wrapper to turn on the motor
		require
			object_exists: obj /= default_pointer
		external
			"C++ inline use %"NXT++.h%""
		alias
			"[
			NXT::Motor::SetForward ((Comm::NXTComm *) $obj, (int) $a_port, (int) $a_speed);
			]"
		end

	c_set_reverse (obj: POINTER; a_port: INTEGER; a_speed: INTEGER)
			-- Wrapper to turn on the motor
		require
			object_exists: obj /= default_pointer
		external
			"C++ inline use %"NXT++.h%""
		alias
			"[
			NXT::Motor::SetReverse ((Comm::NXTComm *) $obj, (int) $a_port, (int) $a_speed);
			]"
		end

	c_stop (obj: POINTER; a_port: INTEGER; a_brake: BOOLEAN)
			-- Wrapper to turn on the motor
		require
			object_exists: obj /= default_pointer
		external
			"C++ inline use %"NXT++.h%""
		alias
			"[
			NXT::Motor::Stop ((Comm::NXTComm *) $obj, (int) $a_port, (bool) $a_brake);
			]"
		end

	c_get_rotation_count (obj: POINTER; a_port: INTEGER): INTEGER
			-- Wrapper to turn on the motor
		require
			object_exists: obj /= default_pointer
		external
			"C++ inline use %"NXT++.h%""
		alias
			"[
			return (EIF_INTEGER) NXT::Motor::GetRotationCount ((Comm::NXTComm *) $obj, (int) $a_port);
			]"
		end

	c_reset_rotation_count (obj: POINTER; a_port: INTEGER; relative: BOOLEAN)
			-- Wrapper to reset the motor relative to it last movement or
			-- to its absolute position
		require
			object_exists: obj /= default_pointer
		external
			"C++ inline use %"NXT++.h%""
		alias
			"[
			NXT::Motor::ResetRotationCount ((Comm::NXTComm *) $obj, (int) $a_port, (bool) $relative);
			]"
		end

	c_brake_on (obj: POINTER; a_port: INTEGER)
			-- Wrapper to turn the brake on
		require
			object_exists: obj /= default_pointer
		external
			"C++ inline use %"NXT++.h%""
		alias
			"[
			NXT::Motor::BrakeOn ((Comm::NXTComm *) $obj, (int) $a_port);
			]"
		end

	c_brake_off (obj: POINTER; a_port: INTEGER)
			-- Wrapper to turn the brake off
		require
			object_exists: obj /= default_pointer
		external
			"C++ inline use %"NXT++.h%""
		alias
			"[
			NXT::Motor::BrakeOff ((Comm::NXTComm *) $obj, (int) $a_port);
			]"
		end

invariant

	is_attached_implication: is_attached implies nxt.index_of_motor (Current) = port

	speed_large_enough: speed >= Minimum_speed
	speed_small_enough: speed <= Maximum_speed


end
