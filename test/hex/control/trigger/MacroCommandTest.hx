package hex.control.trigger;

import hex.control.payload.ExecutionPayload;
import hex.control.payload.PayloadUtil;
import hex.control.trigger.mock.AnotherMockCommand;
import hex.control.trigger.mock.MockCommand;
import hex.control.trigger.mock.MockMacroCommand;
import hex.di.IDependencyInjector;
import hex.di.Injector;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class MacroCommandTest 
{
	@Test( "test MacroCommand execution" )
	public function testMacroCommandExecution() : Void
	{
		MockMacroCommand.command 	= null;
		MockCommand.command 		= null;
		AnotherMockCommand.command 	= null;
		
		var vos : Array<Dynamic> = [];
		vos[ 0 ] = 'string1';
		vos[ 1 ] = 'string2';
		vos[ 2 ] = -3;
		vos[ 3 ] = 4;
		vos[ 4 ] = 5.6;
		vos[ 5 ] = true;
		vos[ 6 ] = [ 'hello', 'world' ];
		vos[ 7 ] = [ 'hello' => 'world' ];
		vos[ 8 ] = Date.now();
		
		var payloads =
		[
			new ExecutionPayload( vos[ 0 ], String, 'name1' ),
			new ExecutionPayload( vos[ 1 ] ).withClassName( 'String' ).withName( 'name2' ),
			new ExecutionPayload( vos[ 2 ] ).withClassName( 'Int' ),
			new ExecutionPayload( vos[ 3 ] ).withClassName( 'UInt' ),
			new ExecutionPayload( vos[ 4 ] ).withClassName( 'Float' ),
			new ExecutionPayload( vos[ 5 ] ).withClassName( 'Bool' ),
			new ExecutionPayload( vos[ 6 ] ).withClassName( 'Array<String>' ),
			new ExecutionPayload( vos[ 7 ] ).withClassName( 'Map<String, String>' ),
			new ExecutionPayload( vos[ 8 ], Date )
		];

		//
		var injector =  new Injector();
		injector.mapToValue( IDependencyInjector, injector );
		injector.mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', payloads );
		
		
		PayloadUtil.mapPayload( payloads, injector );
		var macroCommand = injector.getOrCreateNewInstance( MockMacroCommand );
		PayloadUtil.mapPayload( payloads, injector );
		
		macroCommand.execute();
		
		//
		var mo = MockMacroCommand.command;
		Assert.equals( vos[ 0 ], mo.pString1 );
		Assert.equals( vos[ 1 ], mo.pString2 );
		Assert.equals( vos[ 2 ], mo.pInt );
		Assert.equals( vos[ 3 ], mo.pUInt );
		Assert.equals( vos[ 4 ], mo.pFloat );
		Assert.equals( vos[ 5 ], mo.pBool );
		Assert.equals( vos[ 6 ], mo.pArray );
		Assert.equals( vos[ 7 ], mo.pStringMap );
		Assert.equals( vos[ 8 ], mo.pDate );
		
		//
		var cmd = MockCommand.command;
		Assert.equals( vos[ 0 ], cmd.pString1 );
		Assert.equals( vos[ 1 ], cmd.pString2 );
		Assert.equals( vos[ 2 ], cmd.pInt );
		Assert.equals( vos[ 3 ], cmd.pUInt );
		Assert.equals( vos[ 4 ], cmd.pFloat );
		Assert.equals( vos[ 5 ], cmd.pBool );
		Assert.equals( vos[ 6 ], cmd.pArray );
		Assert.equals( vos[ 7 ], cmd.pStringMap );
		Assert.equals( vos[ 8 ], cmd.pDate );
		
		//
		var acmd = AnotherMockCommand.command;
		Assert.equals( vos[ 0 ], acmd.pString1 );
		Assert.equals( vos[ 1 ], acmd.pString2 );
		Assert.equals( vos[ 2 ], acmd.pInt );
		Assert.equals( vos[ 3 ], acmd.pUInt );
		Assert.equals( vos[ 4 ], acmd.pFloat );
		Assert.equals( vos[ 5 ], acmd.pBool );
		Assert.equals( vos[ 6 ], acmd.pArray );
		Assert.equals( vos[ 7 ], acmd.pStringMap );
		Assert.equals( vos[ 8 ], acmd.pDate );
	}
}