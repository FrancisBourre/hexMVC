package hex.module.dependency;

import hex.service.Service;

/**
 * ...
 * @author Francis Bourre
 */
class RuntimeDependencies implements IRuntimeDependencies
{
	var _serviceDependencies : Array<Class<Service>>;

	public function new() 
	{
		
	}
	
	public function addServiceDependencies( serviceDependencies : Array<Class<Service>> ) : Void
	{
		if ( this._serviceDependencies == null )
		{
			this._serviceDependencies = new Array<Class<Service>>();
		}
		
		this._serviceDependencies = this._serviceDependencies.concat( serviceDependencies );
	}

	public function getServiceDependencies() : Array<Class<Service>>
	{
		return this._serviceDependencies;
	}

	public function hasServiceDependencies() : Bool
	{
		return this._serviceDependencies != null;
	}
}