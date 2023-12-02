extends MarginContainer

func init(resource : MFResource):
	var mat = resource.get_mfmaterial()
	
	$Table/StrengthBar.value = mat.strength
	$Table/VolatilityBar.value = mat.volatility
	$Table/MagicBar.value = mat.magic
