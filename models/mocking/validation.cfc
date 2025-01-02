component {
    function checkValidation(event, fieldname, submittedValue, message="" ){
        writeDump(event.data.data);
            expect( event.getStatusCode() ).tobe( 400 );
            expect( res.data.data ).tohaveKey( fieldName );
            expect( res.data ).tohavekey( "error" );
            expect( res.data.error ).tobeTrue();
            expect( res.data ).tohavekey( "messages" );
            expect( res.data.messages ).tobetypeOf( "array" );
            expect( res.data.messages.len() ).tobe( 1 );
            expect( res.data.messages[ 1 ].findNoCase( "Validation exceptions" ) ).tobegt( 0 );
            expect( res.data.data[fieldName] ).toHaveKeyWithCase( "field" );
            expect( res.data.data[fieldName].fieldName ).tobe( arguments.fieldName );

        if(arguments.message.len()){
                expect( res.data.data[fieldname] ).toHaveKeyWithCase( "message" );
                expect( res.data.data[fieldname].message ).tobe( arguments.message );
        }

        if(!isNull(arguments.submittedValue)){
                expect( res.data.data[fieldname] ).toHaveKeyWithCase( "rejectedValue" );
                expect( res.data.data[fieldname].rejectedValue ).tobe( arguments.submittedValue );
        }
            expect( exampleData ).toHaveKeyWithCase( "validationData" );
            expect( exampleData ).toHaveKeyWithCase( "validationType" );


    }
}
