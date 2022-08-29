CREATE TABLE IF NOT EXISTS "clients" (
    "id" SERIAL PRIMARY KEY,
    "login" VARCHAR(32) NOT NULL,
    "email" VARCHAR(32) NOT NULL
);

CREATE TABLE IF NOT EXISTS "orders" (
    "id" SERIAL PRIMARY KEY,
    "client_id" INTEGER,
    FOREIGN KEY ("client_id") REFERENCES "clients" ("id")
);

CREATE TABLE IF NOT EXISTS "nomenclature" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(64) NOT NULL,
    "cost" DECIMAL(14, 2),
    "amount" INTEGER
);

CREATE TABLE IF NOT EXISTS "catalog" (
    "id" SERIAL PRIMARY KEY,
    "parent_id" INTEGER,
    "nomenclature_id" INTEGER,
    FOREIGN KEY ("parent_id") REFERENCES "catalog" ("id"),
    FOREIGN KEY ("nomenclature_id") REFERENCES "nomenclature" ("id")
);

CREATE TABLE IF NOT EXISTS "order_nomenclature" (
    "id" SERIAL PRIMARY KEY,
    "nomenclature_id" INTEGER,
    "orders_id" INTEGER,
    FOREIGN KEY ("nomenclature_id") REFERENCES "nomenclature" ("id"),
    FOREIGN KEY ("orders_id") REFERENCES "orders" ("id"),
    "amount" INTEGER
);

INSERT INTO "clients" ("id", "login", "email") VALUES
    (1, 'Fedor', '1@mail.ru'),
    (2, 'Alex', '2@mail.ru');

INSERT INTO "nomenclature" ("id", "name", "cost", "amount") VALUES
    (3, 'Бытовая техника', null, null),
    (8, 'Компьютеры', null, null),
    (1, 'Стиральная машина', '14000', '5'),
    (2, 'Ноутбук 17“', '40000', '10');

INSERT INTO "catalog" ("id", "parent_id", "nomenclature_id") VALUES
    (4, null, 3),
    (5, null, 8),
    (6, 4, 1),
    (7, 5, 2);

INSERT INTO "orders" ("id", "client_id") VALUES
    (1, '1'),
    (2, '2');

INSERT INTO "order_nomenclature" ("id", "nomenclature_id", "orders_id", "amount") VALUES
(1, 1, 1, 1),
(2, 2, 1, 1),
(3, 2, 2, 2);

Получение информации о сумме товаров заказанных под каждого клиента 
(Наименование клиента, сумма):
SELECT 
c.login,
SUM(onc.amount)             AS total
FROM     clients            AS c
LEFT JOIN orders             AS o
ON        o.client_id         = c.id
LEFT JOIN order_nomenclature AS onc
ON        onc.orders_id       = o.id

GROUP BY c.login;

Найти количество дочерних элементов первого уровня вложенности 
для категорий номенклатуры:

WITH parentCatalog AS (
  SELECT * FROM "catalog" WHERE parent_id IS NULL
)
SELECT
  parentCatalog.id,
  COUNT(ca.id)
FROM catalog AS ca, parentCatalog
WHERE ca.parent_id = parentCatalog.id
GROUP BY parentCatalog.id;