  CREATE OR REPLACE FORCE VIEW "CL"."GOV_MOFCOM" ("SYR", "SYR_IS_COMPANY", "SYR_HAS_N", "SYR_IS_CHINESE", "SYR_N_CODE", "SYR_B_CODE", "SYR_A_CODE", "SYR_PASSPORT", "SYR_MZ", "SYR_ADDRESS", "SYR_PHONE", "YSRY", "YSYR_IS_COMPANY", "YSYR_HAS_N", "YSYR_IS_CHINESE", "YSYR_N_CODE", "YSYR_B_CODE", "YSYR_A_CODE", "YSYR_PASSPORT", "YSYR_MZ", "YSYR_ADDRESS", "YSYR_PHONE", "IS_JYGS", "JYGS_MC", "JYGS_IS_COMPANY", "JYGS_HAS_N", "JYGS_CONTROY", "JYGS_N_CODE", "JYGS_B_CODE", "JYGS_A_CODE", "JYGS_PASS_PORT", "JYGS_MZ", "JYGS_ADDRESS", "JYGS_PHONE", "HPHM", "DJZSBH", "CLSBDH", "CLPP", "HPZL", "IS_ELECTRONIC", "ZCD", "XSJG", "BID", "BID_ADDRESS", "TAX_CODE", "SLD", "SLD_ADDRESS", "SLD_TAX_CODE", "KP_TIME", "TRADE_TIME", "ORIGINAL_REGISTRY_TIME", "ORIGINAL_PRICE", "MILES", "SLRQ") AS 
  SELECT
	--	y.TMH ,
	-- 现所有人姓名
	y.SYR SYR, 
	-- 是否企业
	CASE WHEN y.SFZMMC IN ('N', 'B') THEN '是' ELSE '否' END SYR_IS_COMPANY , 
	-- 是否有同一社会信用代码
	CASE WHEN y.SFZMMC = 'N' THEN '是' ELSE '否' END SYR_HAS_N ,
	-- 国籍
	CASE WHEN y.SFZMMC NOT IN ('F', 'G', 'I', 'L', 'Q') THEN '中国' ELSE NULL END SYR_IS_CHINESE ,
	-- 显示社会同一信用代码
	CASE WHEN y.SFZMMC = 'N' THEN y.SFZMHM ELSE NULL END SYR_N_CODE ,
	-- 显示组织机构代码
	CASE WHEN y.SFZMMC = 'B' THEN y.SFZMHM ELSE NULL END SYR_B_CODE ,
	-- 显示身份证
	CASE WHEN y.SFZMMC IN ('A', 'M') THEN y.SFZMHM ELSE NULL END SYR_A_CODE ,
	-- 护照
   	CASE WHEN y.YSFZMMC IN ('F', 'G', 'I', 'L', 'Q') THEN y.YSFZMHM ELSE NULL END SYR_PASSPORT ,
	-- 获取所有人的民族说明
	(SELECT DMSM1
	 FROM VEH_CODE
	 WHERE DMLB = '80' 
	 AND DMZ = (SELECT DISTINCT MZ 
	 			FROM CYIMG.ICK 
	 			WHERE JGDM = y.SFZMHM 
	 			AND mz IS NOT NULL 
	 			-- rownum 是非标准的SQL, 如果要移植, 需要修改
	 			AND rownum = 1)) SYR_MZ ,
	-- 所有人地址
	y.ZSXXDZ SYR_ADDRESS,
	-- 所有人电话
    y.SJHM SYR_PHONE ,
    -- 卖家姓名
    y.YSYR YSRY ,
    -- 卖家是否是公司 
    CASE WHEN y.YSFZMMC IN ('N', 'B') THEN '是' ELSE '否' END YSYR_IS_COMPANY , 
    -- 卖家是否统一信用代码
   	CASE WHEN y.YSFZMMC = 'N' THEN '是' ELSE '否' END YSYR_HAS_N ,
   	-- 卖家国籍
   	CASE WHEN y.YSFZMMC NOT IN ('F', 'G', 'I', 'L', 'Q') THEN '中国' ELSE NULL END YSYR_IS_CHINESE ,
   	-- 卖家社会信用代码
   	CASE WHEN y.YSFZMMC = 'N' THEN y.YSFZMHM ELSE NULL END YSYR_N_CODE ,
   	-- 卖家组织机构代码
   	CASE WHEN y.YSFZMMC = 'B' THEN y.YSFZMHM ELSE NULL END YSYR_B_CODE ,
   	-- 卖家身份证号码
   	CASE WHEN y.YSFZMMC IN ('N', 'A') THEN y.YSFZMHM ELSE NULL END YSYR_A_CODE ,
   	-- 护照号
   	CASE WHEN y.YSFZMMC IN ('F', 'G', 'I', 'L', 'Q') THEN y.YSFZMHM ELSE NULL END YSYR_PASSPORT ,
	-- 卖家的民族说明
	(SELECT DMSM1 
	  FROM VEH_CODE 
	  WHERE DMLB = '80' 
	  AND DMZ = (SELECT DISTINCT MZ 
	  	         FROM CYIMG.ICK 
	  	         WHERE JGDM = y.SFZMHM 
	  	         AND mz IS NOT NULL 
	 			-- rownum 是非标准的SQL, 如果要移植, 需要修改
	  	         AND rownum = 1)) YSYR_MZ , 
	-- 卖家地址
	y.YZSXXDZ YSYR_ADDRESS,
	-- 卖家电话
	(SELECT DISTINCT SYRDH
	 FROM JYDJ
	 WHERE BH = y.HDID)	 YSYR_PHONE ,
	-- 是否代理人
	CASE WHEN y.JYGS IS NOT NULL THEN '是' ELSE '否' END IS_JYGS ,
	-- 代理人名字
	d.MC JYGS_MC ,
	-- 代理人是否企业
	CASE WHEN y.JYGS IS NOT NULL AND y.JYGS <> '9999' THEN '是' ELSE '否' END JYGS_IS_COMPANY ,
	-- 是否有统一信用代码证
	NULL JYGS_HAS_N , 
	-- 代理人国籍
	CASE WHEN y.JYGS <> '9999' AND y.JYGS IS NOT NULL THEN '中国' ELSE NULL END JYGS_CONTROY ,
	-- 代理人统一社会信用代码
	NULL JYGS_N_CODE ,
	-- 代理组织机构代码
	NULL JYGS_B_CODE , 
	-- 代理人身份证
	NULL JYGS_A_CODE ,
	-- 代理人护照号
	NULL JYGS_PASS_PORT ,
	-- 代理人民族
	NULL JYGS_MZ ,
	-- 代理人地址
	NULL JYGS_ADDRESS ,
	-- 代理人电话
	NULL JYGS_PHONE ,
	-- 车牌号码
	y.HPHM HPHM ,
	-- 车辆登记证书编号
	y.DJZSBH DJZSBH ,
	-- 车辆识别代号
	y.CLSBDH clsbdh ,
	-- 厂牌型号
	y.CLPP1 || y.CLXH CLPP ,
	-- 车辆类型
	CASE 
	WHEN y.HPZL IS NULL 
	THEN (SELECT MC
		  FROM DM
		  WHERE LX = 'GA24.7-2001'
		  AND DM = y.YHPZL)
	ELSE d2.MC 
	END HPZL ,
	-- 是否新能源
	CASE WHEN y.SFXNY IS NOT NULL THEN '是' ELSE '否' END IS_ELECTRONIC ,
	--  转入地车管所
	CASE 
	  WHEN y.ZCD = '沪A' THEN '上海市公安局交通警察总队车辆管理所'
	  WHEN y.ZCD IS NULL THEN '上海市公安局交通警察总队车辆管理所'
	ELSE vc.DMSM1 END ZCD ,
	-- 合计(销售金额)
	y.XSJG XSJG,
	-- 拍卖,经营单位
	NULL BID,
	-- 拍卖地址
	NULL BID_ADDRESS ,
	-- 纳税人识别号
	NULL TAX_CODE,
	-- 二手车市场名称
	SLD.MS SLD,
	-- 二手车市场地址
	NULL SLD_ADDRESS,
	-- 纳税人识别号
	NULL SLD_TAX_CODE,
	-- 出票时间
	TO_CHAR(y.SLRQ , 'YYYY/MM/DD') KP_TIME,
	-- 交易时间
	TO_CHAR(y.SLRQ , 'YYYY/MM/DD') TRADE_TIME,
	-- 车辆初始购买时间
	TO_CHAR(y.CCDJRQ , 'YYYY/MM/DD') ORIGINAL_REGISTRY_TIME,
	-- 车辆初次购买价格
	NULL ORIGINAL_PRICE ,
	-- 里程数
	NULL MILES,
	-- 用于查询的时间列
	y.SLRQ SLRQ
FROM
	CL.YLR y 
	LEFT OUTER JOIN cl.DM d ON  y.JYGS = d.DM AND d.LX = 'ESC2003.2'
	LEFT OUTER JOIN CL.DM d2 ON 	y.HPZL = d2.DM AND d2.LX = 'GA24.7-2001'
	LEFT OUTER JOIN CL.VEH_CODE vc ON y.ZCD = vc.DMZ AND vc.DMLB = '34'
	LEFT OUTER JOIN CL.DM SLD ON y.SLD = SLD.DM AND SLD.LX = 'ESC2003.1'
WHERE (y.YW LIKE 'B%' OR y.YW = 'C1')
AND y.BLZT <> 'YTB';
 