﻿&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьМесяцы()
	
	СЗ = Новый СписокЗначений;
	
	Для НомерМесяца = 1 По 12 Цикл
		ТекДата = Дата(2000, НомерМесяца, 1);
		НаимМесяца = Формат(ТекДата, "ДФ=MMMM");
		СЗ.Добавить(НомерМесяца, НаимМесяца);
	КонецЦикла; 
	
	Возврат СЗ;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьДниНедели()
	
	СЗ = Новый СписокЗначений;
	СЗ.Добавить(1, "понедельник");
	СЗ.Добавить(2, "вторник");
	СЗ.Добавить(3, "среда");
	СЗ.Добавить(4, "четверг");
	СЗ.Добавить(5, "пятница");
	СЗ.Добавить(6, "суббота");
	СЗ.Добавить(7, "воскресенье");
	
	Возврат СЗ;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьНомераНедель()
	
	СЗ = Новый СписокЗначений;
	СЗ.Добавить(1, "1");
	СЗ.Добавить(2, "2");
	СЗ.Добавить(3, "3");
	СЗ.Добавить(4, "4");
	СЗ.Добавить(9, "последн.");
	
	Возврат СЗ;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Периодичность = Перечисления.ПериодичностьРебалансировки.Ежедневно;
		Объект.ЧислоПериодов = 1;
		Объект.ВариантВыбораДняМесяца = Перечисления.ВариантыВыбораДняМесяца.ЧислоМесяца;
		Объект.ДеньМесяца = 1;
		Объект.ДеньНедели = 1;
		Объект.НомерНедели = 1;
		Объект.МесяцГода = 1;
	КонецЕсли;
	
	Месяцы = ПолучитьМесяцы();
	Для Каждого ЭлемСЗ Из Месяцы Цикл
		Элементы.МесяцГодаДеньМесяца.СписокВыбора.Добавить(ЭлемСЗ.Значение, ЭлемСЗ.Представление);
		Элементы.МесяцГодаДеньНедели.СписокВыбора.Добавить(ЭлемСЗ.Значение, ЭлемСЗ.Представление);
	КонецЦикла; 
	
	ДниНедели = ПолучитьДниНедели();
	Для Каждого ЭлемСЗ Из ДниНедели Цикл
		Элементы.ДеньНеделиЕжемесячно.СписокВыбора.Добавить(ЭлемСЗ.Значение, ЭлемСЗ.Представление);
		Элементы.ДеньНеделиЕжегодно.СписокВыбора.Добавить(ЭлемСЗ.Значение, ЭлемСЗ.Представление);
	КонецЦикла;

	НомераНедель = ПолучитьНомераНедель();
	Для Каждого ЭлемСЗ Из НомераНедель Цикл
		Элементы.НомерНеделиЕжемесячно.СписокВыбора.Добавить(ЭлемСЗ.Значение, ЭлемСЗ.Представление);
		Элементы.НомерНеделиЕжегодно.СписокВыбора.Добавить(ЭлемСЗ.Значение, ЭлемСЗ.Представление);
	КонецЦикла;		
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодичностьПриИзменении(Элемент)
	
	УстановитьВидимость();
	
КонецПроцедуры


&НаКлиенте
Процедура УстановитьВидимость()
	
	Для Каждого ТекСтраница Из Элементы.ГруппаПараметрыПериода.ПодчиненныеЭлементы Цикл
		ТекСтраница.Видимость = Ложь;
	КонецЦикла;
	//Элементы[Строка(Объект.Периодичность)].Видимость = Истина;	
	
	Если Объект.Периодичность = ПредопределенноеЗначение("Перечисление.ПериодичностьРебалансировки.Ежедневно") Тогда
		Элементы.Ежедневно.Видимость = Истина;
	ИначеЕсли Объект.Периодичность = ПредопределенноеЗначение("Перечисление.ПериодичностьРебалансировки.Ежемесячно") Тогда
		Элементы.Ежемесячно.Видимость = Истина;
		ВыбранВариантЧислоМесяца = (Объект.ВариантВыбораДняМесяца = ПредопределенноеЗначение("Перечисление.ВариантыВыбораДняМесяца.ЧислоМесяца"));
		Элементы.ГруппаЕжемесячноДеньМесяца.Видимость = ВыбранВариантЧислоМесяца;
		Элементы.ГруппаЕжемесячноДеньНедели.Видимость = (НЕ ВыбранВариантЧислоМесяца);
	ИначеЕсли Объект.Периодичность = ПредопределенноеЗначение("Перечисление.ПериодичностьРебалансировки.Ежегодно") Тогда
		Элементы.Ежегодно.Видимость = Истина;
		ВыбранВариантЧислоМесяца = (Объект.ВариантВыбораДняМесяца = ПредопределенноеЗначение("Перечисление.ВариантыВыбораДняМесяца.ЧислоМесяца"));
		Элементы.ГруппаЕжегодноДеньМесяца.Видимость = ВыбранВариантЧислоМесяца;
		Элементы.ГруппаЕжегодноДеньНедели.Видимость = (НЕ ВыбранВариантЧислоМесяца);
	КонецЕсли; 
	
КонецПроцедуры


&НаКлиенте
Процедура ВариантВыбораДняМесяцаПриИзменении(Элемент)
	
	УстановитьВидимость();
	
КонецПроцедуры


&НаКлиенте
Процедура ВариантВыбораДняМесяцаГодаПриИзменении(Элемент)
	
	УстановитьВидимость();
	
КонецПроцедуры

