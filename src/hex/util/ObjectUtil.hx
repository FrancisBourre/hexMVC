package hex.util;

import hex.error.IllegalArgumentException;
import hex.ioc.assembler.ApplicationContext;
import hex.ioc.core.CoreFactory;

/**
 * ...
 * @author Francis Bourre
 */
class ObjectUtil
{
	function new() 
	{
		
	}
	
	static public function fastEvalFromTarget( target : Dynamic, toEval : String, coreFactory : CoreFactory ) : Dynamic
	{
		var members : Array<String> = toEval.split( "." );
		var result 	: Dynamic;
		
		while ( members.length > 0 )
		{
			var member : String = members.shift();
			result = Reflect.field( target, member );
			
			if ( result == null )
			{
				if ( Std.is( target, ApplicationContext ) && coreFactory.isRegisteredWithKey( member ) )
				{
					result = coreFactory.locate( member );
					if ( members.length > 0 )
					{
						//TODO: check if it's really good? I don't think so - grosmar
						break;
						ObjectUtil.fastEvalFromTarget( target, toEval, coreFactory );
					}
				}
				#if js
				else if ( Std.is( target, js.html.Element ) )
				{
					result = cast( target, js.html.Element).getElementsByClassName(member)[0];
				}
				#end
				else
				{
					throw new IllegalArgumentException( "ObjectUtil.fastEvalFromTarget(" + target + ", " + toEval + ", " + coreFactory + ") failed." );
				}
			}
			
			target = result;
		}
		
		return target;
	}
	
}