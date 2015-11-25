package hex.domain;

import hex.domain.Domain;
import hex.domain.DomainDispatcher;
import hex.domain.NoDomain;
import hex.event.IEvent;
import hex.event.IEventListener;
import hex.event.IEventDispatcher;
import hex.event.EventDispatcher;
import hex.module.IModuleListener;

/**
 * ...
 * @author Francis Bourre
 */
class ApplicationDomainDispatcher<ListenerType:IEventListener> extends DomainDispatcher<ListenerType, IEvent> implements IApplicationDomainDispatcher<ListenerType>
{
	static private var _Instance : ApplicationDomainDispatcher<IModuleListener> = new ApplicationDomainDispatcher<IModuleListener>();

	private function new() 
	{
		super( TopLevelDomain.DOMAIN, EventDispatcher );
	}
	
	static public function getInstance() : ApplicationDomainDispatcher<IModuleListener>
	{
		return ApplicationDomainDispatcher._Instance;
	}
	
	override public function getDomainDispatcher( ?domain : Domain ) : IEventDispatcher<ListenerType, IEvent>
	{
		return ( domain != NoDomain.DOMAIN ) ? super.getDomainDispatcher( domain ) : null;
	}
}

private class TopLevelDomain extends Domain
{
    public static var DOMAIN : TopLevelDomain = new TopLevelDomain( "TopLevelDomain" );
}