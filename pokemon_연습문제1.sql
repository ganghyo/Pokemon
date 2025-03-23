-- 1. trainer 테이블에 있는 모든 데이터를 보여주는 쿼리문을 작성해주세요.
-- SELECT *
-- FROM `basic.trainer`

-- 2. trainer 테이블에 있는 트레이너의 name을 출력하는 쿼리를 작성해주세요.
-- SELECT name
-- FROM `basic.trainer`

-- 3. trainer 테이블에 있는 name, age를 출력하는 쿼리를 작성해주세요.
-- SELECT name, age
-- FROM `basic.trainer`

-- 4. trainer 테이블에서 id가 3인 트레이너의 name, age, hometown을 출력하는 쿼리를 작성해주세요.
-- SELECT name,
--   age,
--   hometown
-- FROM `basic.trainer`
-- WHERE id = 3

-- 5. pokemon 테이블에서 "피카츄" 의 공격력과 체력을 확인할 수 있는 쿼리를 작성해주세요.
-- SELECT attack,
--   hp
-- FROM `basic.pokemon`
-- WHERE kor_name = '피카츄'

-- 6. 포켓몬 중에 type2가 없는 포켓몬의 수를 확인할 수 있는 쿼리를 작성해주세요.
-- SELECT count(id) as cnt
-- FROM basic.pokemon
-- WHERE type2 IS NULL

-- 7. type2가 없는 포켓몬의 type1과 type1의 포켓몬 수를 알려주는 쿼리를 작성해주세요. 단, type1의 포켓몬 수가 큰 순으로 정렬해주세요.
-- SELECT type1,
--   count(id) as cnt
-- FROM `basic.pokemon`
-- WHERE type2 IS NULL
-- GROUP BY type1
-- ORDER BY cnt desc

-- 8. type2 상관 없이 type1의 포켓몬 수를 알 수 있는 쿼리를 작성해주세요.
-- SELECT type1,
--   count(id)
-- FROM `basic.pokemon`
-- GROUP BY type1

-- 9. 전설 여부에 따른 포켓몬 수를 알 수 있는 쿼리를 작성해주세요.
-- SELECT CASE WHEN is_legendary IS TRUE THEN '전설 포켓몬'
--             ELSE '일반 포켓몬' END as is_legendary,
--   count(id)
-- FROM `basic.pokemon`
-- GROUP BY is_legendary

-- 10. 동명 이인이 있는 이름은 무엇일까요?
-- SELECT name
-- FROM (
--   SELECT name, count(name) as name_cnt
--   FROM `basic.trainer`
--   GROUP BY name
-- )
-- WHERE name_cnt >= 2

-- 11. trainer 테이블에서 "Iris" 트레이너의 정보를 알 수 있는 쿼리를 작성해주세요.
-- SELECT *
-- FROM `basic.trainer`
-- WHERE name="Iris"

-- 12. trainer 테이블에서 "Iris", "Whitney", "Cynthia" 트레이너의 정보를 알 수 있는 쿼리를 작성해주세요.
-- SELECT *
-- FROM `basic.trainer`
-- WHERE name IN ("Iris", "Whitney", "Cynthia")

-- 13. 전체 포켓몬의 수는 얼마나 되나요?
-- SELECT count(id)
-- FROM `basic.pokemon`

-- 14. 세대별로 포켓몬 수가 얼마나 되는지 알 수 있는 쿼리를 작성해주세요.
-- SELECT generation,
--   count(id)
-- FROM `basic.pokemon`
-- GROUP BY generation

-- 15. type2가 존재하는 포켓몬의 수는 얼마나 되나요?
-- SELECT count(id)
-- FROM `basic.pokemon`
-- WHERE type2 IS NOT NULL

-- 16. type2가 있는 포켓몬 중에 제일 많은 type1은 무엇인가요?
-- SELECT type1,
--   count(id)
-- FROM `basic.pokemon`
-- WHERE type2 IS NOT NULL
-- GROUP BY type1
-- ORDER BY count(id) desc
-- limit 1

-- 17. 단일 타입 포켓몬 중 많은 type1은 무엇일까요?
-- SELECT type1,
--   count(id)
-- FROM `basic.pokemon`
-- WHERE type2 IS NULL
-- GROUP BY type1
-- ORDER BY count(id) desc
-- limit 1

-- 18. 포켓몬의 이름에 "파"가 들어가는 포켓몬은 어떤 포켓몬이 있을까요?
-- SELECT kor_name
-- FROM `basic.pokemon`
-- WHERE kor_name LIKE '%파%'

-- 19. 뱃지가 6개 이상인 트레이너는 몇 명이 있나요?
-- SELECT count(id)
-- FROM `basic.trainer`
-- WHERE badge_count >= 6

-- 20. 트레이너가 보유한 포켓몬이 제일 많은 트레이너는 누구일까요?
-- SELECT t.name,
--   count(t.id)
-- FROM `basic.trainer` as t
-- LEFT JOIN `basic.trainer_pokemon` as tp
-- ON t.id = tp.trainer_id
-- GROUP BY t.name
-- ORDER BY count(t.id) desc
-- limit 1

-- 21. 포켓몬을 가장 많이 풀어준 트레이너는 누구일까요?
-- SELECT t.name,
--   count(tp.id)
-- FROM `basic.trainer` as t
-- LEFT JOIN `basic.trainer_pokemon` as tp
-- ON t.id = tp.trainer_id
-- WHERE tp.status = 'Released'
-- GROUP BY t.name
-- ORDER BY count(tp.id) desc
-- limit 1

-- 22. 트레이너 별로 풀어준 포켓몬의 비율이 20%가 넘는 포켓몬 트레이너는 누구일까요?
-- WITH released_ratio_with as (
--   SELECT t.name as trainer_name,
--     tp.trainer_id as trainer_id,
--     tp.released_cnt/tp.pokemon_cnt as released_ratio
--   FROM (
--     SELECT trainer_id,
--       count(id) as pokemon_cnt,
--       countif(status='Released') as released_cnt
--     FROM `basic.trainer_pokemon`
--     GROUP BY trainer_id
--   ) as tp
--   LEFT JOIN `basic.trainer` as t
--   ON tp.trainer_id = t.id
-- )
-- SELECT trainer_id,
--   trainer_name
-- FROM released_ratio_with
-- WHERE released_ratio >= 0.2

-- 풀이) SELECT 문에서 연산하면 간단하게 작성할 수 있다.
SELECT
  name,
  tp.trainer_id
FROM (
  SELECT trainer_id,
    count(id) as pokemon_cnt,
    countif(status='Released') as released_cnt,
    countif(status='Released')/count(id) as released_ratio
  FROM `basic.trainer_pokemon`
  GROUP BY trainer_id
  HAVING released_ratio >= 0.2
) as tp
LEFT JOIN basic.trainer as t
ON t.id = tp.trainer_id