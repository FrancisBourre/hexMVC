package hex.domain;

import hex.domain.Domain;
import hex.error.IllegalStateException;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
@:final 
class DomainExpert
{
	var _registeredDomains 	: Map<UInt, Domain>;
	var _subscribedModules 	: Map<IModule, Domain>;
	
	static var _Instance 	= new DomainExpert();
	static var _DomainIndex : UInt = 0;
	
	static public function getInstance() : DomainExpert
	{
		return DomainExpert._Instance;
	}
	
	function new() 
	{
		this._registeredDomains = new Map<UInt, Domain>();
		this._subscribedModules = new Map<IModule, Domain>();
	}
	
	public function getDomainFor( module : IModule ) : Domain
	{
		if ( !this._subscribedModules.exists( module ) )
		{
			if ( this._registeredDomains.exists( DomainExpert._DomainIndex ) )
			{
				var moduleDomain : Domain = this._registeredDomains.get( DomainExpert._DomainIndex );
				this._registeredDomains.remove( DomainExpert._DomainIndex );
				DomainExpert._DomainIndex++;
				this._subscribedModules.set( module, moduleDomain );
				return moduleDomain;
			}
			else
			{
				return null;
			}
		}
		else
		{
			return this._subscribedModules.get( module );
		}
	}
	
	public function registerDomain( domain : Domain ) : Void
	{
		this._registeredDomains.set( DomainExpert._DomainIndex, domain );
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