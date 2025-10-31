
--Join the data
SELECT
		DISTINCT se.EMPLID
		, se.ACAD_CAREER
		, se.STRM AS TERM
		, term.DESCR AS TERM_DESCR
		, coh.FALL_COHORT_DESCR
		, se.CLASS_NBR
		, se.CLASS_NBR_STR
		, se.STDNT_ENRL_STATUS
		, se.CRSE_GRADE_OFF 
		, CASE WHEN se.STDNT_ENRL_STATUS = 'EN' THEN NVL(se.CRSE_GRADE_OFF, 'N')
			ELSE 'N'
			END AS CRSE_GRADE_MODIFIED
		, CASE WHEN se.STDNT_ENRL_STATUS = 'EN' AND se.CRSE_GRADE_OFF IN ('D', 'F') THEN 1
			WHEN se.STDNT_ENRL_STATUS = 'WL' THEN 1
			ELSE 0
			END AS DFW_FLAG

		, CASE WHEN term.DESCR LIKE 'Fall%' THEN 'FALL'
			WHEN term.DESCR LIKE 'Spring%' THEN 'SPRING'
			WHEN term.DESCR LIKE 'Summer%' THEN 'SUMMER' 
			ELSE 'OTHER'
			END AS TERM_TYPE
		, class.DESCR AS CLASS_DESCR
		, class.SUBJECT
		, class.DESCR_SUBJECT_MISMATCH
		
	
FROM 
	(--start se
	SELECT 
		DISTINCT EMPLID
		, ACAD_CAREER
		, STRM
		, CLASS_NBR
		, TO_CHAR (CLASS_NBR) AS CLASS_NBR_STR
		, STDNT_ENRL_STATUS
		, CRSE_GRADE_OFF 
	FROM SYSADM.PS_STDNT_ENRL
	ORDER BY EMPLID, STRM
	)se --end se
	
	LEFT JOIN

	(--start term
	SELECT DISTINCT STRM, DESCR
	FROM SYSADM.PS_TERM_TBL
	ORDER BY STRM
	)term --end term
	ON se.STRM=term.STRM
	
	LEFT JOIN
	
	(--start class
	SELECT 
		STRM 
		, CLASS_NBR
		, TO_CHAR (CLASS_NBR) AS CLASS_NBR_STR
		, DESCR
		, SUBJECT
		--this flags out records that have discrepancies between the DESCR and the SUBJECT, say Workshop: ENGL and MATH, or Special Topics in MATH and BIO
		, CASE WHEN SUBSTR(DESCR, -4) LIKE '%' || SUBJECT THEN 0
			ELSE 1
			END AS DESCR_SUBJECT_MISMATCH
		, CASE WHEN (SUBSTR(DESCR, -3) = SUBJECT OR SUBSTR(DESCR, -4) = SUBJECT OR SUBSTR(DESCR, -2) = SUBJECT) THEN 0
			ELSE 1
			END AS DESCR_SUBJECT_MISMATCH2
	FROM SYSADM.PS_CLASS_TBL
	ORDER BY STRM, CLASS_NBR
	--Fields: STRM (0810), DESCR (Intro to BIO), CLASS_NBR (49,558 int should be string), SUBJECT (BIO, CHEM)
	)class --end class
	ON se.STRM=class.STRM AND se.CLASS_NBR=class.CLASS_NBR
	
	LEFT JOIN
	
	(--start coh
	--Fall Cohort for each EMPLID
	SELECT 
		DISTINCT ef.EMPLID
		, MIN(ef.TERM_DESCR) AS FALL_COHORT_DESCR
	FROM
		--enrollment in Fall terms
		(--start ef
		SELECT
			DISTINCT se.EMPLID
			, se.STRM AS TERM
			, term.DESCR AS TERM_DESCR
		FROM 
			(--start se
			SELECT 
			DISTINCT EMPLID
			, STRM
			, STDNT_ENRL_STATUS
			FROM SYSADM.PS_STDNT_ENRL
			WHERE STDNT_ENRL_STATUS = 'EN'

			)se --end se
	
		INNER JOIN

		(--start term
		SELECT DISTINCT STRM, DESCR
		FROM SYSADM.PS_TERM_TBL
		WHERE DESCR LIKE 'Fall%'
		ORDER BY STRM
		)term --end term
		ON se.STRM=term.STRM
		)ef --end ef
	GROUP BY ef.EMPLID
	ORDER BY ef.EMPLID
	)coh --end coh
	ON se.EMPLID = coh.EMPLID
	
ORDER BY se.EMPLID, se.STRM;
	


--Retention Fall 2024 (1110) to Fall 2025 (1140)
SELECT

	SUM (CASE WHEN ret.EMPLID IS NULL THEN 0
		ELSE 1
		END)/COUNT (coh.EMPLID) AS RETENTION_RATE
FROM

	--Fall 2024 cohort:
	(-- start coh
	SELECT 
		DISTINCT EMPLID
	FROM SYSADM.PS_STDNT_ENRL
	WHERE STDNT_ENRL_STATUS = 'EN'
		AND STRM = :STRM --'1110'
	)coh --end coh
	
	LEFT JOIN	
	
	--retained in Fall 2025 cohort
	(--start ret
	SELECT 
		DISTINCT EMPLID
	FROM SYSADM.PS_STDNT_ENRL
	WHERE STDNT_ENRL_STATUS = 'EN'
		AND STRM = :STRM
		AND EMPLID IN	
			(
			SELECT 
				DISTINCT EMPLID
			FROM SYSADM.PS_STDNT_ENRL
			WHERE STDNT_ENRL_STATUS = 'EN'
				AND STRM = TO_CHAR(TO_NUMBER(:STRM)+30)--'1140'
			)
	)ret --end ret
ON coh.EMPLID = ret.EMPLID
	
