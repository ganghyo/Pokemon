-- 1. 각 트레이너별로 가진 포켓몬의 평균 레벨을 계산하고, 그 중 평균레벨이 높은 TOP3 트레이너의 이름과 보유한 포켓몬 수, 평균 레벨을 출력해주세요.
-- SELECT
--   t.name,
--   count(tp.id) as pokemon_cnt,
--   ROUND(avg(tp.level), 2) as level_avg
-- FROM `basic.trainer_pokemon` as tp
-- LEFT JOIN `basic.trainer` as t
-- ON tp.trainer_id = t.id
-- WHERE tp.status in ('Active', 'Training')
-- GROUP BY t.name
-- ORDER BY 3 desc
-- limit 3

-- 2. 각 포켓몬의 타입1을 기준으로 가장 많이 포획된 포켓몬의 타입1, 포켓몬의 이름과 포획 횟수를 출력해주세요.
-- SELECT
--   p.kor_name,
--   p.type1,
--   count(tp.id)
-- FROM `basic.trainer_pokemon` as tp
-- LEFT JOIN `basic.pokemon` as p
-- ON tp.pokemon_id = p.id
-- GROUP BY p.type1, p.kor_name
-- ORDER BY count(tp.id) desc
-- limit 1

-- 3. 전설의 포켓몬을 보유한 트레이너들은 전설의 포켓몬과 일반 포켓몬을 얼마나 보유하고 있을까요?
-- SELECT
--   *
-- FROM (
--   SELECT
--     t.name,
--     SUM(CASE WHEN p.is_legendary THEN 1 ELSE 0 END) as legend_cnt,
--     SUM(CASE WHEN NOT p.is_legendary THEN 1 ELSE 0 END) as normal_cnt
--   FROM `basic.trainer_pokemon` as tp
--   LEFT JOIN `basic.trainer` as t
--   ON tp.trainer_id = t.id
--   LEFT JOIN `basic.pokemon` as p
--   ON tp.pokemon_id = p.id
--   GROUP BY t.name
-- )
-- WHERE legend_cnt >= 1

-- 4. 가장 승리가 많은 트레이너 ID, 트레이너의 이름, 승리한 횟수, 보유한 포켓몬의 수, 평균 포켓몬의 레벨을 출력해주세요.
-- WITH battle_rank_top1 as(
--   SELECT
--     winner_id,
--     count(id) as win_cnt
--   FROM `basic.battle`
--   WHERE winner_id IS NOT NULL
--   GROUP BY winner_id
--   ORDER BY count(id) desc
--   limit 1
-- )
-- SELECT
--   tp.trainer_id,
--   t.name,
--   brt.win_cnt,
--   count(tp.id) as pokemon_cnt,
--   ROUND(avg(tp.level), 2) as level_avg
-- FROM `basic.trainer_pokemon` as tp
-- LEFT JOIN `basic.trainer` as t
-- ON t.id = tp.trainer_id
-- LEFT JOIN `basic.pokemon` as p
-- ON p.id = tp.pokemon_id
-- INNER JOIN battle_rank_top1 as brt
-- ON brt.winner_id = tp.trainer_id
-- WHERE tp.status in ('Active', 'Training')
-- GROUP BY ALL

-- 5. 트레이너가 잡았던 포켓몬의 총 공격력과 방어력의 합을 계산하고, 이 합이 가장 높은 트레이너를 찾으세요.
-- SELECT
--   tp.trainer_id,
--   t.name,
--   SUM(p.attack) + SUM(p.defense) as pokemon_stat
-- FROM `basic.trainer_pokemon` as tp
-- LEFT JOIN `basic.trainer` as t
-- ON tp.trainer_id = t.id
-- LEFT JOIN `basic.pokemon` as p
-- ON tp.pokemon_id = p.id
-- GROUP BY ALL
-- ORDER BY 3 desc
-- limit 1

-- 6. 각 포켓몬의 최고 레벨과 최저 레벨을 계산하고, 레벨 차이가 가장 큰 포켓몬의 이름을 출력하세요.
-- SELECT
--   pokemon_name,
--   max_level - min_level as level_diff
-- FROM (
--   SELECT
--     p.kor_name as pokemon_name,
--     min(tp.level) as min_level,
--     max(tp.level) as max_level
--   FROM `basic.trainer_pokemon` as tp
--   LEFT JOIN `basic.trainer` as t
--   ON tp.trainer_id = t.id
--   LEFT JOIN `basic.pokemon` as p
--   ON tp.pokemon_id = p.id
--   GROUP BY p.kor_name
-- )
-- ORDER BY level_diff desc
-- limit 1

-- 7. 각 트레이너가 가진 포켓몬 중에서 공격력이 100 이상인 포켓몬과 100 미만인 포켓몬의 수를 각각 계산해주세요.
WITH pokemon_cnt as (
  SELECT
    t.name as trainer_name,
    p.attack as attack_stat,
    tp.id as trainer_id
  FROM `basic.trainer_pokemon` as tp
  LEFT JOIN `basic.trainer` as t
  ON tp.trainer_id = t.id
  LEFT JOIN `basic.pokemon` as p
  ON tp.pokemon_id = p.id
  WHERE tp.status in ('Active', 'Training')
)
SELECT
  trainer_name,
  SUM(CASE WHEN attack_stat >= 100 THEN 1 ELSE 0 END) as over_100,
  SUM(CASE WHEN attack_stat < 100 THEN 1 ELSE 0 END) as under_100
FROM pokemon_cnt
GROUP BY trainer_name