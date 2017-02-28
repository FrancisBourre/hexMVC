package hex.control;

import hex.config.stateless.StatelessCommandConfig;
import hex.control.command.BasicCommand;
import hex.control.macro.Macro;
import hex.control.payload.ExecutionPayload;
import hex.domain.Domain;
import hex.event.MessageType;
import hex.module.Module;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class RequestTestWithMacro 
{
	@Test( "Test payloads mapping with Macro" )
	public function testRequestWithMacro() : Void
	{
		var vos : Array<Dynamic> = [];
		vos[ 0 ] = 'string1';
		vos[ 1 ] = 'string2';
		vos[ 2 ] = -3;
		vos[ 3 ] = 4;
		vos[ 4 ] = 5.6;
		vos[ 5 ] = true;
		vos[ 6 ] = [ 'hello', 'world' ];
		vos[ 7 ] = [ 'hello' => 'world' ];
		vos[ 8 ] = [ Domain.getDomain('hello'), Domain.getDomain('world') ];
		vos[ 9 ] = Date.now();
		//vos[ 10 ] = null;
		
		var module = new MockModule( vos );
		
		var mo = MockMacro.command;
		var cmd = MockCommand.command;
		
		Assert.equals( vos[ 0 ], mo.pString1 );
		Assert.equals( vos[ 1 ], mo.pString2 );
		Assert.equals( vos[ 2 ], mo.pInt );
		Assert.equals( vos[ 3 ], mo.pUInt );
		Assert.equals( vos[ 4 ], mo.pFloat );
		Assert.equals( vos[ 5 ], mo.pBool );
		Assert.equals( vos[ 6 ], mo.pArray );
		Assert.equals( vos[ 7 ], mo.pStringMap );
		Assert.equals( vos[ 8 ], mo.pObjectMap );
		Assert.equals( vos[ 9 ], mo.pDate );
		//Assert.equals( vos[ 10 ], mo.pNullInt );
		
		Assert.equals( vos[ 0 ], cmd.pString1 );
		Assert.equals( vos[ 1 ], cmd.pString2 );
		Assert.equals( vos[ 2 ], cmd.pInt );
		Assert.equals( vos[ 3 ], cmd.pUInt );
		Assert.equals( vos[ 4 ], cmd.pFloat );
		Assert.equals( vos[ 5 ], cmd.pBool );
		Assert.equals( vos[ 6 ], cmd.pArray );
		Assert.equals( vos[ 7 ], cmd.pStringMap );
		Assert.equals( vos[ 8 ], cmd.pObjectMap );
		Assert.equals( vos[ 9 ], cmd.pDate );
		//Assert.equals( vos[ 10 ], cmd.pNullInt );
	}
}

private class MockModule extends Module
{
	static public inline var TEST = new MessageType( 'test' );

	public function new( vos : Array<Dynamic> )
	{
		super();
		
		this._addStatelessConfigClasses( [ MockCommandConfig ] );
		
		this._dispatchPrivateMessage( TEST, 
			new Request( 
			[
				new ExecutionPayload( vos[ 0 ], String, 'name1' ),
				new ExecutionPayload( vos[ 1 ] ).withClassName( 'String' ).withName( 'name2' ),
				new ExecutionPayload( vos[ 2 ] ).withClassName( 'Int' ),
				new ExecutionPayload( vos[ 3 ] ).withClassName( 'UInt' ),
				new ExecutionPayload( vos[ 4 ] ).withClassName( 'Float' ),
				new ExecutionPayload( vos[ 5 ] ).withClassName( 'Bool' ),
				new ExecutionPayload( vos[ 6 ] ).withClassName( 'Array<String>' ),
				new ExecutionPayload( vos[ 7 ] ).withClassName( 'Map<String, String>' ),
				new ExecutionPayload( vos[ 8 ] ).withClassName( 'Map<hex.domain.Domain, hex.domain.Domain>' ),
				new ExecutionPayload( vos[ 9 ] ).withClassName( 'Date' )/*,
				new ExecutionPayload( vos[ 10 ] ).withClassName( 'Null<Int>' )*/
			] ) );
	}
}

private class MockCommandConfig extends StatelessCommandConfig
{
	override public function configure():Void
	{
		this.map( MockModule.TEST, MockCommand );
	}
}

private class MockMacro extends Macro
{
	static public var executionCount 	: UInt = 0;
	static public var command			: MockMacro;
	
	@Inject( 'name1' )
	public var pString1 : String;
	
	@Inject( 'name2' )
	public var pString2 : String;
	
	@Inject
	public var pInt 	: Int;
	
	@Inject
	public var pUInt 	: UInt;
	
	@Inject
	public var pFloat 	: Float;
	
	@Inject
	public var pBool 	: Bool;
	
	@Inject
	public var pArray 	: Array<String>;
	
	@Inject
	public var pStringMap : Map<String, String>;
	
	@Inject
	public var pObjectMap : Map<Domain, Domain>;
	
	@Inject
	public var pDate : Date;
	
	/*@Inject
	public var pNullInt : Null<Int>;*/
	
	public function new()
	{
		super();
	}
	
	override function _prepare():Void 
	{
		MockMacro.executionCount++;
		MockMacro.command = this;
		this.add( MockCommand );
	}
}

private class MockCommand extends BasicCommand
{
	static public var executionCount 	: UInt = 0;
	static public var command			: MockCommand;
	
	@Inject( 'name1' )
	public var pString1 : String;
	
	@Inject( 'name2' )
	public var pString2 : String;
	
	@Inject
	public var pInt 	: Int;
	
	@Inject
	public var pUInt 	: UInt;
	
	@Inject
	public var pFloat 	: Float;
	
	@Inject
	public var pBool 	: Bool;
	
	@Inject
	public var pArray 	: Array<String>;
	
	@Inject
	public var pStringMap : Map<String, String>;
	
	@Inject
	public var pObjectMap : Map<Domain, Domain>;
	
	@Inject
	public var pDate : Date;
	
	/*@Inject
	public var pNullInt : Null<Int>;*/
	
	public function new()
	{
		super();
	}
	
	override public function execute() : Void
	{
		MockCommand.executionCount++;
		MockCommand.command = this;
	}
}