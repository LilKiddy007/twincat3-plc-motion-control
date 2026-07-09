/* Variable declaration code */

PROGRAM MAIN
VAR
	Axis : AXIS_REF;
	
	fbPower : MC_Power;
	fbVel : MC_MoveVelocity;
	fbStop : MC_Stop;
	fbHalt : MC_Halt;
	
	Timer : TON;	
	
	timevalue : TIME;
	Deceleration: LREAL;
	dir: MC_Direction;
	velvalue: LREAL;
	decvalue: LREAL;
	
	Slow : LREAL := 300;
	Fast : LREAL := 1000;

	Step : INT := 0;
	Cyclecount : INT := 0;

 	execute_vel : BOOL;
	execute_halt : BOOL;
	bStop : BOOL;
	T : BOOL;

 	Tdone : BOOL;
	
END_VAR


/* Implemtation code */

fbPower(Axis := Axis, Enable := TRUE, Enable_Negative := TRUE, Enable_Positive := TRUE);
fbVel(Axis := Axis, Execute := execute_vel, velocity := velvalue, Direction := dir);
fbHalt(Axis := Axis, Execute := execute_halt, Deceleration := decvalue);
Timer(IN := T, PT := timevalue);
fbStop(Axis := Axis, Execute := bStop);
Tdone := Timer.Q;

CASE Step OF
		
	0:
		IF fbPower.Status THEN
		dir := MC_Positive_Direction;
		velvalue:= slow;
		execute_vel := TRUE;
		T := TRUE;
		timevalue := T#5S;
		END_IF
		IF Tdone THEN
			decvalue:= slow;
			execute_halt := TRUE;
			execute_vel := FALSE;
			T := FALSE;
			Step := 1;
		END_IF
		
		
	1:
		dir := MC_Negative_Direction;
		velvalue:= slow;
		execute_vel := TRUE;
		execute_halt := FALSE;
		T := TRUE;
		timevalue := T#5S;
		IF Tdone THEN
			decvalue:= slow;
			execute_halt := TRUE;
			execute_vel := FALSE;
			T := FALSE;
			Step := 2;
		END_IF
		
		
	2:
		dir := MC_Positive_Direction;
		velvalue:= fast;
		execute_vel := TRUE;
		execute_halt := FALSE;
		T := TRUE;
		timevalue := T#7S;
		IF Tdone THEN
			decvalue:= fast;
			execute_halt := TRUE;
			execute_vel := FALSE;
			T := FALSE;
			Cyclecount := Cyclecount + 1;
			IF Cyclecount < 3 THEN
				Step := 0;
			ELSE
				Step := 3;
			END_IF
		END_IF

						
		
		
	3:
		bStop := TRUE;


				
		
END_CASE

bStop := FALSE;