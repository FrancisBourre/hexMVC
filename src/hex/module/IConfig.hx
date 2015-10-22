package hex.module;

/**
 * Optional module configuration interface
 */
interface IConfig
{
    /**
     * Configure will be invoked after dependencies have been supplied
     */
    function configure() : Void;
}