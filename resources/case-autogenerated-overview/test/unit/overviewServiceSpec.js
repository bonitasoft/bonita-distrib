'use strict';

describe('Case Overview - Overview Service test', function () {

  var ROOT_PATH = '../';

  var $httpBackend, overviewSrvc, dataSrvc, contextSrvc;

  beforeEach(module('caseOverview'));

  beforeEach(function () {

    inject(function ($injector) {
      // Set up the mock http service responses
      $httpBackend = $injector.get('$httpBackend');
      dataSrvc =  $injector.get('dataSrvc');
      contextSrvc = $injector.get('contextSrvc');
      overviewSrvc = $injector.get('overviewSrvc',{dataSrvc: dataSrvc, contextSrvc: contextSrvc});

    });
  });

  afterEach(function () {
    $httpBackend.verifyNoOutstandingExpectation();
    $httpBackend.verifyNoOutstandingRequest();
  });


  it('should complete the promise even if a variable is not initialized', function () {
    // Given
    var context = {
        businessObject_ref: {
          type : 'com.acme.object.Ticket',
          storageId : 7,
          link : 'API/bdm/businessData/com.acme.object.Ticket/7'
        },
        notInitialized_ref: {

        },
        multipleBusinessData_ref: {
          type : 'com.acme.object.Ticket',
          storageIds : [ 100, 101, 102 ],
          link : 'API/bdm/businessData/com.acme.object.Ticket?q=findByIds&f=ids=100,101,102'
        },
        notMultipleBusinessData_ref: {
          type : 'com.acme.object.Ticket',
          storageIds : [ ],
          link : 'API/bdm/businessData/com.acme.object.Ticket?q=findByIds&f=ids='
        },
        notInitializedDocument_ref: null
        ,
        document_ref: {
          id:1,
          fileName:'page.properties',
        }
        ,
        notInitializedMultipleDocument_ref:[]
        ,
        multipleDocument_ref:[
          {
            id:2,
            fileName:'index.html',
          },
          {
            id:3,
            fileName:'page.properties',
          }
        ]
    };

    var ticket7 =
    {
      persistenceId: 2,
    };

    var tickets = [{persistenceId: 100},{persistenceId: 101},{persistenceId: 102}];

    $httpBackend.expect('GET', ROOT_PATH + 'API/bpm/case/' + 2 + '/context')
        .respond(context);

    $httpBackend.expect('GET', ROOT_PATH + 'API/bdm/businessData/com.acme.object.Ticket/7')
        .respond(ticket7);

    $httpBackend.expect('GET', ROOT_PATH + 'API/bdm/businessData/com.acme.object.Ticket?q=findByIds&f=ids=100,101,102')
        .respond(tickets);


    // When
    var response = null;
    overviewSrvc.fetchContext(2).then(function(data){
      response = data;
    }, function(error){
      response = error;
    });

    $httpBackend.flush();

    // Then
    expect(response).toEqual({ businessData : { 'com.acme.object.Ticket' : [ { persistenceId : 2 }, { persistenceId : 100 }, { persistenceId : 101 }, { persistenceId : 102 } ] }, documents : [ { id : 1, fileName : 'page.properties' }, { id : 2, fileName : 'index.html' }, { id : 3, fileName : 'page.properties' } ] });

  });

});
