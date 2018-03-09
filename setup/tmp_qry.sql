delete  ChemSys

insert into ChemSysType
(
	ChemSysTypeName
	,BatchType
)
values
('Precursor powder','Weighing date')
,('Paste','Weighing date')
,('Calcined powder','Calcine date')
,('Anode-supported half cell','Sinter date')

insert into ChemSys
(
	ChemSysName
	,ChemSysFormula
	,ChemSysTypeId
)
values ('BCZY35 precursor','BaCe0.3Zr0.5Y0.2O3',1)
,('BZY20 precursor','BaZr0.8Y0.2O3',1)
,('BCZYYb7111 precursor','BaCe0.7Zr0.1Y0.1Yb0.1O3',1)
,('BCZYYb4411 precursor','BaCe0.4Zr0.4Y0.1Yb0.1O3',1)

select * from ChemSys cs
	join ChemSysType cst
		on cst.ChemSysTypeId = cs.ChemSysTypeId

insert into ChemSys
(
	ChemSysName
	,ChemSysTypeId
)
values ('40 wt% BZY20/60 wt% NiO + 20 wt% Starch',1)

insert into ChemSysSubsys
(
	ChemSysId
	,ChemSubsysId
	,SubsysAmount
	,AmountUnit
)
values (5,2,40, 'wt%')

insert into Ingredient
(
	IngredientName
	,IngredentChemicalFormula
	,IngredientSupplier
	,IngredientPurity
)
values
('Nickel Oxide','NiO','Alfa Aesar',1)
,('Corn Starch',null,'Sigma Aldrich',1)


select * from ChemSys
select * from Ingredient

insert into ChemSysIngredient
(
	ChemSysId
	,IngredientId
	,IngredientAmount
	,AmountUnit
)
values
(5, 1, 60, 'wt%')
,(5, 2, 20, 'wt%')

select *
from ChemSys cs
	left join ChemSysSubsys css
		on css.ChemSysId = cs.ChemSysId
	left join ChemSys ss
		on ss.ChemSysId = css.ChemSubsysId
	left join ChemSysIngredient csi
		on csi.ChemSysId = cs.ChemSysId
	left join Ingredient i
		on i.IngredientId = csi.IngredientId
order by cs.ChemSysId














