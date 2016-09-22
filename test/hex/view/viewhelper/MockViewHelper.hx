package hex.view.viewhelper;
import hex.event.IClosureDispatcher;

/**
 * ...
 * @author Francis Bourre
 */
class MockViewHelper extends ViewHelper<MockView>
{
	public var preInitializeCallCount 	: UInt = 0;
	public var initializeCallCount 		: UInt = 0;
	public var releaseCallCount 		: UInt = 0;
	
	public function new()
	{
		super();
	}
	
	override function _preInitialize() : Void 
	{
		this.preInitializeCallCount++;
		super._preInitialize();
	}
	
	override function _initialize() : Void 
	{
		this.initializeCallCount++;
		super._initialize();
	}
	
	override function _release() : Void 
	{
		this.releaseCallCount++;
		super._release();
	}
	
	public function getDispatcher() : IClosureDispatcher
	{
		return this._internal;
	}
}
