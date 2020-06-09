--Group hosts by CPU number and sort by their memory size in descending order
SELECT cpu_number,id,total_mem
FROM public.host_info
ORDER BY cpu_number ASC, total_mem DESC;

--Average used memory in percentage over 5 mins interval for each host.
SELECT
  u.host_id,
  i.hostname,
  date_trunc('hour', u."timestamp")+ date_part('minute', u."timestamp"):: int / 5 * interval '5 min' as time_stamp,
  CAST(
    AVG(i.total_mem - u.memory_free*1000)/ i.total_mem * 100 as decimal (10, 2)
  ) as Avg_Mem_Used_Percentage
FROM
  host_usage u INNER JOIN host_info i ON i.id = u.host_id
GROUP BY
  u.host_id,
  i.hostname,
  time_stamp,
  i.total_mem
ORDER BY
  u.host_id,
  time_stamp ASC
LIMIT 10;