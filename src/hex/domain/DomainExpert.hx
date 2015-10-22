package hex.domain;
import hex.domain.Domain;
import hex.error.IllegalStateException;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
class DomainExpert
{
	private var _registeredDomains : Map<Int, Domain>;
	private var _subscribedModules : Map<IModule, Domain>;
	
	static private var _Instance : DomainExpert = new DomainExpert();
	
	static public function getInstance() : DomainExpert
	{
		return DomainExpert._Instance;
	}
	
	function new() 
	{
		this._subscribedModules = new Map<IModule, Domain>();
	}
	
	public function getDomainFor( module : IModule ) : Domain
	{
		if ( !this._subscribedModules.exists( module ) )
		{
			return null;
		}
		else
		{
			return this._subscribedModules.get( module );
		}
	}
	
	public function registerDomain( domain : Domain ) : Void
	{
		//Register
	}
	
	public function releaseDomain( module : IModule ) : Void
	{
		if ( module.isReleased )
		{
			this._subscribedModules.remove( module );
		}
		else
		{
			throw new IllegalStateException( "Illegal call, '" + module + "' is not released." );
		}
	}
}