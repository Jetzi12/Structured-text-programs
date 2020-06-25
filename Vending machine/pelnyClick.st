(* created by  GEB Automation IDE v3.2.15.107, 2020-06-08 *)
(* Wojciech Bąba, Jerzy Cal, Michał Wiecha, AGH Kraków *)
// Systemy mikrokomputerowe 2020
FUNCTION_BLOCK pelnyClick 
	VAR
		i : INT;
		stanPrzycisku : S5BOOL;
		ArrSt1_1 : S5BOOL;

	END_VAR
	
	VAR_INPUT
		ArrWe : S5BOOL;
		reset : BOOL;
	END_VAR
	
	VAR_OUTPUT
		ArrWy : S5BOOL;
	END_VAR
	
	//zresetowanie zmiennych wewnętrznych, niekoniecznie potrzebne
	
	IF reset THEN 
	FOR i := 1 TO 5 BY 1 DO
	stanPrzycisku[i] := FALSE;
	ArrSt1_1[i] := FALSE;
	ArrWy[i] := FALSE;
	END_FOR;
	END_IF;
	
	// przeglądanie wektora z wartosciami logicznymi wejsc i przy odpuszczeniu przycisku zaznaczenie bądź odznaczenie wyboru
		FOR i := 1 TO 5 BY 1 DO
		
			IF ArrWe[i] AND NOT ArrSt1_1[i] AND NOT stanPrzycisku[i] THEN
				stanPrzycisku[i] := TRUE;
				ArrSt1_1[i] := ArrWe[i];
			END_IF;
		
		IF NOT ArrWe[i] AND ArrSt1_1[i] AND stanPrzycisku[i] THEN
		stanPrzycisku[i] := FALSE;
		
			IF ArrWy[i] THEN
				ArrWy[i] := FALSE;
			ELSE
				ArrWy[1] := FALSE;		//Ograniczenie do jednego produktu
				ArrWy[2] := FALSE;		//Zerowanie wszystkich wejść a następnie ustawienie tylko jednego
				ArrWy[3] := FALSE;
				ArrWy[4] := FALSE;
				ArrWy[5] := FALSE;
		
				ArrWy[i] := TRUE;
			END_IF;
			
			ArrSt1_1[i] := ArrWe[i];
		END_IF;
		END_FOR;
END_FUNCTION_BLOCK
