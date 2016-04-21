package hex.control;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Field;

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
		fields = hex.annotation.AnnotationReader.parseMetadata( "hex.control.IController", [ "CommandClass", "FireOnce", "MethodName" ], true );
		
		//get data result
		var data = hex.annotation.AnnotationReader._static_classes[ hex.annotation.AnnotationReader._static_classes.length - 1 ];
		
		trace( data.methods. );
		
		/*
		annotationDatas	: Array<AnnotationData>,
		argumentDatas	: Array<ArgumentData>,
		methodName 		: String
		*/
		
		for ( field in fields ) 
		{
			switch ( field.kind ) 
			{
				case FFun( func ) :
				
					var methodName  = field.name;
					if ( methodName == "new" ) continue;
					
					/*
					 for ( m in field.meta )
					{
						m.set( m.name, m.params );
					}
					*/
					
					
					
					for ( m in field.meta )
					{
						if ( m.name == "CommandClass" )
						{
							var param = m.params[ 0 ];
							trace( param );
							var commandClassName = "";
							
							
							switch( param.expr )
							{
								case EConst( c ):
									switch ( c )
									{
										case CString( s ):
											commandClassName = s;

										default: null;
									}

								default: null;
							}

							var commandClass = Context.getType( commandClassName );
							var pack = commandClassName.split( "." );
							var className = pack[ pack.length -1 ];
							pack.splice( pack.length - 1, 1 );

							
							var tp = { pack: pack, name: className };
							var args = [for (arg in func.args) macro $i { arg.name } ];

							func.expr = macro 
							{
								var command = new $tp();
								Reflect.callMethod( command, Reflect.field( command, command.executeMethodName ), $a{ args } );
							};
						}
					}

				default : 
			}
		}

		return fields;
	}
}