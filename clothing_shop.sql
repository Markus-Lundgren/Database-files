-- ============================================
-- 1) Lista 100 kunder med deras för- och efternamn.
--    (En enkel SELECT för att bekanta sig med tabellen Customer)
-- ============================================

-- Resultat (första 5 av 100 rader):
-- +-------+----------+
-- | FName | LName    |
-- +-------+----------+
-- | Ida   | Berglund |
-- | Johan | Engström |
-- | Signe | Holm     |
-- | Lena  | Nyström  |
-- | Jonas | Ström    |
-- +-------+----------+
select c.FName, c.LName from Customer c
limit 100;

-- ============================================
-- 2) Lista 100 produkter med deras namn och kategori-ID.
--    (Ger en överblick över vilka produkter som finns och vilken kategori de tillhör)
-- ============================================

-- Resultat (första 5 av 100 rader):
-- +----+------------------------+------------+
-- | Id | Name                   | CategoryId |
-- +----+------------------------+------------+
-- |  1 | Active Leather Sneaker |          2 |
-- |  2 | Alpine Mesh Sneaker    |          2 |
-- |  3 | Alpine Runner Sneaker  |          2 |
-- |  4 | City Leather Sneaker   |          2 |
-- |  5 | City Mesh Sneaker      |          2 |
-- +----+------------------------+------------+
select p.Name, p.CategoryId from Product p limit 100;

-- ============================================
-- 3) Lista alla kunder som bor i Malmö.
--    Lista sedan alla kunder i Malmö som bor på en gata vars namn slutar
--    på 'gatan' (t.ex. 'Storgatan 12').
--    (Träna på WHERE och LIKE för att filtrera resultat)
-- ============================================

-- Resultat alla i Malmö (första 5 av 1985 rader):
-- +-------+-----------+------------------+-------+
-- | FName | LName     | Address          | City  |
-- +-------+-----------+------------------+-------+
-- | Johan | Engström  | Sveavägen 58     | Malmö |
-- | Liam  | Andersson | Kungsgatan 10    | Malmö |
-- | Anna  | Magnusson | Vintergatan 55   | Malmö |
-- | Johan | Svensson  | Industrivägen 44 | Malmö |
-- | Lena  | Holm      | Storgatan 125    | Malmö |
-- +-------+-----------+------------------+-------+

-- Resultat Malmö + gata som slutar på 'gatan' (första 5 av 1180 rader):
-- +-------+-----------+-------------------+-------+
-- | FName | LName     | Address           | City  |
-- +-------+-----------+-------------------+-------+
-- | Liam  | Andersson | Kungsgatan 10     | Malmö |
-- | Anna  | Magnusson | Vintergatan 55    | Malmö |
-- | Lena  | Holm      | Storgatan 125     | Malmö |
-- | Peter | Bengtsson | Drottninggatan 37 | Malmö |
-- | Ida   | Engström  | Kungsgatan 38     | Malmö |
-- +-------+-----------+-------------------+-------+
select c.FName, c.LName, c.Address, c.City from Customer c
where c.City = 'Malmö' and c.Address like '%gatan%';

-- ============================================
-- 4) Visa alla varianter med tillhörande produktnamn.
--    (Träna på JOIN – kombinera Variant med Product för att visa fullständig information)
-- ============================================

-- Resultat (första 5 av 1358 rader):
-- +-----------+---------------+------------------------+
-- | VariantId | VariantName   | ProductName            |
-- +-----------+---------------+------------------------+
-- |         1 | 37 - khaki    | Active Leather Sneaker |
-- |         2 | 39 - marinblå | Active Leather Sneaker |
-- |         3 | 40 - khaki    | Active Leather Sneaker |
-- |         4 | 42 - marinblå | Active Leather Sneaker |
-- |         5 | 43 - khaki    | Active Leather Sneaker |
-- +-----------+---------------+------------------------+

select p.Name, v.Name from Variant v
join Product p on v.ProductId = p.Id;
-- ============================================
-- 5) Vilka storlekar säljer mest?
--    Räkna antal sålda enheter i storlek M.
--    (Storleken står först i Variant.Name, t.ex. 'M - svart'.
--     Tips: använd WHERE v.Name LIKE 'M -%')
--    Gör sedan samma sak för XS, S, L, XL och XXL.
--
--    Gör samma sak för några skostorlekar, t.ex. 36, 41 och 46.
--    Drag slutsatser: ska affären köpa in lika många av varje storlek?
-- ============================================

-- Resultat storlek M:
-- +--------------+
-- | SaldaEnheter |
-- +--------------+
-- |        15886 |
-- +--------------+

-- Resultat skostorlek 36:
-- +--------------+
-- | SaldaEnheter |
-- +--------------+
-- |          122 |
-- +--------------+
select sum(prTO.Quantity) from ProductToOrder prTO
join Variant v on prTO.VariantId = v.Id
where v.Name like 'M -%'; -- 13806 M, 3953 XS, 8770 S, 12714 L, 7846 XL, 4118 XXL, 110 36, 2327 41, 122 46

-- ============================================
-- 6) Räkna antal returer per returstatus.
--    (Ger en bild av hur returerna fördelas mellan olika statusar)
--
--    Drag slutsatser, vad spelar detta för roll för affären? (Logistik, lagerhantering?)
--    Finns det mer data om returer som vore intressant att analysera om just detta?
-- ============================================

-- Resultat (alla 5 rader):
-- +------------------+-------------+
-- | ReturnStatus     | ReturnCount |
-- +------------------+-------------+
-- | Återbetald       |        5803 |
-- | Avslagen         |         541 |
-- | Godkänd          |          36 |
-- | Under granskning |          27 |
-- | Inkommen         |           8 |
-- +------------------+-------------+
select count(rs.Id) as Returns, rs.Name from `Return` r
join ReturnStatus rs on r.ReturnStatusId = rs.Id
group by rs.Name
order by Returns desc;


-- ============================================
-- 7) Vilken kund har lagt flest beställningar?
--    (Räkna antal ordrar per kund)
-- ============================================

-- Resultat (första 5 av 20 rader):
-- +---------------+------------+
-- | Customer      | OrderCount |
-- +---------------+------------+
-- | Karin Larsson |         32 |
-- | Sofia Åberg   |         30 |
-- | Liam Olsson   |         27 |
-- | Erik Holm     |         26 |
-- | Liam Holm     |         26 |
-- +---------------+------------+
select concat(c.FName, ' ', c.LName) as Customer, count(co.CustomerId) orderCount from Customer c
join COrder co on co.CustomerId = c.Id
group by c.Id
order by orderCount desc;

-- ============================================
-- 8) Lagersaldo per kategori.
--    (Summera Variant.Stock per produktkategori)
-- ============================================

-- Resultat lager per kategori (första 5 av 26 rader):
-- +----------+-------------+
-- | Category | StockOnHand |
-- +----------+-------------+
-- | Sneakers |         895 |
-- | T-shirt  |         844 |
-- | Jeans    |         840 |
-- | Hoodie   |         697 |
-- | Sandaler |         676 |
-- +----------+-------------+
select sum(v.Stock) lagersaldo,
       pc.Name from Variant v
join Product p on v.ProductId = p.Id
join ProductCategory pc on p.CategoryId = pc.Id
group by pc.Name
order by lagersaldo desc;

select pc.Name,
       sum(PtoO.Quantity) as Sold
from ProductToOrder PtoO
join Variant v on PtoO.VariantId = v.Id
join COrder co on PtoO.OrderId = co.Id
join Product p on v.ProductId = p.Id
join ProductCategory pc on p.CategoryId = pc.Id
where co.CreatedDate between '2026-08-26' - interval 1 year and '2026-08-26'
group by pc.Name
order by Sold desc;


-- ============================================
-- 9) Räkna ut de 10 bäst säljande produkterna.
--    (Summera antal sålda enheter per produktnamn)
--    Drag slutsatser, vad spelar detta för roll för affären? (Rabatter, kampanjer?)
-- ============================================

-- Resultat (första 5 av 10 rader):
-- +-------------------------+-----------+
-- | ProductName             | UnitsSold |
-- +-------------------------+-----------+
-- | Core Tech Tee           |      2730 |
-- | Alpine Flannel Jeans    |      2454 |
-- | City Brushed Hoodie     |      2301 |
-- | Coastal Leather Sneaker |      2120 |
-- | Harbor Cotton Knit      |      1952 |
-- +-------------------------+-----------+
select sum(prTO.Quantity) sold,
       p.Name from ProductToOrder prTO
join Variant v on prTO.VariantId = v.Id
join Product p on v.ProductId = p.Id
group by p.Name
order by sold desc
limit 10;

-- ============================================
-- 10) Top 10 kunder som butiken tjänar mest pengar på
--    (Summera alla deras ordervärden)
-- Vi vill ha ders namn och email. De ska få bonuskoder!
-- ============================================

-- Resultat (första 5 av 10 rader):
-- +----------------+-------------------------------+------------+
-- | Customer       | Email                         | TotalSpent |
-- +----------------+-------------------------------+------------+
-- | Karin Larsson  | karin.larsson3427@example.se  |   67230.00 |
-- | Peter Holm     | peter.holm7667@example.se     |   61270.00 |
-- | Lena Bengtsson | lena.bengtsson4275@example.se |   51185.00 |
-- | Maja Holm      | maja.holm4817@example.se      |   49885.00 |
-- | Liam Lindqvist | liam.lindqvist9528@example.se |   49775.00 |
-- +----------------+-------------------------------+------------+
select concat(c.FName, ' ', c.LName) as Customer,
       c.Email as Email,
       sum(prO.UnitPrice * prO.Quantity) as TotalSpent
from Customer c
join COrder co on c.Id = co.CustomerId
join ProductToOrder prO on co.Id = prO.OrderId
group by c.Id
order by TotalSpent desc
limit 10;

-- ============================================
-- 11) Hitta de 5 mest returnerade produkterna.
--    (Summera antal returnerade enheter per produktnamn)
-- ============================================

-- Resultat (alla 5 rader):
-- +-------------------------+-------------+
-- | ProductName             | QtyReturned |
-- +-------------------------+-------------+
-- | Alpine Flannel Jeans    |         299 |
-- | Studio Wool Jacket      |         255 |
-- | Coastal Leather Sneaker |         233 |
-- | Harbor Cotton Knit      |         191 |
-- | Core Tech Tee           |         176 |
-- +-------------------------+-------------+
select sum(r.QuantityReturned) TotalReturned,
       p.Name
from `Return` r
join ProductToOrder PtoO on r.PToOId = PtoO.Id
join Variant v on PtoO.VariantId = v.Id
join Product p on v.ProductId = p.Id
group by p.Name
order by TotalReturned desc
limit 5;

-- ============================================
-- 12) Räkna ut hur stor ANDEL av de sålda enheterna som returneras, per kategori.
--    (Summera sålda enheter och returnerade enheter per kategori, räkna sedan ut procenten)
--
-- Jämför med fråga 11 - blir det samma ranking? Varför/varför inte?
-- Vilka kategorier sticker ut? Vad kan det bero på?
-- Vad skulle affären kunna göra åt de kategorier som sticker ut?
-- ============================================

-- Resultat (första 5 av 26 rader):
-- +----------+--------------+--------------------+-------------------+
-- | Kategori | SaldaEnheter | ReturneradeEnheter | ReturandelProcent |
-- +----------+--------------+--------------------+-------------------+
-- | Boots    |         2421 |                525 |              21.7 |
-- | Jacka    |         3467 |                579 |              16.7 |
-- | Kappa    |         1891 |                284 |              15.0 |
-- | Dunjacka |         1308 |                165 |              12.6 |
-- | Jeans    |         8055 |                934 |              11.6 |
-- +----------+--------------+--------------------+-------------------+
select sum(r.QuantityReturned)/sum(PtoO.Quantity) * 100 returnPercent,
       pc.Name
from ProductToOrder PtoO
left join `Return` r on r.PToOId = PtoO.Id
join Variant v on PtoO.VariantId = v.Id
join Product p on v.ProductId = p.Id
join ProductCategory pc on p.CategoryId = pc.Id
group by pc.Name
order by returnPercent desc;

-- ============================================
-- 13) Varianter som aldrig har sålts.
--    (LEFT JOIN mot ProductToOrder och filtrera där pto saknas)
--
-- Vilka kategorier tillhör de? Hur mycket lager ligger det på dem?
-- Är det bara ovanliga storlekar, eller finns det hela produkter som aldrig sålts?
-- Vad kostar det affären att ha dem kvar?
-- ============================================

-- Resultat (första 5 av 71 rader):
-- +-----------+---------------------+--------------+-------+
-- | Kategori  | Produkt             | Variant      | Lager |
-- +-----------+---------------------+--------------+-------+
-- | Badkläder | Active Swim Shorts  | XS - blå     |     4 |
-- | Bälte     | Active Canvas Belt  | S/M - svart  |     8 |
-- | Bälte     | Active Canvas Belt  | L/XL - svart |     5 |
-- | Bälte     | Alpine Leather Belt | S/M - khaki  |    12 |
-- | Bälte     | Alpine Leather Belt | L/XL - vit   |    15 |
-- +-----------+---------------------+--------------+-------+
select pc.Name as Kategori,
       p.Name as Produkt,
       v.Name as Variant,
       v.Stock as Lager
from Variant v
left join ProductToOrder PtoO on v.Id = PtoO.VariantId
join Product p on v.ProductId = p.Id
join ProductCategory pc on p.CategoryId = pc.Id
where PtoO.VariantId is null
order by Produkt;

-- ============================================
-- 14) Räkna ut antal orderrader per år och månad
--    (Visar aktivitetsnivå i olika perioder)
--
-- Visualisera på valfritt vis.
-- Drag slutsatser. Vad säger detta om affären och försäljningen?
-- Visa Krister
-- ============================================

-- Resultat (första 5 av 56 rader):
-- +------+-------+------------+
-- | Year | Month | OrderLines |
-- +------+-------+------------+
-- | 2022 |     1 |        608 |
-- | 2022 |     2 |        571 |
-- | 2022 |     3 |        708 |
-- | 2022 |     4 |        849 |
-- | 2022 |     5 |       1066 |
-- +------+-------+------------+

select year(co.CreatedDate) as Year,
       month(co.CreatedDate) as Month,
       count(PtoO.Id) as OrderLines
from COrder co
join ProductToOrder PtoO on co.Id = PtoO.OrderId
group by Year, Month;

-- ============================================
-- 15) Räkna ut vilka månader då försäljningen går som bäst
--    (Summera total försäljning per år och månad)
--
-- Visualisera på valfritt vis.
-- Drag slutsatser. Vad säger detta om affären och försäljningen?
-- Visa Krister
-- ============================================

-- Resultat (första 5 av 56 rader):
-- +------+-------+--------------+
-- | Year | Month | MonthlySales |
-- +------+-------+--------------+
-- | 2025 |    12 |   2581995.00 |
-- | 2025 |    11 |   2404195.00 |
-- | 2024 |    12 |   2082730.00 |
-- | 2024 |    11 |   2054295.00 |
-- | 2026 |     5 |   1878220.00 |
-- +------+-------+--------------+

select year(co.CreatedDate) as Year,
       month(co.CreatedDate) as Month,
       sum(PtoO.UnitPrice * PtoO.Quantity) as MonthlySales
from COrder co
join ProductToOrder PtoO on co.Id = PtoO.OrderId
group by Year, Month
order by MonthlySales desc;

-- ============================================
-- 16) Jämför resultaten i fråga 14 och 15. Vad säger detta?
-- Senare månader säljer mycket samt att försäljningen har ökat under dem senare åren i jämförelse med tidigare år
-- ============================================


-- ============================================
-- 17) Summera försäljningen per år. Växer eller krymper affären?
--    (GROUP BY på år)
--
-- Titta NOGA på resultatet innan du svarar. Är alla år jämförbara?
-- Tips: ta med första och sista orderdatum för varje år i resultatet.
-- Drag slutsatser. Visa Krister.
-- ============================================

-- Resultat (alla 5 rader):
-- +------+-------------+-------------+-------------+------------+
-- | Ar   | AntalOrdrar | Forsaljning | ForstaOrder | SistaOrder |
-- +------+-------------+-------------+-------------+------------+
-- | 2022 |        6231 |  9539190.00 | 2022-01-06  | 2022-12-31 |
-- | 2023 |        7652 | 12487005.00 | 2023-01-01  | 2023-12-31 |
-- | 2024 |        9045 | 15437000.00 | 2024-01-01  | 2024-12-31 |
-- | 2025 |       10452 | 18965415.00 | 2025-01-01  | 2025-12-31 |
-- | 2026 |        6940 | 12849300.00 | 2026-01-01  | 2026-08-26 |
-- +------+-------------+-------------+-------------+------------+

select year(co.CreatedDate) as År,
       count(co.Id) as AntalOrdrar,
       sum(PtoO.UnitPrice * PtoO.Quantity) as Försäljning,
       min(date(co.CreatedDate)) as ForstaOrder,
       max(date(co.CreatedDate))
from COrder co
join ProductToOrder PtoO on co.Id = PtoO.OrderId
group by År;
-- ============================================
-- 18) Visa antal sålda enheter per månad för kategorierna 'Sandaler', 'Jacka' och 'Jeans'.
--    (JOIN hela vägen från ProductToOrder till ProductCategory, GROUP BY kategori och månad)
--
-- Visualisera gärna alla tre kategorierna i samma diagram.
-- Vad händer med de olika kategorierna över året? Varför?
-- En av kategorierna beter sig annorlunda än de andra två - vilken?
-- Vad betyder detta för inköp och lagerhållning?
-- ============================================

-- Resultat (första 5 av 36 rader):
-- +----------+-------+--------------+
-- | Kategori | Manad | SaldaEnheter |
-- +----------+-------+--------------+
-- | Jacka    |     1 |          474 |
-- | Jacka    |     2 |          393 |
-- | Jacka    |     3 |          299 |
-- | Jacka    |     4 |          142 |
-- | Jacka    |     5 |           63 |
-- +----------+-------+--------------+
select pc.Name as Kategori,
       month(co.CreatedDate) Månad,
       sum(PtoO.Quantity) SåldaEnheter
from COrder co
join ProductToOrder PtoO on co.Id = PtoO.OrderId
join Variant v on PtoO.VariantId = v.Id
join Product p on v.ProductId = p.Id
join ProductCategory pc on p.CategoryId = pc.Id
where pc.Name = 'Sandaler' or pc.Name = 'Jacka' or pc.Name = 'Jeans'
group by Kategori, Månad
order by Kategori, Månad;

-- ============================================
-- 19) Visa antal ordrar OCH genomsnittligt styckpris per dag under november 2025.
--    (GROUP BY på datum)
--
-- Något händer i slutet av månaden. Vad?
-- Titta på BÅDA kolumnerna - vad händer med priset samma dagar?
-- Vad kallas detta fenomen? Tjänar affären mer eller mindre pengar dessa dagar?
-- Visualisera och visa Krister.
-- ============================================

-- Resultat (första 5 av 30 rader):
-- +------------+--------+----------------+
-- | Dag        | Ordrar | SnittStyckpris |
-- +------------+--------+----------------+
-- | 2025-11-01 |     24 |            921 |
-- | 2025-11-02 |     42 |           1013 |
-- | 2025-11-03 |     31 |           1038 |
-- | 2025-11-04 |     32 |           1076 |
-- | 2025-11-05 |     30 |           1026 |
-- +------------+--------+----------------+

    select Date(co.CreatedDate) as Dag,
           count(distinct co.Id) as Ordrar,
           round(avg(PtoO.UnitPrice))
    from COrder co
    join ProductToOrder PtoO on co.Id = PtoO.OrderId
    where co.CreatedDate between '2025-11-01' and '2025-12-01'
    group by Dag;

select * from ProductToOrder;
select * from Variant;
select * from Product;
select * from ProductCategory;
-- ============================================
-- 20) Räkna antal returer per månad (använd Return.IncomeDate) och jämför med
--    antal ordrar per månad (använd COrder.CreatedDate).
--    (Två SELECT - en för returerna och en för ordrarna)
--
-- Kommer topparna samtidigt? Hur lång tid efter en försäljningstopp kommer returtoppen?
-- Varför blir det så?
-- Om du var chef för returavdelningen - när på året behöver du extrapersonal?
-- ============================================

-- Resultat ordrar per månad (första 5 av 56 rader):
-- +------+-------+--------+
-- | Ar   | Manad | Ordrar |
-- +------+-------+--------+
-- | 2022 |     1 |    355 |
-- | 2022 |     2 |    331 |
-- | 2022 |     3 |    428 |
-- | 2022 |     4 |    502 |
-- | 2022 |     5 |    635 |
-- +------+-------+--------+
select year(co.CreatedDate) as År,
       month(co.CreatedDate) as Månad,
       count(co.Id)
from COrder co
group by År, Månad;
-- Resultat returer per månad (första 5 av 56 rader):
-- +------+-------+---------+
-- | Ar   | Manad | Returer |
-- +------+-------+---------+
-- | 2022 |     1 |      24 |
-- | 2022 |     2 |      55 |
-- | 2022 |     3 |      59 |
-- | 2022 |     4 |      69 |
-- | 2022 |     5 |      64 |
-- +------+-------+---------+
select year(r.IncomeDate) as År,
       month(r.IncomeDate) as Månad,
       count(r.Id)
from `Return` r
group by År, Månad;

-- ============================================
-- 21) Hjälp oss komma på: vi kan inte det här med datanalys,
-- vad mer vore intressant att ta reda på?
-- Ge oss kuliga visualiseringar för det förstår vi!
-- Hitta på tusen stycken!
-- ============================================


-- ============================================
-- 22) EXTRA: LEDNINGSMÖTET
--
-- Ledningen har bokat ett möte med dig på fredag. De kan inte SQL, men de
-- vill ha svar på frågorna nedan. Till varje fråga gör du så här:
--   - Skriv SQL-frågan.
--   - Kopiera resultatet och klistra in i Excel eller Google Sheets.
--     Där kan du räkna vidare (procent, skillnader, summor).
--   - Gör ett diagram. Välj själv vilken typ som passar bäst.
--   - Klistra in diagrammet på en slide i PowerPoint/Google Slides.
--     Rubriken ska säga vad man ser, t.ex. "Jackor säljer 20 gånger mer i
--     december än i juli" - inte "Jackor per månad".
--   - Skriv 1-2 meningar: vad betyder detta för affären?
--
-- Leverera:
--   - En presentation: en slide per fråga (22.1-22.10), och en sista slide
--     med 3 konkreta råd till ledningen inför nästa år.
--   - En kort rapport på 1 sida, som ett mejl till VD: det viktigaste
--     först, inga SQL-ord.
--   - Presentera för Krister, som spelar VD. Räkna med frågor som
--     "Hur vet du det?" och "Vad kostar det oss?".
--
-- Bra att veta:
--   - Affären tjänar ca 50 kr per 100 kr i försäljning när varan säljs till
--     fullpris (efter inköp och frakt, men före löner och marknadsföring).
--   - Product.Cost är vad affären betalar för varan (inköpspris per styck).
--   - Datan slutar 2026-08-26, så 2026 är inte ett helt år.
-- ============================================

-- 22.1) Växer vi för att vi får nya kunder, eller för att kunderna kommer tillbaka?
--    a) Räkna hur många olika kunder som handlade varje år.
--       (COUNT(DISTINCT CustomerId), GROUP BY år)
--    b) Räkna hur många av dem som handlade IGEN året efter.
--       (Joina COrder med sig själv: samma kund, och året på den andra
--        ordern är året på den första + 1.)
--    Räkna ut procenten i Excel. Vilka år kan du jämföra? (Tänk på 2026.)

-- Resultat a) (alla 5 rader):
-- +------+--------+
-- | Ar   | Kunder |
-- +------+--------+
-- | 2022 |   2476 |
-- | 2023 |   3703 |
-- | 2024 |   5087 |
-- | 2025 |   5611 |
-- | 2026 |   4348 |
-- +------+--------+

-- Resultat b) (alla 4 rader):
-- +------+-------------------+
-- | Ar   | KoptIgenAretEfter |
-- +------+-------------------+
-- | 2022 |              1282 |
-- | 2023 |              1882 |
-- | 2024 |              1895 |
-- | 2025 |              1974 |
-- +------+-------------------+


-- 22.2) När på året tjänar vi pengar?
--    Försäljning per år och månad (som fråga 15). Klistra in i Excel och
--    gör ett linjediagram med en linje per år.
--    Är mönstret samma varje år? Vilka månader är svaga?

-- Resultat (första 5 av 56 rader):
-- +------+-------+-------------+
-- | Ar   | Manad | Forsaljning |
-- +------+-------+-------------+
-- | 2022 |     1 |   618360.00 |
-- | 2022 |     2 |   585750.00 |
-- | 2022 |     3 |   648650.00 |
-- | 2022 |     4 |   749480.00 |
-- | 2022 |     5 |   875780.00 |
-- +------+-------+-------------+


-- 22.3) Black Week ökar försäljningen - men hur mycket är verklig ökning?
--    Black Week 2025 var 24 november - 1 december.
--    a) Räkna antal ordrar 13-19 oktober, 17-23 november (veckan före)
--       och under Black Week. Vad händer veckan före?
--    b) Räkna returgraden (returnerade enheter / sålda enheter) för ordrar
--       under Black Week, och för ordrar under oktober 2025.
--    c) Hur många olika kunder handlade under Black Week 2025? Hur många av
--       dem handlade igen under 2026? Gör samma sak för oktober 2025.
--    Lönar sig Black Week? Vad skulle du ändra?

-- Resultat a) 13-19 oktober:
-- +--------+
-- | Ordrar |
-- +--------+
-- |    200 |
-- +--------+

-- Resultat a) 17-23 november:
-- +--------+
-- | Ordrar |
-- +--------+
-- |    137 |
-- +--------+

-- Resultat a) Black Week:
-- +--------+
-- | Ordrar |
-- +--------+
-- |    779 |
-- +--------+

-- Resultat b) Black Week:
-- +-------+-------------+
-- | Salda | Returnerade |
-- +-------+-------------+
-- |  1748 |         251 |
-- +-------+-------------+

-- Resultat c) kunder under Black Week:
-- +--------+
-- | Kunder |
-- +--------+
-- |    779 |
-- +--------+

-- Resultat c) handlade igen 2026:
-- +--------------+
-- | KoptIgen2026 |
-- +--------------+
-- |          276 |
-- +--------------+


-- 22.4) När ska vi annonsera jackor och sandaler, och var?
--    Räkna sålda jackor och sandaler per månad för kunder i Luleå.
--    (Använd kolumnen City, som i fråga 3.) Gör sedan samma sak för
--    Stockholm och Malmö.
--    Gör ett diagram per stad. När börjar jacksäsongen? Och sandalsäsongen?
--    Tips: städerna är olika stora. Vill du jämföra dem rättvist, räkna ut
--    procent i Excel (dela med stadens största månad eller totala försäljning).

-- Resultat Luleå (första 5 av 17 rader):
-- +----------+-------+--------------+
-- | Kategori | Manad | SaldaEnheter |
-- +----------+-------+--------------+
-- | Jacka    |     1 |           29 |
-- | Jacka    |     2 |           25 |
-- | Jacka    |     3 |           27 |
-- | Jacka    |     4 |           15 |
-- | Jacka    |     5 |            8 |
-- +----------+-------+--------------+


-- 22.5) Varför returneras det?
--    a) Vilken kategori har högst returgrad? (Fråga 12)
--    b) Räkna returer per produkt och returorsak inom den kategorin.
--       Sticker någon produkt ut?
--    c) Räkna returer per produkt för orsaken 'Trasiga sömmar'. Ta sedan den
--       produkt som har flest och räkna dess returer per år och månad.
--       Har något förändrats?
--    Vad ska affären göra - konkret?

-- Resultat b) (första 5 av 10 rader):
-- +--------------------+------------+---------+
-- | Produkt            | Orsak      | Returer |
-- +--------------------+------------+---------+
-- | Classic Rain Boot  | För liten  |     110 |
-- | Nordic Winter Boot | För liten  |      28 |
-- | Nordic Winter Boot | Ångrat köp |      24 |
-- | Nordic Winter Boot | För stor   |      24 |
-- | Nordic Winter Boot | Obekväma   |      18 |
-- +--------------------+------------+---------+

-- Resultat c) per produkt (alla 5 rader):
-- +----------------------+---------+
-- | Produkt              | Returer |
-- +----------------------+---------+
-- | Studio Wool Jacket   |      84 |
-- | Harbor Cotton Knit   |      10 |
-- | Alpine Flannel Jeans |      10 |
-- | City Brushed Hoodie  |       8 |
-- | Nordic Winter Boot   |       6 |
-- +----------------------+---------+

-- Resultat c) 'Studio Wool Jacket' per år och månad (första 5 av 11 rader):
-- +------+-------+---------+
-- | Ar   | Manad | Returer |
-- +------+-------+---------+
-- | 2022 |    11 |       1 |
-- | 2023 |    11 |       1 |
-- | 2024 |    10 |       1 |
-- | 2025 |    10 |       4 |
-- | 2025 |    11 |      16 |
-- +------+-------+---------+


-- 22.6) I mars 2024 började vi samarbeta med en influencer i Göteborg.
--    Det kostar oss 800 000 kr per år. Lönade det sig?
--    a) Räkna försäljningen per år för kunder i Göteborg (City),
--       och den totala försäljningen per år. Räkna ut Göteborgs andel av
--       försäljningen varje år i Excel. Hur mycket extra försäljning gav
--       samarbetet? Räkna på vinsten, inte bara försäljningen.
--    b) COrder.Source visar var kunden kom ifrån (Direkt, Google, Instagram,
--       Nyhetsbrev). Räkna antal ordrar per år och Source för kunder i
--       Göteborg. Gör samma sak för Stockholm. Syns influencern?

-- Resultat a) Göteborg (alla 5 rader):
-- +------+-------------+
-- | Ar   | Forsaljning |
-- +------+-------------+
-- | 2022 |  2073370.00 |
-- | 2023 |  2691000.00 |
-- | 2024 |  4228050.00 |
-- | 2025 |  5682280.00 |
-- | 2026 |  4003690.00 |
-- +------+-------------+

-- Resultat a) totalt (alla 5 rader):
-- +------+-------------+
-- | Ar   | Forsaljning |
-- +------+-------------+
-- | 2022 |  9539190.00 |
-- | 2023 | 12487005.00 |
-- | 2024 | 15437000.00 |
-- | 2025 | 18965415.00 |
-- | 2026 | 12849300.00 |
-- +------+-------------+

-- Resultat b) Göteborg (första 5 av 20 rader):
-- +------+------------+--------+
-- | Ar   | Source     | Ordrar |
-- +------+------------+--------+
-- | 2022 | Direkt     |    435 |
-- | 2022 | Google     |    433 |
-- | 2022 | Instagram  |    217 |
-- | 2022 | Nyhetsbrev |    276 |
-- | 2023 | Direkt     |    570 |
-- +------+------------+--------+


-- 22.7) Hur viktiga är de bästa kunderna?
--    a) Lista alla kunder med hur mycket de handlat för de senaste 12
--       månaderna (från 2025-08-27), sorterat med störst först. Klistra in i
--       Excel. Hur stor andel av den totala försäljningen står de bästa 10%
--       av kunderna för? De bästa 20%?
--    b) Lista de 100 kunder som handlat för mest totalt, med datum för
--       senaste köpet (MAX). Hur många har inte handlat på över ett år?
--    Vad borde vi göra med dem? (Tänk på bonuskoderna i fråga 10.)

-- Resultat a) (första 5 av 6102 rader):
-- +------------+----------+
-- | CustomerId | Summa    |
-- +------------+----------+
-- |       1935 | 24360.00 |
-- |       7378 | 23130.00 |
-- |       9235 | 22360.00 |
-- |       5758 | 21880.00 |
-- |       4853 | 21355.00 |
-- +------------+----------+

-- Resultat b) (första 5 av 100 rader):
-- +----------------+-------------------------------+------------+---------------------+
-- | Kund           | Email                         | TotaltKopt | SenasteKop          |
-- +----------------+-------------------------------+------------+---------------------+
-- | Karin Larsson  | karin.larsson3427@example.se  |   67230.00 | 2026-06-27 14:30:21 |
-- | Peter Holm     | peter.holm7667@example.se     |   61270.00 | 2026-08-13 14:55:47 |
-- | Lena Bengtsson | lena.bengtsson4275@example.se |   51185.00 | 2026-08-05 10:57:23 |
-- | Maja Holm      | maja.holm4817@example.se      |   49885.00 | 2026-08-10 20:08:40 |
-- | Liam Lindqvist | liam.lindqvist9528@example.se |   49775.00 | 2026-08-08 12:40:03 |
-- +----------------+-------------------------------+------------+---------------------+


-- 22.8) Vilka kategorier tjänar vi mest pengar på?
--    Räkna per kategori: försäljning (Quantity * UnitPrice), inköp
--    (Quantity * Product.Cost) och vinst (försäljning minus inköp).
--    Sortera på vinst. Räkna ut vinsten i procent av försäljningen i Excel.
--    Är det samma kategorier som säljer mest och tjänar mest?

-- Resultat (första 5 av 26 rader):
-- +----------+-------------+---------+------------+
-- | Kategori | Forsaljning | Inkop   | Vinst      |
-- +----------+-------------+---------+------------+
-- | Jeans    |  7630825.00 | 3295045 | 4335780.00 |
-- | Sneakers |  8789590.00 | 4810740 | 3978850.00 |
-- | T-shirt  |  3808780.00 | 1482705 | 2326075.00 |
-- | Jacka    |  6022640.00 | 3707060 | 2315580.00 |
-- | Hoodie   |  4646865.00 | 2371460 | 2275405.00 |
-- +----------+-------------+---------+------------+


-- 22.9) Vilka kunder når vi var, och vad köper de?
--    a) Räkna antal ordrar per födelsedecennium och Source.
--       (Födelsedecennium: FLOOR(c.BirthYear / 10) * 10, t.ex. 1987 -> 1980)
--    b) Räkna sålda Hoodie, Kappa, Keps och Loafers per födelsedecennium.
--    Var ska vi annonsera om vi vill nå unga kunder? Äldre? Vad ska vi visa dem?

-- Resultat a) (första 5 av 28 rader):
-- +-------+------------+--------+
-- | Fodda | Source     | Ordrar |
-- +-------+------------+--------+
-- |  1940 | Direkt     |     47 |
-- |  1940 | Google     |     39 |
-- |  1940 | Instagram  |      2 |
-- |  1940 | Nyhetsbrev |     27 |
-- |  1950 | Direkt     |    288 |
-- +-------+------------+--------+

-- Resultat b) (första 5 av 27 rader):
-- +-------+----------+-------+
-- | Fodda | Kategori | Salda |
-- +-------+----------+-------+
-- |  1940 | Hoodie   |    13 |
-- |  1940 | Kappa    |     6 |
-- |  1940 | Loafers  |     7 |
-- |  1950 | Hoodie   |    83 |
-- |  1950 | Kappa    |    76 |
-- +-------+----------+-------+


-- 22.10) Något eget: hitta en sak i datan som ledningen inte har frågat om,
--    men borde veta.
