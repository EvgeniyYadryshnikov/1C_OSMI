Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
                      |	ПродажиПоДисконтнымКартамОбороты.Период КАК Период
                      |ИЗ
                      |	РегистрНакопления.ПродажиПоДисконтнымКартам.Обороты(, , День, ДисконтнаяКарта = &Карта) КАК ПродажиПоДисконтнымКартамОбороты
                      |ГДЕ
                      |	ПродажиПоДисконтнымКартамОбороты.СуммаОборот > 0
                      |
                      |УПОРЯДОЧИТЬ ПО
                      |	Период УБЫВ");

Запрос.УстановитьПараметр("Карта", Карта);

Выборка = Запрос.Выполнить().Выбрать();
Если Выборка.Следующий() Тогда
	Результат = Формат(Выборка.Период, "ДЛФ=DD");
Иначе
	Результат = "Покупок не найдено";
КонецЕсли;
