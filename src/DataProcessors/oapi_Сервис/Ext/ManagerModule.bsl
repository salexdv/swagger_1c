﻿Функция ЭтоРасширенныйТипДанных(Данные) Экспорт
	
	ТипДанных = ТипЗнч(Данные);

	Возврат ТипДанных = Тип("ОбработкаОбъект.oapi_Структура") Или
			ТипДанных = Тип("ОбработкаОбъект.oapi_Соответствие") Или
			ТипДанных = Тип("ОбработкаОбъект.oapi_Массив") Или
			ТипДанных = Тип("ОбработкаОбъект.oapi_ПримитивныйТип");
	
КонецФункции