package service;

import hex.service.AbstractService;
import hex.service.ServiceEvent;

/**
 * ...
 * @author Francis Bourre
 */
class MockService extends AbstractService<ServiceEvent>
{
	public function new()
	{
		super();
		this.setEventClass( ServiceEvent );
	}
}