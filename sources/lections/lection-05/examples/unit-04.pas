{
	Библиотека работы с комплексными числами

	version 0.2
}
unit Complex;

interface
	type
		//тип данных для хранения вещественной и мнимой части
		TСElem = real;
		
		//форма вывода комплексного числа
		TCOutputForm = (cofAlg, cofExp, cofTrg);

		//структура данных для работы с комплексными числами
		TComplex = record
			Re, //вещественная часть
			Im: TСElem; //мнимая часть
		end;
	const
		//типизированные константы
		C_ZERO: TComplex = (Re:0; Im:0);
		C_ONE: TComplex = (Re:1; Im:0);
		C_IM_ONE: TComplex = (Re:0; Im:1);

		//точность представления, кол-во
		//  двочиных разрядов при выводе
		C_PR: byte = 2;
		C_DC: byte = C_PR + 2;

	//заголовки открытых процедур и функций
	procedure Init(Re, Im: TСElem; var A: TComplex);

	//сложение
	procedure Add(const A, B: TComplex; var C: TComplex); 

	//вычитание
	procedure Sub(const A, B: TComplex; var C: TComplex); 

	//умножение
	procedure Mul(const A, B: TComplex; var C: TComplex); 

	//деление
	procedure Div(const A, B: TComplex; var C: TComplex); 

	//получение сопряженного числа
	procedure Conj(const A: TComplex; var B: TComplex); 

	//получение действительной части
	function GetRe(const A: TComplex): TCElem;
	//получение мнимой части
	function GetIm(const A: TComplex): TCElem;

	//получение модуля
	function GetModule(const A: TComplex): TCElem;

	//получение аргумента
	function GetArgument(const A: TComplex): TCElem;

	//вывод комплексного числа
	procedure Out(const A: TComplex);

	//установка формы вывода по умолчанию
	procedure SetDefaultForm(aForm: TCOutputForm);

	//формирование представления в виде строки
	function CToString(const A: TComplex): string;

	//формирование представления в виде строки в заданной форме
	function CToStringForm(const A: TComplex; aForm: TCOutputForm): string;

	//получение признака ошибки вычислений
	function CGetError:integer;

	//установка признака ошибки вычислений
	function CSetError(aError: integer):integer;

	//сброс признака ошибки вычислений
	procedure CClearError;

	//расшифровка кода ошибки
	function GetErrorMessage:string;

implementation
	const
		//константа для разделения дробной и целой части
		DELIMITER = ',';
		OUT_FORM : TCOutputForm = cofAlg;
		EPS = 1e-6;

	var
		iCError: integer;

	//реализация открытых процедур и функций
	
	//do: инициализаия полей переменной комлексного типа
	//	  значениями Re, Im
	//in:
	//	Re - вещественная часть
	//  Im - мнимая часть
	//out: 
	//	A - комплексное число (Re, Im)
	procedure Init(Re, Im: TСElem; var A: TComplex);
	begin
		A.Re := Re;
		A.Im := Im;
	end;

	//do: получение суммы комплексных чисел
	//in:
	//	A, B - слагаемые
	//out: 
	//	С - сумма A+B
	procedure Add(const A, B: TComplex; var C: TComplex);
	begin
		C.Re := A.Re + B.Re;
		C.Im := A.Im + B.Im;
	end;

	//do: получение разности комплексных чисел
	//in:
	//	A - уменьшаемое
	//  B - вычитаемое
	//out: 
	//	С - разность A - B
	procedure Sub(const A, B: TComplex; var C: TComplex); 
	begin
		C.Re := A.Re - B.Re;
		C.Im := A.Im - B.Im;
	end;

	//do: получение произведения комплексных чисел
	//in:
	//	A, B - множители
	//out: 
	//	С - разность A - B
	procedure Mul(const A, B: TComplex; var C: TComplex); //умножение
	begin
		C.Re := A.Re * B.Re - A.Im * B.Im;
		C.Im := A.Re * B.Im + A.Im * B.Re;
	end;

	//do: получение частного комплексных чисел
	//in:
	//	A - делимое
	//  B - делитель. B <> (0, 0)
	//out: 
	//	С - частное A / B
	procedure Div(const A, B: TComplex; var C: TComplex);
	var
		d: TCElem;
	begin
		d := B.Re * B.Re + B.Im * B.Im;

		C.Re := (A.Re * B.Re + A.Im * B.Im) / d;
		C.Im := (A.Im * B.Re - A.Re * B.Im) / d;
	end;	

	//do: получение сопряженного числа	
	//in:
	//	A - число
	//out: 
	//	B - число, сопряженное A
	procedure Conj(const A: TComplex; var B: TComplex); 
	begin
		B.Re := A.Re;
		B.Im := - A.Im;
	end;

	//получение действительной и мнимой частей

	//do: получение вещественной части числа	
	//in:
	//	A - комплекксное число
	//out: 
	//	GetRe - вещественная часть A
	function GetRe(const A: TComplex): TCElem;
	begin
		GetRe := A.Re;
	end;

	//do: получение вещественной части числа	
	//in:
	//	A - комплекксное число
	//out: 
	//	GetRe - вещественная часть A	
	function GetIm(const A: TComplex): TCElem;
	begin
		GetIm := A.Im;
	end;

	//получение модуля и аргумента
	function GetModule(const A: TComplex): TCElem;
	begin
		GetModule := sqrt(A.Re*A.Re + A.Im*A.Im);
	end;

	function GetArgument(const A: TComplex): TCElem;
	begin
		if (abs(A.Re) <EPS) AND (abs(A.Im) <EPS) then
		begin
			GetArgument := 0;

			CSetError(-2);
		end;
		//...
	end;

	//вывод комплексного числа
	//do: вывод комплексного числа в форме OUT_FORM
	//in:
	//	A - комплекксное число
	//out: none	
	procedure Out(const A: TComplex);
	begin
		OutForm(A, OUT_FORM);
	end;
	
	//do: вывод комплексного числа в заданной форме
	//in:
	//	A - комплекксное число
	//  aForm - форма вывода, TCOutputForm
	//		cofAlg - алгебраическая (12.13 ; 90.00)
	//		cofExp - экспоненциальная форма (4.56*exp(4.12i))
	// 		cofTrg - тригонометрическая форма (4.76(cos(4.12)+i sin(4.12)));
	//out: none
	procedure OutForm(const A: TComplex; aForm: TCOutputForm);
	begin
		writeln(CToStringForm(A, aForm));
	end;

	//do: установка формы вывода комплексного числа по-умолчанию
	//in:
	//  aForm - форма вывода, TCOutputForm
	//		cofAlg - алгебраическая (12.13 ; 90.00)
	//		cofExp - экспоненциальная форма (4.56*exp(4.12i))
	// 		cofTrg - тригонометрическая форма (4.76(cos(4.12)+i sin(4.12)));
	//out: none
	procedure SetDefaultForm(aForm: TCOutputForm);
	begin
		OUT_FORM := aForm;	
	end;

	//do: формирование представления в виде строки в заданной форме
	//in:
	//	A - комплекксное число
	//  aForm - форма вывода, TCOutputForm
	//		cofAlg - алгебраическая (12.13 ; 90.00)
	//		cofExp - экспоненциальная форма (4.56*exp(4.12i))
	// 		cofTrg - тригонометрическая форма (4.76(cos(4.12)+i sin(4.12)));
	//out: none	
	function CToStringForm(const A: TComplex; aForm: TCOutputForm): string;
	var
		s, s1, s2: string;
		ar, md: TCElem;
	begin
		if OUT_FORM in [cofExp, cofTrg] then
		begin
			ar := GetModule(A);
			md := GetArgument(A);

			Str(md:C_DC:C_PR, s1);
			Str(ar:C_DC:C_PR, s2);
		end 
		else
		begin
			Str(A.Re:C_DC:C_PR, s1);
			Str(A.Im:C_DC:C_PR, s2);
		end;

		case OUT_FORM of
			cofAlg: s := '(' + s1 + ',' + s2 + ')';
			cofExp: s := s1 + '*exp(' + s2 + 'i)';
			cofTrg: s := s1 + '*(cos(' + s2 + ') + i sin(' + s2 + ')';
		end;

		CToStringForm := s;
	end;

	//do: формирование представления в виде строки
	//in:
	//	A - комплекксное число
	//out: none	
	function CToString(const A: TComplex): string;
	begin
		CToString := CToStringForm(A, OUT_FORM);
	end;

	//do: получение признака ошибки вычислений
	//in: - 
	//out: код ошибки, iCError 	
	function CGetError:integer;
	begin
		CGetError := iCError;
	end;

	//do: установка признака ошибки вычислений
	//in:
	//	aError - код ошибки 
	//out: 
	//	CGetError - код текущей ошибки
	function CSetError(aError: integer):integer;
	begin
		CSetError := CGetError;

		iCError := aError;
	end;

	//сброс признака ошибки вычислений
	procedure CClearError;
	begin
		iCError := 0;
	end;

	//расшифровка кода ошибки
	function CGetErrorMessage:string;
	var
		msg: string;
	begin
		case CGetError of
			 0: msg := '';
			-1: msg := 'Деление на ноль';
			-2: msg := 'Аргумент числа не определен';
			else
				msg := 'Неизвестная ошибка';			
		end;

		CGetErrorMessage := msg;
	end;

begin
	iCError := 0;
end. 	
