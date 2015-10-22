package hex.module.dependency;
import hex.service.IService;

/**
 * ...
 * @author Francis Bourre
 */
class RuntimeDependencies implements IRuntimeDependencies
{
	private var _serviceDependencies : Array<Class<IService>>;

	public function new() 
	{
		
	}
	
	public function addServiceDependencies( serviceDependencies : Array<Class<IService>> ) : Void
	{
		if ( this._serviceDependencies == null )
		{
			this._serviceDependencies = new Array<Class<IService>>();
		}
		
		this._serviceDependencies = this._serviceDependencies.concat( serviceDependencies );
	}

	public function getServiceDependencies() : Array<Class<IService>>
	{
		return this._serviceDependencies;
	}

	public function hasServiceDependencies() : Bool
	{
		return this._serviceDependencies != null;
	}
}