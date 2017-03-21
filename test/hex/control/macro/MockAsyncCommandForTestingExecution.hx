package hex.control.macro;

import hex.control.async.AsyncCommand;
import hex.module.IContextModule;

/**
 * ...
 * @author Francis Bourre
 */
class MockAsyncCommandForTestingExecution extends MockBasicAsyncCommand
{
	static public var executeCallCount 		: Int = 0;
	static public var preExecuteCallCount 	: Int = 0;
	
	static public var owner 				: IContextModule;
	
	static public var completeHandlers 		: Array<AsyncCommand->Void> = [];
	static public var failHandlers 			: Array<AsyncCommand->Void> = [];
	static public var cancelHandlers 		: Array<AsyncCommand->Void> = [];
	
	override public function setOwner( owner : IContextModule ) : Void 
	{
		MockAsyncCommandForTestingExecution.owner = owner;
	}
	
	override public function preExecute( ?request : Request ) : Void 
	{
		MockAsyncCommandForTestingExecution.preExecuteCallCount++;
	}
	
	override public function execute() : Void
	{
		MockAsyncCommandForTestingExecution.executeCallCount++;
	}
	
	override public function addCompleteHandler( callback : AsyncCommand->Void ) : Void
	{
		MockAsyncCommandForTestingExecution.completeHandlers.push( callback );
	}
	
	override public function addFailHandler( callback : AsyncCommand->Void ) : Void
	{
		MockAsyncCommandForTestingExecution.failHandlers.push( callback );
	}
	
	override public function addCancelHandler( callback : AsyncCommand->Void ) : Void
	{
		MockAsyncCommandForTestingExecution.cancelHandlers.push( callback );
	}
}