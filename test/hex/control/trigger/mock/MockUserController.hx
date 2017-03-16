package hex.control.trigger.mock;

import hex.control.async.IAsyncCallback;
import hex.control.trigger.mock.MockUserVO;

/**
 * ...
 * @author Francis Bourre
 */
class MockUserController implements ICommandTrigger
{
	@Map( GetUserVOMacro )
	public function getUserVO( ageProvider : Void->UInt ) : IAsyncCallback<MockUserVO>;
	
	public function getTemperature( cityName : String ) : IAsyncCallback<UInt>
	{
		@Inject
		var temperatureService : TemperatureService;
		return temperatureService( cityName );
	}
}