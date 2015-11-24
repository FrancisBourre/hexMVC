package hex.service;

import hex.error.VirtualMethodException;
import hex.event.IEvent;
import hex.service.ServiceConfiguration;

/**
 * ...
 * @author Francis Bourre
 */
class AbstractService<EventClass:ServiceEvent, ConfigurationClass:ServiceConfiguration> implements IService<EventClass, ConfigurationClass>
{
	private var _configuration : ConfigurationClass;
	private var _serviceEventClass : Class<EventClass>;
	
	private function new() 
	{
		
	}

	public function getConfiguration() : ConfigurationClass
	{
		return this._configuration;
	}
	
	@postConstruct
	public function createConfiguration() : Void
	{
		throw new VirtualMethodException( this + ".createConfiguration must be overridden" );
	}
	
	@final
	public function setEventClass( serviceEventClass : Class<EventClass> ) : Void
	{
		this._serviceEventClass = serviceEventClass;
	}
	
	public function setConfiguration( configuration : ConfigurationClass ) : Void
	{
		throw new VirtualMethodException( this + ".setConfiguration must be overridden" );
	}
	
	public function addHandler( eventType : String, handler : EventClass->Void ) : Void
	{
		throw new VirtualMethodException( this + ".addHandler must be overridden" );
	}
	
	public function removeHandler( eventType : String, handler : EventClass->Void ) : Void
	{
		throw new VirtualMethodException( this + ".removeHandler must be overridden" );
	}
	
	public function release() : Void
	{
		throw new VirtualMethodException( this + ".release must be overridden" );
	}
}