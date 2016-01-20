package hex.config.stateful;

import hex.collection.Locator;
import hex.collection.LocatorMessage;
import hex.di.IDependencyInjector;
import hex.error.IllegalArgumentException;
import hex.error.NoSuchElementException;
import hex.event.CompositeDispatcher;
import hex.event.IDispatcher;
import hex.module.IModule;
import hex.service.IService;
import hex.service.ServiceConfiguration;
import hex.service.stateful.IStatefulService;

/**
 * ...
 * @author Francis Bourre
 */
class ServiceLocator extends Locator<String, ServiceLocatorHelper> implements IStatefulConfig
{
	public function new() 
	{
		super();
	}
	
	public function getService<ServiceType>( type : Class<ServiceType>, name : String = "" ) : ServiceType
	{
		var helper : ServiceLocatorHelper;

		if ( name.length > 0 )
		{
			helper = this.locate( name + "#" + Type.getClassName( type ) );
		}
		else
		{
			helper = this.locate( Type.getClassName( type ) );
		}

		var service : Dynamic = helper.value;

		if ( Std.is( service, Class ) )
		{
			service = Type.createInstance( service, [] );
		}

		if ( Std.is( service, IService ) )
		{
			return service;

		} else
		{
			throw new NoSuchElementException( this + ".getService failed to retrieve service with key '" + type + "'" );
		}
	}
	
	public function configure( injector : IDependencyInjector, dispatcher : IDispatcher<{}>, module : IModule ) : Void
	{
		var keys = this.keys();
        for ( className in keys )
        {
			var separatorIndex 	: Int 					= className.indexOf("#");
			var serviceClassKey : Class<Dynamic>;

			if ( separatorIndex != -1 )
			{
				serviceClassKey = Type.resolveClass( className.substr( separatorIndex+1 ) );
			}
			else
			{
				serviceClassKey = Type.resolveClass( className );
			}

			var helper 	: ServiceLocatorHelper 	= this.locate( className );
			var service : Dynamic = helper.value;

			if ( Std.is( service, Class ) )
			{
				if ( helper.mapName.length > 0 )
				{
					injector.mapToType( serviceClassKey, service, helper.mapName );
				}
				else
				{
					injector.mapToType( serviceClassKey, service );
				}

			}
			else if ( Std.is( service, IStatefulService ) )
			{
				var serviceDispatcher : CompositeDispatcher = ( cast service ).getDispatcher();
				if ( serviceDispatcher != null )
				{
					serviceDispatcher.add( dispatcher );
				}
				
				if ( helper.mapName.length > 0 )
				{
					injector.mapToValue( serviceClassKey, service, helper.mapName );
				}
				else
				{
					injector.mapToValue( serviceClassKey, service );
				}
			}

			else
			{
				throw new IllegalArgumentException( "Mapping failed on '" + service + "' This instance is not a stateful service nor a service class." );
			}
		}
	}
	
	public function addService( service : Class<IService<ServiceConfiguration>>, value : Dynamic, ?mapName : String = "" ) : Bool
	{
		return this._registerService( service, new ServiceLocatorHelper( value, mapName ), mapName );
	}
	
	private function _registerService( type : Class<IService<ServiceConfiguration>>, service : ServiceLocatorHelper, ?mapName : String = "" ) : Bool
	{
		var className : String = ( mapName != "" ? mapName + "#" : "" ) + Type.getClassName( type );
		return this.register( className, service );
	}
	
	override function _dispatchRegisterEvent( key : String, element : ServiceLocatorHelper ) : Void 
	{
		this._dispatcher.dispatch( LocatorMessage.REGISTER, [ key, element ] );
	}
	
	override function _dispatchUnregisterEvent( key : String ) : Void 
	{
		this._dispatcher.dispatch( LocatorMessage.UNREGISTER, [ key ] );
	}
}

private class ServiceLocatorHelper
{
	public var value	: Dynamic;
	public var mapName	: String;

	public function new( value : Dynamic, mapName : String  )
	{
		this.value 		= value;
		this.mapName 	= mapName;
	}
	
	public function toString() : String
	{
		return 'ServiceLocatorHelper( value:$value, mapName:$mapName )';
	}
}