package hex.module.dependency;

import hex.di.mapping.Mapping;

/**
 * ...
 * @author Francis Bourre
 */
class RuntimeDependencies implements IRuntimeDependencies
{
	var _mappedDependencies : Array<Mapping>;

	public function new() 
	{
		
	}
	
	public function addMappedDependencies( serviceDependencies : Array<Mapping> ) : Void
	{
		if ( this._mappedDependencies == null )
		{
			this._mappedDependencies = [];
		}
		
		this._mappedDependencies = this._mappedDependencies.concat( serviceDependencies );
	}

	public function getMappedDependencies() : Array<Mapping>
	{
		return this._mappedDependencies;
	}

	public function hasMappedDependencies() : Bool
	{
		return this._mappedDependencies != null;
	}
}