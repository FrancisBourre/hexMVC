package hex.control.trigger.mock;

import hex.control.async.Expect;
import hex.control.trigger.mock.MockUserVO;

/**
 * ...
 * @author Francis Bourre
 */
class MockUserController implements ICommandTrigger
{
	@Map( GetUserVOMacro )
	public function getUserVO( ageProvider : Void->UInt ) : Expect<MockUserVO>;
	
	public function getTemperature( cityName : String ) : Expect<Int>
	{
		@Inject
		var temperatureService : TemperatureService;
		return temperatureService( cityName );
	}

	public function new()
	{

	}
}