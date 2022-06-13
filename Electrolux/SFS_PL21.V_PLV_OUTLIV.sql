USE [SFS_PL21_Master_A_T]
GO

/****** Object:  View [SFS_PL21].[V_PLV_OUTLIV]    Script Date: 13.06.2022 10:22:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [SFS_PL21].[V_PLV_OUTLIV]
AS
WITH explBOM AS(
	SELECT 
		bo.MATNR AS 'FinishedGood',
		bo.DATUV AS 'StartDate',
		bo.ZDATEH AS 'EndDate',
		bo.MATNR AS 'ParentPart',
		bi.IDNRK AS 'ComponentPart',
		bi.POSNR + bi.ITEMFIELD3 AS 'Prefix',
		bi.MENGE AS 'Quantity',
		1 AS 'CurrentLVL',
		CAST(bo.MATNR AS VARCHAR(MAX)) AS 'SortPath'
	FROM dbo.BOMMAT bo WITH(NOLOCK)
		INNER JOIN dbo.IMDMARA im WITH(NOLOCK) ON im.MATNR = bo.MATNR
		INNER JOIN dbo.BOMMAT_ITEMS bi WITH(NOLOCK) ON bi.BOMMATID = bo.BOMMATID
	WHERE im.MTART = 'ZFER'

	UNION ALL
		
	SELECT 
		c.FinishedGood,
		bi2.DATUV,
		bi2.ZDATE,
		bo2.MATNR,
		bi2.IDNRK,
		bi2.POSNR + bi2.ITEMFIELD3,
		c.Quantity,
		c.CurrentLVL + 1,
		c.SortPath + ',' + CAST(bo2.MATNR AS VARCHAR(MAX))
	FROM dbo.BOMMAT bo2 WITH(NOLOCK)
		INNER JOIN dbo.BOMMAT_ITEMS bi2 WITH(NOLOCK) ON bi2.BOMMATID = bo2.BOMMATID
		INNER JOIN explBOM c ON c.ComponentPart = bo2.MATNR
)SELECT DISTINCT
	'?' AS 'P',
	e.FinishedGood AS 'END_ITEM',
	ia.MAKTX AS 'END_ITEM DESCRIPTION',
	im.MTART AS 'BC',
	e.ParentPart AS 'PARENT',
	e.ComponentPart AS 'CHILD',
	ia2.MAKTX AS 'CHILD DESCRIPTION',
	e.CurrentLVL AS 'LV',
	e.Quantity AS 'QTY USED',
	im2.MEINS AS 'UM',
	im2.MTART AS 'BC2',
	'?' AS 'RS',
	'?' AS 'DEF',
	iu.ATWRT AS 'IDCO',
	'?' AS 'PQ',
	im2.DISPO AS 'BUYER',
	e.Prefix AS 'PREFIX',
	'?' AS 'SUFX',
	'?' AS 'SEC',
	e.StartDate AS 'START.DT',
	'?' AS 'EEC',
	e.EndDate AS 'END.DT',
	'?' AS 'A',
	'?' AS 'P.',
	e.SortPath
FROM explBOM e
	LEFT JOIN dbo.IMDMARA im WITH(NOLOCK) ON im.MATNR = e.FinishedGood
	LEFT JOIN dbo.IMDMAKT ia WITH(NOLOCK) ON ia.IMDMARAID = im.IMDMARAID AND ia.SPRAS_ISO = 'EN'
	LEFT JOIN dbo.IMDMARA im2 WITH(NOLOCK) ON im2.MATNR = e.ComponentPart
	LEFT JOIN dbo.IMDMAKT ia2 WITH(NOLOCK) ON ia2.IMDMARAID = im2.IMDMARAID AND ia.SPRAS_ISO = 'EN'
	LEFT JOIN dbo.IMDAUSP iu WITH(NOLOCK) ON iu.OBJEK = e.ComponentPart AND iu.ATNAM = 'IDCO'
--OPTION (MAXRECURSION 0)
GO


