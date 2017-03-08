package hex.control.trigger;

import hex.control.payload.ExecutionPayload;
import hex.control.payload.PayloadUtil;
import hex.di.IDependencyInjector;
import hex.error.VirtualMethodException;
import hex.util.Stringifier;

/**
 * ...
 * @author Francis Bourre
 */
class MacroCommand<ResultType> extends Command<ResultType>
{
	var _injector : IDependencyInjector;
	var _payloads : Array<ExecutionPayload>;
	var _commands : Array<Class<Command<ResultType>>> = [];
	
	
	public function new() 
	{
		super();
		
		this.isAtomic 			= true;
		this.isInSequenceMode 	= true;
	}
	
	@Inject
	public function preExecute( injector : IDependencyInjector, payloads : Array<ExecutionPayload> ) : Void
	{
		this._injector = injector;
		this._payloads = payloads;
		this._prepare();
	}
	
	function _prepare() : Void
	{
		throw new VirtualMethodException();
	}

	@:final 
	override public function execute() : Void
	{
		this._executeNextCommand( null );
	}
	
	public function add( commandClass : Class<Command<ResultType>> ) : MacroCommand<ResultType>
	{
		this._commands.push( commandClass );
		return this;
	}
	
	function _executeNextCommand( r : ResultType = null ) : Void
	{
		if ( this._commands.length > 0 )
		{
			var command = MacroCommand.getCommand( this._injector, this._commands.shift(), this._payloads );
			command.execute();
			
			command.onComplete
				( function( r ) this._executeNextCommand( r ) )
					.onFail
						( function( e ) this._fail( e ) );

		}
		else
		{
			this._complete( r );
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
	
	public function toString() : String
	{
		return Stringifier.stringify( this );
	}
	
	//
	static public function getCommand<ResultType>( injector : IDependencyInjector, commandClass : Class<Command<ResultType>>, payloads : Array<ExecutionPayload> ) : Command<ResultType>
    {
		// Map payloads
        if ( payloads != null )
        {
            PayloadUtil.mapPayload( payloads, injector );
        }

		// Instantiate command
		var command : Command<ResultType> = null;
        command = injector.getOrCreateNewInstance( commandClass );

		// Unmap payloads
        if ( payloads != null )
        {
            PayloadUtil.unmapPayload( payloads, injector );
        }
		
		return command;
    }
}

