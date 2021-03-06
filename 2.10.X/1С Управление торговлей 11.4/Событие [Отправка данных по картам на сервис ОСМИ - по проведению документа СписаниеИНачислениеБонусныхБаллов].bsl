//Отправка данных по картам на сервис ОСМИ - по проведению документа СписаниеИНачислениеБонусныхБаллов

Запрос = НОВЫЙ Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
                      |	КартыЛояльности.Ссылка КАК Карта
                      |ПОМЕСТИТЬ ВТ_Карты
                      |ИЗ
                      |	Документ.НачислениеИСписаниеБонусныхБаллов.Начисление КАК ДокНачисление
                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КартыЛояльности КАК КартыЛояльности
                      |		ПО ДокНачисление.Партнер = КартыЛояльности.Партнер
                      |ГДЕ
                      |	ДокНачисление.Ссылка = &Ссылка
                      |
                      |ОБЪЕДИНИТЬ ВСЕ
                      |
                      |ВЫБРАТЬ РАЗЛИЧНЫЕ
                      |	КартыЛояльности.Ссылка
                      |ИЗ
                      |	Документ.НачислениеИСписаниеБонусныхБаллов.Списание КАК ДокСписание
                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КартыЛояльности КАК КартыЛояльности
                      |		ПО ДокСписание.Партнер = КартыЛояльности.Партнер
                      |ГДЕ
                      |	ДокСписание.Ссылка = &Ссылка
                      |;
                      |
                      |////////////////////////////////////////////////////////////////////////////////
                      |ВЫБРАТЬ РАЗЛИЧНЫЕ
                      |	ВТ_Карты.Карта КАК Карта
                      |ИЗ
                      |	ВТ_Карты КАК ВТ_Карты
                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОСМИ_СоответствиеКарт КАК СоответствиеКарт
                      |		ПО ВТ_Карты.Карта = СоответствиеКарт.ОбъектБазы"); 

Запрос.УстановитьПараметр("Ссылка", Источник);

Выборка = Запрос.Выполнить().Выбрать();
Пока Выборка.Следующий() Цикл 
	Результат.Добавить(Выборка.Карта);
КонецЦикла;