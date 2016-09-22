package hex.event;

import hex.control.Request;

/**
 * ...
 * @author Francis Bourre
 */
class MockRequest extends Request
{
	public var message : String;
	
	public function new()
	{
		super();
		this.message = "Message";
	}
}