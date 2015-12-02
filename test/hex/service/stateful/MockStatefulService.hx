package hex.service.stateful;
import hex.service.ServiceConfiguration;
import hex.service.ServiceEvent;

/**
 * ...
 * @author duke
 */
class MockStatefulService extends StatefulService<ServiceEvent, ServiceConfiguration>
{

	public function new() 
	{
		super();
		
	}
	
	public function run()
	{
		this._lock();
	}
	
	public function stop()
	{
		this._release();
	}
	
}

