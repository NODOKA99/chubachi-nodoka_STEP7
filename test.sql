-- 設問1. すべてのユーザー情報を取得するSQLを書いてください。
SELECT * FROM users;


-- 設問2. 2024年に作成されたユーザーを取得するSQLを書いてください。
SELECT * FROM users WHERE YEAR(created_at) = 2024;
-- ※もし上記でエラーが出る場合は、以下のBETWEENを使った書き方でも大丈夫です
-- SELECT * FROM users WHERE created_at BETWEEN '2024-01-01' AND '2024-12-31';


-- 設問3. 30歳未満かつ女性のユーザーを取得するSQLを書いてください。
SELECT * FROM users WHERE age < 30 AND gender = 'female';


-- 設問4. 全商品の一覧（商品名と価格）を取得するSQLを書いてください。
SELECT product_name, price FROM products;


-- 設問5. ordersとusersを結合し、ユーザー名と注文日を取得するSQLを書いてください。
SELECT users.name, orders.order_date
FROM orders
JOIN users ON orders.user_id = users.id;


-- 設問6. order_itemsとproductsを結合し、各明細ごとに商品名と数量、単価、金額（単価×数量）を取得するSQLを書いてください。
SELECT products.product_name, order_items.quantity, products.price AS 単価, (products.price * order_items.quantity) AS 金額
FROM order_items
JOIN products ON order_items.product_id = products.id;


-- 設問7. ユーザーごとの注文件数を取得するSQLを書いてください。
SELECT users.name, COUNT(orders.id) AS 注文件数
FROM users
LEFT JOIN orders ON users.id = orders.user_id
GROUP BY users.id, users.name;


-- 設問8. 各ユーザーの総購入金額（明細の合計）を取得するSQLを書いてください。
SELECT users.name, SUM(products.price * order_items.quantity) AS 総購入金額
FROM users
JOIN orders ON users.id = orders.user_id
JOIN order_items ON orders.id = order_items.order_id
JOIN products ON order_items.product_id = products.id
GROUP BY users.id, users.name;


-- 設問9. 最も注文金額が高かったユーザーの名前と金額を取得するSQLを書いてください。
SELECT users.name, SUM(products.price * order_items.quantity) AS 総購入金額
FROM users
JOIN orders ON users.id = orders.user_id
JOIN order_items ON orders.id = order_items.order_id
JOIN products ON order_items.product_id = products.id
GROUP BY users.id, users.name
ORDER BY 総購入金額 DESC
LIMIT 1;


-- 設問10. 各商品が何回注文されたか（order_itemsの合計数量）を取得するSQLを書いてください。
SELECT products.product_name, SUM(order_items.quantity) AS 合計数量
FROM products
LEFT JOIN order_items ON products.id = order_items.product_id
GROUP BY products.id, products.product_name;

-- 設問11. 注文が1回もないユーザーを取得するSQLを書いてください。
SELECT users.*
FROM users
LEFT JOIN orders ON users.id = orders.user_id
WHERE orders.id IS NULL;


-- 設問12. 1回の注文で2種類以上の商品を購入した注文のIDを取得するSQLを書いてください。
SELECT order_id
FROM order_items
GROUP BY order_id
HAVING COUNT(DISTINCT product_id) >= 2;


-- 設問13. 「テレビ」という商品を注文したすべてのユーザー名を取得するSQLを書いてください。
SELECT DISTINCT users.name
FROM users
JOIN orders ON users.id = orders.user_id
JOIN order_items ON orders.id = order_items.order_id
JOIN products ON order_items.product_id = products.id
WHERE products.product_name = 'テレビ';


-- 設問14. 明細ごとの注文日・ユーザー名・商品名・数量・合計金額を一瞬で取得するSQLを書いてください。
SELECT orders.order_date, users.name AS ユーザー名, products.product_name, order_items.quantity, (products.price * order_items.quantity) AS 合計金額
FROM order_items
JOIN orders ON order_items.order_id = orders.id
JOIN users ON orders.user_id = users.id
JOIN products ON order_items.product_id = products.id;


-- 設問15. 最も多く購入された商品（数量ベース）の商品名を取得するSQLを書いてください。
SELECT products.product_name
FROM products
JOIN order_items ON products.id = order_items.product_id
GROUP BY products.id, products.product_name
ORDER BY SUM(order_items.quantity) DESC
LIMIT 1;


-- 設問16. 各月の注文件数を取得するSQLを書いてください（order_dateの年月を使う）。
SELECT DATE_FORMAT(order_date, '%Y-%m') AS 年月, COUNT(id) AS 注文件数
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m');


-- 設問17. 注文のない商品を取得するSQLを書いてください。
SELECT products.*
FROM products
LEFT JOIN order_items ON products.id = order_items.product_id
WHERE order_items.id IS NULL;


-- 設問18. order_items.product_id にインデックスを追加するSQLを書いてください。
ALTER TABLE order_items ADD INDEX idx_product_id(product_id);


-- 設問19. ユーザーごとの平均注文金額を取得するSQLを書いてください。
-- ※「1回の注文あたりの平均金額」を出すクエリです
SELECT users.name, AVG(order_total.total_price) AS 平均注文金額
FROM users
JOIN orders ON users.id = orders.user_id
JOIN (
    SELECT order_id, SUM(products.price * order_items.quantity) AS total_price
    FROM order_items
    JOIN products ON order_items.product_id = products.id
    GROUP BY order_id
) AS order_total ON orders.id = order_total.order_id
GROUP BY users.id, users.name;


-- 設問20. 各ユーザーの最新注文日のみを取得するSQLを書いてください。
SELECT users.name, MAX(orders.order_date) AS 最新注文日
FROM users
JOIN orders ON users.id = orders.user_id
GROUP BY users.id, users.name;

-- 設問21. 新規ユーザー「中村愛（25歳・女性・2025-06-01作成）」をusersテーブルに追加するSQLを書いてください。
-- ※既存のデータがID 5までなので、IDを6として追加します
INSERT INTO users (id, name, age, gender, created_at)
VALUES (6, '中村愛', 25, 'female', '2025-06-01');


-- 設問22. 商品「エアコン（価格：60000円）」をproductsテーブルに追加するSQLを書いてください。
-- ※設問24の指示に合わせて商品IDを6として追加します
INSERT INTO products (id, product_name, price)
VALUES (6, 'エアコン', 60000);


-- 設問23. ユーザーIDが1の人が2025-06-10に行った新しい注文（orders）を追加するSQLを書いてください。注文IDは10とします。
INSERT INTO orders (id, user_id, order_date)
VALUES (10, 1, '2025-06-10');


-- 設問24. 上記の注文（注文ID：10）に対して、「エアコン（商品ID：6）」を1つ購入したことを表すorder_itemsを追加するSQLを書いてください。
-- ※既存の明細がID 9までなので、明細IDを10として追加します
INSERT INTO order_items (id, order_id, product_id, quantity)
VALUES (10, 10, 6, 1);


-- 設問25. ユーザー「田中美咲」の年齢を23歳から24歳に更新するSQLを書いてください。
UPDATE users
SET age = 24
WHERE name = '田中美咲';


-- 設問26. 全ての商品価格を10%値上げするSQLを書いてください。
UPDATE products
SET price = price * 1.1;


-- 設問27. 2024年5月以前（5月1日より前（4月末まで））に行われた注文（orders）のorder_dateをすべて「2024-05-01」に統一する（更新する）SQLを書いてください。
UPDATE orders
SET order_date = '2024-05-01'
WHERE order_date < '2024-05-01';


-- 設問28. ユーザー名が「高橋健一」のレコードをusersテーブルから削除するSQLを書いてください。※関連する注文や明細はそのまま。
DELETE FROM users
WHERE name = '高橋健一';


-- 設問29. 注文IDが5の明細（order_items）をすべて削除するSQLを書いてください。
DELETE FROM order_items
WHERE order_id = 5;


-- 設問30. 一度も注文されたことのない商品をproductsテーブルから削除するSQLを書いてください。
DELETE FROM products
WHERE id NOT IN (SELECT DISTINCT product_id FROM order_items);
