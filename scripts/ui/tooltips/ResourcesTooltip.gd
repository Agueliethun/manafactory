extends MarginContainer

func init(resource : MFResource):
	var mat = resource.get_mfmaterial()
	
	$Table/StrengthBar.value = mat.strength
	$Table/StrengthBar/Label.text = str(snappedf(mat.strength, 0.01))
	$Table/VolatilityBar.value = mat.volatility
	$Table/VolatilityBar/Label.text = str(snappedf(mat.volatility, 0.01))
	$Table/MagicBar.value = mat.magic
	$Table/MagicBar/Label.text = str(snappedf(mat.magic, 0.01))
