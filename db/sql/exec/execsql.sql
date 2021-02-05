SELECT
    ename 이름, e.job 직급, sal 급여, max 직급최대급여
FROM
    emp e, 
    (
        SELECT
            job, MAX(sal) max
        FROM
            emp
        GROUP BY
            job
    ) t
WHERE
    e.job = t.job 
    AND sal = max
;