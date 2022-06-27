Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
                      |	ПродажиПоДисконтнымКартамОбороты.СуммаОборот КАК СуммаОборот
                      |ИЗ
                      |	РегистрНакопления.ПродажиПоДисконтнымКартам.Обороты(, , День, ДисконтнаяКарта = &Карта) КАК ПродажиПоДисконтнымКартамОбороты
                      |ГДЕ
                      |	ПродажиПоДисконтнымКартамОбороты.СуммаОборот > 0");

Запрос.УстановитьПараметр("Карта", Карта);

Выборка = Запрос.Выполнить().Выбрать();
Если Выборка.Следующий() Тогда
	Результат = Выборка.СуммаОборот;
Иначе
	Результат = "Покупок не найдено";
КонецЕсли;
