(* created by  GEB Automation IDE v3.2.15.107, 2020-06-08 *)
(* Wojciech Bąba, Jerzy Cal, Michał Wiecha, AGH Kraków *)
// Systemy mikrokomputerowe 2020

PROGRAM Automat 

	TYPE
		S3BYTE: ARRAY[1..5] OF BYTE;
		S5BOOL: ARRAY[1..5] OF BOOL;
		S5BYTE: ARRAY[1..5] OF BYTE;
		S5BYTE1: ARRAY[1..5] OF BYTE  := [11,5,19,15,29]; // ceny towarów
		S5BYTE2: ARRAY[1..5] OF BYTE  := [0,9,0,0,5];  // ilość nominałów

		
	END_TYPE
	
	VAR_GLOBAL
// WEJSCIA
	// wybór towaru
 		WE1  AT %IXWETowar01 : BOOL; // Towar1
		WE2  AT %IXWETowar02 : BOOL; // Towar2
		WE3  AT %IXWETowar03 : BOOL; // Towar3
		WE4  AT %IXWETowar04 : BOOL; // Towar4
		WE5  AT %IXWETowar05 : BOOL; // Towar5
	
	// wpłata gotówki
		WE6  AT %IXWEDoDdwaDZ06 : BOOL; // Gotówka 20zł
		WE7  AT %IXWEDoddz07 : BOOL; // Gotówka 10zł
		WE8  AT %IXWEdodpie08 : BOOL; // Gotówka  5zł
		WE9  AT %IXWEdoddwa09 : BOOL; // Gotówka  2zł
		WE10 AT %IXWEdodjeden10 : BOOL; // Gotówka  1zł
	
	// przerwanie transakcji
		WE11 AT %IXWErezygnacja11 : BOOL; // przerwanie transakcji	
	// zadziałanie czujnika
		WE12 AT %IXWEczujnik12 : BOOL; // przerwanie transakcji	
	END_VAR

	VAR_GLOBAL	
// WYJŚCIA
	// wybrany towar
		WY1  AT %QXTowar01 : BOOL; // wybrano Towar1
		WY2  AT %QXTowar02 : BOOL; // wybrano Towar2
		WY3  AT %QXTowar03 : BOOL; // wybrano Towar3
		WY4  AT %QXTowar04 : BOOL; // wybrano Towar4
		WY5  AT %QXTowar05 : BOOL; // wybrano Towar5
	
	// brak miejsca
		WY6  AT %QXDWDZ06 : BOOL; // brak miejsca na 20zł
		WY7  AT %QXDz07 : BOOL; // brak miejsca na 10zł
		WY8  AT %QXPie08 : BOOL; // brak miejsca na  5zł
		WY9  AT %QXdwa09 : BOOL; // brak miejsca na  2zł
		WY10 AT %QXjeden10 : BOOL; // brak miejsca na  1zł
	
	// brak mozliwości wydana reszty
		WY11 AT %QXNiemoznawydac11 : BOOL; // brak mozliwości wydania reszty
	
		
		
	//ilość gotówki w automacie
		WYA1 AT %QBIloscDWDZ01 : BYTE; // ilość banknotów 20zł
		WYA2 AT %QBIloscDZ02 : BYTE; // ilość banknotów 10zł
		WYA3 AT %QBIloscPie03 : BYTE; // ilość monet 5zł
		WYA4 AT %QBIloscDwa04 : BYTE; // ilość monet 2zł
		WYA5 AT %QBIloscDWjeden05 : BYTE; // ilość monet 1zł
	
	// zapłata i reszta
		WYA6 AT  %QBCenaTOW06 : BYTE; // cena wybranego towaru w zł
		WYA7 AT  %QBWPLata07 : BYTE; // kwota wpłaty zł
		WYA8 AT  %QBReszta08 : BYTE; // kwota reszty w zł
		
		WYA9  AT  %QBresztaPia09 : BYTE; // ilość sztuk monet w reszcie 5zł
		WYA10 AT  %QBresztadwa10 : BYTE; // reeszta ilość sztuk monet 2zł
		WYA11 AT  %QBresztajeden11 : BYTE; // reeszta ilość sztuk monet 1zł
		
	//WYA12 AT  %QB12 : BYTE; // obecnie wybrany towar
	//WYA13 AT  %QB13 : BYTE; // poprzednio wybrany towar
	END_VAR
	
	VAR
	numerWybranegoTowaru : INT;
	numerWybranegoTowaru_1 : INT; //numer poprzedniego towaru do rozróżnienia następnej transakcji
	
	wejsciaTowarow : S5BOOL;
	wyjsciaTowarow : S5BOOL;
	wyjsciaTowarowMiganie : S5BOOL; //wektory wartosci logicznych z wejsc towarow
	
	pelnyKlik_1_5 : pelnyClick; //deklaracja funkcji obsługującej wybór towaru 
	
	podliczenieWplaty : podliczenieWplaty; //blok funkcyjny podliczający 
										   //wartość wpłaconych nominałów
	
	//podliczenieNominalow : podliczenieNominalow;//blok funkcyjny podliczający 
										   		//wartość wpłaconych nominałów
	
	iloscNominalow : S5BYTE2;
	iloscNominalow2 : S5BYTE2;
	iloscNominalowPoWrzuceniu : S5BYTE2;	//wektory ilosci nominalow w różnych stadiach
	iloscNominalowPoReszcie : S5BYTE2;		//zakupu towaru
	
	nominalyKontrolna : S5BYTE2;	//wektor kontrolny aktualizowany przy zakończeniu transakcji
	
	
	wejsciaPieniazkow : S5BOOL;	//wektor wartosci logicznych obsługujący wejścia nominałów
	
	brakMiejsca : S5BOOL;//wektor wartosci logicznych braku miejsc w automacie na dane nominały
	
	reset : BOOL;			//wartosc logiczna resetujaca
	reset1 : BOOL := FALSE; //DLA RESZT
	
	tylkoRaz : BOOL;				 //Pomocnicze zmienne
	tylkoRaz2 : BOOL := FALSE;		 //
	tylkoRaz3 : BOOL := FALSE;		 //
	tylkoRaz4 : BOOL := FALSE;		 //
	i : INT;						 //
	reszta : BYTE;					 //
	koniec : BOOL := FALSE;			 //
	koniecReset : BOOL := FALSE;	 //
	przyjetoReszte : BOOL;			 //
	wyjscieMigania : BOOL;			 //
	miganie : BOOL;					 //
	restart : BOOL := FALSE;		 //
	rezygnacjaZKupna : BOOL := FALSE;//
	roznicaWNominalach : S5BYTE2;	 //
	iloscWplaconychNominalow : S5BYTE;//
	
	czyDaSieWydac : BOOL := FALSE;  //wartosc logiczna obsługująca możliwość wydania reszty
	
	nominalyReszty : S5BYTE;		//wektor nominałów reszty
	
	timer1 : TON; //Timery
	timer2 : TON;
	timer3 : TON;
	timer4 : TON;
	
	END_VAR

	//Resetowanie parametrów w przypadku nowego zakupu 
IF WE11 OR WE12 OR restart THEN
	reset := TRUE;
	reset1 := TRUE;
	tylkoRaz := TRUE;
	czyDaSieWydac := FALSE;
	miganie := FALSE;
	restart := FALSE;
	WYA6 := 0;
ELSE 
	miganie := TRUE;
	reset := FALSE;

END_IF;



	// Pobieranie wejść towarów
	wejsciaTowarow[1] := WE1;
	wejsciaTowarow[2] := WE2; 
	wejsciaTowarow[3] := WE3;
	wejsciaTowarow[4] := WE4;
	wejsciaTowarow[5] := WE5;
	
	
	// Wyświetlanie wybranego towaru dopóki nie zostały wrzucone żadne nominały
	IF WYA7=0 THEN
		pelnyKlik_1_5(reset := reset, ArrWe := wejsciaTowarow, ArrWy => wyjsciaTowarow);
		WY1 := wyjsciaTowarow[1];
		WY2 := wyjsciaTowarow[2];
		WY3 := wyjsciaTowarow[3];
		WY4 := wyjsciaTowarow[4];
		WY5 := wyjsciaTowarow[5];
		
		IF NOT reset THEN //żeby przepisało poprzednią wartość
			szukanieWTablicy(wyjsciaTowarow := wyjsciaTowarow, numerWybranegoTowaru => numerWybranegoTowaru);
		END_IF;
	END_IF;
	
	// Zapamiętywanie numeru poprzedniego towaru w celu pomocy w odróżnieniu kolejnego zakupu
	
	IF numerWybranegoTowaru <> 0 AND numerWybranegoTowaru <> numerWybranegoTowaru_1 AND reset THEN
		numerWybranegoTowaru_1 := numerWybranegoTowaru;
	
	END_IF;
	
	
//WYA12 := INT_TO_BYTE(numerWybranegoTowaru);
//WYA13 := INT_TO_BYTE(numerWybranegoTowaru_1);


	//Obsługa wyświetlania ceny towaru oraz wydawania towaru gdy została wrzucona odpowiednia kwota
	
	IF WYA7 >= WYA6 AND miganie AND NOT czyDaSieWydac AND WYA7 <> 0 THEN
		miganie := TRUE;
	ELSE
		wyborCenyTowaru(wyjsciaTowarow := wyjsciaTowarow, cena => WYA6 );
	END_IF;
	
	//===================================================================================================================================================
	// Obsługa podliczania wpłaty oraz ilości nominałów w automacie
	
	wejsciaPieniazkow[1] := WE6;
	wejsciaPieniazkow[2] := WE7;
	wejsciaPieniazkow[3] := WE8;
	wejsciaPieniazkow[4] := WE9;
	wejsciaPieniazkow[5] := WE10;
	
	//Gdy jest za dużo nominalów, nie pozwala wpłacić kolejnego
	IF WYA1 >= 10 THEN  
	wejsciaPieniazkow[1] := FALSE;
	WY6 := TRUE;
	ELSE
	WY6 := FALSE;
	END_IF;
	IF WYA2 >= 10 THEN  
	wejsciaPieniazkow[2] := FALSE;
	WY7 := TRUE;
	ELSE
	WY7 := FALSE;
	END_IF;
	IF WYA3 >= 15 THEN  
	wejsciaPieniazkow[3] := FALSE;
	WY8 := TRUE;
	ELSE
	WY8 := FALSE;
	END_IF;
	IF WYA4 >= 20 THEN  
	wejsciaPieniazkow[4] := FALSE;
	WY9 := TRUE;
	ELSE
	WY9 := FALSE;
	END_IF;
	IF WYA1 >= 25 THEN  
	wejsciaPieniazkow[5] := FALSE;
	WY10 := TRUE;
	ELSE
	WY10 := FALSE;
	END_IF;
	
	
	//Podliczanie ilości wpłaconych nominałów dopóki wpłata jest mniejsza od ceny
	
	IF NOT reset AND WYA7 < WYA6 THEN
	podliczenieWplaty(reset := reset, ArrWe := wejsciaPieniazkow, output2 => iloscWplaconychNominalow );
	END_IF;
	
	
	//Przypisanie wartości nominałów!!!!!!!!!!!!!!!(DODAĆ - RESZTA)
	IF WE12 AND NOT WE11 THEN
	iloscNominalow[1] := iloscNominalow[1] + iloscWplaconychNominalow[1];
	iloscNominalow[2] := iloscNominalow[2] + iloscWplaconychNominalow[2];
	iloscNominalow[3] := iloscNominalow[3] + iloscWplaconychNominalow[3]-nominalyReszty[1];
	iloscNominalow[4] := iloscNominalow[4] + iloscWplaconychNominalow[4]-nominalyReszty[2];
	iloscNominalow[5] := iloscNominalow[5] + iloscWplaconychNominalow[5]-nominalyReszty[3];
	END_IF;
	
	
	//Podczas resetu wykonanie dla pustego wektora dla wyczyszczenia pamięci
	IF reset THEN
	wejsciaPieniazkow[1] := FALSE;
	wejsciaPieniazkow[2] := FALSE;
	wejsciaPieniazkow[3] := FALSE;
	wejsciaPieniazkow[4] := FALSE;
	wejsciaPieniazkow[5] := FALSE;
	podliczenieWplaty(reset := reset, ArrWe := wejsciaPieniazkow, output2 => iloscWplaconychNominalow );
	WYA7 := 0;
	WYA6 := 0; 
	END_IF;
	
	//Wyświetlanie wpłaty na żywo
	WYA7 := iloscWplaconychNominalow[1] * 20 + iloscWplaconychNominalow[2] * 10 + iloscWplaconychNominalow[3] * 5 + iloscWplaconychNominalow[4]*2 + iloscWplaconychNominalow[5]*1;

	//======================================================================================================
	//======================================================================================================
	//Zerowanie wyswietleń nominałów przy wybraniu następnego towaru w następnej transakcji
	IF WYA6 <> 0 AND tylkoRaz THEN
	tylkoRaz := FALSE;
	WYA8 := 0;
	WYA9 := 0;
	WYA10 := 0;
	WYA11 := 0;
	END_IF;
	
	// Zerowanie wartości reszt
	IF reset OR czyDaSieWydac THEN
	nominalyReszty[1] := 0;
	nominalyReszty[2] := 0;
	nominalyReszty[3] := 0;
	reszta := 0;
	IF czyDaSieWydac THEN
	WYA8 := 0;
	WYA9 := 0;
	WYA10 := 0;
	WYA11 := 0;
	END_IF;
	END_IF;
	
	//Podliczanie reszty oraz sprawdzenie możliwości jej wydania
	IF WYA7 > 0 AND WYA7 > WYA6 AND NOT czyDaSieWydac THEN
	
		reszta := WYA7 - WYA6;
		WYA8 := reszta;
		
		resztaW5(reset:=reset, reszta:=reszta, ilosc5 => nominalyReszty[1]);
		
		IF nominalyReszty[1] > (iloscNominalow[3] + iloscWplaconychNominalow[3]) THEN
			nominalyReszty[1] := iloscNominalow[3] + iloscWplaconychNominalow[3];
		END_IF;
		WYA9 := nominalyReszty[1];
		
		resztaW2(reset:=reset, a := nominalyReszty[1], reszta:=reszta, ilosc2 => nominalyReszty[2]);
		IF nominalyReszty[2] > (iloscNominalow[4] + iloscWplaconychNominalow[4]) THEN
			nominalyReszty[2] := iloscNominalow[4] + iloscWplaconychNominalow[4];
		END_IF;
		WYA10 := nominalyReszty[2];
		
		resztaW1(reset:=reset, a := nominalyReszty[1],b := nominalyReszty[2], reszta:=reszta, ilosc1 => nominalyReszty[3]);
	
		IF nominalyReszty[3] > (iloscNominalow[5] + iloscWplaconychNominalow[5]) THEN
			IF nominalyReszty[3] <> 0 THEN
				czyDaSieWydac := TRUE;//JEŚLI TRUE TO SIE NIE DA
			END_IF;
		END_IF;
		WYA11 := nominalyReszty[3];
		END_IF;
		

		//Wyświetlanie nominałow na żywo
		IF NOT czyDaSieWydac THEN
			WYA1 := iloscNominalow[1] + iloscWplaconychNominalow[1];
			WYA2 := iloscNominalow[2] + iloscWplaconychNominalow[2];
			WYA3 := iloscNominalow[3] + iloscWplaconychNominalow[3]-nominalyReszty[1];
			WYA4 := iloscNominalow[4] + iloscWplaconychNominalow[4]-nominalyReszty[2];
			WYA5 := iloscNominalow[5] + iloscWplaconychNominalow[5]-nominalyReszty[3];
		END_IF;
	
	//Gdy nie da się wydać reszty miga wyjściem 11
	IF czyDaSieWydac THEN
		timer1.PT :=T#500ms;
		timer2.PT :=T#4s;
		timer1();
		timer2();
		IF timer1.Q AND NOT timer2.Q THEN
			timer1.IN :=FALSE;
			WY11 := NOT WY11;
		ELSE
			timer1.IN :=TRUE;
			timer2.IN :=TRUE;
		END_IF;
		
		IF timer2.Q THEN
			WY11 := FALSE;
		restart := TRUE;
		END_IF;
		
		ELSE
	timer1.IN :=FALSE;
	timer2.IN :=FALSE;
	END_IF;
	
	//Gdy wszystko przebiegnie dobrze następuje wydanie towaru
	IF NOT czyDaSieWydac AND WYA7 >= WYA6 AND WYA7 <> 0 THEN
		timer3.PT :=T#500ms;
		timer3();
		IF timer3.Q  THEN
			timer3.IN :=FALSE;
			wyjsciaTowarow[numerWybranegoTowaru] := NOT wyjsciaTowarow[numerWybranegoTowaru];
			WY1 := wyjsciaTowarow[1]; 					
	 		WY2 := wyjsciaTowarow[2]; 					 
	 		WY3 := wyjsciaTowarow[3]; 					
	 		WY4 := wyjsciaTowarow[4];
	 		WY5 := wyjsciaTowarow[5];
		ELSE
			timer3.IN :=TRUE;
		END_IF;
	ELSE
		timer3.IN :=FALSE;
	END_IF;
	
END_PROGRAM
