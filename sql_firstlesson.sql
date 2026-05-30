CREATE TABLE book(
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author VARCHAR(30),
    price DECIMAL(8, 2),
    amount INT
);

SELECT title AS Название, author AS Автор FROM book;

SELECT title, amount,
       amount * 1.65 AS pack
FROM book;

/* В конце года цену каждой книги на складе пересчитывают – снижают ее на 30%. Написать SQL запрос, который из таблицы book выбирает названия, авторов, количества и вычисляет новые цены книг. Столбец с новой ценой назвать new_price, цену округлить до 2-х знаков после запятой. */

SELECT title, author, amount,
     ROUND(price * 0.70,2) AS new_price
FROM book;


SELECT title, amount, price,
    ROUND(
     IF(amount < 4, price * 0.5, 
         IF(amount < 11, price * 0.7, price * 0.9)),
     2) AS sale,
    IF(amount < 4, 'скидка 50%', 
      IF(amount < 11, 'скидка 30%', 'скидка 10%')
     ) AS Ваша_скидка
FROM book;

SELECT author, title,
      ROUND(
          IF(author = 'Булгаков М.А.', price * 1.1,
             IF(author = 'Есенин С.А.', price * 1.05, price)),
          2) AS new_price
FROM book;


SELECT title, author, price, amount
FROM book
WHERE (price<500 OR price>600) and (amount * price >= 5000);


/* Вывести название и авторов тех книг, цены которых принадлежат интервалу от 540.50 до 800 (включая границы),  а количество или 2, или 3, или 5, или 7 .  */

SELECT title, author
FROM book
WHERE (price BETWEEN 540.50 AND 800) AND amount IN (2, 3, 5, 7);



/* Вывести  автора и название  книг, количество которых принадлежит интервалу от 2 до 14 (включая границы). Информацию  отсортировать сначала по авторам (в обратном алфавитном порядке), а затем по названиям книг (по алфавиту). */

SELECT author, title
FROM book
WHERE amount BETWEEN 2 AND 14
ORDER BY author DESC, title ASC;

SELECT title, author
FROM book
WHERE title LIKE '_% _%'
   AND author LIKE '%С.%'
ORDER BY title;

SELECT
      'Донцова Дарья' AS author,
      CONCAT('Евлампия Романова и ', title) AS title,
      ROUND(price * 1.42, 2) as price
FROM book
ORDER BY price, title DESC;
     

SELECT author, MIN(price) AS Минимальная_цена, MAX(price) AS Максимальная_цена, AVG(price) AS Средняя_цена
FROM book
GROUP BY author;  

SELECT author,
       SUM(price*amount) AS Стоимость,
       ROUND(SUM(price*amount)*(18/118),2) AS НДС,
       ROUND(SUM(price*amount)/1.18,2) AS Стоимость_без_НДС
FROM book
GROUP BY author;

SELECT MIN(price) AS Минимальная_цена, MAX(price) AS Максимальная_цена, ROUND(AVG(price),2) AS Средняя_цена
FROM book;

SELECT ROUND(AVG(price),2) AS Средняя_цена, ROUND(SUM(price*amount),2) AS Стоимость 
FROM book
WHERE amount BETWEEN 5 AND 14;

SELECT author,
    SUM(price*amount) AS Стоимость
FROM book
WHERE title <> 'Идиот' AND title <> 'Белая гвардия'
GROUP BY author
HAVING SUM(price*amount) > 5000
ORDER BY Стоимость DESC;
        

SELECT SUM(price) AS Стоимость_всех_книг_по_одному_экз, count(title) AS Количество_купленных_книг
FROM book;

SELECT author, title, price
FROM book
WHERE price <= (
        SELECT AVG(price)
        FROM book
    )
ORDER BY price DESC;


SELECT author, title, price
FROM book
WHERE price <= (
    SELECT MIN(price)
    FROM book
    ) + 150
ORDER BY price;



SELECT author, title, amount
FROM book
WHERE amount IN (
    SELECT amount
    FROM book
    GROUP BY amount
    HAVING COUNT(amount)=1
    );


SELECT author, title, price
FROM book
WHERE price < ANY(
        SELECT MIN(price)
        FROM book
        GROUP BY author
        );


SELECT title, author, amount,
    (
     SELECT MAX(amount)
     FROM book
     ) - amount AS Заказ
FROM book
WHERE amount<(SELECT MAX(amount) FROM book);



SELECT  *, round((100*price*amount/(SELECT SUM(price*amount) FROM book)), 2) AS income_percent
FROM book
ORDER BY income_percent DESC;








