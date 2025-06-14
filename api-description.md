Документация

Уважаемые коллеги!

Сервис «Расписание БГУИР» предоставляет программные интерфейсы, предназначенные для работы с расписанием групп и преподавателей. Каждый из интерфейсов предлагает свой инструмент, позволяющий решать ту или иную задачу.

Обращаем Ваше внимание, что Вы используете данные сервисы на свой страх и риск. Программные интерфейсы могут быть модифицированы либо отключены в любое время без предварительного уведомления. Также в любое время могут измениться условия доступа к сервисам. Таким образом, используя наши сервисы, Вы соглашаетесь с данными условиями.

С уважением, отдел ИТ ЦИИР БГУИР.

Столкнулись с неисправностью? Наша команда поможет Вам [+375 (17) 293-22-22.](\"tel:+375172932222\")

Получение расписания группы

Метод

HTTP запрос

Описание

GET

https://iis.bsuir.by/api/v1/schedule?studentGroup={groupNumber}, где groupNumber - номер группы

HTTP-запрос на получение расписания группы в формате JSON/XML.

JSON

XML

**Пример ответа**

{
    \\"employeeDto\\": null,
    \\"studentGroupDto\\": {
      \\"name\\": \\"053503\\",
      \\"facultyId\\": 20026,
      \\"facultyAbbrev\\": \\"ФКСиС\\",
      \\"specialityDepartmentEducationFormId\\": 20021,
      \\"specialityName\\": \\"Информатика и технологии программирования\\",
      \\"specialityAbbrev\\": \\"ИиТП\\",
      \\"course\\": 4,
      \\"id\\": 23316,
      \\"calendarId\\": \\"nefjuco5s419csfgiud3je9lfo@group.calendar.google.com\\", 
      \\"educationDegree\\": 1
    },
    \\"schedules\\": {
      \\"Понедельник\\": \[Schedule\],
      \\"Вторник\\": \[Schedule\],
      \\"Среда\\": \[Schedule\],
      \\"Четверг\\": \[Schedule\],
      \\"Пятница\\": \[Schedule\],
      \\"Суббота\\": \[Schedule\],
    },
    \\"exams\\": \[Schedule\],
    \\"startDate\\": \\"09.02.2022\\",
    \\"endDate\\": \\"07.06.2022\\",
    \\"startExamsDate\\": \\"14.06.2022\\",
    \\"endExamsDate\\": \\"02.07.2022\\"
}

**Schedule (занятия)**

{
    \\"weekNumber\\": \[
      1,
      3
    \],
    \\"studentGroups\\": \[
      {
        \\"specialityName\\": \\"Информатика и технологии программирования\\",
        \\"specialityCode\\": \\"1-40 01 03\\",
        \\"numberOfStudents\\": 25,
        \\"name\\": \\"053503\\",
        \\"educationDegree\\": 1
      }
    \],
    //Если 0 - значит подгруппы у пары нету
    \\"numSubgroup\\": 1,
    \\"auditories\\": \[
      \\"111-4 к.\\"
    \],
    \\"startLessonTime\\": \\"09:00\\",
    \\"endLessonTime\\": \\"10:20\\",
    \\"subject\\": \\"ООП\\",
    \\"subjectFullName\\": \\"Объектно-ориентированное программирование\\",
    //Не стоит пропускать этот параметр.
    //Здесь может хранится важная информация о типе занятия или его переносе.
    //К примеру: ИнЯз. Занятие называется одинаково, но в поле note может фигурировать
    //название языка (к примеру: \\"французский\\", \\"английский\\" и др.)
    \\"note\\": null,
    //Типы занятий в основном: ЛК, ЛР, ПЗ
    \\"lessonTypeAbbrev\\": \\"ЛР\\",
    \\"dateLesson\\": null,
    \\"startLessonDate\\": \\"14.02.2022\\",
    \\"endLessonDate\\": \\"06.06.2022\\",
    \\"announcement\\": false,
    \\"split\\": false
    \\"employees\\": \[
      {
        \\"firstName\\": \\"Вадим\\",
        \\"lastName\\": \\"Владымцев\\",
        \\"middleName\\": \\"Денисович\\",
        \\"degree\\": \\"\\",
        \\"degreeAbbrev\\": \\"\\",
        \\"rank\\": null,
        \\"photoLink\\": \\"https://iis.bsuir.by/api/v1/employees/photo/536343\\",
        \\"calendarId\\": \\"k2ecr5nj6j3m45f3pk31ji7l1s@group.calendar.google.com\\",
        \\"id\\": 536343,
        \\"urlId\\": \\"v-vladymtsev\\",
        \\"email\\": null,
        \\"jobPositions\\": null
      }
    \],
}

**Schedule (экзамены)**

Нужно учитывать специфику расписания экзаменов у заочных групп: их экзаменационная сессия также содержит лекции, лабораторные и практические занятия.

{
    \\"weekNumber\\": \[
      2
    \],
    \\"studentGroups\\": \[
      {
        \\"specialityName\\": \\"Информатика и технологии программирования\\",
        \\"specialityCode\\": \\"1-40 01 03\\",
        \\"numberOfStudents\\": 25,
        \\"name\\": \\"053503\\",
        \\"educationDegree\\": 1
      }
    \],
    //Если 0 - значит подгруппы у пары нету
    \\"numSubgroup\\": 0,
    \\"auditories\\": \[
      \\"112-4 к.\\"
    \],
    \\"startLessonTime\\": \\"15:00\\",
    \\"endLessonTime\\": \\"16:00\\",
    \\"subject\\": \\"ИСП\\",
    \\"subjectFullName\\": \\"Инструменты и средства программирования\\",
    //Не стоит пропускать этот параметр.
    //Здесь может хранится важная информация о типе занятия или его переносе.
    //К примеру: ИнЯз. Занятие называется одинаково, но в поле note может фигурировать
    //название языка (к примеру: \\"французский\\", \\"английский\\" и др.)
    \\"note\\": null,
    //Типы занятий в основном: ЛК, ЛР, ПЗ, Консультация, Экзамен
    \\"lessonTypeAbbrev\\": \\"Консультация\\",
    \\"dateLesson\\": \\"14.06.2022\\",
    \\"startLessonDate\\": null,
    \\"endLessonDate\\": null,
    \\"announcement\\": false,
    \\"split\\": false,
    \\"employees\\": \[
      {
        \\"firstName\\": \\"Виталий\\",
        \\"lastName\\": \\"Бутома\\",
        \\"middleName\\": \\"Сергеевич\\",
        \\"degree\\": \\"\\",
        \\"degreeAbbrev\\": \\"\\",
        \\"rank\\": null,
        \\"photoLink\\": \\"https://iis.bsuir.by/api/v1/employees/photo/524912\\",
        \\"calendarId\\": \\"5busnevj7cj5214q3m6qqim8f4@group.calendar.google.com\\",
        \\"id\\": 524912,
        \\"urlId\\": \\"v-butoma\\",
        \\"email\\": null,
        \\"jobPositions\\": null
      }
    \],
}

Получение расписания преподавателя

Метод

HTTP запрос

Описание

GET

https://iis.bsuir.by/api/v1/employees/schedule/{urlId}, где urlId - строка, идентифицирующая преподавателя (например, s-nesterenkov)

HTTP-запрос на получение расписания преподавателя в формате JSON.

JSON

XML

**Пример ответа**

{
    \\"employeeDto\\": EmployeeDto,
    \\"studentGroupDto\\": null,
    \\"schedules\\": {
      \\"Понедельник\\": \[Schedule\],
      \\"Вторник\\": \[Schedule\],
      \\"Среда\\": \[Schedule\],
      \\"Четверг\\": \[Schedule\],
      \\"Пятница\\": \[Schedule\],
      \\"Суббота\\": \[Schedule\],
    },
    \\"exams\\": \[Schedule\],
    \\"startDate\\": null,
    \\"endDate\\": null,
    \\"startExamsDate\\": \\"13.05.2022\\",
    \\"endExamsDate\\": \\"07.12.2022\\"
}

**Employee**

{                         
  \\"firstName\\": \\"Сергей\\",
  \\"lastName\\": \\"Нестеренков\\",
  \\"middleName\\": \\"Николаевич\\",
  \\"degree\\": \\"кандидат технических наук\\",
  \\"degreeAbbrev\\": \\"к.т.н.\\",
  \\"email\\": null,
  \\"rank\\": \\"доцент\\",
  \\"photoLink\\": \\"https://iis.bsuir.by/api/v1/employees/photo/501822\\",
  \\"calendarId\\": \\"gipll6sb72aqkmsgjhnikl8e64@group.calendar.google.com\\",
  \\"id\\": 501822,
  \\"urlId\\": \\"s-nesterenkov\\",
  \\"jobPositions\\": null
}

**Schedule (занятия)**

{
    \\"weekNumber\\": \[
        3
    \],
    \\"studentGroups\\": \[
      {
        \\"specialityName\\": \\"Компьютерная инженерия\\",
        \\"specialityCode\\": \\"1-40 80 01\\",
        \\"numberOfStudents\\": 0,
        \\"name\\": \\"155841\\",
        \\"educationDegree\\": 2
      },
      {
        \\"specialityName\\": \\"Программная инженерия\\",
        \\"specialityCode\\": \\"1-40 80 05\\",
        \\"numberOfStudents\\": 0,
        \\"name\\": \\"156341\\",
        \\"educationDegree\\": 2
      }
    \],
    //Если 0 - значит подгруппы у пары нету
    \\"numSubgroup\\": 0,
    \\"auditories\\": \[
      \\"322а-5 к.\\"
    \],
    \\"startLessonTime\\": \\"14:00\\",
    \\"endLessonTime\\": \\"15:20\\",
    \\"subject\\": \\"ГиЭВ\\",
    \\"subjectFullName\\": \\"Генетические и эволюционные вычисления\\",
    //Не стоит пропускать этот параметр.
    //Здесь может хранится важная информация о типе занятия или его переносе.
    //К примеру: ИнЯз. Занятие называется одинаково, но в поле note может фигурировать
    //название языка (к примеру: \\"французский\\", \\"английский\\" и др.)
    \\"note\\": null,
    //Типы занятий в основном: ЛК, ЛР, ПЗ
    \\"lessonTypeAbbrev\\": \\"ЛК\\",
    \\"dateLesson\\": \\"23.05.2022\\",
    \\"startLessonDate\\": null,
    \\"endLessonDate\\": null,
    \\"announcement\\": false,
    \\"split\\": false,
    \\"employees\\": null,
}

**Schedule (экзамены)**

Нужно учитывать специфику расписания экзаменов у заочных групп: их экзаменационная сессия также содержит лекции, лабораторные и практические занятия.

{
    \\"weekNumber\\": \[
      2
    \],
    \\"studentGroups\\": \[
      {
        \\"specialityName\\": \\"Компьютерная инженерия\\",
        \\"specialityCode\\": \\"1-40 80 01\\",
        \\"numberOfStudents\\": 0,
        \\"name\\": \\"155841\\",
        \\"educationDegree\\": 2
      },
      {
        \\"specialityName\\": \\"Программная инженерия\\",
        \\"specialityCode\\": \\"1-40 80 05\\",
        \\"numberOfStudents\\": 0,
        \\"name\\": \\"156341\\",
        \\"educationDegree\\": 2
      }
    \],
    //Если 0 - значит подгруппы у пары нету
    \\"numSubgroup\\": 0,
    \\"auditories\\": \[
      \\"209-5 к.\\"
    \],
    \\"startLessonTime\\": \\"12:25\\",
    \\"endLessonTime\\": \\"15:20\\",
    \\"subject\\": \\"ГиЭВ\\",
    \\"subjectFullName\\": \\"Генетические и эволюционные вычисления\\",
    //Не стоит пропускать этот параметр.
    //Здесь может хранится важная информация о типе занятия или его переносе.
    //К примеру: ИнЯз. Занятие называется одинаково, но в поле note может фигурировать
    //название языка (к примеру: \\"французский\\", \\"английский\\" и др.)
    \\"note\\": null,
    //Типы занятий в основном: ЛК, ЛР, ПЗ, Консультация, Экзамен
    \\"lessonTypeAbbrev\\": \\"Экзамен\\",
    \\"dateLesson\\": \\"13.05.2022\\",
    \\"startLessonDate\\": \\"13.05.2022\\",
    \\"endLessonDate\\": \\"13.05.2022\\",
    \\"announcement\\": false,
    \\"split\\": false,
    \\"employees\\": null,
}

Получение списка всех групп

Метод

HTTP запрос

Описание

GET

https://iis.bsuir.by/api/v1/student-groups

Список всех групп.

JSON

XML

**Пример ответа**

\[  
{
  \\"name\\": \\"145241\\",
  \\"facultyId\\": 20035,
  \\"facultyName\\": \\"факультет радиотехники и электроники\\",
  \\"specialityDepartmentEducationFormId\\": 20572,
  \\"specialityName\\": \\"Радиосистемы и радиотехнологии\\",
  \\"course\\": 1,
  \\"id\\": 23514,
  \\"calendarId\\": \\"hnv3te2od9gsnshkh312c3r3ik@group.calendar.google.com\\"
}
...
\]

Получение списка всех преподавателей

Метод

HTTP запрос

Описание

GET

https://iis.bsuir.by/api/v1/employees/all

Список всех преподавателей.

JSON

XML

**Пример ответа**

\[
{
  \\"firstName\\": \\"Игорь\\",
  \\"lastName\\": \\"Абрамов\\",
  \\"middleName\\": \\"Иванович\\",
  \\"degree\\": \\"д.ф.-м.н.\\",
  \\"rank\\": \\"профессор\\",
  \\"photoLink\\": \\"https://iis.bsuir.by/api/v1/employees/photo/500434\\",
  \\"calendarId\\": \\"4t4b9qurekmm2nnb2tjjdcseq0@group.calendar.google.com\\",
  \\"academicDepartment\\": \[\\"каф.МиНЭ\\"\],
  \\"id\\": 500434,
  \\"urlId\\": \\"i-abramov\\",
  \\"fio\\": \\"Абрамов И. И. (профессор)\\"
}
...
\]

Получение списка всех факультетов

Метод

HTTP запрос

Описание

GET

https://iis.bsuir.by/api/v1/faculties

Список всех факультетов.

JSON

XML

**Пример ответа**

\[
  {
      \\"name\\": \\"военный факультет\\",
      \\"abbrev\\": \\"ВФ\\",
      \\"id\\": 20000
  },
  {
      \\"name\\": \\"инженерно-экономический факультет\\",
      \\"abbrev\\": \\"ИЭФ\\",
      \\"id\\": 20012
  },
  ...
\]

Получение списка всех кафедр

Метод

HTTP запрос

Описание

GET

https://iis.bsuir.by/api/v1/departments

Список всех кафедр.

JSON

XML

**Пример ответа**

\[
  {
      \\"id\\": 20036,
      \\"name\\": \\"Антенн и устройств СВЧ\\",
      \\"abbrev\\": \\"АиУСВЧ\\"
  },
  {
      \\"id\\": 20003,
      \\"name\\": \\"Белорусского и русского языков\\",
      \\"abbrev\\": \\"БиРЯ\\"
  },
  ...
\]

Получение списка всех специальностей

Метод

HTTP запрос

Описание

GET

https://iis.bsuir.by/api/v1/specialities

Список всех специальностей.

JSON

XML

**Пример ответа**

\[
  {
      \\"id\\": 20002,
      \\"name\\": \\"Автоматизированные системы обработки информации\\",
      \\"abbrev\\": \\"АСОИ\\",
      \\"educationForm\\": \[EducationForm\],
      \\"facultyId\\": 20005,
      \\"code\\": \\"1-53 01 02\\"
  },
  ...
\]

**EducationForm**

{
  \\"id\\": 1,
  \\"name\\": \\"дневная\\"  
}

Получение списка всех актуальных объявлений преподавателя

Метод

HTTP запрос

Описание

GET

https://iis.bsuir.by/api/v1/announcements/employees?url-id={urlId}, где urlId - строка, идентифицирующая преподавателя (например, s-nesterenkov)

Список всех актуальных объявлений преподавателя.

JSON

XML

**Пример ответа**

\[
  {
      \\"id\\": 254,
      \\"employee\\": \\"Нестеренков С. Н. (доцент)\\",
      \\"content\\": \\"Пересдача зачета 85350\* в 8.00 ауд. 108-4\\",
      \\"date\\": \\"21.03.2022\\",
      \\"employeeDepartments\\": \[
          \\"каф.ПОИТ\\",
          \\"ОИТ\\",
          \\"деканат ФКСС\\"
      \],
      \\"studentGroups\\": \[
          {
              \\"id\\": 22756,
              \\"name\\": \\"853501\\"
          },
          {
              \\"id\\": 22757,
              \\"name\\": \\"853502\\"
          },
          ...
      \]
  },
  ...
\]

Получение списка всех актуальных объявлений кафедры

Метод

HTTP запрос

Описание

GET

https://iis.bsuir.by/api/v1/announcements/departments?id={id}, где id - идентификатор кафедры (например, 20027)

Список всех актуальных объявлений кафедры (ответ идентичен списку актуальных объявлений преподавателя).

JSON

XML

**Пример ответа**

\[
  {
      \\"id\\": 254,
      \\"employee\\": \\"Нестеренков С. Н. (доцент)\\",
      \\"content\\": \\"Пересдача зачета 85350\* в 8.00 ауд. 108-4\\",
      \\"date\\": \\"21.03.2022\\",
      \\"employeeDepartments\\": \[
          \\"каф.ПОИТ\\",
          \\"ОИТ\\",
          \\"деканат ФКСС\\"
      \],
      \\"studentGroups\\": \[
          {
              \\"id\\": 22756,
              \\"name\\": \\"853501\\"
          },
          {
              \\"id\\": 22757,
              \\"name\\": \\"853502\\"
          },
          ...
      \]
  },
  ...
\]

Получение списка всех аудиторий

Метод

HTTP запрос

Описание

GET

https://iis.bsuir.by/api/v1/auditories

Список всех аудиторий.

JSON

XML

**Пример ответа**

\[
  {
      \\"id\\": 1,
      \\"name\\": \\"104\\",
      \\"note\\": \\"\\",
      \\"capacity\\": null,
      \\"auditoryType\\": {
          \\"id\\": 1,
          \\"name\\": \\"лекционная\\",
          \\"abbrev\\": \\"лк\\"
      },
      \\"buildingNumber\\": {
          \\"id\\": 4,
          \\"name\\": \\"4 к.\\"
      },
      \\"department\\": {
          \\"idDepartment\\": 127,
          \\"abbrev\\": \\"ОТСО\\",
          \\"name\\": \\"отдел технических средств обучения\\",
          \\"nameAndAbbrev\\": \\"отдел технических средств обучения (ОТСО)\\"
      }
  },
...
\]

Получение последнего обновления расписания

Метод

HTTP запрос

Описание

GET

https://iis.bsuir.by/api/v1/last-update-date/student-group?groupNumber={groupNumber}, где groupNumber - номер группы

https://iis.bsuir.by/api/v1/last-update-date/student-group?id={sgId}, где sgId - идентификатор группы

https://iis.bsuir.by/api/v1/last-update-date/employee?url-id={urlId}, где urlId - строка, идентифицирующая преподавателя (например, s-nesterenkov)

https://iis.bsuir.by/api/v1/last-update-date/employee?id={empId}, где empId - идентификатор преподавателя

Дата последнего обновления расписания.

JSON

XML

**Пример ответа**

{
  \\"lastUpdateDate\\": \\"23.02.2022\\"
}

Получение текущей недели

Метод

HTTP запрос

Описание

GET

https://iis.bsuir.by/api/v1/schedule/current-week

Получение текущей недели.

JSON

XML

**Пример ответа**

2

"
