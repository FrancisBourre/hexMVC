package hex.domain;

import hex.event.IEvent;
import hex.event.IEventListener;

/**
 * @author Francis Bourre
 */
interface IApplicationDomainDispatcher<ListenerType:IEventListener> extends IDomainDispatcher<ListenerType, IEvent>
{
	
}