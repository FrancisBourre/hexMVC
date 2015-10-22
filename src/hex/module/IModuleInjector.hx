package hex.module;

/**
 * @author Francis Bourre
 */
interface IModuleInjector 
{
	function mapToValue( clazz : Class<Dynamic>, value : Dynamic, ?name : String = '' ) : Void;

    function mapToType( clazz : Class<Dynamic>, type : Class<Dynamic>, name:String = '' ) : Void;

    function mapToSingleton( clazz : Class<Dynamic>, type : Class<Dynamic>, name:String = '' ) : Void;

    function getInstance( type : Class<Dynamic>, name : String = "" ) : Dynamic;

    function instantiateUnmapped( type : Class<Dynamic> ) : Dynamic;

    function getOrCreateNewInstance( type : Class<Dynamic> ) : Dynamic;
}