# testboxMockingUtils
A collection of mocking utilities to be used with TestBox

### Mocking

When doing unit tests, it is fairly straight forward to mock components and then set them as properties in
the cfc being tested. However, in unit testing events or handlers, there is no alternative other than to place the
mocked component into WireBox so the handler or event being tested can call WireBox to obtain it. This leads to the
problem of restoring the original non-mocked component to Wirebox to either testing can continue or the site
can return to normal operations.

There are six methods to help with mocking components in WireBox.

`storeOriginalMapping` accepts a mapping name, retrieves that mapping from WireBox and stores it in the variable scope of the instantiated mocking.cfc.

`replaceMapping` accepts a mapping name and a target component, unmaps the Wirebox Version and inserts the submitted version.

`restoreMappings` loops through the stored mappings in the instantiated mocking.cfc and restores the saved value to WireBox.

`reloadModule` accepts the name of the module and reloads it from the file system.

`clearStoredMappings` clears all the stored mappings in the instantiated mocking.cfc.

`whileSwapped` accepts a structure with the name of mappings as the keys and the targets as the values as well as a
callback. The method stores the original mapping from WireBox in the variables scope of the instantiated CFC, runs the callback, then restores the mappings.


Examples:

`component extends="coldbox.system.testing.BaseTestCase" {

function beforeAll(){
super.beforeAll();
variables.testboxMockingUtils = getInstance("mocking@testboxUtils");
variables.testboxMockingUtils.storeOriginalMapping("path.to.model");
}

function afterAll(){
variables.testBoxUtils.restoreMappings();
}


function run(){
describe(
title="Unit Testing",
body=function(){
beforeEach(function(){
mockQB = createMock(object=getInstance("queryBuilder@"));
variables.testBoxUtils.replaceMapping("queryBuilder@qb",mockQB);
mockModel = createMock(object=getInstance("path.to.model");
variables.testBoxUtils.replaceMapping("path.to.model",mockModel);
});
}
);
}`