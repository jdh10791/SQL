USE REFUEL

--must drop tables in correct order to satisfy foreign key constraints
if object_id('dbo.ChemSysBatchIngredient') is not null
drop table ChemSysBatchIngredient

if object_id('dbo.ChemSysIngredient') is not null
drop table ChemSysIngredient

if object_id('dbo.Ingredient') is not null
drop table Ingredient

if object_id('dbo.ChemSysBatchPrepStepDetail') is not null
drop table ChemSysBatchPrepStepDetail

if object_id('dbo.ChemSysBatchSubsysBatch') is not null
drop table ChemSysBatchSubsysBatch

if object_id('dbo.ChemSysBatch') is not null
drop table ChemSysBatch

if object_id('dbo.ChemSysSubsys') is not null
drop table ChemSysSubsys

if object_id('dbo.ChemSys') is not null
drop table ChemSys

if object_id('dbo.ChemSysTypePrepStep') is not null
drop table ChemSysTypePrepStep

if object_id('dbo.ChemSysType') is not null
drop table ChemSysType

if object_id('dbo.PrepStepDetail') is not null
drop table PrepStepDetail

if object_id('dbo.PrepStep') is not null
drop table PrepStep

--create tables

if object_id('dbo.ChemSysType') is not null
drop table ChemSysType

create table ChemSysType
(
	ChemSysTypeId int primary key identity(1,1)
	,ChemSysTypeName varchar(50)
	,BatchType varchar(50)
	,ChemSysTypeDescription varchar(max)
)

if object_id('dbo.ChemSys') is not null
drop table ChemSys

create table ChemSys
(
	ChemSysId int primary key identity(1,1)
	,ChemSysCode varchar(50)
	,ChemSysName varchar(50)
	--,ChemSysInputFormula varchar(50)
	,ChemSysFormula varchar(50)
	,ChemSysMolecularWeight AS dbo.mol_wt(ChemSysFormula)
	,ChemSysDescription varchar(max)
	,ChemSysTypeId int foreign key references ChemSysType(ChemSysTypeId)
)

if object_id('dbo.ChemSysBatch') is not null
drop table ChemSysBatch

create table ChemSysBatch
(
	ChemSysBatchId int primary key identity(1,1)
	,ChemSysId int foreign key references ChemSys(ChemSysId)
	,BatchDate date
	,BatchNotes varchar(max)
)

if object_id('dbo.Ingredient') is not null
drop table Ingredient

create table Ingredient
(
	IngredientId int primary key identity(1,1)
	,IngredientName varchar(50)
	,IngredentChemicalFormula varchar(50)
	,IngredientMolecularWeight AS dbo.mol_wt(IngredentChemicalFormula)
	,IngredientSupplier varchar(50)
	,IngredientPurity decimal(5,4)
)


if object_id('dbo.ChemSysIngredient') is not null
drop table ChemSysIngredient

create table ChemSysIngredient
(
	ChemSysIngredientId int primary key identity(1,1)
	,ChemSysId int foreign key references ChemSys(ChemSysId)
	,IngredientId int foreign key references Ingredient(IngredientId)
	--,IngredientName varchar(50) --computed field - maybe just handle with a view
	,IngredientAmount decimal(7,3)
	,AmountUnit varchar(15)
)

--ChemSysBatchIngredient - would be where actual amounts are tracked - not sure if worth time
if object_id('dbo.ChemSysBatchIngredient') is not null
drop table ChemSysBatchIngredient

create table ChemSysBatchIngredient
(
	ChemSysBatchIngredientId int primary key identity(1,1)
	,ChemSysBatchId int foreign key references ChemSysBatch(ChemSysBatchId)
	,IngredientId int foreign key references Ingredient(IngredientId)
	,IdealIngredAmount decimal(7,3)
	,ActualIngredAmount decimal(7,3)
	,AmountUnit varchar(15)
)

if object_id('dbo.ChemSysSubsys') is not null
drop table ChemSysSubsys

create table ChemSysSubsys
(
	ChemSysSubsysId int primary key identity(1,1)
	,ChemSysId int foreign key references ChemSys(ChemSysId)
	,ChemSubsysId int foreign key references ChemSys(ChemSysId)
	,SubsysAmount decimal(7,3)
	,AmountUnit varchar(15)
)


if object_id('dbo.PrepStep') is not null
drop table PrepStep

create table PrepStep
(
	PrepStepId int primary key identity(1,1)
	,PrepStepName varchar(50)
)

if object_id('dbo.PrepStepDetail') is not null
drop table PrepStepDetail

create table PrepStepDetail
(
	PrepStepDetailId int primary key identity(1,1)
	,PrepStepId int foreign key references PrepStep(PrepStepId)
	,PrepStepDetailName varchar(50)
	,PrepStepDetailUnits varchar(20)
)

if object_id('dbo.ChemSysTypePrepStep') is not null
drop table ChemSysTypePrepStep

create table ChemSysTypePrepStep
(
	ChemSysTypePrepStepId int primary key identity(1,1)
	,ChemSysTypeId int foreign key references ChemSysType(ChemSysTypeId)
	,PrepStepId int foreign key references PrepStep(PrepStepId)
)

if object_id('dbo.ChemSysBatchPrepStepDetail') is not null
drop table ChemSysBatchPrepStepDetail

create table ChemSysBatchPrepStepDetail
(
	ChemSysBatchPrepStepDetailId int primary key identity(1,1)
	,ChemSysBatchId int foreign key references ChemSysBatch(ChemSysBatchId)
	,PrepStepDetailId int foreign key references PrepStepDetail(PrepStepDetailId)
	,PrepStepDetailValue varchar(50)
)


if object_id('dbo.ChemSysBatchSubsysBatch') is not null
drop table ChemSysBatchSubsysBatch

create table ChemSysBatchSubsysBatch
(
	ChemSysBatchSubsysBatchId int primary key identity(1,1)
	,ChemSysBatchId int foreign key references ChemSysBatch(ChemSysBatchId)
	,SubsysBatchId int foreign key references ChemSysBatch(ChemSysBatchId)
	,IdealSubsysAmount decimal(7,3)
	,ActualSubsysAmount decimal(7,3)
	,AmountUnit varchar(15)
)



--insert into Material
----(
----	MaterialName
----	,MaterialDescription
----	,MaterialMolecularWeight
----)
--values
--('BCZY35','BaCoZrYO',275.2)

--Insert into Ingredient
--(
--	IngredientName
--	,IngredentChemicalFormula
--)
--values
--('Barium Carbonate','BaCO3')
--,('Ceria','CeO2')
--,('Zirconia','ZrO2')
--,('Yttria','Y2O3')


--insert into MaterialIngredient
--values
--(1,



--select * from Material