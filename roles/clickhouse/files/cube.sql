CREATE TABLE IF NOT EXISTS tutorial.visits_daily_shard ON CLUSTER '{cluster}'
(
    `Day`              Date,
    `UserID`           String,
    `Count`            AggregateFunction(count),
    `Average Duration` AggregateFunction(avg, UInt32),
    `Max Duration`     AggregateFunction(max, UInt32),
    `Min Duration`     AggregateFunction(min, UInt32),
    `Total PageViews`  AggregateFunction(sum, Int32),
    `Total Hits`       AggregateFunction(sum, Int32),
    `LastVisit`        AggregateFunction(max, Date)
)
    ENGINE = ReplicatedSummingMergeTree('/clickhouse_sandbox/tables/{shard}/hits_daily', '{replica}')
        PARTITION BY tuple()
        ORDER BY (`UserID`, `Day`);

CREATE MATERIALIZED VIEW IF NOT EXISTS tutorial.visits_daily_mv
            ON CLUSTER '{cluster}'
            TO tutorial.visits_daily_shard
AS
SELECT toStartOfDay(`StartDate`) as `Day`,
       `UserID`,
       countState()              AS `Count`,
       avgState(`Duration`)      AS `Average Duration`,
       maxState(`Duration`)      AS `Max Duration`,
       minState(`Duration`)      AS `Min Duration`,
       sumState(`PageViews`)     AS `Total PageViews`,
       sumState(`PageViews`)     AS `Total Hits`,
       maxState(`LastVisit`)     AS `LastVisit`
FROM tutorial.visits_shard
GROUP BY `UserID`, `Day`
ORDER BY `UserID`, `Day`;

CREATE TABLE IF NOT EXISTS tutorial.visits_daily ON CLUSTER '{cluster}' AS tutorial.visits_daily_shard
    ENGINE = Distributed('{cluster}', tutorial, visits_daily_shard, rand());