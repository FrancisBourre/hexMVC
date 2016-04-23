package hex.control.controller;

import haxe.macro.Context;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.TypePath;
import hex.annotation.MethodAnnotationData;

/**
 * ...
 * @author Francis Bourre
 */
class ControllerBuilder
{
	function new()
	{
		
	}
	
	macro static public function build() : Array<Field> 
	{
		var fields = Context.getBuildFields();
		
		//parse annotations
		fields = hex.annotation.AnnotationReader.parseMetadata( "hex.control.controller.IController", [ "CommandClass", "FireMessageType", "ExecuteMethodName", "ExecuteOnce" ], true );
		
		//get data result
		var data = hex.annotation.AnnotationReader._static_classes[ hex.annotation.AnnotationReader._static_classes.length - 1 ];
		
		//Create command class map
		//var tMap : Map<String, TypePath> = new Map();
		var tMap : Map<String, String> = new Map();
		
		//Create responder
		var responderTypePath = getTypePath( Type.getClassName( ControllerResponder ) );
		
		for ( method in data.methods )
		{
			tMap.set( method.methodName, getAnnotation( method, "CommandClass" ) );
			trace( getAnnotation( method, "FireMessageType" ) );
		}
		
		for ( field in fields ) 
		{
			switch ( field.kind ) 
			{
				case FFun( func ) :
				
					var methodName  = field.name;
					if ( tMap.exists( methodName ) )
					{
						var commandClassName : String = tMap.get( methodName );
						
						if ( commandClassName != null )
						{
							var tp = getFieldExpression( commandClassName );
							var args = [for (arg in func.args) macro $i { arg.name } ];

							func.expr = macro 
							{
								var command = this._injector.getOrCreateNewInstance( $p { tp } );
								
								var isAsync = Std.is( command, hex.control.async.IAsyncCommand );
								if ( isAsync )
								{
									command.preExecute();
								}
								
								Reflect.callMethod( command, Reflect.field( command, command.executeMethodName ), $a { args } );
								return new $responderTypePath();
							};
						}
						
					}
					
				default : 
			}
		}

		return fields;
	}

	static function getAnnotation( method : MethodAnnotationData, annotationName : String )
	{
		var meta = method.annotationDatas.filter( function ( v ) { return v.annotationName == annotationName; } );
		if ( meta.length > 0 )
		{
			return meta[ 0 ].annotationKeys[ 0 ];
		}
		else
		{
			return null;
		}
	}
	
	static function getTypePath( className : String ) : TypePath
	{
		Context.getType( className );
		var pack = className.split( "." );
		var className = pack[ pack.length -1 ];
		pack.splice( pack.length - 1, 1 );
		return { pack: pack, name: className };
	}
	
	static function getFieldExpression( className : String )
	{
		Context.getType( className );
		return className.split( "." );
	}
}