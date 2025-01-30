note
	description	: "[
		Root class for MindStorms robot project.
	]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_mindstorms/trunk/tests/mindstorms_tester.e $"
	date:		"$Date: 2013-05-20 18:42:05 -0400 (Mon, 20 May 2013) $"
	revision:	"$Revision: 3 $"

class
	MINDSTORMS_TESTER

inherit

	NXT_CONSTANTS

create
	make

feature -- Initialization

	make
			-- Run application.
		do
			test
		end

feature

	test
			--
		local
			i: INTEGER
			c: INTEGER
			s: INTEGER
		do
			print ("MINDSTORMS_TESTER.test %N")
			create my_nxt
			create m1.make (my_nxt, port_a)
			create m2.make (my_nxt, port_b)
			create m3.make (my_nxt, port_c)

			create ts.make (port_1)
			create ls.make (port_2)
			create ss.make (port_3)
			create ds.make (port_4)
			my_nxt.attach_sensor (ts)
			my_nxt.attach_sensor (ls)
			my_nxt.attach_sensor (ss)
			my_nxt.attach_sensor (ds)

			my_nxt.connect_bluetooth
			if my_nxt.is_connected then
				print ("NXT connected %N")
				m1.set_speed (75)
				from i := 1
				until i > 6
				loop
					if ts.is_pressed then
						m1.run
					else
						if m1.is_running then
							c := c + 1
							if c \\ 2 = 0 then
								m1.set_reversed
							else
								m1.set_forward
							end
						end
						m1.stop
					end
					s := ss.value
					if s > 10 then
						print ("sound = " + s.out + "%N")
						print ("distance = " + ds.value.out + "%N")
					end
				end
			else
				print ("Unable to connect to NXT %N")
			end
			print ("MINDSTORMS_TESTER.test -- end %N")
		end

feature {NONE} -- Implementation

	my_nxt: NXT

	m1, m2, m3: MOTOR
	ts: TOUCH_SENSOR
	ss: SOUND_SENSOR
	ds: DISTANCE_SENSOR
	ls: LIGHT_SENSOR

end
