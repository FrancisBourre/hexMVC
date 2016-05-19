package hex.module.dependency;

/**
 * ...
 * @author Francis Bourre
 */
class RuntimeDependencies implements IRuntimeDependencies
{
	var _mappedDependencies : Array<Class<Dynamic>>;

	public function new() 
	{
		
	}
	
	public function addMappedDependencies( serviceDependencies : Array<Class<Dynamic>> ) : Void
	{
		if ( this._mappedDependencies == null )
		{
			this._mappedDependencies = new Array<Class<Dynamic>>();
		}
		
		this._mappedDependencies = this._mappedDependencies.concat( serviceDependencies );
	}

	public function getMappedDependencies() : Array<Class<Dynamic>>
	{
		return this._mappedDependencies;
	}

	public function hasMappedDependencies() : Bool
	{
		return this._mappedDependencies != null;
	}
}