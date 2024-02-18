SELECT
   student_id,
   track_name,
   date_enrolled,
   date_completed,
   student_track_id,
   track_completed,
   days_for_competition,
    CASE
        WHEN days_for_competition = 0 THEN 'Same day'
        WHEN days_for_competition between 0 AND 7 THEN '1 to 7'
        WHEN days_for_competition between 7 AND 30 THEN '8 to 30 days'
        WHEN days_for_competition between 31 AND 60 THEN '31 to 60 days'
        WHEN days_for_competition between 61 AND 90 THEN '61 to 90 days'
        WHEN days_for_competition between 91 AND 365 THEN '91 to 365 days'
        WHEN days_for_competition >= 366 THEN '366+ days'
    END AS completion_bucket
FROM 
    (
        SELECT
            b.student_id,
            a.track_name,
            b.date_enrolled,
            b.date_completed,
            ROW_NUMBER() OVER (ORDER BY b.student_id, a.track_name desc) AS student_track_id,
            CASE WHEN b.date_completed IS NULL THEN 0 ELSE 1 END AS track_completed,
            DATEDIFF(b.date_completed, b.date_enrolled) AS days_for_competition
        FROM
            career_track_info a
        JOIN 
            career_track_student_enrollments b ON a.track_id = b.track_id
    ) c;
