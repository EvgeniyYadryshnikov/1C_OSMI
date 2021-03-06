Результат = "";

Запрос = Новый Запрос("ВЫБРАТЬ
                      |	ИнформационныеКартыКонтактнаяИнформация.НомерТелефона КАК НомерТелефона
                      |ИЗ
                      |	Справочник.ИнформационныеКарты.КонтактнаяИнформация КАК ИнформационныеКартыКонтактнаяИнформация
                      |ГДЕ
                      |	ИнформационныеКартыКонтактнаяИнформация.Ссылка = &Карта
                      |	И ИнформационныеКартыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон)
                      |	И ИнформационныеКартыКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонИнформационнойКарты)");


Запрос.УстановитьПараметр("Карта", Карта);

Выборка = Запрос.Выполнить().Выбрать();
Если Выборка.Следующий() Тогда
	Результат = СокрЛП(Выборка.НомерТелефона);
КонецЕсли;

Если Результат = "" Тогда

	Запрос.Текст = "ВЫБРАТЬ
	               |	ФизическиеЛицаКонтактнаяИнформация.НомерТелефона КАК НомерТелефона
	               |ИЗ
	               |	Справочник.ИнформационныеКарты КАК ИнформационныеКарты
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица.КонтактнаяИнформация КАК ФизическиеЛицаКонтактнаяИнформация
	               |		ПО ИнформационныеКарты.ВладелецКарты = ФизическиеЛицаКонтактнаяИнформация.Ссылка
	               |ГДЕ
	               |	ИнформационныеКарты.Ссылка = &Карта
	               |	И ФизическиеЛицаКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон)
	               |	И ФизическиеЛицаКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонФизическогоЛица)
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	КонтрагентыКонтактнаяИнформация.НомерТелефона
	               |ИЗ
	               |	Справочник.ИнформационныеКарты КАК ИнформационныеКарты
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Контрагенты.КонтактнаяИнформация КАК КонтрагентыКонтактнаяИнформация
	               |		ПО ИнформационныеКарты.ВладелецКарты = КонтрагентыКонтактнаяИнформация.Ссылка
	               |ГДЕ
	               |	ИнформационныеКарты.Ссылка = &Карта
	               |	И КонтрагентыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон)
	               |	И КонтрагентыКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонКонтрагента)
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ПользователиКонтактнаяИнформация.НомерТелефона
	               |ИЗ
	               |	Справочник.ИнформационныеКарты КАК ИнформационныеКарты
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Пользователи.КонтактнаяИнформация КАК ПользователиКонтактнаяИнформация
	               |		ПО ИнформационныеКарты.ВладелецКарты = ПользователиКонтактнаяИнформация.Ссылка
	               |ГДЕ
	               |	ИнформационныеКарты.Ссылка = &Карта
	               |	И ПользователиКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон)
	               |	И ПользователиКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонПользователя)";


	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = СокрЛП(Выборка.НомерТелефона);
	Иначе
		Результат = "";
	КонецЕсли;
	
КонецЕсли;