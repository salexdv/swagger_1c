﻿#Область ОписаниеПеременных

Перем ШаблоныURL;
Перем Схемы;
Перем ОписанияСхем;
Перем Теги;
Перем КоллекцияТипов Экспорт;
Перем СервисыКонфигурации Экспорт;

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьСоответствиеСхемеДанных(ИдентификаторСхемыДанных)
	
	Если ИспользоватьСхемыДанных Тогда
		
		Если Не ЗначениеЗаполнено(ИдентификаторСхемыДанных) Тогда
			ТекстОшибки = НСтр("ru='Не указан идентификатор схемы данных.'");
			ВызватьИсключение(ТекстОшибки);
		КонецЕсли;
		
		Если Схемы[ИдентификаторСхемыДанных] <> Неопределено Тогда
			ТекстОшибки = НСтр("ru='Идентификатор схемы данных уже используется.'");
			ВызватьИсключение(ТекстОшибки);
		КонецЕсли;
		
	Конецесли;
	
КонецПроцедуры

Процедура СохранитьСхемуДанных(ИдентификаторСхемыДанных, Обработка)
	
	Если ИспользоватьСхемыДанных Тогда
		Схемы[ИдентификаторСхемыДанных] = Обработка;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьИмяСхемыАвторизации()
	
	Возврат "auth";
	
КонецФункции

Функция ПолучитьТипАвторизации()
	
	Перем Тип;
	
	Если СхемаАвторизации = "BasicAuth" Или СхемаАвторизации = "BearerAuth" Тогда
		Тип = "http";
	ИначеЕсли СхемаАвторизации = "ApiKeyAuth" Тогда
		Тип = "apiKey";
	ИначеЕсли СхемаАвторизации = "OpenID" Тогда
		Тип = "openIdConnect";
	ИначеЕсли СхемаАвторизации = "OAuth2" Тогда
		Тип = "oauth2";
	Иначе
		ТекстОшибки = НСтр("ru='Неизвестный тип авторизации.'");
		ВызватьИсключение(ТекстОшибки);
	КонецЕсли;
	
	Возврат Тип;
	
КонецФункции

Функция ЭтоРасширенныйТипДанных(Данные) Экспорт
	
	ТипДанных = ТипЗнч(Данные);

	Возврат ТипДанных = Тип("ОбработкаОбъект.oapi_Структура") Или
			ТипДанных = Тип("ОбработкаОбъект.oapi_Соответствие") Или
			ТипДанных = Тип("ОбработкаОбъект.oapi_Массив") Или
			ТипДанных = Тип("ОбработкаОбъект.oapi_ПримитивныйТип");
	
КонецФункции

Функция ПолучитьАдресШаблона(КорневойURL, Адрес)
	
	АдресШаблона = "/" + КорневойURL + "/" + Адрес;
	АдресШаблона = СтрЗаменить(АдресШаблона, "///", "//");
	
	Возврат СтрЗаменить(АдресШаблона, "//", "/");
	
КонецФункции

Функция ПолучитьОписаниеШаблонаМетодаИзКонфигурации(Объект)
	
	Описания = Новый Структура("КраткоеОписание, ПолноеОписание");
	
	Если Объект.Имя <> Объект.Синоним Тогда
		Описания.КраткоеОписание = Объект.Синоним;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Комментарий) Тогда
		
		Если ЗначениеЗаполнено(Описания.КраткоеОписание) Тогда
			Описания.ПолноеОписание = Объект.Комментарий;
		Иначе
			Описания.КраткоеОписание = Объект.Комментарий;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Описания;
	
КонецФункции

Процедура ПроверитьПараметрыЗагрузкиСервисовИзКонфигурации(ПараметрыЗагрузки)
	
	Если ПараметрыЗагрузки <> Неопределено Тогда
		ТекстОшибки = НСтр("ru='Некорректные параметры загрузки сервисов (см. ПараметрыЗагрузкиСервисовИзКонфигурации).'");
		Если ТипЗнч(ПараметрыЗагрузки) <> Тип("Структура") Тогда
			ВызватьИсключение(ТекстОшибки);
		ИначеЕсли Не ПараметрыЗагрузки.Свойство("ВключатьСервисы") Тогда
			ВызватьИсключение(ТекстОшибки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ЗагружатьСервисШаблонМетод(Ключ, ПараметрыЗагрузки)
	
	Загружать = Истина;
	
	Если ПараметрыЗагрузки <> Неопределено Тогда
		
		КоличествоРазделителей = СтрРазделить(Ключ, "-").Количество() - 1;
		ЭтоСервис = (КоличествоРазделителей = 0);
		ЭтоШаблон = (КоличествоРазделителей = 1);
		
		Если ЭтоСервис Тогда
			Если ПараметрыЗагрузки.ВключатьСервисы.Количество() <> 0 Тогда
				Загружать = (ПараметрыЗагрузки.ВключатьСервисы.Найти(Ключ) <> Неопределено);
			КонецЕсли;
			Если ПараметрыЗагрузки.ИсключатьСервисы.Количество() <> 0 Тогда
				Загружать = (ПараметрыЗагрузки.ИсключатьСервисы.Найти(Ключ) = Неопределено);
			КонецЕсли;
		ИначеЕсли ЭтоШаблон Тогда
			Если ПараметрыЗагрузки.ВключатьШаблоны.Количество() <> 0 Тогда
				Загружать = (ПараметрыЗагрузки.ВключатьШаблоны.Найти(Ключ) <> Неопределено);
			КонецЕсли;
			Если ПараметрыЗагрузки.ИсключатьШаблоны.Количество() <> 0 Тогда
				Загружать = (ПараметрыЗагрузки.ИсключатьШаблоны.Найти(Ключ) = Неопределено);
			КонецЕсли;
		Иначе
			Если ПараметрыЗагрузки.ВключатьМетоды.Количество() <> 0 Тогда
				Загружать = (ПараметрыЗагрузки.ВключатьМетоды.Найти(Ключ) <> Неопределено);
			КонецЕсли;
			Если ПараметрыЗагрузки.ИсключатьМетоды.Количество() <> 0 Тогда
				Загружать = (ПараметрыЗагрузки.ИсключатьМетоды.Найти(Ключ) = Неопределено);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Загружать;
	
КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область ТипыДанных

// Преобразует типы Структура, Массив и т.п в расширенные типы
// ТипСтруктура, ТипМассив и т.п.
//
// Параметры:
//  Данные	 - Произвольный	 - Тип, который необходимо преобразовать
// 
// Возвращаемое значение:
//  Произвольный - ТипСтруктура, ТипМассив, ТиЧисло
//
Функция ПреобразоватьТипы1СВРасширенныеТипы(Данные) Экспорт
	
	Если ИспользоватьСхемыДанных Тогда
		ТекстОшибки = НСтр("ru='Преобразование в расширенные типы возможно только тогда, когда не используются схемы данных.'");
		ВызватьИсключение(ТекстОшибки);
	КонецЕсли;
	
	Результат = Неопределено;
	
	Если ТипЗнч(Данные) = Тип("Структура") Тогда
		
		Результат = ТипСтруктура("");
		Для Каждого Обход Из Данные Цикл
			Результат.Вставить(Обход.Ключ, ПреобразоватьТипы1СВРасширенныеТипы(Обход.Значение));
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Данные) = Тип("Соответствие") Тогда
		
		Результат = ТипСоответствие("");
		Для Каждого Обход Из Данные Цикл
			Результат.Вставить(Обход.Ключ, ПреобразоватьТипы1СВРасширенныеТипы(Обход.Значение));
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Данные) = Тип("Массив") Тогда
		
		Результат = ТипМассив("");
		Для Каждого Значение Из Данные.Коллекция() Цикл
			Результат.Добавить(ПреобразоватьТипы1СВРасширенныеТипы(Значение));
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Данные) = Тип("Число") Или
		ТипЗнч(Данные) = Тип("Строка") Или 
		ТипЗнч(Данные) = Тип("Булево") Тогда
		
		Результат = ПримитивныйТип(Данные, "");
		
	Иначе
		
		Результат = Данные;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Преобразует типы ТипСтруктура, ТипМассив и т.п в родные типы
// Структура, Массив и т.п.
//
// Параметры:
//  Данные	 - Произвольный	 - Расширенный тип, который необходимо преобразовать
// 
// Возвращаемое значение:
//  Произвольный - Структура, Соответствие, Массив
//
Функция ПреобразоватьДанныеВТипы1С(Данные) Экспорт
	
	Результат = Неопределено;
	
	Если ТипЗнч(Данные) = Тип("ОбработкаОбъект.oapi_Структура") Тогда
		
		Результат = Новый Структура();
		Для Каждого Обход Из Данные.Коллекция() Цикл
			Результат.Вставить(Обход.Ключ, ПреобразоватьДанныеВТипы1С(Обход.Значение));
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Данные) = Тип("ОбработкаОбъект.oapi_Соответствие") Тогда
		
		Результат = Новый Соответствие();
		Для Каждого Обход Из Данные.Коллекция() Цикл
			Результат.Вставить(Обход.Ключ, ПреобразоватьДанныеВТипы1С(Обход.Значение));
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Данные) = Тип("ОбработкаОбъект.oapi_Массив") Тогда
		
		Результат = Новый Массив();
		Для Каждого Значение Из Данные.Коллекция() Цикл
			Результат.Добавить(ПреобразоватьДанныеВТипы1С(Значение));
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Данные) = Тип("ОбработкаОбъект.oapi_ПримитивныйТип") Тогда
		
		Результат = Данные.Значение;
		
	Иначе
		
		Результат = Данные;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает расширенный тип "Структура", который позволяет хранить
// описание структуры, идентификатор схемы данных и признак обязательного поля.
// Используется для описание входящих и исходящих данных сервиса вместе с типами
// ТипСоответствие, ТипМассив, ТипЧисло, ТипСтрока, ТипБулево
//
// Параметры:
//  Описание				 - Строка	 - Текстовое описание структуры
//  ИдентификаторСхемыДанных - Строка	 - Уникальный идентификатор схемы данных
//  Обязательное			 - Булево	 - Признак обязательного поля
// 
// Возвращаемое значение:
//  oapi_Структура - Ссылка на обработку, реализующую методы структуры
//
Функция ТипСтруктура(Описание, ИдентификаторСхемыДанных = "", Обязательное = Истина) Экспорт
	
	ПроверитьСоответствиеСхемеДанных(ИдентификаторСхемыДанных);
	
	Обработка = Обработки.oapi_Структура.Создать();
	Обработка.ИдентификаторСхемыДанных = ИдентификаторСхемыДанных;
	Обработка.Описание     = Описание;
	Обработка.Обязательное = Обязательное;
	
	СохранитьСхемуДанных(ИдентификаторСхемыДанных, Обработка);
	
	Возврат Обработка;
	
КонецФункции

// Возвращает расширенный тип "Соответствие", который позволяет хранить
// описание соответствия, идентификатор схемы данных и признак обязательного поля.
// Используется для описание входящих и исходящих данных сервиса вместе с типами
// ТипСтруктура, ТипМассив, ТипЧисло, ТипСтрока, ТипБулево
//
// Параметры:
//  Описание				 - Строка	 - Текстовое описание соответствия
//  ИдентификаторСхемыДанных - Строка	 - Уникальный идентификатор схемы данных
//  Обязательное			 - Булево	 - Признак обязательного поля
// 
// Возвращаемое значение:
//  oapi_Соответствие - Ссылка на обработку, реализующую методы соответствия
//
Функция ТипСоответствие(Описание, ИдентификаторСхемыДанных = "", Обязательное = Истина) Экспорт
	
	ПроверитьСоответствиеСхемеДанных(ИдентификаторСхемыДанных);
	
	Обработка = Обработки.oapi_Соответствие.Создать();
	Обработка.ИдентификаторСхемыДанных = ИдентификаторСхемыДанных;
	Обработка.Описание     = Описание;
	Обработка.Обязательное = Обязательное;
	
	СохранитьСхемуДанных(ИдентификаторСхемыДанных, Обработка);
	
	Возврат Обработка;
	
КонецФункции

// Возвращает расширенный тип "Массив", который позволяет хранить
// описание массива и признак обязательного поля.
// Используется для описание входящих и исходящих данных сервиса вместе с типами
// ТипСтруктура, ТипСоответствие, ТипЧисло, ТипСтрока, ТипБулево
//
// Параметры:
//  Описание				 - Строка	 - Текстовое описание массив
//  Обязательное			 - Булево	 - Признак обязательного поля
// 
// Возвращаемое значение:
//  oapi_Массив - Ссылка на обработку, реализующую методы соответствия
//
Функция ТипМассив(Описание, Обязательное = Истина) Экспорт
	
	Обработка = Обработки.oapi_Массив.Создать();
	Обработка.Описание     = Описание;
	Обработка.Обязательное = Обязательное;
	
	Возврат Обработка;
	
КонецФункции

// Возвращает расширенный тип "Число", который позволяет хранить
// описание числа и признак обязательного поля.
// Используется для описание входящих и исходящих данных сервиса вместе с типами
// ТипСтруктура, ТипСоответствие, ТипМассив, ТипСтрока, ТипБулево
//
// Параметры:
//  Значение	 - Число	 - Значение
//  Описание	 - Строка	 - Текстовое описание
//  Обязательное - Булево	 - Призна обязательного поля
// 
// Возвращаемое значение:
//  oapi_ПримитивныйТип - Ссылка на обработку
//
Функция ТипЧисло(Значение = 0, Описание = "", Обязательное = Истина) Экспорт
	
	Возврат ПримитивныйТип(Значение, Описание, Обязательное);
	
КонецФункции

// Возвращает расширенный тип "Строка", который позволяет хранить
// описание числа и признак обязательного поля.
// Используется для описание входящих и исходящих данных сервиса вместе с типами
// ТипСтруктура, ТипСоответствие, ТипМассив, ТипЧисло, ТипБулево
//
// Параметры:
//  Значение	 - Строка	 - Значение
//  Описание	 - Строка	 - Текстовое описание
//  Обязательное - Булево	 - Призна обязательного поля
// 
// Возвращаемое значение:
//  oapi_ПримитивныйТип - Ссылка на обработку
//
Функция ТипСтрока(Значение = "", Описание = "", Обязательное = Истина) Экспорт
	
	Возврат ПримитивныйТип(Значение, Описание, Обязательное);
	
КонецФункции

// Возвращает расширенный тип "Булево", который позволяет хранить
// описание и признак обязательного поля.
// Используется для описание входящих и исходящих данных сервиса вместе с типами
// ТипСтруктура, ТипСоответствие, ТипМассив, ТипЧисло, ТипСтрока
//
// Параметры:
//  Значение	 - Булево	 - Значение
//  Описание	 - Строка	 - Текстовое описание
//  Обязательное - Булево	 - Призна обязательного поля
// 
// Возвращаемое значение:
//  oapi_ПримитивныйТип - Ссылка на обработку
//
Функция ТипБулево(Значение = Ложь, Описание = "", Обязательное = Истина) Экспорт
	
	Возврат ПримитивныйТип(Значение, Описание, Обязательное);
	
КонецФункции

Функция ПримитивныйТип(Значение, Описание, Обязательное = Истина)
	
	Обработка = Обработки.oapi_ПримитивныйТип.Создать();
	Обработка.Описание     = Описание;
	Обработка.Обязательное = Обязательное;
	Обработка.Значение     = Значение;
	
	Возврат Обработка;
	
КонецФункции

#КонецОбласти

#Область УправлениеСтруктуройСервиса

// Возвращает параметры для загрузки сервисов из конфигурации,
// используемые в методе ЗагрузитьСервисыИзКонфигурации
// 
// Возвращаемое значение:
//  Структура - Параметры для загрузки сервисов
//
Функция ПараметрыЗагрузкиСервисовИзКонфигурации() Экспорт
	
	Параметры = Новый Структура();
	Параметры.Вставить("ВключатьСервисы" , Новый Массив);
	Параметры.Вставить("ИсключатьСервисы", Новый Массив);
	Параметры.Вставить("ВключатьШаблоны" , Новый Массив);
	Параметры.Вставить("ИсключатьШаблоны", Новый Массив);
	Параметры.Вставить("ВключатьМетоды"  , Новый Массив);
	Параметры.Вставить("ИсключатьМетоды" , Новый Массив);
	
	Возврат Параметры;
	
КонецФункции

// Загружает из конфигурации структуру http-сервисов.
// В дальнейшем работать с полученной структурой можно через ПолучитьМетод()
//
// Параметры:
//  ИсключаемыеСервисы - Массив - Массив имен http-сервисов, которые нужно пропустить
//  ИсключаемыеШаблоны - Массив - Массив шаблонов, которые нужно пропустить. Имя шаблона должно
//                                быть записано в формате "ИмяСервиса-ИмяШаблона".
//                                Например, "Биллинг-СчетНаОплату"
//  ИсключаемыеМетоды  - Массив - Массив методов, которые нужно пропустить. Имя метода должно
//                                быть записано в формате "ИмяСервиса-ИмяШаблона-ИмяМетода".
//                                Например, "Биллинг-СчетНаОплату-Изменить"
// 
// Возвращаемое значение:
//  oapi_Сервис - Ссылка на сервис
//
Функция ЗагрузитьСервисыИзКонфигурации(ПараметрыЗагрузки = Неопределено) Экспорт
	
	ПроверитьПараметрыЗагрузкиСервисовИзКонфигурации(ПараметрыЗагрузки);
		
	СервисыКонфигурации.Очистить();
	ШаблоныURL.Очистить();
	
	Для Каждого Сервис Из Метаданные.HTTPСервисы Цикл
		
		Если  Не ЗагружатьСервисШаблонМетод(Сервис.Имя, ПараметрыЗагрузки) Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяТега = Сервис.Имя;
		
		Если ЗначениеЗаполнено(Сервис.Синоним) Тогда
			ИмяТега = Сервис.Синоним;
		КонецЕсли;
		
		ДобавитьТег(ИмяТега, Сервис.Комментарий);
		
		Для Каждого ШаблонСервиса Из Сервис.ШаблоныURL Цикл
			
			КлючШаблона = СтрШаблон("%1-%2", Сервис.Имя, ШаблонСервиса.Имя);
			Если Не ЗагружатьСервисШаблонМетод(КлючШаблона, ПараметрыЗагрузки) Тогда
				Продолжить;
			КонецЕсли;
			
			АдресШаблона = ПолучитьАдресШаблона(Сервис.КорневойURL, ШаблонСервиса.Шаблон);
			Описание = ПолучитьОписаниеШаблонаМетодаИзКонфигурации(ШаблонСервиса);
			
			Шаблон = ДобавитьШаблонURL(АдресШаблона);
			Шаблон.КраткоеОписание = Описание.КраткоеОписание;
			Шаблон.ПолноеОписание = Описание.ПолноеОписание;
			
			Для Каждого МетодШаблона Из ШаблонСервиса.Методы Цикл
				
				КлючМетода = СтрШаблон("%1-%2", КлючШаблона, МетодШаблона.Имя);
				Если  Не ЗагружатьСервисШаблонМетод(КлючМетода, ПараметрыЗагрузки) Тогда
					Продолжить;
				КонецЕсли;
				
				Описание = ПолучитьОписаниеШаблонаМетодаИзКонфигурации(ШаблонСервиса);
				Метод = Шаблон.ДобавитьМетод(Строка(МетодШаблона.HTTPМетод));
				Метод.КраткоеОписание = Описание.КраткоеОписание;
				Метод.ПолноеОписание = Описание.ПолноеОписание;
				Метод.ДобавитьТег(ПоследнийТег);
				
				СервисыКонфигурации[КлючМетода] = Метод;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ЭтотОбъект;
	
КонецФункции

// Возвращает ссылку на метод существующего в конфигурации http-сервиса, ранее
// загруженного с помощью ЗагрузитьСервисыИзКонфигурации
// 
// Параметры:
//  ИмяСервиса - Строка - Имя http-сервиса, как оно задано дереве метаданных конфигурации.
//                        Например, "ПередачаДанных"
//  ИмяШаблона - Строка - Имя шаблона URL, как оно задано дереве метаданных конфигурации.
//                        Например, "ТомИПутьКФайлу"
//  ИмяМетода  - Строка - Имя метода, как оно задано дереве метаданных конфигурации
//                        Например, "POST"
// 
// Возвращаемое значение:
//  oapi_Метод - Ссылка на метод
//
Функция ПолучитьМетод(ИмяСервиса, ИмяШаблона, ИмяМетода) Экспорт
	
	Ключ = СтрШаблон("%1-%2-%3", ИмяСервиса, ИмяШаблона, ИмяМетода);
	Метод = СервисыКонфигурации[Ключ];
	
	Если Метод <> Неопределено Тогда
		Возврат Метод;
	Иначе
		ТекстОшибки = НСтр("ru='Не найден метод с ключом '") + Ключ;
		ВызватьИсключение(ТекстОшибки);
	КонецЕсли;
	
КонецФункции

// Добавляет в состав сервиса адрес сервера
//
// Параметры:
//  АдресСервера - Строка - адрес сервера, реализующего API
// 
// Возвращаемое значение:
//  oapi_Сервис - ссылка на сервис
//
Функция ДобавитьСервер(АдресСервера) Экспорт
	
	Если Не ЗначениеЗаполнено(АдресСервера) Тогда
		ТекстОшибки = НСтр("ru='Не указан адрес сервера.'");
		ВызватьИсключение(ТекстОшибки);
	КонецЕсли;
	
	Сервера.Добавить().АдресСервера = АдресСервера;
	
	Возврат ЭтотОбъект;
	
Конецфункции

// Добавляет в состав сервиса тег.
// Теги позволяют группировать методы и шаблоны URL
//
// Параметры:
//  ИмяТега	 - Строка	 - Уникальное имя тега
//  Описание - Строка	 - Текстовое рписание тега
// 
// Возвращаемое значение:
//  oapi_Тег - Ссылка на тег
//
Функция ДобавитьТег(ИмяТега, Описание = "") Экспорт
	
	Если Не ЗначениеЗаполнено(ИмяТега) Тогда
		ТекстОшибки = НСтр("ru='Не указано имя тега.'");
		ВызватьИсключение(ТекстОшибки);
	КонецЕсли;
	
	Тег = Теги[ИмяТега];
	
	Если Тег = Неопределено Тогда
		Тег = Обработки.oapi_Тег.Создать();
		Тег.ИмяТега = ИмяТега;
		Тег.Сервис = ЭтотОбъект;
		Теги[ИмяТега] = Тег;
	КонецЕсли;
	
	Тег.Описание = Описание;
	
	ПоследнийТег = Тег;
	
	Возврат Тег;
	
КонецФункции

// Добавляет в состав сервиса новый шаблон URL.
//
// Параметры:
//  Адрес			- Строка	 - Адрес шаблона URL (endpoint)
//  КраткоеОписание	- Строка	 - Текстовое описание шаблона
// 
// Возвращаемое значение:
//  oapi_ШаблонURL - Ссылка на шаблон
//
Функция ДобавитьШаблонURL(Адрес, КраткоеОписание = "") Экспорт
	
	Если Не ЗначениеЗаполнено(Адрес) Тогда
		ТекстОшибки = НСтр("ru='Не указан адрес шаблона URL.'");
		ВызватьИсключение(ТекстОшибки);
	КонецЕсли;
	
	Если Лев(Адрес, 1) <> "/" Тогда
		ТекстОшибки = НСтр("ru='Шаблон URL должен начинаться с символа ""/""'");
		ВызватьИсключение(ТекстОшибки);
	КонецЕсли;
	
	ШаблонURL = ШаблоныURL[Адрес];
	
	Если ШаблонURL = Неопределено Тогда
		ШаблонURL = Обработки.oapi_ШаблонURL.Создать();
		ШаблонURL.Адрес = Адрес;
		ШаблонURL.Сервис = ЭтотОбъект;
		ШаблоныURL[Адрес] = ШаблонURL;
	КонецЕсли;
	
	ШаблонURL.КраткоеОписание = КраткоеОписание;
	
	Возврат ШаблонURL;
	
КонецФункции

// Сохраняет внутри сервиса коллекцию данных с уникальным именем
// для передачи коллекции между шаблонами
//
// Параметры:
//  ИмяКоллекции- Строка		 - Уникальное имя коллекции
//  Коллекция	- Произвольный	 - Произвольное значение
// 
// Возвращаемое значение:
//  oapi_Сервис - Ссылка на сервис
//
Функция УстановитьКоллекцияТипов(ИмяКоллекции, Коллекция) Экспорт
	
	Если Не ЗначениеЗаполнено(ИмяКоллекции) Тогда
		ТекстОшибки = НСтр("ru='Не указано имя коллекции типов.'");
		ВызватьИсключение(ТекстОшибки);
	КонецЕсли;
	
	КоллекцияТипов.Вставить(ИмяКоллекции, Коллекция);
	
	Возврат ЭтотОбъект;
	
КонецФункции

Функция ШаблоныURL() Экспорт
	
	Возврат ШаблоныURL;
	
КонецФункции

Функция Теги() Экспорт
	
	Возврат Теги;
	
КонецФункции

#КонецОбласти

#Область Авторизация

Функция ПолучитьСхемыАвторизации() Экспорт
	
	ИмяСхемы = ПолучитьИмяСхемыАвторизации();
	СхемыАвторизации = Новый Массив();
	
	Если СхемаАвторизации = "BasicAuth" Тогда
		СхемыАвторизации.Добавить(Новый Структура(ИмяСхемы, Новый Массив));
	Иначе
		ТекстОшибки = НСтр("ru='Нет реализации для указанной схемы авторизации.'");
		ВызватьИсключение(ТекстОшибки);
	КонецЕсли;
	
	Возврат СхемыАвторизации;
	
КонецФункции

Функция ПолучитьОписаниеСхемыАвторизации() Экспорт
	
	ИмяСхемы = ПолучитьИмяСхемыАвторизации();
	ТипАвторизации = ПолучитьТипАвторизации();
	
	ОписаниеАвторизации = Новый Структура();
	ОписаниеАвторизации.Вставить("type", ТипАвторизации);
		
	Если СхемаАвторизации = "BasicAuth" Тогда
		ОписаниеАвторизации.Вставить("scheme", "basic");
	ИначеЕсли СхемаАвторизации = "BearerAuth" Тогда
		ОписаниеАвторизации.Вставить("scheme", "bearer");
	ИначеЕсли СхемаАвторизации = "ApiKeyAuth" Тогда
		ОписаниеАвторизации.Вставить("in", "header");
		ОписаниеАвторизации.Вставить("name", "X-API-Key");
	ИначеЕсли СхемаАвторизации = "OpenID" Тогда
		ОписаниеАвторизации.Вставить("openIdConnectUrl", "https://example.com/.well-known/openid-configuration");
	ИначеЕсли СхемаАвторизации = "OAuth2" Тогда
		ОписаниеАвторизации.Вставить("openIdConnectUrl", "https://example.com/.well-known/openid-configuration");
		Возможности = Новый Структура();
		Возможности.Вставить("read" , "Grants read access");
		Возможности.Вставить("write", "Grants write access");
		Возможности.Вставить("admin", "Grants access to admin operations");
		ПолучениеКода = Новый Структура();
		ПолучениеКода.Вставить("authorizationUrl", "https://example.com/oauth/authorize");
		ПолучениеКода.Вставить("tokenUrl", "https://example.com/oauth/token");
		ПолучениеКода.Вставить("scopes", Возможности);
		ОписаниеАвторизации.Вставить("flows", Новый Структура(ПолучениеКода));
	Иначе
		ТекстОшибки = НСтр("ru='Неизвестный тип авторизации.'");
		ВызватьИсключение(ТекстОшибки);
	КонецЕсли;
	
	Возврат Новый Структура(ИмяСхемы, ОписаниеАвторизации);
	
КонецФункции

Функция УстановитьСхемуАвторизацииBasicAuth() Экспорт
	
	СхемаАвторизации = "BasicAuth";
	
КонецФункции

Функция УстановитьСхемуАвторизацииBearerAuth() Экспорт
	
	СхемаАвторизации = "BearerAuth";
	
КонецФункции

Функция УстановитьСхемуАвторизацииApiKeyAuth() Экспорт
	
	СхемаАвторизации = "ApiKeyAuth";
	
КонецФункции

Функция УстановитьСхемуАвторизацииOpenID() Экспорт
	
	СхемаАвторизации = "OpenID";
	
КонецФункции

Функция УстановитьСхемуАвторизацииOAuth2() Экспорт
	
	СхемаАвторизации = "OAuth2";
	
КонецФункции

#КонецОбласти

#Область ФормированиеОписания

Функция ПолучитьОписаниеСервиса()
	
	// Общая информация о сервисе
	ОписаниеСервиса = Новый Структура();
	ОписаниеСервиса.Вставить("openapi" , "3.0.3");
	ОписаниеСервиса.Вставить("info"    , Новый Структура);
	ОписаниеСервиса.Вставить("servers" , Новый Массив);
	
	Для Каждого Сервер Из Сервера Цикл
		ОписаниеСервиса.servers.Добавить(Новый Структура("url", Сервер.АдресСервера));
	КонецЦикла;
	
	ОписаниеСервиса.Вставить("info", Новый Структура);
	ОписаниеСервиса.info.Вставить("title"      , КраткоеОписание);
	ОписаниеСервиса.info.Вставить("description", ПолноеОписание);
	ОписаниеСервиса.info.Вставить("version"    , Версия);
	
	ОписаниеСервиса.Вставить("tags", Новый Массив);
	ОписаниеСервиса.Вставить("paths", Новый Соответствие);
	ОписаниеСервиса.Вставить("components", Новый Соответствие);
	
	Схемы = Новый Соответствие();
	
	Для Каждого Тег Из Теги() Цикл
		ОписаниеТега = Новый Структура();
		ОписаниеТега.Вставить("name", Тег.Значение.ИмяТега);
		ОписаниеТега.Вставить("description", Тег.Значение.Описание);
		ОписаниеСервиса.tags.Добавить(ОписаниеТега);
	КонецЦикла;
	
	// Описание шаблонов URL и методов
	Для Каждого Шаблон Из ШаблоныURL() Цикл
		
		ОписаниеШаблона = Новый Структура();
		
		Для Каждого Метод Из Шаблон.Значение.Методы() Цикл
			
			ОписаниеМетода = Метод.Значение.ПолучитьОписание();
			Если 1 < ОписаниеМетода.Количество() Тогда
				ОписаниеШаблона.Вставить(НРег(Метод.Ключ), ОписаниеМетода);
			КонецЕсли;
			
		КонецЦикла;
		
		ОписаниеСервиса.paths.Вставить(Шаблон.Значение.Адрес, ОписаниеШаблона);
		
	КонецЦикла;
	
	// Описание схем данных
	Если 0 < ОписанияСхем.Количество() Тогда
		
		ОписаниеСервиса.components["schemas"] = Новый Соответствие();
		
		Для Каждого Схема Из ОписанияСхем Цикл
			ОписаниеСхемы = Схема.Значение;
			ОписаниеСхемы.Удалить("component");
			ОписаниеСервиса.components["schemas"][Схема.Ключ] = ОписаниеСхемы;
		КонецЦикла;
		
	КонецЕсли;
	
	// Схема авторизации
	ОписаниеСервиса.components.Вставить("securitySchemes", ПолучитьОписаниеСхемыАвторизации());
	
	Возврат ОписаниеСервиса;
	
КонецФункции

// Возвращает описание сервиса в формате JSON
// 
// Возвращаемое значение:
//  Строка - описание сервиса в формате OpenAPI (Swagger)
//
Функция ПолучитьОписаниеOpenAPI() Экспорт
	
	Попытка
		ОписаниеСервиса = ПолучитьОписаниеСервиса();
		Возврат oapi_ОбщегоНазначения.СериализоватьДанные(ОписаниеСервиса);
	Исключение
		ТекстОшибки = НСтр("ru='Не удалось получить описание сервиса: '") + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение(ТекстОшибки);
	КонецПопытки;
	
КонецФункции

Функция УстановитьОписаниеСхемы(ИдентификаторСхемыДанных, ОписаниеСхемы) Экспорт
	
	ОписанияСхем[ИдентификаторСхемыДанных] = ОписаниеСхемы;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область Инициализация

ШаблоныURL          = Новый Соответствие();
Схемы               = Новый Соответствие();
Теги                = Новый Соответствие();
КоллекцияТипов      = Новый Структура();
ОписанияСхем        = Новый Соответствие();
СервисыКонфигурации = Новый Соответствие;
УстановитьСхемуАвторизацииBasicAuth();

#КонецОбласти