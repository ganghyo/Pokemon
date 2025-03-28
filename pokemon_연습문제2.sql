-- 1. 트레이너가 포켓몬을 포획한 날짜를 기준으로, 2023년 1월에 포획한 포켓몬의 수를 계산해주세요.
-- * EXTRACT: DATETIME에서 특정 부분만 추출하고 싶은 경우
-- SELECT
--   count(distinct id) as pokemon_cnt
-- FROM `basic.trainer_pokemon`
-- WHERE
--   EXTRACT(YEAR FROM DATETIME(catch_datetime, 'Asia/Seoul')) = 2023
--   AND EXTRACT(MONTH FROM DATETIME(catch_datetime, 'Asia/Seoul')) = 1

-- 2. 배틀이 일어난 시간을 기준으로, 오전 6시에서 오후 6시 사이에 일어난 배틀의 수를 계산해주세요.
-- SELECT
--   count(distinct id) as battle_cnt
-- FROM `basic.battle`
-- WHERE
--   EXTRACT(HOUR FROM DATETIME(battle_timestamp, 'Asia/Seoul')) BETWEEN 6 AND 18

-- 3. 각 트레이너 별로 그들이 포켓몬을 포획한 첫 날을 찾고, 그 날짜를 'DD/MM/YY' 형식으로 출력해주세요.
-- SELECT
--   trainer_id,
--   FORMAT_DATE('%d/%m/%Y', first_catch_date)
-- FROM (
--   SELECT
--     trainer_id,
--     min(DATETIME(catch_datetime, 'Asia/Seoul')) as first_catch_date
--   FROM `basic.trainer_pokemon`
--   GROUP BY trainer_id
-- )

-- 4. 배틀이 일어난 날짜를 기준으로, 요일별로 배틀이 얼마나 자주 일어났는지 계산해주세요.
-- * DAYOFWEEK -> 1/2/3/4/5/6/7
-- *              일/월/화/수/목/금/토
-- SELECT
--   battle_datetime_kor,
--   count(id)
-- FROM (
--   SELECT
--     id,
--     EXTRACT(DAYOFWEEK FROM DATETIME(battle_timestamp, 'Asia/Seoul')) as battle_datetime_kor
--   FROM `basic.battle`
-- )
-- GROUP BY battle_datetime_kor
-- ORDER BY battle_datetime_kor

-- 5. 트레이너가 포켓몬을 처음으로 포획한 날짜와 마지막으로 포획한 날짜의 간격이 큰 순으로 정렬하는 쿼리를 작성해주세요.
-- SELECT
--   trainer_id,
--   min(DATETIME(catch_datetime, 'Asia/Seoul')) as first_catch_date,
--   max(DATETIME(catch_datetime, 'Asia/Seoul')) as last_catch_date,
--   DATE_DIFF(max(DATETIME(catch_datetime, 'Asia/Seoul')), min(DATETIME(catch_datetime, 'Asia/Seoul')), DAY) as catch_date_diff
-- FROM `basic.trainer_pokemon`
-- GROUP BY trainer_id
-- ORDER BY 4 desc

-- 6. 포켓몬의 'Speed' 가 70 이상이면 '빠름', 그렇지 않으면 '느림'으로 표시하는 새로운 컬럼 'Speed_Category'를 만들어 주세요.
-- SELECT
--   kor_name,
--   IF(speed >= 70, '빠름', '느림') as Speed_category
-- FROM `basic.pokemon`

-- 7. 포켓몬의 type1에 따라 '물', '불', '전기', '기타'로 분류하는 새로운 컬럼 'type_korean'을 만들어 주세요.
-- SELECT
--   kor_name,
--   CASE WHEN type1 = 'Water' THEN '물'
--     WHEN type1 = 'Fire' THEN '불'
--     WHEN type1 = 'Electric' THEN '전기'
--     ELSE '기타' END as type_korean
-- FROM `basic.pokemon`

-- 8. 각 포켓몬의 총점을 기준으로, 300 이하면 'Low', 301~500 이면 'Medium', 501 이상이면 'High'로 분류해주세요.
-- SELECT
--   kor_name,
--   CASE WHEN total <= 300 THEN 'Low'
--     WHEN total BETWEEN 301 AND 500 THEN 'Medium'
--     ELSE 'High' END as total_category
-- FROM `basic.pokemon`

-- 9. 각 트레이너의 배지 개수를 기준으로, 5개 이하면 'Beginner', 6~8 이면 'Intermediate', 그 이상이면 'Advanced'로 분류해주세요.
-- SELECT
--   name,
--   CASE WHEN badge_count <= 5 THEN 'Beginner'
--     WHEN badge_count BETWEEN 6 AND 8 THEN 'Intermediate'
--     ELSE 'Advanced' END as badge_grade
-- FROM `basic.trainer`

-- 10. 트레이너가 포켓몬을 포획한 날짜가 '2023-01-01' 이후면 'Recent', 그렇지 않으면 'Old'로 분류해주세요.
-- SELECT
--   id,
--   IF(DATE(DATETIME(catch_datetime, 'Asia/Seoul')) >= '2023-01-01', 'Recent', 'Old'),
--   'Recent' as recent_value
--   # 모든 컬럼에 동일한 값을 추가하고 싶을 때
-- FROM `basic.trainer_pokemon`

-- 11. 배틀에서 승자가 player1과 같으면 'Player1 Win', player2와 같으면 'Player2 Win', 그렇지 않으면 'Draw'로 결과가 나오게 해주세요.
-- SELECT
--   id,
--   CASE WHEN player1_id = winner_id THEN 'Player1 Win'
--     WHEN player2_id = winner_id THEN 'Player2 Win'
--     ELSE 'Draw' END as battle_result
-- FROM (
--   SELECT
--     id,
--     player1_id,
--     player2_id,
--     winner_id
--   FROM `basic.battle`
-- )
-- ORDER BY id

-- 12. 포켓몬들 중 트레이너가 보유하고 있는 포켓몬은 얼마나 있는지 알 수 있는 쿼리를 작성해주세요.
-- SELECT
--   p.kor_name,
--   count(tp.id)
-- FROM `basic.trainer_pokemon` as tp
-- LEFT JOIN `basic.pokemon` as p
-- ON tp.pokemon_id = p.id
-- WHERE status in ('Active', 'Training')
-- GROUP BY p.kor_name
-- ORDER BY count(tp.id) desc

-- 13. 각 트레이너가 가진 포켓몬 중에서 type1이 'Grass'인 포켓몬 수를 계산해주세요.
-- SELECT
--   type1,
--   count(tp.id)
-- FROM `basic.trainer_pokemon` as tp
-- LEFT JOIN `basic.pokemon` as p
-- ON tp.pokemon_id = p.id
-- WHERE tp.status in ('Active', 'Training')
--   AND type1 = 'Grass'
-- GROUP BY type1

-- 14. 트레이너의 고향과 포켓몬을 포획한 위치가 같은 트레이너의 수를 계산해주세요.
-- SELECT
--   count(tp.trainer_id)
-- FROM `basic.trainer_pokemon` as tp
-- LEFT JOIN `basic.trainer` as t
-- ON tp.trainer_id = t.id
-- WHERE tp.location = t.hometown

-- 15. Master 등급인 트레이너들은 어떤 타입의 포켓몬을 제일 많이 보유하고 있을까요?
-- SELECT
--   p.type1,
--   count(tp.id)
-- FROM `basic.trainer_pokemon` as tp
-- LEFT JOIN `basic.trainer` as t
-- ON t.id = tp.trainer_id
-- LEFT JOIN `basic.pokemon` as p
-- ON p.id = tp.pokemon_id
-- WHERE t.achievement_level = 'Master'
--   AND tp.status in ('Active', 'Training')
-- GROUP BY p.type1
-- ORDER BY count(tp.id) desc
-- limit 1

-- 16. Incheon 출신 트레이너들은 1세대, 2세대 포켓몬을 각각 얼마나 보유하고 있나요?
-- SELECT
--   p.generation,
--   count(tp.id)
-- FROM `basic.trainer_pokemon` as tp
-- LEFT JOIN `basic.trainer` as t
-- ON tp.trainer_id = t.id
-- LEFT JOIN `basic.pokemon` as p
-- ON tp.pokemon_id = p.id
-- WHERE tp.status in ('Active', 'Training')
--   AND t.hometown = 'Incheon'
-- GROUP BY p.generation
-- ORDER BY p.generation