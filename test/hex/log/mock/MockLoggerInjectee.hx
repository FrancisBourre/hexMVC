package hex.log.mock;
import hex.di.IInjectorContainer;
import hex.log.ILogger;

/**
 * ...
 * @author ...
 */
class MockLoggerInjectee implements IInjectorContainer
{

	@Inject
	public var logger:ILogger;
	
	public function new() 
	{
	}
	
}