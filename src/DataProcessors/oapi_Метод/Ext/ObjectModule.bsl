﻿#Область ОписаниеПеременных

Перем ВариантыЗапросов;
Перем ПараметрыЗапроса;
Перем ВариантыОтветов;
Перем Теги;

#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область УправлениеСтруктуройМетода

// Добавляет в состав метода новый вариант ответа
//
// Параметры:
//  КодСостояния	- Строка	 - 200, 404 и т.п.
//  КраткоеОписание	- Строка	 - Текстовое описание метода
// 
// Возвращаемое значение:
//  oapi_ВариантОтвета - Ссылка на вариант ответа
//
Функция ДобавитьВариантОтвета(КодСостояния, КраткоеОписание = "") Экспорт
	
	Если Не ЗначениеЗаполнено(КодСостояния) Тогда
		ТекстОшибки = НСтр("ru='Не указан код состояния (200, 404 и т.п.)'");
		ВызватьИсключение(ТекстОшибки);
	КонецЕсли;
	
	ВариантОтвета = ВариантыОтветов[КодСостояния];
	
	Если ВариантОтвета = Неопределено Тогда
		ВариантОтвета = Обработки.oapi_ВариантОтвета.Создать();
		ВариантОтвета.КодСостояния = КодСостояния;
		ВариантОтвета.Сервис = Сервис;
		ВариантОтвета.Метод = ЭтотОбъект;
		ВариантыОтветов[КодСостояния] = ВариантОтвета;
	КонецЕсли;
	
	ВариантОтвета.КраткоеОписание = КраткоеОписание;
	
	Возврат ВариантОтвета;
	
КонецФункции

// Добавляет в состав метода новый вариант запроса
//
// Параметры:
//  КраткоеОписание	- Строка	 - Текстовое описание метода
//  ТипДанных	    - Строка	 - Тип ожидаемых данных
// 
// Возвращаемое значение:
//  oapi_ВариантЗапроса - Ссылка на вариант запроса
//
Функция ДобавитьВариантЗапроса(КраткоеОписание = "", ТипДанных = "application/json") Экспорт
	
	ВариантЗапроса = ВариантыЗапросов[ТипДанных];
	
	Если ВариантЗапроса = Неопределено Тогда
		ВариантЗапроса = Обработки.oapi_ВариантЗапроса.Создать();
		ВариантЗапроса.ТипДанных = ТипДанных;
		ВариантЗапроса.Сервис = Сервис;
		ВариантЗапроса.Метод = ЭтотОбъект;
		ВариантыЗапросов[ТипДанных] = ВариантЗапроса;
	КонецЕсли;
	
	ВариантЗапроса.КраткоеОписание = КраткоеОписание;
	
	Возврат ВариантЗапроса;
	
КонецФункции

// Добавляет в состав метода новый параметр запроса
//
// Параметры:
//  ИмяПараметра			- Строка	 	- Имя параметра запроса
//  ЗначениеПараметра		- Произвольный	- Значение параметра запроса
//  ЯвляетсяЧастьюАдреса	- Строка	 	- Признак того, что параметр является частью адреса, а не передается через &
// 
// Возвращаемое значение:
//  oapi_ПараметрЗапроса - Ссылка на параметр запроса
//
Функция ДобавитьПараметрЗапроса(ИмяПараметра, ЗначениеПараметра, ЯвляетсяЧастьюАдреса = Ложь) Экспорт
	
	Если ТипЗнч(ЗначениеПараметра) <> Тип("ОбработкаОбъект.oapi_ПримитивныйТип") Тогда
		ТекстОшибки = НСтр("ru='В качестве параметра запроса может выступать только примитивный тип данных (Сервис.ТипСтрока, Сервис.ТипЧисло).'");
		ВызватьИсключение(ТекстОшибки);
	КонецЕсли;
	
	ПараметрЗапроса = ПараметрыЗапроса[ИмяПараметра];
	
	Если ПараметрЗапроса = Неопределено Тогда
		ПараметрЗапроса = Обработки.oapi_ПараметрЗапроса.Создать();
		ПараметрЗапроса.ИмяПараметра = ИмяПараметра;
		ПараметрЗапроса.Сервис = Сервис;
		ПараметрЗапроса.Метод = ЭтотОбъект;
		ПараметрыЗапроса[ИмяПараметра] = ПараметрЗапроса;
	КонецЕсли;
	
	ПараметрЗапроса.ЯвляетсяЧастьюАдреса = ЯвляетсяЧастьюАдреса;
	ПараметрЗапроса.Значение = ЗначениеПараметра;
	
	Возврат ПараметрЗапроса;
	
КонецФункции

// Добавляет в состав метода новый тег
//
// Параметры:
//  Тег	- oapi_Тег	- Ссылка на тег
// 
// Возвращаемое значение:
//  oapi_Метод - Ссылка на метод
//
Функция ДобавитьТег(Тег) Экспорт
	
	Если ТипЗнч(Тег) <> Тип("ОбработкаОбъект.oapi_Тег") Тогда
		ТекстОшибки = НСтр("ru='Некорректное значение тега.'");
		ВызватьИсключение(ТекстОшибки);
	КонецЕсли;
	
	Если Теги.Найти(Тег) = Неопределено Тогда
		Теги.Добавить(Тег);
	КонецЕсли;
	
	Возврат ЭтотОбъект;
	
КонецФункции

Функция ПараметрыЗапроса() Экспорт
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ВариантыЗапросов() Экспорт
	
	Возврат ВариантыЗапросов;
	
КонецФункции

Функция ВариантыОтветов() Экспорт
	
	Возврат ВариантыОтветов;
	
КонецФункции

Функция Теги() Экспорт
	
	Возврат Теги;
	
КонецФункции

#КонецОбласти

#Область ФормированиеОписания

Функция ПолучитьОписание() Экспорт
	
	ОписаниеМетода = Новый Структура();
	
	// Описание тегов метода
	ОписаниеМетода.Вставить("tags", Новый Массив);
	
	Для Каждого Тег Из Теги() Цикл
		ОписаниеМетода.tags.Добавить(Тег.ИмяТега);
	КонецЦикла;
	
	// Описание параметров метода
	Если 0 < ПараметрыЗапроса().Количество() Тогда
		
		ОписаниеМетода.Вставить("parameters", Новый Массив);
		
		Для Каждого Параметр Из ПараметрыЗапроса() Цикл
			ОписаниеПараметра = Параметр.Значение.ПолучитьОписание();
			ОписаниеМетода.parameters.Добавить(ОписаниеПараметра);
		КонецЦикла;
	КонецЕсли;
	
	// Описание вариантов запроса (тела запроса)
	Если 0 < ВариантыЗапросов().Количество() Тогда
		
		ОписаниеЗапроса = Новый Структура();
		ОписаниеЗапроса.Вставить("content", Новый Соответствие);
		ОписаниеЗапроса.Вставить("description", "");
		
		Для Каждого ВариантЗапроса Из ВариантыЗапросов() Цикл
			
			ОписаниеЗапроса.description = ВариантЗапроса.Значение.КраткоеОписание;
			ОписанияДанных = ВариантЗапроса.Значение.ПолучитьОписание();
			
			Для Каждого ОписаниеДанных Из ОписанияДанных Цикл
				ОписаниеЗапроса.content.Вставить(ОписаниеДанных.Ключ, ОписаниеДанных.Значение);
			КонецЦикла;
			
		КонецЦикла;
		
		ОписаниеМетода.Вставить("requestBody", ОписаниеЗапроса);
		
	КонецЕсли;
	
	// Описание вариантов ответа
	Если 0 < ВариантыОтветов().Количество() Тогда
		
		ОписаниеМетода.Вставить("responses", Новый Соответствие);
		
		Для Каждого ВариантОтвета Из ВариантыОтветов() Цикл
			ОписаниеОтвета = ВариантОтвета.Значение.ПолучитьОписание();
			ОписаниеМетода.responses.Вставить(Строка(ВариантОтвета.Ключ), ОписаниеОтвета);
		КонецЦикла;
		
		ОписаниеМетода.Вставить("security", Сервис.ПолучитьСхемыАвторизации());
		
	КонецЕсли;
	
	Возврат ОписаниеМетода;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область Инициализация

ВариантыЗапросов = Новый Соответствие();
ВариантыОтветов = Новый Соответствие();
ПараметрыЗапроса = Новый Соответствие();
Теги = Новый Массив();

#КонецОбласти