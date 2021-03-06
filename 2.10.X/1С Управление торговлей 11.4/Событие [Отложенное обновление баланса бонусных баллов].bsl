Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
                      |	КартыЛояльности.Ссылка КАК Карта
                      |ИЗ
                      |	РегистрНакопления.БонусныеБаллы КАК БонусныеБаллы
                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КартыЛояльности КАК КартыЛояльности
                      |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОСМИ_СоответствиеКарт КАК ОСМИ_СоответствиеКарт
                      |			ПО КартыЛояльности.Ссылка = ОСМИ_СоответствиеКарт.ОбъектБазы
                      |		ПО БонусныеБаллы.Партнер = КартыЛояльности.Партнер
                      |ГДЕ
                      |	БонусныеБаллы.Период = &Дата
                      |	И БонусныеБаллы.БонуснаяПрограммаЛояльности = &БонуснаяПрограммаЛояльности
                      |	И (БонусныеБаллы.Начислено <> 0
                      |			ИЛИ БонусныеБаллы.КСписанию <> 0)");

Запрос.УстановитьПараметр("Дата", НачалоДня(ТекущаяДатаСеанса()));
Запрос.УстановитьПараметр("БонуснаяПрограммаЛояльности", Отборы.Получить(0).Значение);

Выборка = Запрос.Выполнить().Выбрать();
Пока Выборка.Следующий() Цикл
	Результат.Добавить(Выборка.Карта);
КонецЦикла;
