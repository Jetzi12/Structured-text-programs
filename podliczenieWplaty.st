(* created by  GEB Automation IDE v3.2.15.107, 2020-06-08 *)
(* Wojciech Bąba, Jerzy Cal, Michał Wiecha, AGH Kraków *)
// Systemy mikrokomputerowe 2020
FUNCTION_BLOCK podliczenieWplaty 
	VAR
		i : INT;
		stanPrzycisku : S5BOOL;
		ArrSt1_1 : S5BOOL;
		ArrWy : S5BOOL;

	END_VAR
	VAR_INPUT
		ArrWe : S5BOOL;
		reset : BOOL;
	END_VAR
	VAR_OUTPUT
		output2 : S5BYTE; 
	END_VAR
	
IF reset THEN
	 FOR i := 1 TO 5 BY 1 DO
	output2[i] := 0;
	END_FOR;
END_IF;
	
	// Detekcja 
 FOR i := 1 TO 5 BY 1 DO

	IF ArrWe[i] AND NOT ArrSt1_1[i] AND NOT stanPrzycisku[i] THEN
		stanPrzycisku[i] := TRUE;
		ArrSt1_1[i] := ArrWe[i];
		
		
		IF ArrWe[1] AND NOT ArrWe[2] AND NOT ArrWe[3] AND NOT ArrWe[4] AND NOT ArrWe[5] THEN
			output2 [1] := output2 [1] + 1;
		END_IF;

		IF NOT ArrWe[1] AND ArrWe[2] AND NOT ArrWe[3] AND NOT ArrWe[4] AND NOT ArrWe[5] THEN
			output2 [2] := output2 [2] + 1;
		END_IF;
		
		
		IF NOT ArrWe[1] AND NOT ArrWe[2] AND ArrWe[3] AND NOT ArrWe[4] AND NOT ArrWe[5]  THEN
			output2 [3] := output2 [3] + 1;
		END_IF;
		
		IF NOT ArrWe[1] AND NOT ArrWe[2] AND NOT ArrWe[3] AND ArrWe[4] AND NOT ArrWe[5]  THEN
			output2 [4] := output2 [4] + 1;
		END_IF;

		IF NOT ArrWe[1] AND NOT ArrWe[2] AND NOT ArrWe[3] AND NOT ArrWe[4] AND ArrWe[5]  THEN
			output2 [5] := output2 [5] + 1;
		END_IF;

	
	END_IF;
		
	IF NOT ArrWe[i] AND ArrSt1_1[i] AND stanPrzycisku[i] THEN
		stanPrzycisku[i] := FALSE;
		ArrSt1_1[i] := ArrWe[i];
	END_IF;
END_FOR;
	
END_FUNCTION_BLOCK
