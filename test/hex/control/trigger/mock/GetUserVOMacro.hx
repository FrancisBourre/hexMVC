package hex.control.trigger.mock;

import hex.control.trigger.MacroCommand;
import hex.error.Exception;

/**
 * ...
 * @author Francis Bourre
 */
class GetUserVOMacro extends MacroCommand<MockUserVO>
{
	public function new() 
	{
		super();
	}
	
	override function _prepare():Void 
	{
		this.add( MockGetUsername ).withCompleteHandler( this._onUsername );
		this.add( MockGetUserAge ).withCompleteHandler( this._onAge );
		this._setResult( new MockUserVO() );
	}
	
	function _onUsername( username : String ) : Void
	{
		this._result.username = username;
	}
	
	function _onAge( age : UInt ) : Void
	{
		this._result.age = age;
		if ( age >= 18 ) 
		{
			this.add( MockGetUserPrivilege ).withCompleteHandler( this._onPrivilege );
		}
	}
	
	function _onPrivilege( isAdmin : Bool ) : Void
	{
		this._result.isAdmin = isAdmin;
	}
}