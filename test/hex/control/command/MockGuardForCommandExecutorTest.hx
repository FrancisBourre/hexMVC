package hex.control.command;

import hex.control.guard.IGuard;
import hex.di.IInjectorContainer;
import hex.domain.Domain;

/**
 * ...
 * @author Francis Bourre
 */
class MockGuardForCommandExecutorTest implements IGuard implements IInjectorContainer
{
	@Inject
	public var domain : Domain;
	
	public function new()
	{
		
	}
	
	public function approve() : Bool
	{
		return this.domain.getName() == "testGuardInjectionApproved";
	}
}