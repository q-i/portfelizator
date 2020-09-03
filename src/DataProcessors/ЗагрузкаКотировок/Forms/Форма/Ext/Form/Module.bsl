﻿
&НаКлиентеНаСервереБезКонтекста
// Разбивает строку на несколько строк по разделителю. Разделитель может иметь любую длину.
//
// Параметры:
//  Строка                 - Строка - текст с разделителями;
//  Разделитель            - Строка - разделитель строк текста, минимум 1 символ;
//  ПропускатьПустыеСтроки - Булево - признак необходимости включения в результат пустых строк.
//    Если параметр не задан, то функция работает в режиме совместимости со своей предыдущей версией:
//     - для разделителя-пробела пустые строки не включаются в результат, для остальных разделителей пустые строки
//       включаются в результат.
//     - если параметр Строка не содержит значащих символов или не содержит ни одного символа (пустая строка), то в
//       случае разделителя-пробела результатом функции будет массив, содержащий одно значение "" (пустая строка), а
//       при других разделителях результатом функции будет пустой массив.
//  СокращатьНепечатаемыеСимволы - Булево - сокращать непечатаемые символы по краям каждой из найденных подстрок.
//
// Возвращаемое значение:
//  Массив - массив строк.
//
// Примеры:
//  РазложитьСтрокуВМассивПодстрок(",один,,два,", ",") - возвратит массив из 5 элементов, три из которых  - пустые
//  строки;
//  РазложитьСтрокуВМассивПодстрок(",один,,два,", ",", Истина) - возвратит массив из двух элементов;
//  РазложитьСтрокуВМассивПодстрок(" один   два  ", " ") - возвратит массив из двух элементов;
//  РазложитьСтрокуВМассивПодстрок("") - возвратит пустой массив;
//  РазложитьСтрокуВМассивПодстрок("",,Ложь) - возвратит массив с одним элементом "" (пустой строкой);
//  РазложитьСтрокуВМассивПодстрок("", " ") - возвратит массив с одним элементом "" (пустой строкой);
//
// Примечание:
//  В случаях, когда разделителем является строка из одного символа, и не используется параметр СокращатьНепечатаемыеСимволы,
//  рекомендуется использовать функцию платформы СтрРазделить.
Функция РазложитьСтрокуВМассивПодстрок(Знач Строка, Знач Разделитель = ",", Знач ПропускатьПустыеСтроки = Неопределено, СокращатьНепечатаемыеСимволы = Ложь) Экспорт
	
	Результат = Новый Массив;
	
	// Для обеспечения обратной совместимости.
	Если ПропускатьПустыеСтроки = Неопределено Тогда
		ПропускатьПустыеСтроки = ?(Разделитель = " ", Истина, Ложь);
		Если ПустаяСтрока(Строка) Тогда 
			Если Разделитель = " " Тогда
				Результат.Добавить("");
			КонецЕсли;
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	//
	
	Позиция = СтрНайти(Строка, Разделитель);
	Пока Позиция > 0 Цикл
		Подстрока = Лев(Строка, Позиция - 1);
		Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Подстрока) Тогда
			Если СокращатьНепечатаемыеСимволы Тогда
				Результат.Добавить(СокрЛП(Подстрока));
			Иначе
				Результат.Добавить(Подстрока);
			КонецЕсли;
		КонецЕсли;
		Строка = Сред(Строка, Позиция + СтрДлина(Разделитель));
		Позиция = СтрНайти(Строка, Разделитель);
	КонецЦикла;
	
	Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Строка) Тогда
		Если СокращатьНепечатаемыеСимволы Тогда
			Результат.Добавить(СокрЛП(Строка));
		Иначе
			Результат.Добавить(Строка);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции 

&НаКлиенте
Процедура Загрузить(Команда)
	
	ЗагрузитьНаСервере();
	
	ПоказатьОповещениеПользователя("Загрузка котировок завершена!");
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНаСервере()
	
	Дата1 = Период.ДатаНачала;
	Дата2 = Период.ДатаОкончания;
	
	МассивИдРежимовТоргов = РазложитьСтрокуВМассивПодстрок(ИдентификаторыРежимовТоргов);
	Если МассивИдРежимовТоргов.Количество() = 0 Тогда
		МассивИдРежимовТоргов = Новый Массив;
		МассивИдРежимовТоргов.Добавить("TQBR"); // Т+: Акции и ДР - безадрес.
	КонецЕсли;

	Для Каждого ИдРежимаТоргов Из МассивИдРежимовТоргов Цикл
		
		ПараметрыЗагрузки = Новый Структура;
		ПараметрыЗагрузки.Вставить("Дата1", Дата1);
		ПараметрыЗагрузки.Вставить("Дата2", Дата2);
		ПараметрыЗагрузки.Вставить("Тикер", Тикер);
		ПараметрыЗагрузки.Вставить("ИдРежимаТоргов", ИдРежимаТоргов);
		
		ТаблицаКотировок = ПолучитьТаблицуКотировок(ПараметрыЗагрузки);
		
		Если ТаблицаКотировок = Неопределено Тогда
			Сообщить("Не удалось получить котировки!");
			Возврат;
		КонецЕсли; 
		
		Для Каждого СтрокаТаблицыКотировок Из ТаблицаКотировок Цикл
			МЗ = РегистрыСведений.Котировки.СоздатьМенеджерЗаписи();
			МЗ.Период		= СтрокаТаблицыКотировок.Дата;
			МЗ.Тикер		= СтрокаТаблицыКотировок.Тикер;
			МЗ.Котировка	= СтрокаТаблицыКотировок.Цена;
			МЗ.Записать();
		КонецЦикла; 
		
	КонецЦикла; 
	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТаблицуКотировок(ПараметрыЗагрузки)
	
	ТаблицаКотировок = Новый ТаблицаЗначений;
	ТаблицаКотировок.Колонки.Добавить("Тикер");
	ТаблицаКотировок.Колонки.Добавить("Дата");
	ТаблицаКотировок.Колонки.Добавить("Цена");
	
	ПарамДата1 = ПараметрыЗагрузки.Дата1;
	ПарамДата2 = ПараметрыЗагрузки.Дата2;
	ПарамТикер = ПараметрыЗагрузки.Тикер;
	ПарамИдРежимаТоргов = ПараметрыЗагрузки.ИдРежимаТоргов;
	
	Сервер = "iss.moex.com";
	ИмяКолонкиЦенаЗакрытия = "LEGALCLOSEPRICE";
	
	АдресСтраницы = Неопределено;
	ПараметрыЗапросов = Новый Массив;
	
	Если ЗначениеЗаполнено(ПарамТикер) Тогда
		// КОТИРОВКИ ПО ВЫБРАННОМУ ТИКЕРУ
		// /iss/history/engines/[engine]/markets/[market]/boards/[board]/securities/[security]
		// (https://iss.moex.com/iss/reference/65)
		// TQBR(example):
		// http://iss.moex.com/iss/history/engines/stock/markets/shares/boards/tqbr/securities/GAZP?from=2020-08-01&till=2020-08-31
		
		АдресСтраницы = "/iss/history/engines/stock/markets/shares/boards/[ИдРежимаТоргов]/securities/[Тикер].json?from=[Дата1]&till=[Дата2]";
		
		Если Найти(",SNDX,RTSI,INAV,MMIX,", "," + ПарамИдРежимаТоргов + ",") > 0 Тогда
			// грязный хак для получения значений индексов
			АдресСтраницы = "/iss/history/engines/stock/markets/index/boards/[ИдРежимаТоргов]/securities/[Тикер].json?from=[Дата1]&till=[Дата2]";
			ИмяКолонкиЦенаЗакрытия = "CLOSE";
		КонецЕсли; 
		
		ЗначенияПараметров = Новый Соответствие;
		ЗначенияПараметров.Вставить("ИдРежимаТоргов", ПарамИдРежимаТоргов);
		ЗначенияПараметров.Вставить("ИмяКолонкиЦенаЗакрытия", ИмяКолонкиЦенаЗакрытия);
		ЗначенияПараметров.Вставить("Тикер", ПарамТикер);
		ЗначенияПараметров.Вставить("Дата1", Формат(ПарамДата1, "ДФ=yyyy-MM-dd"));
		ЗначенияПараметров.Вставить("Дата2", Формат(ПарамДата2, "ДФ=yyyy-MM-dd"));
		ПараметрыЗапросов.Добавить(ЗначенияПараметров);
		
	Иначе 
		// ВСЕ КОТИРОВКИ
		// /iss/history/engines/[engine]/markets/[market]/boards/[board]/securities
		// (https://iss.moex.com/iss/reference/64)
		// TQBR(example):
		// http://iss.moex.com/iss/history/engines/stock/markets/shares/boards/tqbr/securities?date=2020-08-03
		
		АдресСтраницы = "/iss/history/engines/stock/markets/shares/boards/[ИдРежимаТоргов]/securities.json?date=[ДатаКотировок]";
		
		Сутки = 24 * 60 * 60;
		
		ТекДата = ПарамДата1;
		Пока ТекДата <= ПарамДата2 Цикл
			
			ЗначенияПараметров = Новый Соответствие;
			ЗначенияПараметров.Вставить("ИдРежимаТоргов", ПарамИдРежимаТоргов);
			ЗначенияПараметров.Вставить("ИмяКолонкиЦенаЗакрытия", ИмяКолонкиЦенаЗакрытия);
			ЗначенияПараметров.Вставить("ДатаКотировок", Формат(ТекДата, "ДФ=yyyy-MM-dd"));
			ПараметрыЗапросов.Добавить(ЗначенияПараметров);
			
			ТекДата = ТекДата + Сутки;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если АдресСтраницы = Неопределено 
		Или ПараметрыЗапросов.Количество() = 0 Тогда
		ВызватьИсключение "ВНУТРЕННЯЯ ОШИБКА 2222! НЕ ЗАДАНЫ ЗНАЧЕНИЯ ОБЯЗАТЕЛЬНЫХ ПЕРЕМЕННЫХ!";
	КонецЕсли; 
	
	АдресСтраницы = АдресСтраницы + "&iss.meta=off"; // отключаем вывод мета-информации
	АдресСтраницы = АдресСтраницы + "&history.columns=TRADEDATE,SECID,[ИмяКолонкиЦенаЗакрытия]"; // выводим только нужные нам колонки
	АдресСтраницы = АдресСтраницы + "&iss.json=extended"; // используем расширенный формат json
	
	
	Для Каждого ЗначенияПараметров Из ПараметрыЗапросов Цикл
		
		ТекАдресСтраницы = АдресСтраницы;
		
		Для Каждого КлючИЗначение Из ЗначенияПараметров Цикл
			ТекАдресСтраницы = СтрЗаменить(ТекАдресСтраницы, "[" + КлючИЗначение.Ключ + "]", КлючИЗначение.Значение);
		КонецЦикла; 
		
		ЕстьСледующаяПорцияДанных = Истина;
		Старт = 0;
		Пока ЕстьСледующаяПорцияДанных Цикл
			
			ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
			
			ТекАдресСтраницы = ТекАдресСтраницы + ?(Старт > 0, "&start=" + Формат(Старт, "ЧГ="), "");
			
			HTTPСоединение = Новый HTTPСоединение(Сервер);
			HTTPЗапрос = Новый HTTPЗапрос(ТекАдресСтраницы);
			HTTPОтвет = HTTPСоединение.Получить(HTTPЗапрос, ИмяВременногоФайла);
			Если HTTPОтвет.КодСостояния <> 200 Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Сервер " + Сервер + " вернул код ошибки " + HTTPОтвет.КодСостояния);
				УдалитьФайлы(ИмяВременногоФайла);
				Возврат Неопределено;
			КонецЕсли;
			
			ЕстьСледующаяПорцияДанных = Ложь;
			КолвоПрочитано = 0;
			
			ЧтениеJSON = Новый ЧтениеJSON;
			ЧтениеJSON.ОткрытьФайл(ИмяВременногоФайла);
			ДокументJSON = ПрочитатьJSON(ЧтениеJSON, Истина);
			Для Каждого Раздел Из ДокументJSON Цикл
				history = Раздел.Получить("history");
				Если history = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				Для Каждого СтрокаТаблицы Из history Цикл
					ТекЦена = СтрокаТаблицы.Получить(ИмяКолонкиЦенаЗакрытия);
					Если ТекЦена <> Неопределено Тогда
						НоваяСтрока = ТаблицаКотировок.Добавить();
						НоваяСтрока.Тикер = СтрокаТаблицы.Получить("SECID");
						НоваяСтрока.Дата = ПрочитатьДатуJSON(СтрокаТаблицы.Получить("TRADEDATE"), ФорматДатыJSON.ISO);
						НоваяСтрока.Цена = ТекЦена;
					КонецЕсли; 
					КолвоПрочитано = КолвоПрочитано + 1;
				КонецЦикла;
				history_cursor = Раздел.Получить("history.cursor");
				Если history_cursor <> Неопределено Тогда
					hs_INDEX	= history_cursor[0].Получить("INDEX");
					hs_PAGESIZE	= history_cursor[0].Получить("PAGESIZE");
					hs_TOTAL	= history_cursor[0].Получить("TOTAL");
					ЕстьСледующаяПорцияДанных = ( (hs_INDEX + hs_PAGESIZE) < hs_TOTAL );
					Старт = Старт + hs_PAGESIZE;
				Иначе 
					ЕстьСледующаяПорцияДанных = (КолвоПрочитано > 0);
					Старт = Старт + КолвоПрочитано;
				КонецЕсли;
			КонецЦикла;
			
			ЧтениеJSON.Закрыть();
			
			УдалитьФайлы(ИмяВременногоФайла);
		
		КонецЦикла; 
		
	КонецЦикла;
	
	Возврат ТаблицаКотировок;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Период.ДатаНачала		= НачалоМесяца(ТекущаяДатаСеанса());
	Период.ДатаОкончания	= КонецМесяца(Период.ДатаНачала);
	
	ИдентификаторыРежимовТоргов = "SNDX,RTSI,TQBR,TQTF";
	СЗ = Элементы.ИдентификаторыРежимовТоргов.СписокВыбора;
	СЗ.Добавить("SNDX,RTSI,TQBR,TQTF", "Индексы, Акции, ETF");
	СЗ.Добавить("SNDX,RTSI", "Индексы");
	СЗ.Добавить("TQBR", "Акции");
	СЗ.Добавить("TQTF", "ETF");
	Для Каждого ЭлемСЗ Из СЗ Цикл
		ЭлемСЗ.Представление = ЭлемСЗ.Представление + " (" + ЭлемСЗ.Значение + ")";
	КонецЦикла; 
	
	МассивТикеров = ОбщегоНазначенияСервер.ПолучитьМассивТикеров();
	Элементы.Тикер.СписокВыбора.ЗагрузитьЗначения(МассивТикеров);
	
КонецПроцедуры



