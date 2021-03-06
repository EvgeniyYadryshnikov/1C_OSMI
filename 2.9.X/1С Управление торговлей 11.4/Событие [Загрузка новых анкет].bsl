//При создании электронной карты производится дополнительное начисление приветсвенных бонусных баллов

//Входные параметры:
//	1. Имя регистрационной группы
//	2. Виды карт лояльности
//	3. Шаблон электронной карты
//	4. Бонусная программа лояльности
//	5. Количество приветственных баллов
//  6. Ссылка на дополнительное свойство для контроля однократности начисления приветственных бонусов

МассивКарт = ОСМИ_РаботаСAPI.ПолучитьСписокЗарегистрированныхКарт(Отборы.Получить(0).Значение).Ответ.registrations;

МассивНаУдаление = новый Массив;

Для Каждого Карта из МассивКарт Цикл

	Попытка

		НачатьТранзакцию();

		СерийныйНомер = Карта.serialNo;
		Штрихкод = СерийныйНомер;
		ФИО = Карта.Фамилия + " " + Карта.Имя;
		Телефон = ?(Карта.Телефон = "-empty-", "", Карта.Телефон);
		ТелефонЦифры = СтрЗаменить(Телефон, " ", "");
		ТелефонЦифры = СтрЗаменить(ТелефонЦифры, ")", "");
		ТелефонЦифры = СтрЗаменить(ТелефонЦифры, "(", "");
		ТелефонЦифры = СтрЗаменить(ТелефонЦифры, "-", "");
		ПартнерНовый = Ложь;

        Если Телефон = "" Тогда
            ВызватьИсключение "В новой дисконтной карте не задан номер телефона!";
        КонецЕсли;
                
		//Поиск партнера
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
						|	ПартнерыКонтактнаяИнформация.Ссылка КАК Ссылка
						|ИЗ
						|	Справочник.Партнеры.КонтактнаяИнформация КАК ПартнерыКонтактнаяИнформация
						|ГДЕ
						|	ПартнерыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон)
						|	И (ПартнерыКонтактнаяИнформация.Представление = &Телефон
						|			ИЛИ ПартнерыКонтактнаяИнформация.НомерТелефона = &НомерТелефона7
						|			ИЛИ ПартнерыКонтактнаяИнформация.НомерТелефона = &НомерТелефона8)
						|	И ПартнерыКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонПартнера)
						|	И НЕ ПартнерыКонтактнаяИнформация.Ссылка.ПометкаУдаления";
			
		Запрос.УстановитьПараметр("Телефон", Телефон);
		НомТел = Прав(ТелефонЦифры, 10);
		НомерТелефона7 = "7" + НомТел;
		НомерТелефона8 = "8" + НомТел;
		Запрос.УстановитьПараметр("НомерТелефона7", НомерТелефона7);
		Запрос.УстановитьПараметр("НомерТелефона8", НомерТелефона8);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			//Нашли, берем только одного
			Партнер = Выборка.Ссылка.ПолучитьОбъект();
		Иначе
			//Создаем новый
			ПартнерНовый = Истина;
			Партнер = Справочники.Партнеры.СоздатьЭлемент();
			Партнер.ЮрФизЛицо = Перечисления.КомпанияЧастноеЛицо.ЧастноеЛицо;
			Партнер.ДатаРегистрации = ТекущаяДата();
			Партнер.Клиент = Истина;
			Партнер.Наименование = ФИО;
			Партнер.НаименованиеПолное = ФИО;
			Попытка
				ДР = СтрРазделить(Карта.Дата_Рождения, ".");
				Партнер.ДатаРождения = Дата(ДР[2],ДР[1],ДР[0]);
			Исключение
			КонецПопытки;
			
            УправлениеКонтактнойИнформацией.ДобавитьКонтактнуюИнформацию(Партнер, Телефон,
                Справочники.ВидыКонтактнойИнформации.ТелефонПартнера, ТекущаяДата());
                			
		КонецЕсли;
					
		//Почта
   		Если Карта.Почта <> "" Тогда
           УправлениеКонтактнойИнформацией.ДобавитьКонтактнуюИнформацию(Партнер, Карта.Почта,
                Справочники.ВидыКонтактнойИнформации.EmailПартнера, ТекущаяДата(), Истина);
		КонецЕсли;

		Партнер.Записать();
			
		//Карта лояльности - если у Партнера уже есть Карта лояльности с требуемой бонусной программой, то используем ее, иначе создаем новую
		ВидКарты = Отборы.Получить(1).Значение;
		БонуснаяПрограммаЛояльности = Отборы.Получить(3).Значение;
		 
		Запрос = Новый Запрос("ВЫБРАТЬ
                      |	КартыЛояльности.Ссылка КАК Ссылка
                      |ИЗ
                      |	Справочник.КартыЛояльности КАК КартыЛояльности
                      |ГДЕ
                      |	КартыЛояльности.Владелец.БонуснаяПрограммаЛояльности = &БонуснаяПрограммаЛояльности
                      |	И КартыЛояльности.Партнер = &Партнер
                      |	И НЕ КартыЛояльности.ПометкаУдаления");

		Запрос.УстановитьПараметр("БонуснаяПрограммаЛояльности", БонуснаяПрограммаЛояльности);
		Запрос.УстановитьПараметр("Партнер", Партнер.Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
		    КартаСсылка = Выборка.Ссылка;
		Иначе
		
			ИнфКарта = Справочники.КартыЛояльности.СоздатьЭлемент();
			ИнфКарта.Штрихкод = Карта.serialNo;
			ИнфКарта.Статус = Перечисления.СтатусыКартЛояльности.Действует;
			ИнфКарта.Наименование = Карта.Имя + " " + Карта.Фамилия;
			ИнфКарта.Владелец = ВидКарты;
			ИнфКарта.Партнер = Партнер.Ссылка;
			ИнфКарта.ОбменДанными.Загрузка = Истина;
			ИнфКарта.Записать();
			КартаСсылка = ИнфКарта.Ссылка;
			
		КонецЕсли;
		
		//Электронная карта
		КартаЭл = Справочники.ОСМИ_ЭлектроннаяКарта.НайтиПоКоду(СерийныйНомер);
		Если КартаЭл.Пустая() Тогда
			КартаОСМИ = Справочники.ОСМИ_ЭлектроннаяКарта.СоздатьЭлемент();
			КартаОСМИ.Код = СерийныйНомер;
			КартаОСМИ.Наименование = СерийныйНомер;
			КартаОСМИ.Шаблон = Отборы.Получить(2).Значение;
			КартаОСМИ.ОбменДанными.Загрузка = Истина;
			КартаОСМИ.Записать();
			КартаЭл = КартаОСМИ.Ссылка;
		КонецЕсли;
		Рег = РегистрыСведений.ОСМИ_СоответствиеКарт.СоздатьМенеджерЗаписи();
		Рег.ОбъектБазы = КартаСсылка;
		Рег.ЭлектроннаяКарта = КартаЭл;
		Рег.Записать();
		//Заполним поля
		Если КартаОСМИ <> Неопределено Тогда
			КартаОСМИ.УстановитьЗначенияПолей();
			КартаОСМИ.ОбновитьЗначенияССервера();
			//Еще раз запишем
			КартаОСМИ.Записать();
		КонецЕсли;

		Если ЗначениеЗаполнено(Отборы.Получить(5).Значение) Тогда
		
			НачислениеНеТребуется = УправлениеСвойствами.ЗначениеСвойства(КартаСсылка,
				Отборы.Получить(5).Значение);
			
			Если НачислениеНеТребуется <> Истина Тогда
			
				ТаблицаСвойствИЗначений = Новый ТаблицаЗначений;
				ТаблицаСвойствИЗначений.Колонки.Добавить("Свойство");
				ТаблицаСвойствИЗначений.Колонки.Добавить("Значение");
			
				НовоеСвойство = ТаблицаСвойствИЗначений.Добавить();
				НовоеСвойство.Свойство = Отборы.Получить(5).Значение;
				НовоеСвойство.Значение = Истина;
			
				УправлениеСвойствами.ЗаписатьСвойстваУОбъекта(КартаСсылка, ТаблицаСвойствИЗначений);
			
				Док = Документы.НачислениеИСписаниеБонусныхБаллов.СоздатьДокумент();
				Док.БонуснаяПрограммаЛояльности = Отборы.Получить(3).Значение;
				Док.Дата = ТекущаяДата();
				Док.ПравилоНачисления = Справочники.ПравилаНачисленияИСписанияБонусныхБаллов.ПустаяСсылка();
				Док.ВидПравила = Перечисления.ВидыПравилНачисленияБонусныхБаллов.Начисление;
				Док.КоличествоПериодовДействия = 1;
				Док.ПериодДействия = Перечисления.Периодичность.Год;
				Док.ПериодОтсрочкиНачалаДействия = Перечисления.Периодичность.День;
				Док.Комментарий = "Автоматическое начисление приветсвенных бонусов";
				СтрокаНачисления = Док.Начисление.Добавить();
				СтрокаНачисления.Партнер = Партнер.Ссылка;
				СтрокаНачисления.Баллы = Отборы.Получить(4).Значение;
				
				Док.Записать(РежимЗаписиДокумента.Проведение);

			КонецЕсли;		
		
		Иначе
            ВызватьИсключение "Не задано свойство регистрации произведенного начисления приветственных бонусов!" +
            	Символы.ПС + "Начисление привественных бонусов не произведено!";
		КонецЕсли;

		МассивНаУдаление.Добавить(СерийныйНомер);

		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации("ОСМИ.Ошибка", УровеньЖурналаРегистрации.Ошибка,,, ОписаниеОшибки());
	КонецПопытки;
КонецЦикла;

Если МассивНаУдаление.Количество() > 0 Тогда
	ОСМИ_РаботаСAPI.УдалитьРегиcтрацию(МассивНаУдаление);
КонецЕсли;
