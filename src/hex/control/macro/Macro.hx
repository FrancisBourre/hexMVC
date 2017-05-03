package hex.control.macro;

import hex.control.async.AsyncCommand;
import hex.control.async.IAsyncCommand;
import hex.control.async.IAsyncCommandListener;
import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;
import hex.di.IInjectorContainer;
import hex.error.NullPointerException;
import hex.error.VirtualMethodException;
import hex.util.Stringifier;

/**
 * ...
 * @author Francis Bourre
 */
class Macro extends AsyncCommand implements IAsyncCommandListener
{
	var _request 			: Request;
	
	@Inject
	public var macroExecutor 		: IMacroExecutor;

	public function new() 
	{
		super();
		
		this.isAtomic 			= true;
		this.isInSequenceMode 	= true;
	}
	
	function _prepare() : Void
	{
		throw new VirtualMethodException();
	}
	
	override public function preExecute( ?request : Request ) : Void
	{
		if ( this.macroExecutor != null )
		{
			this.macroExecutor.setAsyncCommandListener( this );
		}
		else
		{
			throw new NullPointerException( "macroExecutor can't be null in '" + Stringifier.stringify( this ) + "'" );
		}
		
		if ( request != null ) 
		{
			this._request = request;
		}
		
		this._prepare();
		super.preExecute( request );
	}
	
	@:final 
	override public function execute() : Void
	{
		!this.isRunning && this._throwExecutionIllegalStateError();
		this._executeNextCommand();
	}
	
	public function add( commandClass : Class<ICommand> ) : ICommandMapping
	{
		return this.macroExecutor.add( commandClass );
	}
	
	public function addMapping( mapping : ICommandMapping ) : ICommandMapping
	{
		return this.macroExecutor.addMapping( mapping );
	}
	
	function _executeCommand() : Void
	{
		var command : ICommand = this.macroExecutor.executeNextCommand( this._request );
		
		if ( command != null )
		{
			var isAsync : Bool = Std.is( command, IAsyncCommand );
			
			if ( !isAsync || this.isInParallelMode )
			{
				this._executeNextCommand();
			}
		}
	}
	
	function _executeNextCommand() : Void
	{
		if ( this.isRunning && this.macroExecutor.hasNextCommandMapping )
		{
			this._executeCommand();
		}
		else if ( this.macroExecutor.hasRunEveryCommand && this.isRunning )
		{
			this._handleComplete();
		}
	}
	
	@:isVar public var isAtomic( get, set ) : Bool;
	function get_isAtomic() : Bool
	{
		return this.isAtomic;
	}
	
	function set_isAtomic( value : Bool ) : Bool
	{
		this.isAtomic = value;
		return value;
	}
	
	@:isVar public var isInSequenceMode( get, set ) : Bool;
	function get_isInSequenceMode() : Bool
	{
		return this.isInSequenceMode;
	}
	
	function set_isInSequenceMode( value : Bool ) : Bool
	{
		this.isInSequenceMode = value;
		return value;
	}
	
	@:isVar
	public var isInParallelMode( get, set ) : Bool;
	function get_isInParallelMode() : Bool
	{
		return !this.isInSequenceMode;
	}
	
	function set_isInParallelMode( value : Bool ) : Bool
	{
		this.isInSequenceMode = !value;
		return this.isInSequenceMode;
	}
	
	public function onAsyncCommandComplete( cmd : AsyncCommand ) : Void
	{
		this.macroExecutor.asyncCommandCalled( cmd );
		this._executeNextCommand();
	}

	public function onAsyncCommandFail( cmd : AsyncCommand ) : Void
	{
		// I have to check if it's not null because the macroexecutor calls out when a guard protected the run of a command. Then it handles itself the callNotification - Duke
		if ( cmd != null )
		{
			this.macroExecutor.asyncCommandCalled( cmd );
		}
		
		if ( this.isAtomic && this.isRunning )
		{
			this._handleFail();
		}
		else
		{
			this._executeNextCommand();
		}
	}

	public function onAsyncCommandCancel( cmd : AsyncCommand ) : Void
	{
		this.macroExecutor.asyncCommandCalled( cmd );
		
		if ( this.isAtomic && this.isRunning )
		{
			this.cancel();
		}
		else
		{
			this._executeNextCommand();
		}
	}
	
	public function toString() : String
	{
		return Stringifier.stringify( this );
	}
}
