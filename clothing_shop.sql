-- ============================================
-- 1) Lista 100 kunder med deras för- och efternamn.
--    (En enkel SELECT för att bekanta sig med tabellen Customer)
-- ============================================
select c.FName, c.LName from Customer c
limit 100;

-- ============================================
-- 2) Lista 100 produkter med deras namn och kategori-ID.
--    (Ger en överblick över vilka produkter som finns och vilken kategori de tillhör)
-- ============================================
select p.Name, p.CategoryId from Product p limit 100;

-- ============================================
-- 3) Lista alla kunder som bor i Malmö.
--    Lista sedan alla kunder i Malmö som bor på en gata vars namn slutar
--    på 'gatan' (t.ex. 'Storgatan 12').
--    (Träna på WHERE och LIKE för att filtrera resultat)
-- ============================================
select c.FName, c.LName, c.Address, c.City from Customer c
where c.City = 'Malmö' and c.Address like '%gatan%';

-- ============================================
-- 4) Visa alla varianter med tillhörande produktnamn.
--    (Träna på JOIN – kombinera Variant med Product för att visa fullständig information)
-- ============================================
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
--    Svar: Nej
-- ============================================
select count(v.Name) from ProductToOrder prTO
join Variant v on prTO.VariantId = v.Id
where v.Name like '46 -%'; -- 13806 M, 3953 XS, 8770 S, 12714 L, 7846 XL, 4118 XXL, 110 36, 2327 41, 122 46

-- ============================================
-- 6) Räkna antal returer per returstatus.
--    (Ger en bild av hur returerna fördelas mellan olika statusar)
--
--    Drag slutsatser, vad spelar detta för roll för affären? (Logistik, lagerhantering?)
--    Finns det mer data om returer som vore intressant att analysera om just detta?
--    Inkommen: 8, Under granskning: 27, Godkänd 36, Avslagen: 541, Återbetald: 5803
-- ============================================
select count(rs.Id) as Returns, rs.Name from `Return` r
join ReturnStatus rs on r.ReturnStatusId = rs.Id
group by rs.Name
order by Returns desc;

-- ============================================
-- 7) Vilken kund har lagt flest beställningar?
--    (Räkna antal ordrar per kund)
-- ============================================
select count(pto.Id) orderCount, c.FName from Customer c
join COrder co on co.CustomerId = c.Id
join ProductToOrder pto on pto.OrderId = co.Id
group by c.Id
order by orderCount desc;

-- ============================================
-- 8) Lagersaldo per kategori.
--    (Summera Variant.Stock per produktkategori)
--
-- Bara siffror säger inte så mycket. Ta med hur många enheter som sålts
-- per kategori de senaste 12 månaderna (datan slutar 2026-08-26).
-- Hur många månader räcker lagret? Vilken kategori sticker ut? Varför är
-- det ett problem just nu i slutet av augusti? Vad borde affären göra?
-- ============================================
select sum(v.Stock) lagersaldo, pc.Name from Variant v
join Product p on v.ProductId = p.Id
join ProductCategory pc on p.CategoryId = pc.Id
group by pc.Name
order by lagersaldo desc;

-- ============================================
-- 9) Räkna ut de 10 bäst säljande produkterna.
--    (Summera antal sålda enheter per produktnamn)
--    Drag slutsatser, vad spelar detta för roll för affären? (Rabatter, kampanjer?)
-- ============================================
select sum(prTO.Quantity) sold, p.Name from ProductToOrder prTO
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
select sum(prO.UnitPrice) sold, c.FName, c.LName, c.Email
from Customer c
join COrder co on c.Id = co.CustomerId
join ProductToOrder prO on co.Id = prO.OrderId
group by c.Id
order by sold desc
limit 10;


-- ============================================
-- 11) Hitta de 5 mest returnerade produkterna.
--    (Summera antal returnerade enheter per produktnamn)
-- ============================================


-- ============================================
-- 12) Räkna ut hur stor ANDEL av de sålda enheterna som returneras, per kategori.
--    (Summera sålda enheter och returnerade enheter per kategori, räkna sedan ut procenten)
--
-- Jämför med fråga 11 - blir det samma ranking? Varför/varför inte?
-- Vilka kategorier sticker ut? Vad kan det bero på?
-- Vad skulle affären kunna göra åt de kategorier som sticker ut?
-- ============================================


-- ============================================
-- 13) Varianter som aldrig har sålts.
--    (LEFT JOIN mot ProductToOrder och filtrera där pto saknas)
--
-- Vilka kategorier tillhör de? Hur mycket lager ligger det på dem?
-- Är det bara ovanliga storlekar, eller finns det hela produkter som aldrig sålts?
-- Vad kostar det affären att ha dem kvar?
-- ============================================


-- ============================================
-- 14) Räkna ut antal orderrader per år och månad
--    (Visar aktivitetsnivå i olika perioder)
--
-- Visualisera på valfritt vis.
-- Drag slutsatser. Vad säger detta om affären och försäljningen?
-- Visa Krister
-- ============================================


-- ============================================
-- 15) Räkna ut vilka månader då försäljningen går som bäst
--    (Summera total försäljning per år och månad)
--
-- Visualisera på valfritt vis.
-- Drag slutsatser. Vad säger detta om affären och försäljningen?
-- Visa Krister
-- ============================================


-- ============================================
-- 16) Jämför resultaten i fråga 14 och 15. Vad säger detta?
--
-- ============================================


-- ============================================
-- 17) Summera försäljningen per år. Växer eller krymper affären?
--    (GROUP BY på år)
--
-- Titta NOGA på resultatet innan du svarar. Är alla år jämförbara?
-- Tips: ta med första och sista orderdatum för varje år i resultatet.
-- Drag slutsatser. Visa Krister.
-- ============================================


-- ============================================
-- 18) Visa antal sålda enheter per månad för kategorierna 'Sandaler', 'Jacka' och 'Jeans'.
--    (JOIN hela vägen från ProductToOrder till ProductCategory, GROUP BY kategori och månad)
--
-- Visualisera gärna alla tre kategorierna i samma diagram.
-- Vad händer med de olika kategorierna över året? Varför?
-- En av kategorierna beter sig annorlunda än de andra två - vilken?
-- Vad betyder detta för inköp och lagerhållning?
-- ============================================


-- ============================================
-- 19) Visa antal ordrar OCH genomsnittligt styckpris per dag under november 2025.
--    (GROUP BY på datum)
--
-- Något händer i slutet av månaden. Vad?
-- Titta på BÅDA kolumnerna - vad händer med priset samma dagar?
-- Vad kallas detta fenomen? Tjänar affären mer eller mindre pengar dessa dagar?
-- Visualisera och visa Krister.
-- ============================================


-- ============================================
-- 20) Räkna antal returer per månad (använd Return.IncomeDate) och jämför med
--    antal ordrar per månad (använd COrder.CreatedDate).
--    (Två SELECT - en för returerna och en för ordrarna)
--
-- Kommer topparna samtidigt? Hur lång tid efter en försäljningstopp kommer returtoppen?
-- Varför blir det så?
-- Om du var chef för returavdelningen - när på året behöver du extrapersonal?
-- ============================================


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


-- 22.2) När på året tjänar vi pengar?
--    Försäljning per år och månad (som fråga 15). Klistra in i Excel och
--    gör ett linjediagram med en linje per år.
--    Är mönstret samma varje år? Vilka månader är svaga?


-- 22.3) Black Week ökar försäljningen - men hur mycket är verklig ökning?
--    Black Week 2025 var 24 november - 1 december.
--    a) Räkna antal ordrar 13-19 oktober, 17-23 november (veckan före)
--       och under Black Week. Vad händer veckan före?
--    b) Räkna returgraden (returnerade enheter / sålda enheter) för ordrar
--       under Black Week, och för ordrar under oktober 2025.
--    c) Hur många olika kunder handlade under Black Week 2025? Hur många av
--       dem handlade igen under 2026? Gör samma sak för oktober 2025.
--    Lönar sig Black Week? Vad skulle du ändra?


-- 22.4) När ska vi annonsera jackor och sandaler, och var?
--    Räkna sålda jackor och sandaler per månad för kunder i Luleå.
--    (Använd kolumnen City, som i fråga 3.) Gör sedan samma sak för
--    Stockholm och Malmö.
--    Gör ett diagram per stad. När börjar jacksäsongen? Och sandalsäsongen?
--    Tips: städerna är olika stora. Vill du jämföra dem rättvist, räkna ut
--    procent i Excel (dela med stadens största månad eller totala försäljning).


-- 22.5) Varför returneras det?
--    a) Vilken kategori har högst returgrad? (Fråga 12)
--    b) Räkna returer per produkt och returorsak inom den kategorin.
--       Sticker någon produkt ut?
--    c) Räkna returer per produkt för orsaken 'Trasiga sömmar'. Ta sedan den
--       produkt som har flest och räkna dess returer per år och månad.
--       Har något förändrats?
--    Vad ska affären göra - konkret?


-- 22.6) I mars 2024 började vi samarbeta med en influencer i Göteborg.
--    Det kostar oss 800 000 kr per år. Lönade det sig?
--    a) Räkna försäljningen per år för kunder i Göteborg (City),
--       och den totala försäljningen per år. Räkna ut Göteborgs andel av
--       försäljningen varje år i Excel. Hur mycket extra försäljning gav
--       samarbetet? Räkna på vinsten, inte bara försäljningen.
--    b) COrder.Source visar var kunden kom ifrån (Direkt, Google, Instagram,
--       Nyhetsbrev). Räkna antal ordrar per år och Source för kunder i
--       Göteborg. Gör samma sak för Stockholm. Syns influencern?


-- 22.7) Hur viktiga är de bästa kunderna?
--    a) Lista alla kunder med hur mycket de handlat för de senaste 12
--       månaderna (från 2025-08-27), sorterat med störst först. Klistra in i
--       Excel. Hur stor andel av den totala försäljningen står de bästa 10%
--       av kunderna för? De bästa 20%?
--    b) Lista de 100 kunder som handlat för mest totalt, med datum för
--       senaste köpet (MAX). Hur många har inte handlat på över ett år?
--    Vad borde vi göra med dem? (Tänk på bonuskoderna i fråga 10.)


-- 22.8) Vilka kategorier tjänar vi mest pengar på?
--    Räkna per kategori: försäljning (Quantity * UnitPrice), inköp
--    (Quantity * Product.Cost) och vinst (försäljning minus inköp).
--    Sortera på vinst. Räkna ut vinsten i procent av försäljningen i Excel.
--    Är det samma kategorier som säljer mest och tjänar mest?


-- 22.9) Vilka kunder når vi var, och vad köper de?
--    a) Räkna antal ordrar per födelsedecennium och Source.
--       (Födelsedecennium: FLOOR(c.BirthYear / 10) * 10, t.ex. 1987 -> 1980)
--    b) Räkna sålda Hoodie, Kappa, Keps och Loafers per födelsedecennium.
--    Var ska vi annonsera om vi vill nå unga kunder? Äldre? Vad ska vi visa dem?


-- 22.10) Något eget: hitta en sak i datan som ledningen inte har frågat om,
--    men borde veta.