package hex.control.trigger.mock;

import hex.control.guard.IGuard;

/**
 * ...
 * @author Francis Bourre
 */
class MockGuardRefuse implements IGuard
{
	@Inject
	public var shouldApprove : Bool;
	
	public function new() 
	{
		
	}
	
	public function approve() : Bool
	{
		return this.shouldApprove;
	}
}