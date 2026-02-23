create  PROCEDURE [dbo].[spInserSD_Sales_Data]
    @MyData dbo.SD_Sales_Data READONLY   -- Table-valued parameter containing sales data from SAP
AS
BEGIN
    SET NOCOUNT ON;  -- Prevents extra result sets from interfering with SELECT statements

    /* ============================================================
       Step 1: Identify duplicate records inside incoming dataset
       ------------------------------------------------------------
       - Partition by VBELN (Sales Document) and POSNR (Item)
       - Keep only the first occurrence
       - Used to prevent duplicate line items during insert
    ============================================================ */
WITH Dups AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY VBELN, POSNR   order by POSNR ) AS rn
  FROM @MyData
)


    /* ============================================================
       Step 2: Remove existing records for incoming Sales Documents
       ------------------------------------------------------------
       - Ensures data refresh behavior (Delete + Insert strategy)
       - Prevents old data from remaining in the table
       - Maintains data accuracy & integrity
    ============================================================ */


Delete from  SD_Sales_Details  where VBELN  in (
Select Distinct VBELN  from    @MyData
)
    /* ============================================================
       Step 3: Insert Cleaned & Deduplicated Records
       ------------------------------------------------------------
       - Inserts only unique records (rn = 1)
       - Prevents duplicate Sales Document line items
       - Ensures consistency between SAP and MSSQL
    ============================================================ */
	INSERT INTO [SD_Sales_Details]
           (
		   [VBELN]
      ,[AUDAT]
      ,[AUART]
      ,[VKORG]
      ,[VTWEG]
	  ,SPART
      ,[KUNNR]
      ,[NAME1]
      ,[CMGST]
      ,[KVGR1]
      ,[KVGR2]
      ,[KVGR3]
      ,[POSNR]
      ,[MATNR]
      ,[ARKTX]
      ,[KWMENG]
      ,[VRKME]
      ,[ABGRU]
      ,[WERKS]
      ,[KONDM]
      ,[KTGRM]
      ,[MVGR1]
      ,[MVGR2]
      ,[NETWR]
      ,[KZWI2]
      ,[KZWI3]
      ,[KZWI6]
      ,[MWSBP]
      ,[TERRITORY]
      ,[AREA]
      ,[CZONE]
      ,[PGROUP1]
      ,[PGROUP2]
      ,[VTEXT]
      ,[ASM]
      ,[ASM_NAME]
      ,[DSE]
      ,[DSE_NAME]
      ,[AP_DATE]
      ,[PTC_UOM]
      ,[PTC_NUM]
      ,[PTC_DNUM]
      ,[MT_UOM]
      ,[MT_NUM]
      ,[MT_DNUM]
         )

    /* ============================================================
       Select Only Unique Records from Incoming Dataset
    ============================================================ */
Select
[VBELN]
      ,[AUDAT]
      ,[AUART]
      ,[VKORG]
      ,[VTWEG]
	  ,SPART
      ,[KUNNR]
      ,[NAME1]
      ,[CMGST]
      ,[KVGR1]
      ,[KVGR2]
      ,[KVGR3]
      ,[POSNR]
      ,[MATNR]
      ,[ARKTX]
      ,[KWMENG]
      ,[VRKME]
      ,[ABGRU]
      ,[WERKS]
      ,[KONDM]
      ,[KTGRM]
      ,[MVGR1]
      ,[MVGR2]
      ,[NETWR]
      ,[KZWI2]
      ,[KZWI3]
      ,[KZWI6]
      ,[MWSBP]
      ,[TERRITORY]
      ,[AREA]
      ,[CZONE]
      ,[PGROUP1]
      ,[PGROUP2]
      ,[VTEXT]
      ,[ASM]
      ,[ASM_NAME]
      ,[DSE]
      ,[DSE_NAME]
      ,[AP_DATE]
      ,[PTC_UOM]
      ,[PTC_NUM]
      ,[PTC_DNUM]
      ,[MT_UOM]
      ,[MT_NUM]
      ,[MT_DNUM]

from  

(

  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY VBELN, POSNR   order by POSNR ) AS rn
  FROM @MyData


) A where rn=1 -- Keep only first occurrence per Sales Document Item

END;