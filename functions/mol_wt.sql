--requires delimited input formula (deimiter = '_')
--CREATE function dbo.mol_wt (@formula varchar(50))
--RETURNS decimal(7,3)
--AS
--BEGIN
--	declare @ret decimal(7,3)
--	select @ret = sum(t1.AtomicMass*t1.formulaUnits)
--	from
--	(
--		select substring(ss.value, patindex('%[0-9]%',ss.value), len(value)) formulaUnits
--			,pt.AtomicMass
--		from STRING_SPLIT(@formula,'_') as ss
--			join PeriodicTable pt
--				on pt.ElementSymbol = left(ss.value, patindex('%[0-9]%',ss.value)-1) 
--	) t1
--	RETURN @ret;
--END



--accepts normal input formula
if OBJECT_ID('dbo.mol_wt','FN') is not null
	drop function dbo.mol_wt
GO
CREATE function dbo.mol_wt (@formula varchar(50))
RETURNS decimal(7,3)
AS
BEGIN
	declare @offset int
	declare @tstr varchar(10)
	declare @numidx int
	declare @element varchar(5)
	declare @units decimal(6,3)
	declare @molwt decimal(7,3)

	set @molwt = 0

	IF @formula is null
		SET @molwt = null
	
	ELSE
		WHILE (@formula!='')
		BEGIN
			set @offset = patindex('%[A-Z]%', substring(@formula,2,len(@formula)) COLLATE Latin1_General_BIN)
			if @offset = 0 --if reached last element
				set @offset = len(@formula)
			set @tstr = left(@formula,@offset)
			set @numidx = patindex('%[0-9]%',@tstr)
			IF @numidx = 0
				BEGIN
					set @element = @tstr
					set @units = 1
				END
			ELSE
				BEGIN
					set @element = left(@tstr, @numidx-1)
					set @units = substring(@tstr, @numidx, len(@tstr))
				END

			set @molwt = @molwt + @units*(select pt.AtomicMass from PeriodicTable pt where pt.ElementSymbol = @element)
			set @formula = SUBSTRING(@formula,@offset+1, len(@formula))
		END

	RETURN @molwt
END
