component {

    property name="controller" inject="coldbox";
	property name="wirebox" inject="wirebox";
	property name="mockBox" inject="testbox.system.mockbox";
    /***
     * Helper method to simply do a "clean" reload of a wirebox mapping from the file system
     **/
    boolean function reloadModule( required string moduleName ) {
        variables.controller.getServices().moduleService.reload( moduleName );
		return true;
    }

    /**
     * Helper method to simplify replacing mappings in Wirebox, helpful in mocking in integration testing
     **/
    boolean function replaceMapping( required string mapping, required target ) {
        variables.controller
            .getWireBox()
            .getBinder()
            .unmap( mapping );
        variables.controller
            .getWireBox()
            .getBinder()
            .map( mapping )
            .toValue( target );

		return true;
    }


    /***
     * Accepts a mapping name and stores the mapping from WireBox in the variables scope in order to be restored later.
     *
     **/
    function storeOriginalMapping( mappingName ) {
        variables.originalMappings = variables.keyExists( "originalMappings" ) ? variables.originalMappings : {};
        var binder = variables.controller.getWireBox().getBinder();
        variables.controller.getWirebox().getInstance( mappingName );
        variables.originalMappings[ mappingName ] = variables.controller
            .getWireBox()
            .getBinder()
            .getMapping( mappingName );
    }

    /***
     * Loops through the stored mappings and restores them to WireBox
     *
     **/
    function restoreMappings() {
		writeDump(variables.originalMappings);
		if(!isNull(variables.originalMappings)){
			variables.originalMappings.each( function( mapping, comp ) {
				variables.controller
					.getWireBox()
					.getBinder()
					.setMapping( mapping, comp );
			} );
		}
    }

    /***
     * Accepts a struct of mappings and a callback function. The struct of mappings has the name of the mapping as the key and the target as the value. WhileSwapped
     * stores the original mapping from Wirebox in the Variables Scope, swaps the mapping for the submitted value, runs the callback and then restores the original mapping to WireBox.
     *
     * @mappings - A struct with the name of the mapping as the key and the target as the value
     * @callback - The function to run between mappings
     * @verifyMappingExists - whether or not the function should verify if the mapping exists in WireBox before trying to swap the mappings.
     **/
    function whileSwapped( struct mappings = {}, any callback, boolean verifyMappingExists = true ) {
        var binder = variables.controller.getWireBox().getBinder();
        var originalMappings = {};
        mappings.each( function( mapping, componentCFC ) {
            if ( verifyMappingExists ) {
							if(!binder.mappingExists( mapping )){
								throw("No #mapping# already configured in WireBox" );
								return;
							}};
            originalMappings[ mapping ] = binder.getMapping( mapping );
            binder.map( alias = mapping, force = true ).toValue( componentCFC );
        } );

        try {
            callback();
        } catch ( any e ) {
            rethrow;
        } finally {
            originalMappings.each( function( mapping, componentCFC ) {
                binder.setMapping( mapping, componentCFC );
            } );
        }
    }

    /***
     * Clears all stored mappings from this cfc's variable scope.
     *
     **/
    function clearStoredMappings() {
        variables.originalMappings = {};
    }

	function compareKeysFromQuery(required string compName,required string funcName,struct args={},required string qbFunction, required string usedKeylist, getFromDB=0){
		var receivedKeys = returnKeysFromQuery(compName,funcName,args,qbFunction,getFromDB);
		return usedKeylist.listToArray().filter(function(item){
			return !receivedKeys.findNoCase(item);
		});
	}

	function returnKeysFromQuery(required string compName,required string funcName,struct args={},required string qbFunction, getFromDB=0 ){
		var mq = mockBox.createMock(object=wirebox.getInstance("QueryBuilder@qb"));
		mq.$(method=qbFunction,returns={});

		var ma = wirebox.getInstance(compName);
		ma.setQb(mq);
		ma[funcName](argumentCollection = arguments.args);
		var allColumns = [];

		mq.getColumns().each(function(item){
			if(isSimpleValue(item) && item != "*"){
				allColumns.append(item);
			} else if(!issimplevalue(item)){
				return item.getSql().listToArray(", ",false, true)
					.each(function(item){
						allColumns.append(item.listLast(" ",false,true).listlast(".",false));
				});
			} else if(isSimpleValue(item) && item == "*"){
				if(!getFromDB){
					allColumns.append("I need to look in the DB");
				}

			}
		});
		return allColumns;
	}
}
